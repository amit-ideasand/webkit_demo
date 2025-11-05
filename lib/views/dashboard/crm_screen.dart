import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webkit/controller/dashboard/crm_controller.dart';
import 'package:webkit/helpers/theme/app_theme.dart';
import 'package:webkit/helpers/utils/my_shadow.dart';
import 'package:webkit/helpers/utils/ui_mixins.dart';
import 'package:webkit/helpers/utils/utils.dart';
import 'package:webkit/helpers/widgets/my_breadcrumb.dart';
import 'package:webkit/helpers/widgets/my_breadcrumb_item.dart';
import 'package:webkit/helpers/widgets/my_card.dart';
import 'package:webkit/helpers/widgets/my_container.dart';
import 'package:webkit/helpers/widgets/my_flex.dart';
import 'package:webkit/helpers/widgets/my_flex_item.dart';
import 'package:webkit/helpers/widgets/my_list_extension.dart';
import 'package:webkit/helpers/widgets/my_spacing.dart';
import 'package:webkit/helpers/widgets/my_text.dart';
import 'package:webkit/helpers/widgets/responsive.dart';
import 'package:webkit/images.dart';
import 'package:webkit/views/layouts/layout.dart';

import 'package:webkit/models/chart_model.dart';

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> with UIMixin {
  CrmController controller = Get.put(CrmController());

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder(
        init: controller,
        tag: 'crm_dashboard_controller',
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "CRM",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Dashboard', active: true),
                        MyBreadcrumbItem(name: 'CRM'),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: MyFlex(
                  children: [
                    MyFlexItem(sizes: 'lg-2.4 md-6 sm-6', child: stats("Total Leads", "823", "15.78%", LucideIcons.users, contentTheme.primary)),
                    MyFlexItem(sizes: 'lg-2.4 md-6 sm-6', child: stats("Total Revenue", "\$1,235.75", "12.50%", LucideIcons.dollar_sign, contentTheme.success)),
                    MyFlexItem(sizes: 'lg-2.4 md-6 sm-6', child: stats("Pending Tasks", "78", "-23.45%", LucideIcons.circle_check, contentTheme.warning)),
                    MyFlexItem(sizes: 'lg-2.4 md-6 sm-6', child: stats("Completed Contracts", "\$543.60", "18.45%", LucideIcons.file_check, contentTheme.info)),
                    MyFlexItem(sizes: 'lg-2.4', child: stats("New Subscribers", "120", "8.25%", LucideIcons.user_plus, contentTheme.primary)),
                    MyFlexItem(sizes: 'lg-6', child: totalSales()),
                    MyFlexItem(sizes: 'lg-6', child: revenueForecast()),
                    MyFlexItem(child: leadReport()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget stats(String title, String value, String valueRate, IconData icon, Color color) {
    return MyCard(
      shadow: MyShadow(elevation: 0.5),
      paddingAll: 24,
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyContainer(
            paddingAll: 0,
            height: 44,
            width: 44,
            color: color,
            child: Icon(icon, color: contentTheme.light),
          ),
          MyText.bodyMedium(title, fontWeight: 600, xMuted: true, maxLines: 1),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: MyText.titleLarge(value, fontWeight: 600, xMuted: true, maxLines: 1)),
                Row(
                  children: [
                    MyText.labelMedium(valueRate, color: valueRate.startsWith('-') ? contentTheme.danger : contentTheme.success, xMuted: true),
                    MySpacing.width(4),
                    Icon(valueRate.startsWith('-') ? LucideIcons.chevron_down : LucideIcons.chevron_up,
                        size: 12, color: valueRate.startsWith('-') ? contentTheme.danger : contentTheme.success),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget totalSales() {
    return MyCard(
      shadow: MyShadow(elevation: 0.5),
      paddingAll: 24,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText.bodyMedium("Total Sales", fontWeight: 600),
              PopupMenuButton(
                onSelected: controller.onSelectedTimeByLocation,
                itemBuilder: (BuildContext context) {
                  return ["Year", "Month", "Week", "Day", "Hours"].map((behavior) {
                    return PopupMenuItem(
                      value: behavior,
                      height: 32,
                      child: MyText.bodySmall(behavior.toString(), color: theme.colorScheme.onSurface, fontWeight: 600),
                    );
                  }).toList();
                },
                color: theme.cardTheme.color,
                child: MyContainer.bordered(
                  padding: MySpacing.xy(8, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MyText.labelMedium(controller.selectedTimeByLocation.toString(), color: theme.colorScheme.onSurface),
                      MySpacing.height(4),
                      Icon(LucideIcons.chevron_down, size: 20, color: theme.colorScheme.onSurface)
                    ],
                  ),
                ),
              ),
            ],
          ),
          MySpacing.height(22),
          SfCartesianChart(
            plotAreaBorderWidth: 0,
            margin: MySpacing.zero,
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            primaryXAxis: const CategoryAxis(majorGridLines: MajorGridLines(width: 0), labelPlacement: LabelPlacement.onTicks),
            primaryYAxis: const NumericAxis(
                minimum: 30,
                interval: 10,
                axisLine: AxisLine(width: 0),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                labelFormat: '{value}',
                majorTickLines: MajorTickLines(size: 0)),
            series: [
              SplineSeries<ChartSampleData, String>(
                dataSource: controller.totalSaleChartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x as String,
                yValueMapper: (ChartSampleData sales, _) => sales.y,
                markerSettings: const MarkerSettings(isVisible: true),
                color: contentTheme.primary,
                name: 'Revenue',
              ),
              SplineSeries<ChartSampleData, String>(
                dataSource: controller.totalSaleChartData,
                name: 'Other',
                color: contentTheme.secondary,
                markerSettings: const MarkerSettings(isVisible: true),
                xValueMapper: (ChartSampleData sales, _) => sales.x as String,
                yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
              )
            ],
            tooltipBehavior: TooltipBehavior(enable: true),
          )
        ],
      ),
    );
  }

  Widget revenueForecast() {
    return MyCard(
      shadow: MyShadow(elevation: 0.5),
      paddingAll: 24,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText.bodyMedium("Revenue Forecast", fontWeight: 600),
              PopupMenuButton(
                offset: Offset(0, 20),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(padding: MySpacing.xy(16, 8), height: 10, child: MyText.bodySmall("Download", fontWeight: 600)),
                  PopupMenuItem(padding: MySpacing.xy(16, 8), height: 10, child: MyText.bodySmall("Import", fontWeight: 600)),
                  PopupMenuItem(padding: MySpacing.xy(16, 8), height: 10, child: MyText.bodySmall("Export", fontWeight: 600)),
                ],
                child: Icon(LucideIcons.ellipsis_vertical, size: 20),
              )
            ],
          ),
          MySpacing.height(24),
          SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: const CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
            margin: MySpacing.zero,
            primaryYAxis: const NumericAxis(minimum: 0, interval: 4, axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
            series: [
              ColumnSeries<ChartSampleData, String>(
                  width: 0.8,
                  spacing: 0.2,
                  dataSource: controller.revenueForestData,
                  color: contentTheme.primary,
                  xValueMapper: (ChartSampleData sales, _) => sales.x as String,
                  yValueMapper: (ChartSampleData sales, _) => sales.y,
                  name: 'Sales Revenue'),
              ColumnSeries<ChartSampleData, String>(
                  dataSource: controller.revenueForestData,
                  width: 0.8,
                  spacing: 0.2,
                  color: contentTheme.secondary,
                  xValueMapper: (ChartSampleData sales, _) => sales.x as String,
                  yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
                  name: 'Product Cost'),
            ],
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            tooltipBehavior: controller.tooltipBehavior,
          )
        ],
      ),
    );
  }

  Widget leadReport() {
    return MyCard(
        shadow: MyShadow(elevation: 0.5),
        paddingAll: 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText.bodyMedium("Lead Report", fontWeight: 600),
            MySpacing.height(24),
            if (controller.leadReport.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    sortAscending: true,
                    onSelectAll: (_) => {},
                    headingRowColor: WidgetStatePropertyAll(contentTheme.primary.withAlpha(40)),
                    dataRowMaxHeight: 70,
                    columnSpacing: 95,
                    columns: [
                      DataColumn(label: MyText.labelLarge('S.No', color: contentTheme.primary)),
                      DataColumn(label: MyText.labelLarge('Lead', color: contentTheme.primary)),
                      DataColumn(label: MyText.labelLarge('Company Name', color: contentTheme.primary)),
                      DataColumn(label: MyText.labelLarge('Phone Number', color: contentTheme.primary)),
                      DataColumn(label: MyText.labelLarge('Status', color: contentTheme.primary)),
                      DataColumn(label: MyText.labelLarge('Location', color: contentTheme.primary)),
                      DataColumn(label: MyText.labelLarge('Date', color: contentTheme.primary)),
                      DataColumn(label: MyText.labelLarge('Amount', color: contentTheme.primary)),
                    ],
                    rows: controller.leadReport
                        .mapIndexed((index, data) => DataRow(cells: [
                              DataCell(MyText.bodyMedium("#${data.id}", fontWeight: 600)),
                              DataCell(Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MyContainer.rounded(
                                    height: 44,
                                    width: 44,
                                    paddingAll: 0,
                                    child: Image.asset(Images.avatars[index % Images.avatars.length], fit: BoxFit.cover),
                                  ),
                                  MySpacing.width(24),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyText.bodyMedium(data.firstName, fontWeight: 600),
                                      MyText.labelMedium(data.email),
                                    ],
                                  )
                                ],
                              )),
                              DataCell(MyText.bodyMedium(data.companyName, fontWeight: 600)),
                              DataCell(MyText.bodyMedium(data.phoneNumber, fontWeight: 600)),
                              DataCell(MyText.bodyMedium(data.status, fontWeight: 600)),
                              DataCell(MyText.bodyMedium(data.location, fontWeight: 600)),
                              DataCell(MyText.bodyMedium("${Utils.getDateStringFromDateTime(data.date)}", fontWeight: 600)),
                              DataCell(MyText.bodyMedium("\$${data.amount}", fontWeight: 600)),
                            ]))
                        .toList()),
              ),
          ],
        ));
  }
}
