Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbdLSVBB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:01:01 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 04/10] staging: atomisp: Disable custom format for now
Date: Tue, 19 Dec 2017 22:59:51 +0200
Message-Id: <20171219205957.10933-4-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Custom video format 'M101' is not supported in upstream and as a result
user will get ugly warning:

 Unknown pixelformat 0x3130314d
 ------------[ cut here ]------------
 WARNING: CPU: 3 PID: 1574 at drivers/media/v4l2-core/v4l2-ioctl.c:1291 v4l_enum_fmt+0xcf1/0x13a0 [videodev]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/include/linux/atomisp.h       | 2 ++
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c  | 5 ++++-
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp.h b/drivers/staging/media/atomisp/include/linux/atomisp.h
index 15fa5679bae7..ebe193ba3871 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp.h
@@ -68,7 +68,9 @@
 #define V4L2_MBUS_FMT_CUSTOM_RGB32	0x800a
 
 /* Custom media bus format for M10MO RAW capture */
+#if 0
 #define V4L2_MBUS_FMT_CUSTOM_M10MO_RAW	0x800b
+#endif
 
 /* Configuration used by Bayer noise reduction and YCC noise reduction */
 struct atomisp_nr_config {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 339b5d31e1f1..5c84dd63778e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -501,7 +501,9 @@ const struct atomisp_format_bridge atomisp_output_fmts[] = {
 		.mbus_code = MEDIA_BUS_FMT_JPEG_1X8,
 		.sh_fmt = CSS_FRAME_FORMAT_BINARY_8,
 		.description = "JPEG"
-	}, {
+	},
+#if 0
+	{
 	/* This is a custom format being used by M10MO to send the RAW data */
 		.pixelformat = V4L2_PIX_FMT_CUSTOM_M10MO_RAW,
 		.depth = 8,
@@ -509,6 +511,7 @@ const struct atomisp_format_bridge atomisp_output_fmts[] = {
 		.sh_fmt = CSS_FRAME_FORMAT_BINARY_8,
 		.description = "Custom RAW for M10MO"
 	},
+#endif
 };
 
 const struct atomisp_format_bridge *atomisp_get_format_bridge(
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
index 70b53988553c..f3e18d627b0a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
@@ -48,7 +48,9 @@ const struct atomisp_in_fmt_conv atomisp_in_fmt_conv[] = {
 	{ V4L2_MBUS_FMT_CUSTOM_NV12, 12, 12, CSS_FRAME_FORMAT_NV12, 0, CSS_FRAME_FORMAT_NV12 },
 	{ V4L2_MBUS_FMT_CUSTOM_NV21, 12, 12, CSS_FRAME_FORMAT_NV21, 0, CSS_FRAME_FORMAT_NV21 },
 	{ V4L2_MBUS_FMT_CUSTOM_YUV420, 12, 12, ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY, 0, IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY },
+#if 0
 	{ V4L2_MBUS_FMT_CUSTOM_M10MO_RAW, 8, 8, CSS_FRAME_FORMAT_BINARY_8, 0, IA_CSS_STREAM_FORMAT_BINARY_8 },
+#endif
 	/* no valid V4L2 MBUS code for metadata format, so leave it 0. */
 	{ 0, 0, 0, ATOMISP_INPUT_FORMAT_EMBEDDED, 0, IA_CSS_STREAM_FORMAT_EMBEDDED },
 	{}
-- 
2.15.1
