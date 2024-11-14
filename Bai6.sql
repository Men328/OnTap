CREATE DATABASE BAI6;

CREATE TABLE employees (
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

CREATE TABLE departments (
	department_id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL
);
CREATE TABLE belong (
	employee_id INT ,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO employees (employee_id, `name`, age, salary) VALUES
(1, 'tran thi men', 20, 60.00),
(2, 'tran huyen trang', 21, 55.00),
(3, 'do minh trong', 35, 30.00),
(4, 'le thi ly', 40, 80.00),
(5, 'hoang cam tu', 25, 45.00);

INSERT INTO departments (department_id, `name`) VALUES
(1, 'ke toan'),
(2, 'nhan su'),
(3, 'ky thuat'),
(4, 'marketing');

INSERT INTO belong (employee_id, department_id) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 2),
(3, 2),
(3, 3),
(4, 4),
(5, 3),
(5, 4);

-- liệt kê tất cả các nhân viên trong bộ phận có tên là "Kế toán".
-- Kết quả cần hiển thị mã nhân viên và tên nhân viên.
SELECT e.employee_id, e.`name` FROM employees AS e
JOIN belong AS b ON e.employee_id = b.employee_id
JOIN departments AS d ON d.department_id = b.department_id
WHERE d.`name` = 'ke toan';

-- Viết câu lệnh SQL để tìm các nhân viên có mức lương lớn hơn 50,000.
-- Kết quả trả về cần bao gồm mã nhân viên, tên nhân viên và mức lương.
SELECT e.employee_id, e.`name`, e.salary FROM employees AS e
WHERE salary > 50.000;

-- Viết câu lệnh SQL để hiển thị tất cả các bộ phận và số lượng nhân viên trong từng bộ phận.
-- Kết quả trả về cần bao gồm tên bộ phận và số lượng nhân viên.
SELECT d.`name`, COUNT(b.employee_id) AS SoLuongNhanVien
FROM departments AS d
JOIN belong AS b ON d.department_id = b.department_id
GROUP BY d.`name`;

-- Viết câu lệnh SQL để tìm ra các thành viên có mức lương cao nhất theo từng bộ phận. 
-- Kết quả trả về là một danh sách theo bất cứ thứ tự nào.
-- Nếu có nhiều nhân viên bằng lương nhau nhưng cũng là mức lương cao nhất
-- thì hiển thị tất cả những nhân viên đó ra.

-- Viết câu lệnh SQL để tìm các bộ phận có tổng mức lương của nhân viên vượt quá 100,000 (hoặc một mức tùy chọn khác).
-- Kết quả trả về bao gồm tên bộ phận và tổng mức lương của bộ phận đó.
SELECT d.`name`, SUM(e.salary) AS total_salary
FROM departments d
JOIN belong AS b ON d.department_id = b.department_id
JOIN employees e ON b.employee_id = e.employee_id
GROUP BY d.`name`
HAVING SUM(e.salary) > 100.00;

-- Viết câu lệnh SQL để liệt kê tất cả các nhân viên làm việc trong hơn 2 bộ phận khác nhau.
-- Kết quả cần hiển thị mã nhân viên, tên nhân viên và số lượng bộ phận mà họ tham gia.
SELECT e.employee_id, e.`name`, COUNT(b.department_id) AS department_count
FROM employees AS  e
JOIN belong AS b ON e.employee_id = b.employee_id
GROUP BY e.employee_id, e.`name`
HAVING COUNT(b.department_id) > 2;
