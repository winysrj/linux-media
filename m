Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39964 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388174AbeGWMEu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:50 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 33/35] media: doc: media/v4l-drivers: Update Qualcomm CAMSS driver document for 8x96
Date: Mon, 23 Jul 2018 14:02:50 +0300
Message-Id: <1532343772-27382-34-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the document to describe the support of Camera Subsystem
on MSM8996/APQ8096.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 Documentation/media/v4l-drivers/qcom_camss.rst     |  93 +++++++++++-------
 .../media/v4l-drivers/qcom_camss_8x96_graph.dot    | 104 +++++++++++++++++++++
 2 files changed, 164 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot

diff --git a/Documentation/media/v4l-drivers/qcom_camss.rst b/Documentation/media/v4l-drivers/qcom_camss.rst
index 9e66b7b..f27c8df 100644
--- a/Documentation/media/v4l-drivers/qcom_camss.rst
+++ b/Documentation/media/v4l-drivers/qcom_camss.rst
@@ -7,34 +7,34 @@ Introduction
 ------------
 
 This file documents the Qualcomm Camera Subsystem driver located under
-drivers/media/platform/qcom/camss-8x16.
+drivers/media/platform/qcom/camss.
 
 The current version of the driver supports the Camera Subsystem found on
-Qualcomm MSM8916 and APQ8016 processors.
+Qualcomm MSM8916/APQ8016 and MSM8996/APQ8096 processors.
 
 The driver implements V4L2, Media controller and V4L2 subdev interfaces.
 Camera sensor using V4L2 subdev interface in the kernel is supported.
 
 The driver is implemented using as a reference the Qualcomm Camera Subsystem
-driver for Android as found in Code Aurora [#f1]_.
+driver for Android as found in Code Aurora [#f1]_ [#f2]_.
 
 
 Qualcomm Camera Subsystem hardware
 ----------------------------------
 
-The Camera Subsystem hardware found on 8x16 processors and supported by the
-driver consists of:
+The Camera Subsystem hardware found on 8x16 / 8x96 processors and supported by
+the driver consists of:
 
-- 2 CSIPHY modules. They handle the Physical layer of the CSI2 receivers.
+- 2 / 3 CSIPHY modules. They handle the Physical layer of the CSI2 receivers.
   A separate camera sensor can be connected to each of the CSIPHY module;
-- 2 CSID (CSI Decoder) modules. They handle the Protocol and Application layer
-  of the CSI2 receivers. A CSID can decode data stream from any of the CSIPHY.
-  Each CSID also contains a TG (Test Generator) block which can generate
+- 2 / 4 CSID (CSI Decoder) modules. They handle the Protocol and Application
+  layer of the CSI2 receivers. A CSID can decode data stream from any of the
+  CSIPHY. Each CSID also contains a TG (Test Generator) block which can generate
   artificial input data for test purposes;
 - ISPIF (ISP Interface) module. Handles the routing of the data streams from
   the CSIDs to the inputs of the VFE;
-- VFE (Video Front End) module. Contains a pipeline of image processing hardware
-  blocks. The VFE has different input interfaces. The PIX (Pixel) input
+- 1 / 2 VFE (Video Front End) module(s). Contain a pipeline of image processing
+  hardware blocks. The VFE has different input interfaces. The PIX (Pixel) input
   interface feeds the input data to the image processing pipeline. The image
   processing pipeline contains also a scale and crop module at the end. Three
   RDI (Raw Dump Interface) input interfaces bypass the image processing
@@ -49,18 +49,33 @@ The current version of the driver supports:
 
 - Input from camera sensor via CSIPHY;
 - Generation of test input data by the TG in CSID;
-- RDI interface of VFE - raw dump of the input data to memory.
+- RDI interface of VFE
 
-  Supported formats:
+  - Raw dump of the input data to memory.
 
-  - YUYV/UYVY/YVYU/VYUY (packed YUV 4:2:2 - V4L2_PIX_FMT_YUYV /
-    V4L2_PIX_FMT_UYVY / V4L2_PIX_FMT_YVYU / V4L2_PIX_FMT_VYUY);
-  - MIPI RAW8 (8bit Bayer RAW - V4L2_PIX_FMT_SRGGB8 /
-    V4L2_PIX_FMT_SGRBG8 / V4L2_PIX_FMT_SGBRG8 / V4L2_PIX_FMT_SBGGR8);
-  - MIPI RAW10 (10bit packed Bayer RAW - V4L2_PIX_FMT_SBGGR10P /
-    V4L2_PIX_FMT_SGBRG10P / V4L2_PIX_FMT_SGRBG10P / V4L2_PIX_FMT_SRGGB10P);
-  - MIPI RAW12 (12bit packed Bayer RAW - V4L2_PIX_FMT_SRGGB12P /
-    V4L2_PIX_FMT_SGBRG12P / V4L2_PIX_FMT_SGRBG12P / V4L2_PIX_FMT_SRGGB12P).
+    Supported formats:
+
+    - YUYV/UYVY/YVYU/VYUY (packed YUV 4:2:2 - V4L2_PIX_FMT_YUYV /
+      V4L2_PIX_FMT_UYVY / V4L2_PIX_FMT_YVYU / V4L2_PIX_FMT_VYUY);
+    - MIPI RAW8 (8bit Bayer RAW - V4L2_PIX_FMT_SRGGB8 /
+      V4L2_PIX_FMT_SGRBG8 / V4L2_PIX_FMT_SGBRG8 / V4L2_PIX_FMT_SBGGR8);
+    - MIPI RAW10 (10bit packed Bayer RAW - V4L2_PIX_FMT_SBGGR10P /
+      V4L2_PIX_FMT_SGBRG10P / V4L2_PIX_FMT_SGRBG10P / V4L2_PIX_FMT_SRGGB10P /
+      V4L2_PIX_FMT_Y10P);
+    - MIPI RAW12 (12bit packed Bayer RAW - V4L2_PIX_FMT_SRGGB12P /
+      V4L2_PIX_FMT_SGBRG12P / V4L2_PIX_FMT_SGRBG12P / V4L2_PIX_FMT_SRGGB12P).
+    - (8x96 only) MIPI RAW14 (14bit packed Bayer RAW - V4L2_PIX_FMT_SRGGB14P /
+      V4L2_PIX_FMT_SGBRG14P / V4L2_PIX_FMT_SGRBG14P / V4L2_PIX_FMT_SRGGB14P).
+
+  - (8x96 only) Format conversion of the input data.
+
+    Supported input formats:
+
+    - MIPI RAW10 (10bit packed Bayer RAW - V4L2_PIX_FMT_SBGGR10P / V4L2_PIX_FMT_Y10P).
+
+    Supported output formats:
+
+    - Plain16 RAW10 (10bit unpacked Bayer RAW - V4L2_PIX_FMT_SBGGR10 / V4L2_PIX_FMT_Y10).
 
 - PIX interface of VFE
 
@@ -75,14 +90,16 @@ The current version of the driver supports:
 
     - NV12/NV21 (two plane YUV 4:2:0 - V4L2_PIX_FMT_NV12 / V4L2_PIX_FMT_NV21);
     - NV16/NV61 (two plane YUV 4:2:2 - V4L2_PIX_FMT_NV16 / V4L2_PIX_FMT_NV61).
+    - (8x96 only) YUYV/UYVY/YVYU/VYUY (packed YUV 4:2:2 - V4L2_PIX_FMT_YUYV /
+      V4L2_PIX_FMT_UYVY / V4L2_PIX_FMT_YVYU / V4L2_PIX_FMT_VYUY).
 
   - Scaling support. Configuration of the VFE Encoder Scale module
     for downscalling with ratio up to 16x.
 
   - Cropping support. Configuration of the VFE Encoder Crop module.
 
-- Concurrent and independent usage of two data inputs - could be camera sensors
-  and/or TG.
+- Concurrent and independent usage of two (8x96: three) data inputs -
+  could be camera sensors and/or TG.
 
 
 Driver Architecture and Design
@@ -90,14 +107,14 @@ Driver Architecture and Design
 
 The driver implements the V4L2 subdev interface. With the goal to model the
 hardware links between the modules and to expose a clean, logical and usable
-interface, the driver is split into V4L2 sub-devices as follows:
+interface, the driver is split into V4L2 sub-devices as follows (8x16 / 8x96):
 
-- 2 CSIPHY sub-devices - each CSIPHY is represented by a single sub-device;
-- 2 CSID sub-devices - each CSID is represented by a single sub-device;
-- 2 ISPIF sub-devices - ISPIF is represented by a number of sub-devices equal
-  to the number of CSID sub-devices;
-- 4 VFE sub-devices - VFE is represented by a number of sub-devices equal to
-  the number of the input interfaces (3 RDI and 1 PIX).
+- 2 / 3 CSIPHY sub-devices - each CSIPHY is represented by a single sub-device;
+- 2 / 4 CSID sub-devices - each CSID is represented by a single sub-device;
+- 2 / 4 ISPIF sub-devices - ISPIF is represented by a number of sub-devices
+  equal to the number of CSID sub-devices;
+- 4 / 8 VFE sub-devices - VFE is represented by a number of sub-devices equal to
+  the number of the input interfaces (3 RDI and 1 PIX for each VFE).
 
 The considerations to split the driver in this particular way are as follows:
 
@@ -115,8 +132,8 @@ The considerations to split the driver in this particular way are as follows:
 
 Each VFE sub-device is linked to a separate video device node.
 
-The media controller pipeline graph is as follows (with connected two OV5645
-camera sensors):
+The media controller pipeline graph is as follows (with connected two / three
+OV5645 camera sensors):
 
 .. _qcom_camss_graph:
 
@@ -124,7 +141,13 @@ camera sensors):
     :alt:   qcom_camss_graph.dot
     :align: center
 
-    Media pipeline graph
+    Media pipeline graph 8x16
+
+.. kernel-figure:: qcom_camss_8x96_graph.dot
+    :alt:   qcom_camss_8x96_graph.dot
+    :align: center
+
+    Media pipeline graph 8x96
 
 
 Implementation
@@ -149,8 +172,12 @@ APQ8016 Specification:
 https://developer.qualcomm.com/download/sd410/snapdragon-410-processor-device-specification.pdf
 Referenced 2016-11-24.
 
+APQ8096 Specification:
+https://developer.qualcomm.com/download/sd820e/qualcomm-snapdragon-820e-processor-apq8096sge-device-specification.pdf
+Referenced 2018-06-22.
 
 References
 ----------
 
 .. [#f1] https://source.codeaurora.org/quic/la/kernel/msm-3.10/
+.. [#f2] https://source.codeaurora.org/quic/la/kernel/msm-3.18/
diff --git a/Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot b/Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
new file mode 100644
index 0000000..de34f0a
--- /dev/null
+++ b/Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
@@ -0,0 +1,104 @@
+digraph board {
+	rankdir=TB
+	n00000001 [label="{{<port0> 0} | msm_csiphy0\n/dev/v4l-subdev0 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000001:port1 -> n0000000a:port0 [style=dashed]
+	n00000001:port1 -> n0000000d:port0 [style=dashed]
+	n00000001:port1 -> n00000010:port0 [style=dashed]
+	n00000001:port1 -> n00000013:port0 [style=dashed]
+	n00000004 [label="{{<port0> 0} | msm_csiphy1\n/dev/v4l-subdev1 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000004:port1 -> n0000000a:port0 [style=dashed]
+	n00000004:port1 -> n0000000d:port0 [style=dashed]
+	n00000004:port1 -> n00000010:port0 [style=dashed]
+	n00000004:port1 -> n00000013:port0 [style=dashed]
+	n00000007 [label="{{<port0> 0} | msm_csiphy2\n/dev/v4l-subdev2 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000007:port1 -> n0000000a:port0 [style=dashed]
+	n00000007:port1 -> n0000000d:port0 [style=dashed]
+	n00000007:port1 -> n00000010:port0 [style=dashed]
+	n00000007:port1 -> n00000013:port0 [style=dashed]
+	n0000000a [label="{{<port0> 0} | msm_csid0\n/dev/v4l-subdev3 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000000a:port1 -> n00000016:port0 [style=dashed]
+	n0000000a:port1 -> n00000019:port0 [style=dashed]
+	n0000000a:port1 -> n0000001c:port0 [style=dashed]
+	n0000000a:port1 -> n0000001f:port0 [style=dashed]
+	n0000000d [label="{{<port0> 0} | msm_csid1\n/dev/v4l-subdev4 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000000d:port1 -> n00000016:port0 [style=dashed]
+	n0000000d:port1 -> n00000019:port0 [style=dashed]
+	n0000000d:port1 -> n0000001c:port0 [style=dashed]
+	n0000000d:port1 -> n0000001f:port0 [style=dashed]
+	n00000010 [label="{{<port0> 0} | msm_csid2\n/dev/v4l-subdev5 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000010:port1 -> n00000016:port0 [style=dashed]
+	n00000010:port1 -> n00000019:port0 [style=dashed]
+	n00000010:port1 -> n0000001c:port0 [style=dashed]
+	n00000010:port1 -> n0000001f:port0 [style=dashed]
+	n00000013 [label="{{<port0> 0} | msm_csid3\n/dev/v4l-subdev6 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000013:port1 -> n00000016:port0 [style=dashed]
+	n00000013:port1 -> n00000019:port0 [style=dashed]
+	n00000013:port1 -> n0000001c:port0 [style=dashed]
+	n00000013:port1 -> n0000001f:port0 [style=dashed]
+	n00000016 [label="{{<port0> 0} | msm_ispif0\n/dev/v4l-subdev7 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000016:port1 -> n00000022:port0 [style=dashed]
+	n00000016:port1 -> n0000002b:port0 [style=dashed]
+	n00000016:port1 -> n00000034:port0 [style=dashed]
+	n00000016:port1 -> n0000003d:port0 [style=dashed]
+	n00000016:port1 -> n00000046:port0 [style=dashed]
+	n00000016:port1 -> n0000004f:port0 [style=dashed]
+	n00000016:port1 -> n00000058:port0 [style=dashed]
+	n00000016:port1 -> n00000061:port0 [style=dashed]
+	n00000019 [label="{{<port0> 0} | msm_ispif1\n/dev/v4l-subdev8 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000019:port1 -> n00000022:port0 [style=dashed]
+	n00000019:port1 -> n0000002b:port0 [style=dashed]
+	n00000019:port1 -> n00000034:port0 [style=dashed]
+	n00000019:port1 -> n0000003d:port0 [style=dashed]
+	n00000019:port1 -> n00000046:port0 [style=dashed]
+	n00000019:port1 -> n0000004f:port0 [style=dashed]
+	n00000019:port1 -> n00000058:port0 [style=dashed]
+	n00000019:port1 -> n00000061:port0 [style=dashed]
+	n0000001c [label="{{<port0> 0} | msm_ispif2\n/dev/v4l-subdev9 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000001c:port1 -> n00000022:port0 [style=dashed]
+	n0000001c:port1 -> n0000002b:port0 [style=dashed]
+	n0000001c:port1 -> n00000034:port0 [style=dashed]
+	n0000001c:port1 -> n0000003d:port0 [style=dashed]
+	n0000001c:port1 -> n00000046:port0 [style=dashed]
+	n0000001c:port1 -> n0000004f:port0 [style=dashed]
+	n0000001c:port1 -> n00000058:port0 [style=dashed]
+	n0000001c:port1 -> n00000061:port0 [style=dashed]
+	n0000001f [label="{{<port0> 0} | msm_ispif3\n/dev/v4l-subdev10 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000001f:port1 -> n00000022:port0 [style=dashed]
+	n0000001f:port1 -> n0000002b:port0 [style=dashed]
+	n0000001f:port1 -> n00000034:port0 [style=dashed]
+	n0000001f:port1 -> n0000003d:port0 [style=dashed]
+	n0000001f:port1 -> n00000046:port0 [style=dashed]
+	n0000001f:port1 -> n0000004f:port0 [style=dashed]
+	n0000001f:port1 -> n00000058:port0 [style=dashed]
+	n0000001f:port1 -> n00000061:port0 [style=dashed]
+	n00000022 [label="{{<port0> 0} | msm_vfe0_rdi0\n/dev/v4l-subdev11 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000022:port1 -> n00000025 [style=bold]
+	n00000025 [label="msm_vfe0_video0\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
+	n0000002b [label="{{<port0> 0} | msm_vfe0_rdi1\n/dev/v4l-subdev12 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000002b:port1 -> n0000002e [style=bold]
+	n0000002e [label="msm_vfe0_video1\n/dev/video1", shape=box, style=filled, fillcolor=yellow]
+	n00000034 [label="{{<port0> 0} | msm_vfe0_rdi2\n/dev/v4l-subdev13 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000034:port1 -> n00000037 [style=bold]
+	n00000037 [label="msm_vfe0_video2\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
+	n0000003d [label="{{<port0> 0} | msm_vfe0_pix\n/dev/v4l-subdev14 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000003d:port1 -> n00000040 [style=bold]
+	n00000040 [label="msm_vfe0_video3\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
+	n00000046 [label="{{<port0> 0} | msm_vfe1_rdi0\n/dev/v4l-subdev15 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000046:port1 -> n00000049 [style=bold]
+	n00000049 [label="msm_vfe1_video0\n/dev/video4", shape=box, style=filled, fillcolor=yellow]
+	n0000004f [label="{{<port0> 0} | msm_vfe1_rdi1\n/dev/v4l-subdev16 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000004f:port1 -> n00000052 [style=bold]
+	n00000052 [label="msm_vfe1_video1\n/dev/video5", shape=box, style=filled, fillcolor=yellow]
+	n00000058 [label="{{<port0> 0} | msm_vfe1_rdi2\n/dev/v4l-subdev17 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000058:port1 -> n0000005b [style=bold]
+	n0000005b [label="msm_vfe1_video2\n/dev/video6", shape=box, style=filled, fillcolor=yellow]
+	n00000061 [label="{{<port0> 0} | msm_vfe1_pix\n/dev/v4l-subdev18 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000061:port1 -> n00000064 [style=bold]
+	n00000064 [label="msm_vfe1_video3\n/dev/video7", shape=box, style=filled, fillcolor=yellow]
+	n000000e2 [label="{{} | ov5645 3-0039\n/dev/v4l-subdev19 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
+	n000000e2:port0 -> n00000004:port0 [style=bold]
+	n000000e4 [label="{{} | ov5645 3-003a\n/dev/v4l-subdev20 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
+	n000000e4:port0 -> n00000007:port0 [style=bold]
+	n000000e6 [label="{{} | ov5645 3-003b\n/dev/v4l-subdev21 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
+	n000000e6:port0 -> n00000001:port0 [style=bold]
+}
-- 
2.7.4
