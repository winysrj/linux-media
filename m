Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40312 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752387AbdHHNa6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:30:58 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 13/21] doc: media/v4l-drivers: Qualcomm Camera Subsystem - PIX Interface
Date: Tue,  8 Aug 2017 16:30:10 +0300
Message-Id: <1502199018-28250-14-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update Qualcomm Camera Subsystem driver document for the PIX interface
and format conversion support.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 Documentation/media/v4l-drivers/qcom_camss.rst | 46 ++++++++++++++++++++------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/v4l-drivers/qcom_camss.rst b/Documentation/media/v4l-drivers/qcom_camss.rst
index 4707ea7..d888443 100644
--- a/Documentation/media/v4l-drivers/qcom_camss.rst
+++ b/Documentation/media/v4l-drivers/qcom_camss.rst
@@ -45,12 +45,36 @@ Supported functionality
 
 The current version of the driver supports:
 
-- input from camera sensor via CSIPHY;
-- generation of test input data by the TG in CSID;
-- raw dump of the input data to memory. RDI interface of VFE is supported.
-  PIX interface (ISP processing, statistics engines, resize/crop, format
-  conversion) is not supported in the current version;
-- concurrent and independent usage of two data inputs - could be camera sensors
+- Input from camera sensor via CSIPHY;
+- Generation of test input data by the TG in CSID;
+- RDI interface of VFE - raw dump of the input data to memory.
+
+  Supported formats:
+
+  - YUYV/UYVY/YVYU/VYUY (packed YUV 4:2:2 - V4L2_PIX_FMT_YUYV /
+    V4L2_PIX_FMT_UYVY / V4L2_PIX_FMT_YVYU / V4L2_PIX_FMT_VYUY);
+  - MIPI RAW8 (8bit Bayer RAW - V4L2_PIX_FMT_SRGGB8 /
+    V4L2_PIX_FMT_SGRBG8 / V4L2_PIX_FMT_SGBRG8 / V4L2_PIX_FMT_SBGGR8);
+  - MIPI RAW10 (10bit packed Bayer RAW - V4L2_PIX_FMT_SBGGR10P /
+    V4L2_PIX_FMT_SGBRG10P / V4L2_PIX_FMT_SGRBG10P / V4L2_PIX_FMT_SRGGB10P);
+  - MIPI RAW12 (12bit packed Bayer RAW - V4L2_PIX_FMT_SRGGB12P /
+    V4L2_PIX_FMT_SGBRG12P / V4L2_PIX_FMT_SGRBG12P / V4L2_PIX_FMT_SRGGB12P).
+
+- PIX interface of VFE
+
+  - Format conversion of the input data.
+
+    Supported input formats:
+
+    - YUYV/UYVY/YVYU/VYUY (packed YUV 4:2:2 - V4L2_PIX_FMT_YUYV /
+      V4L2_PIX_FMT_UYVY / V4L2_PIX_FMT_YVYU / V4L2_PIX_FMT_VYUY).
+
+    Supported output formats:
+
+    - NV12/NV21 (two plane YUV 4:2:0 - V4L2_PIX_FMT_NV12 / V4L2_PIX_FMT_NV21);
+    - NV16/NV61 (two plane YUV 4:2:2 - V4L2_PIX_FMT_NV16 / V4L2_PIX_FMT_NV61).
+
+- Concurrent and independent usage of two data inputs - could be camera sensors
   and/or TG.
 
 
@@ -65,15 +89,15 @@ interface, the driver is split into V4L2 sub-devices as follows:
 - 2 CSID sub-devices - each CSID is represented by a single sub-device;
 - 2 ISPIF sub-devices - ISPIF is represented by a number of sub-devices equal
   to the number of CSID sub-devices;
-- 3 VFE sub-devices - VFE is represented by a number of sub-devices equal to
-  the number of RDI input interfaces.
+- 4 VFE sub-devices - VFE is represented by a number of sub-devices equal to
+  the number of the input interfaces (3 RDI and 1 PIX).
 
 The considerations to split the driver in this particular way are as follows:
 
 - representing CSIPHY and CSID modules by a separate sub-device for each module
   allows to model the hardware links between these modules;
-- representing VFE by a separate sub-devices for each RDI input interface allows
-  to use the three RDI interfaces concurently and independently as this is
+- representing VFE by a separate sub-devices for each input interface allows
+  to use the input interfaces concurently and independently as this is
   supported by the hardware;
 - representing ISPIF by a number of sub-devices equal to the number of CSID
   sub-devices allows to create linear media controller pipelines when using two
@@ -99,6 +123,8 @@ nodes) is as follows:
 - msm_vfe0_video1
 - msm_vfe0_rdi2
 - msm_vfe0_video2
+- msm_vfe0_pix
+- msm_vfe0_video3
 
 
 Implementation
-- 
2.7.4
