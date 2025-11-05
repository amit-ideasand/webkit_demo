import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webkit/controller/my_controller.dart';

import 'package:webkit/models/chart_model.dart';
import 'package:webkit/models/lead_report_model.dart';

class CrmController extends MyController {
  List<ChartSampleData>? totalSaleChartData;
  List<ChartSampleData>? revenueForestData;
  String selectedTimeByLocation = "Year";
  List<LeadReportModel> leadReport = [];

  TooltipBehavior? tooltipBehavior;

  @override
  void onInit() {
    LeadReportModel.dummyList.then((value) {
      leadReport = value.sublist(0, 5);
      update();
    });

    totalSaleChartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 50, secondSeriesYValue: 40, thirdSeriesYValue: 45),
      ChartSampleData(x: 'Feb', y: 48, secondSeriesYValue: 38, thirdSeriesYValue: 46),
      ChartSampleData(x: 'Mar', y: 55, secondSeriesYValue: 42, thirdSeriesYValue: 50),
      ChartSampleData(x: 'Apr', y: 60, secondSeriesYValue: 45, thirdSeriesYValue: 55),
      ChartSampleData(x: 'May', y: 70, secondSeriesYValue: 50, thirdSeriesYValue: 60),
      ChartSampleData(x: 'Jun', y: 75, secondSeriesYValue: 55, thirdSeriesYValue: 65),
      ChartSampleData(x: 'Jul', y: 80, secondSeriesYValue: 60, thirdSeriesYValue: 70),
      ChartSampleData(x: 'Aug', y: 78, secondSeriesYValue: 58, thirdSeriesYValue: 68),
      ChartSampleData(x: 'Sep', y: 72, secondSeriesYValue: 55, thirdSeriesYValue: 65),
      ChartSampleData(x: 'Oct', y: 65, secondSeriesYValue: 50, thirdSeriesYValue: 60),
      ChartSampleData(x: 'Nov', y: 58, secondSeriesYValue: 45, thirdSeriesYValue: 55),
      ChartSampleData(x: 'Dec', y: 52, secondSeriesYValue: 42, thirdSeriesYValue: 50)
    ];

    revenueForestData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 20, secondSeriesYValue: 12),
      ChartSampleData(x: 'Feb', y: 22, secondSeriesYValue: 15),
      ChartSampleData(x: 'Mar', y: 25, secondSeriesYValue: 17),
      ChartSampleData(x: 'Apr', y: 18, secondSeriesYValue: 14),
      ChartSampleData(x: 'May', y: 28, secondSeriesYValue: 18),
      ChartSampleData(x: 'Jun', y: 21, secondSeriesYValue: 13),
      ChartSampleData(x: 'Jul', y: 24, secondSeriesYValue: 16),
      ChartSampleData(x: 'Aug', y: 22, secondSeriesYValue: 15),
      ChartSampleData(x: 'Sep', y: 26, secondSeriesYValue: 18),
      ChartSampleData(x: 'Oct', y: 27, secondSeriesYValue: 20),
      ChartSampleData(x: 'Nov', y: 23, secondSeriesYValue: 16),
      ChartSampleData(x: 'Dec', y: 19, secondSeriesYValue: 14),
    ];

    tooltipBehavior = TooltipBehavior(enable: true);
    super.onInit();
  }

  void onSelectedTimeByLocation(String time) {
    selectedTimeByLocation = time;
    update();
  }
}
