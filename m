Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52591 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259Ab1KCRBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 13:01:48 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LU300AQKGMWDN@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 17:01:44 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU3006QYGMWDZ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 17:01:44 +0000 (GMT)
Date: Thu, 03 Nov 2011 18:01:34 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 3/3] m5mols: Add g_framesamples operation support
In-reply-to: <1320339694-9027-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320339694-9027-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320339694-9027-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The g_framesamples() callback is added to allow the host driver to retrieve
the information about maximum required memory buffer size to hold single
frame. Unlike with raw image formats, the host knowledge about the final
frame size is very limited and depends on compression process parameters,
which details are only known to a subdev driver.

This patch adds M-5MOLS register configuration for maximum amount of data
transmitted through the CSI bus. The configured value is then returned
in .g_framesamples() allowing the host to allocate a memory buffer of
an exact needed size.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h         |    2 ++
 drivers/media/video/m5mols/m5mols_capture.c |    4 ++++
 drivers/media/video/m5mols/m5mols_core.c    |   16 +++++++++++++++-
 drivers/media/video/m5mols/m5mols_reg.h     |    2 ++
 4 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 0d7e202..164cf0e 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -19,6 +19,8 @@
 #include <media/v4l2-subdev.h>
 #include "m5mols_reg.h"
 
+#define M5MOLS_MAIN_JPEG_TAGS_SIZE	0x20000
+
 extern int m5mols_debug;
 
 #define to_m5mols(__sd)	container_of(__sd, struct m5mols_info, sd)
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 1abc4fb..46c9e2d 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -104,6 +104,8 @@ static int m5mols_capture_info(struct m5mols_info *info)
 
 int m5mols_start_capture(struct m5mols_info *info)
 {
+	struct v4l2_mbus_framefmt *mf = &info->ffmt[info->res_type];
+	unsigned int framesize = mf->width * mf->height;
 	struct v4l2_subdev *sd = &info->sd;
 	u8 resolution = info->resolution;
 	int ret;
@@ -122,6 +124,8 @@ int m5mols_start_capture(struct m5mols_info *info)
 	if (!ret)
 		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, resolution);
 	if (!ret)
+		ret = m5mols_write(sd, CAPP_JPEG_SIZE_MAX, framesize);
+	if (!ret)
 		ret = m5mols_lock_3a(info, true);
 	if (!ret)
 		ret = m5mols_mode(info, REG_CAPTURE);
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index e5f2393..205c80f 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -695,8 +695,22 @@ static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
 	return m5mols_mode(info, REG_PARAMETER);
 }
 
+static int m5mols_g_framesamples(struct v4l2_subdev *sd,
+				 struct v4l2_mbus_framefmt *mf,
+				 unsigned int *count)
+{
+	BUG_ON(count == NULL);
+	*count = mf->width * mf->height;
+
+	if (mf->code == V4L2_MBUS_FMT_JPEG_1X8)
+		*count += M5MOLS_MAIN_JPEG_TAGS_SIZE;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_video_ops m5mols_video_ops = {
-	.s_stream	= m5mols_s_stream,
+	.g_mbus_framesamples	= m5mols_g_framesamples,
+	.s_stream		= m5mols_s_stream,
 };
 
 static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index 533aa27..ff56c7f 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -342,6 +342,7 @@
  */
 #define CATB_YUVOUT_MAIN	0x00
 #define CATB_MAIN_IMAGE_SIZE	0x01
+#define CATB_JPEG_SIZE_MAX	0x0f
 #define CATB_MCC_MODE		0x1d
 #define CATB_WDR_EN		0x2c
 #define CATB_LIGHT_CTRL		0x40
@@ -354,6 +355,7 @@
 #define REG_JPEG		0x10
 
 #define CAPP_MAIN_IMAGE_SIZE	I2C_REG(CAT_CAPT_PARM, CATB_MAIN_IMAGE_SIZE, 1)
+#define CAPP_JPEG_SIZE_MAX	I2C_REG(CAT_CAPT_PARM, CATB_JPEG_SIZE_MAX, 4)
 
 #define CAPP_MCC_MODE		I2C_REG(CAT_CAPT_PARM, CATB_MCC_MODE, 1)
 #define REG_MCC_OFF		0x00
-- 
1.7.7.1

