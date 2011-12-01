Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61789 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1LAKVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 05:21:00 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVI00B6HSQXU7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Dec 2011 10:20:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVI007QDSQWCW@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Dec 2011 10:20:57 +0000 (GMT)
Date: Thu, 01 Dec 2011 11:20:51 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v2 2/4] m5mols: Add support for buffer size configuration
 for compressed formats
In-reply-to: <1322734853-8759-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1322734853-8759-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1322734853-8759-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use new struct v4l2_mbus_framefmt framesamples field to return maximum
size of data transmitted per single frame. The framesamples value is
adjusted according to pixel format and configured at the ISP registers.

Except the pixel width and height, the frame size can also be made
dependent on JPEG image quality, when corresponding control is
available at the sub-device interface.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h         |    8 ++++++++
 drivers/media/video/m5mols/m5mols_capture.c |    4 ++++
 drivers/media/video/m5mols/m5mols_core.c    |   15 +++++++++++++++
 drivers/media/video/m5mols/m5mols_reg.h     |    1 +
 4 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 42c494c..3e71151 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -16,9 +16,17 @@
 #ifndef M5MOLS_H
 #define M5MOLS_H
 
+#include <asm/sizes.h>
 #include <media/v4l2-subdev.h>
 #include "m5mols_reg.h"
 
+/*
+ * This is an amount of data transmitted in addition to the configured
+ * JPEG_SIZE_MAX value.
+ */
+#define M5MOLS_JPEG_TAGS_SIZE		0x20000
+#define M5MOLS_MAIN_JPEG_SIZE_MAX	(5 * SZ_1M)
+
 extern int m5mols_debug;
 
 #define to_m5mols(__sd)	container_of(__sd, struct m5mols_info, sd)
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 3248ac8..c8da22f 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -119,6 +119,7 @@ static int m5mols_capture_info(struct m5mols_info *info)
 
 int m5mols_start_capture(struct m5mols_info *info)
 {
+	struct v4l2_mbus_framefmt *mf = &info->ffmt[info->res_type];
 	struct v4l2_subdev *sd = &info->sd;
 	u8 resolution = info->resolution;
 	int timeout;
@@ -170,6 +171,9 @@ int m5mols_start_capture(struct m5mols_info *info)
 	if (!ret)
 		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, resolution);
 	if (!ret)
+		ret = m5mols_write(sd, CAPP_JPEG_SIZE_MAX,
+				   mf->framesamples - M5MOLS_JPEG_TAGS_SIZE);
+	if (!ret)
 		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
 	if (!ret)
 		ret = m5mols_write(sd, CAPC_START, REG_CAP_START_MAIN);
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 3344df5..c230a44 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -505,6 +505,16 @@ static struct v4l2_mbus_framefmt *__find_format(struct m5mols_info *info,
 	return &info->ffmt[type];
 }
 
+static inline void m5mols_get_buffer_size(struct m5mols_info *info,
+					  struct v4l2_mbus_framefmt *mf)
+{
+	u32 min_sz = mf->width * mf->height + M5MOLS_JPEG_TAGS_SIZE;
+
+	/* Clamp provided value to the maximum needed */
+	mf->framesamples = clamp_t(u32, mf->framesamples, min_sz,
+				   M5MOLS_MAIN_JPEG_SIZE_MAX);
+}
+
 static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			  struct v4l2_subdev_format *fmt)
 {
@@ -515,6 +525,9 @@ static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (!format)
 		return -EINVAL;
 
+	if (format->code == V4L2_MBUS_FMT_JPEG_1X8)
+		m5mols_get_buffer_size(info, format);
+
 	fmt->format = *format;
 	return 0;
 }
@@ -537,6 +550,8 @@ static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (!sfmt)
 		return 0;
 
+	if (format->code == V4L2_MBUS_FMT_JPEG_1X8)
+		m5mols_get_buffer_size(info, format);
 
 	format->code = m5mols_default_ffmt[type].code;
 	format->colorspace = V4L2_COLORSPACE_JPEG;
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index 642d8c5..43a6445 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -310,6 +310,7 @@
 #define REG_JPEG		0x10
 
 #define CAPP_MAIN_IMAGE_SIZE	I2C_REG(CAT_CAPT_PARM, 0x01, 1)
+#define CAPP_JPEG_SIZE_MAX	I2C_REG(CAT_CAPT_PARM, 0x0f, 4)
 
 #define CAPP_MCC_MODE		I2C_REG(CAT_CAPT_PARM, 0x1d, 1)
 #define REG_MCC_OFF		0x00
-- 
1.7.7.2

