use Manufactur
select * from manufacturing_dataset

-- =============================================
-- Advanced SQL Queries for Manufacturing Dataset
-- Author: Mohamed Emad Alhadi
-- Dataset: manufacturing_dataset
-- Purpose: Analyze defect rates, production efficiency, and quality
-- =============================================

-- Question: Which production batches have the highest production volume and what are their defect rates?
-- Purpose: Identify whether high production correlates with high defect rates.

SELECT TOP 10 ProductionVolume, DefectRate, DefectStatus
FROM manufacturing_dataset
ORDER BY ProductionVolume DESC;


-- Question: How does supplier quality affect defect rates?
-- Purpose: Evaluate the impact of supplier performance on defects.
SELECT SupplierQuality, AVG(DefectRate) AS AvgDefectRate
FROM manufacturing_dataset
GROUP BY SupplierQuality
ORDER BY AvgDefectRate DESC;


-- Question: Are longer delivery delays associated with higher defect batches?
-- Purpose: Identify supply chain delays contributing to defects.
SELECT ProductionVolume, DeliveryDelay, DefectRate
FROM manufacturing_dataset
WHERE DefectRate > 3.0
ORDER BY DeliveryDelay DESC;


-- Question: How does maintenance effort affect downtime?
-- Purpose: Determine optimal maintenance schedules to minimize downtime and defects.
SELECT MaintenanceHours, DowntimePercentage
FROM manufacturing_dataset
WHERE DowntimePercentage > 2
ORDER BY MaintenanceHours DESC;


-- Question: How do inventory issues correlate with defect rates?
-- Purpose: Evaluate whether poor inventory management contributes to higher defects.
SELECT InventoryTurnover, StockoutRate, DefectRate
FROM manufacturing_dataset
WHERE StockoutRate > 5
ORDER BY InventoryTurnover DESC;

-- Question: Does worker productivity influence defect occurrences?
-- Purpose: Optimize workforce training and scheduling for lower defects.
SELECT WorkerProductivity, AVG(DefectRate) AS AvgDefectRate
FROM manufacturing_dataset
GROUP BY WorkerProductivity
ORDER BY AvgDefectRate DESC;


-- Question: Are safety incidents related to high defect production?
-- Purpose: Improve workplace safety to reduce defects.
SELECT SafetyIncidents, COUNT(*) AS DefectCount
FROM manufacturing_dataset
WHERE DefectStatus = 1
GROUP BY SafetyIncidents
ORDER BY DefectCount DESC;


-- Question: How does energy efficiency relate to defect rates?
-- Purpose: Analyze whether energy optimization improves product quality.
SELECT EnergyConsumption, EnergyEfficiency, DefectRate
FROM manufacturing_dataset
ORDER BY EnergyEfficiency DESC;


-- Question: Does higher additive material cost or process time correlate with fewer defects?
-- Purpose: Optimize additive manufacturing for quality and cost-efficiency.
SELECT AdditiveMaterialCost, AdditiveProcessTime, DefectRate
FROM manufacturing_dataset
ORDER BY AdditiveMaterialCost DESC;


-- Question: Which production batches are most prone to defects?
-- Purpose: Identify high-risk production processes and costs associated.
SELECT TOP 20 ProductionVolume, ProductionCost, DefectRate
FROM manufacturing_dataset
WHERE DefectStatus = 1
ORDER BY DefectRate DESC;


-- Question: How does production cost affect defect rates?
-- Purpose: Assess cost-efficiency trade-offs in quality control.
SELECT 
    CASE 
        WHEN ProductionCost < 10000 THEN 'Low Cost'
        WHEN ProductionCost BETWEEN 10000 AND 15000 THEN 'Medium Cost'
        ELSE 'High Cost'
    END AS CostRange,
    AVG(DefectRate) AS AvgDefectRate
FROM manufacturing_dataset
GROUP BY 
    CASE 
        WHEN ProductionCost < 10000 THEN 'Low Cost'
        WHEN ProductionCost BETWEEN 10000 AND 15000 THEN 'Medium Cost'
        ELSE 'High Cost'
    END
ORDER BY AvgDefectRate DESC;


-- Question: Does maintenance effort impact defect rate?
-- Purpose: Optimize preventive maintenance for defect reduction.
SELECT 
    CASE 
        WHEN MaintenanceHours < 5 THEN 'Low Maintenance'
        WHEN MaintenanceHours BETWEEN 5 AND 15 THEN 'Medium Maintenance'
        ELSE 'High Maintenance'
    END AS MaintenanceLevel,
    AVG(DefectRate) AS AvgDefectRate,
    COUNT(*) AS BatchCount
FROM manufacturing_dataset
GROUP BY 
    CASE 
        WHEN MaintenanceHours < 5 THEN 'Low Maintenance'
        WHEN MaintenanceHours BETWEEN 5 AND 15 THEN 'Medium Maintenance'
        ELSE 'High Maintenance'
    END
ORDER BY AvgDefectRate DESC;


-- Question: Do low-quality suppliers lead to higher defects?
-- Purpose: Focus on supplier improvement strategies.
SELECT SupplierQuality, AVG(DefectRate) AS AvgDefectRate, COUNT(*) AS BatchCount
FROM manufacturing_dataset
WHERE SupplierQuality < 85
GROUP BY SupplierQuality
ORDER BY AvgDefectRate DESC;


-- Question: Which batches are extreme in production volume and defect rate?
-- Purpose: Identify outliers for risk mitigation.
SELECT ProductionVolume, DefectRate
FROM manufacturing_dataset
WHERE ProductionVolume > (SELECT AVG(ProductionVolume) + STDEV(ProductionVolume) FROM manufacturing_dataset)
ORDER BY ProductionVolume DESC;


-- Question: What percentage of production batches are high-defect?
-- Purpose: Quantify defect risk across all production.
SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM manufacturing_dataset) AS HighDefectPercentage
FROM manufacturing_dataset
WHERE DefectStatus = 1;


-- Question: Does energy efficiency quartile correlate with defect rates?
-- Purpose: Find energy optimization strategies for quality improvement.
WITH Quartiles AS (
    SELECT *, NTILE(4) OVER (ORDER BY EnergyEfficiency DESC) AS EfficiencyQuartile
    FROM manufacturing_dataset
)
SELECT EfficiencyQuartile, AVG(DefectRate) AS AvgDefectRate
FROM Quartiles
GROUP BY EfficiencyQuartile
ORDER BY EfficiencyQuartile;

