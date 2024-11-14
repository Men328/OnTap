ALTER TABLE building
ADD FOREIGN KEY (host_id) REFERENCES `host`(id);

ALTER TABLE building
ADD FOREIGN KEY (contractor_id) REFERENCES contractor(id);

ALTER TABLE design
ADD FOREIGN KEY (building_id) REFERENCES building(id);

ALTER TABLE design
ADD FOREIGN KEY (architect_id) REFERENCES architect(id);

ALTER TABLE work
ADD FOREIGN KEY (building_id) REFERENCES building(id);

ALTER TABLE work
ADD FOREIGN KEY (worker_id) REFERENCES worker(id);

-- Ex3:
-- hien thi cong trinh co chi phi cao nhat
SELECT * FROM building 
WHERE cost = (SELECT MAX(cost) FROM building);

-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ
SELECT * FROM building 
WHERE cost > ALL 
	(
		SELECT cost FROM building
        WHERE city = 'can tho'
    );
    
-- Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ
SELECT * FROM building
WHERE cost > ANY
(
	SELECT cost FROM building
	WHERE city = 'can tho'
);

-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế
SELECT * FROM building
WHERE id IN (
	SELECT DISTINCT building_id FROM design
	ORDER BY building_id ASC
);


-- Hiển thị thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp



-- EX4:
-- Hiển thị thù lao trung bình của từng kiến trúc sư
SELECT a.id, a.`name`,
	   AVG(d.benefit) AS thulaotrungbinh
FROM architect AS a
INNER JOIN design AS d ON d.architect_id = a.id
GROUP BY a.id, a.name;

-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố
SELECT city, 
	   SUM(cost) AS totalCost
FROM building
GROUP BY city;

-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50
SELECT building_id
FROM design
WHERE benefit > 50;

-- Tìm các thành phố có ít nhất một kiến trúc sư tốt nghiệp

-- EX5:
-- Hiển thị tên công trình, tên chủ nhân và tên chủ thầu của công trình đó
SELECT b.`name`AS buildingName, c.`name` AS contractorName, h.`name` AS hostName
FROM building AS b
INNER JOIN `host` AS h ON h.id = b.host_id
INNER JOIN contractor AS c ON c.id = b.contractor_id;

-- Hiển thị tên công trình (building), tên kiến trúc sư (architect)
-- và thù lao của kiến trúc sư ở mỗi công trình (design)
SELECT b.`name` AS buildingName, a.`name` AS architectName , d.benefit AS thuLao
FROM design AS d
INNER JOIN building AS b ON b. id = d.building_id
INNER JOIN architect AS a ON a.id = d.architect_id;

-- Hãy cho biết tên và địa chỉ công trình (building) do chủ thầu Công ty xây dựng số 6
-- thi công (contractor)
SELECT b.`name` AS buildingName, b.address
FROM building AS b
INNER JOIN `contractor` AS c ON c.id = b.contractor_id
WHERE c.id = 1;

-- Tìm tên và địa chỉ liên lạc của các chủ thầu (contractor)
-- thi công công trình ở Cần Thơ (building) do kiến trúc sư Lê Kim Dung thiết kế (architect, design)
SELECT c.`name`AS contractorName, c.address
FROM building AS b
JOIN contractor AS c ON c.id = b.contractor_id
JOIN design AS d ON d.building_id = b.id
JOIN architect AS a ON a.id = d.architect_id
WHERE city = 'can tho' AND a.id = 2;

-- 	Hãy cho biết nơi tốt nghiệp của các kiến trúc sư (architect)
-- đã thiết kế (design) công trình Khách Sạn Quốc Tế ở Cần Thơ (building)
SELECT a.id AS architect_id, a.`name`AS architectName, a.place AS noitotnghiep
FROM design AS d
INNER JOIN architect AS a ON a.id = d.architect_id
INNER JOIN building AS b ON b.id = d. building_id
WHERE b.id = 1 AND b.city = 'can tho';

-- Cho biết họ tên, năm sinh, năm vào nghề của các công nhân có chuyên môn hàn hoặc điện (worker)
-- đã tham gia các công trình (work) mà chủ thầu Lê Văn Sơn (contractor) đã trúng thầu (building)
SELECT wk.`name`, wk.birthday, wk.`year` FROM contractor AS c
JOIN building AS b ON b.contractor_id = c.id
JOIN work AS w ON w.building_id = b.id
JOIN worker AS wk ON w.worker_id = wk.id
WHERE c.id = 3 AND skill = 'dien';

-- Những công nhân nào (worker) đã bắt đầu tham gia công trình Khách sạn Quốc Tế ở Cần Thơ (building)
-- trong giai đoạn từ ngày 15/12/1994 đến 31/12/1994 (work) số ngày tương ứng là bao nhiêu
SELECT wk.id, wk.`name`, wk.birthday, wk.year, wk.skill
FROM worker AS wk
JOIN `work` AS w ON w.worker_id = wk.id
JOIN building AS b ON b.id = w.building_id
WHERE b.id = 1 AND w.`date` BETWEEN '1994-12-15' AND '1994-12-31';

-- Cho biết họ tên và năm sinh của các kiến trúc sư đã tốt nghiệp ở TP Hồ Chí Minh (architect)
--  và đã thiết kế ít nhất một công trình (design) có kinh phí đầu tư trên 400 triệu đồng (building)
SELECT a.`name`, a.birthday FROM architect AS a
JOIN design AS d ON d.architect_id = a.id
JOIN building AS b ON b.id = d.building_id
WHERE a.place = 'tp hcm' 
AND b.cost > 400.00;

-- Cho biết tên công trình có kinh phí cao nhất
SELECT `name`, cost FROM building
WHERE cost = (SELECT MAX(cost) FROM building);

-- Cho biết tên các kiến trúc sư (architect) vừa thiết kế các công trình (design)
-- do Phòng dịch vụ sở xây dựng (contractor) thi công vừa thiết kế các công trình
-- do chủ thầu Lê Văn Sơn thi công
SELECT a.`name` FROM architect AS a
JOIN design AS d ON d.architect_id = a.id
JOIN building AS B ON b.id = d.building_id
JOIN contractor AS c ON c.id = b.contractor_id
WHERE c.id = 2 AND c.id = 3;

-- Cho biết họ tên các công nhân (worker) có tham gia (work) các công trình ở Cần Thơ (building)
-- nhưng không có tham gia công trình ở Vĩnh Long
SELECT DISTINCT wk.`name` FROM worker AS wk
JOIN `work` AS w ON w.worker_id = wk.id
JOIN building AS b ON B.id = w.building_id
WHERE b.city = 'can tho' AND b.city <> 'vinhlong';

-- Cho biết tên của các chủ thầu đã thi công các công trình có kinh phí
-- lớn hơn tất cả các công trình do chủ thầu phòng Dịch vụ Sở xây dựng thi công
SELECT DISTINCT c.`name` FROM contractor AS c
JOIN building AS b ON b.contractor_id = c.id
WHERE b.cost > ALL
(
	SELECT b.cost FROM building
    WHERE c.id = 2
);

-- Cho biết họ tên các kiến trúc sư có thù lao thiết kế một công trình nào đó
-- dưới giá trị trung bình thù lao thiết kế cho một công trình
SELECT a.`name` FROM architect AS a
JOIN design AS d ON d.architect_id = a.id
JOIN building AS b ON b.id = d.building_id
WHERE benefit < 
(
	SELECT AVG(benefit) FROM design
);

-- Tìm tên và địa chỉ những chủ thầu đã trúng thầu công trình có kinh phí thấp nhất
SELECT c.`name`, c.address FROM contractor AS c
JOIN building AS b ON b.contractor_id = c.id
WHERE b.cost = (SELECT MIN(cost) FROM building);

-- Tìm họ tên và chuyên môn của các công nhân (worker) tham gia (work) các công trình
-- do kiến trúc sư Le Thanh Tung thiet ke (architect) (design)
SELECT wk.`name`, skill, b.`name` AS buildingName FROM worker AS wk
JOIN `work` AS w ON w.worker_id = wk.id
JOIN building AS b ON b.id = w.building_id
JOIN design AS d ON d.building_id = b.id
JOIN architect AS a ON a.id = d.architect_id
WHERE a.id = 1;

-- Tìm các cặp tên của chủ thầu có trúng thầu các công trình tại cùng một thành phố

-- Tìm tổng kinh phí của tất cả các công trình theo từng chủ thầu
SELECT c.id AS contractor_id, c.`name`AS contractorName,
	   SUM(cost) AS TotalCost
FROM contractor AS c
JOIN building AS b ON c.id = b.contractor_id
GROUP BY c.id, c.`name`;

-- Cho biết họ tên các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
SELECT a.`name`, SUM(benefit) AS TongThuLao
FROM architect AS a
JOIN design AS d ON d.architect_id = a.id
JOIN building AS b ON b.id = d.building_id
GROUP BY a.`name`
HAVING SUM(benefit) > 25.00;

-- Cho biết số lượng các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
SELECT COUNT(DISTINCT a.id) AS SoLuongKienTrucSu FROM 
architect AS a
JOIN design AS d ON d.architect_id = a.id
JOIN building AS b ON b.id = d.building_id
GROUP BY a.id
HAVING SUM(benefit) > 25.00;

-- tìm tổng số công nhân đã than gia ở mỗi công trình
SELECT b.id, b.`name`, COUNT(wk.id) AS SoCongNhan
FROM building AS b
JOIN `work` AS w ON b.id = w.building_id
JOIN worker AS wk ON wk.id = w.worker_id
GROUP BY b.id, b.`name`;

-- Tìm tên và địa chỉ công trình có tổng số công nhân tham gia nhiều nhất
SELECT b.`name`, b.address, COUNT(wk.id) AS SoCongNhan
FROM building AS b
JOIN `work` AS w ON b.id = w.building_id
JOIN worker AS wk ON wk.id = w.worker_id
GROUP BY b.`name`, b.address
HAVING SoCongNhan = (
    SELECT MAX(SoCongNhan)
    FROM (
        SELECT COUNT(wk.id) AS SoCongNhan
        FROM building AS b
        JOIN `work` AS w ON b.id = w.building_id
        JOIN worker AS wk ON wk.id = w.worker_id
        GROUP BY b.id
    ) AS subquery
);

-- Cho biêt tên các thành phố và kinh phí trung bình cho mỗi công trình
-- của từng thành phố tương ứng
SELECT city, AVG(cost) FROM building
GROUP BY city;

-- Cho biết họ tên các công nhân có tổng số ngày tham gia vào các công trình
-- lớn hơn tổng số ngày tham gia của công nhân Nguyễn Hồng Vân

-- Cho biết tổng số công trình mà mỗi chủ thầu đã thi công tại mỗi thành phố
SELECT DISTINCT c.name, b.city, COUNT(b.id) AS SoCongTrinh
FROM building AS b
JOIN contractor AS c ON c.id = b.contractor_id
GROUP BY c.id, b.city;

-- Cho biết họ tên công nhân có tham gia ở tất cả các công trình

