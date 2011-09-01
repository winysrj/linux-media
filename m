Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab1IAPac (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Sep 2011 17:30:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 03/19 v4] s5p-fimc: Limit number of available inputs to one
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-4-git-send-email-s.nawrocki@samsung.com>
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current driver allowed camera sensors to be used only with single
FIMC H/W instance, FIMC0..FIMC2/3, designated at compile time. Remaining FIMC
entities could be used for video processing only, as mem-to-mem devices.
Required camera could be selected with S_INPUT ioctl at one devnode only.

However in that case it was not possible to use both cameras independently
at the same time, as all sensors were registered to single FIMC capture
driver. In most recent S5P SoC version there is enough FIMC H/W instances
to cover all physical camera interfaces.
Each FIMC instance exports its own video devnode. Thus we distribute
the camera sensors one per each /dev/video? by default. It will allow to
use both camera simultaneously by opening different video node.

The camera sensors at FIMC are now not selected with S_INPUT ioctl, there
is one input only available per /dev/video?.

By default a single sensor is connected at FIMC input as specified by the
media device platform data subdev description table. This assignment
can be changed at runtime through the pipeline reconfiguration at the media
device level.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   43 ++++-----------------------
 1 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 6efd952..b786c2c 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -577,57 +577,26 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 }
 
 static int fimc_cap_enum_input(struct file *file, void *priv,
-				     struct v4l2_input *i)
+			       struct v4l2_input *i)
 {
 	struct fimc_ctx *ctx = priv;
-	struct s5p_platform_fimc *pldata = ctx->fimc_dev->pdata;
-	struct s5p_fimc_isp_info *isp_info;
 
-	if (i->index >= pldata->num_clients)
+	if (i->index != 0)
 		return -EINVAL;
 
-	isp_info = &pldata->isp_info[i->index];
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strncpy(i->name, isp_info->board_info->type, 32);
 	return 0;
 }
 
-static int fimc_cap_s_input(struct file *file, void *priv,
-				  unsigned int i)
+static int fimc_cap_s_input(struct file *file, void *priv, unsigned int i)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct s5p_platform_fimc *pdata = fimc->pdata;
-
-	if (fimc_capture_active(ctx->fimc_dev))
-		return -EBUSY;
-
-	if (i >= pdata->num_clients)
-		return -EINVAL;
-
-
-	if (fimc->vid_cap.sd) {
-		int ret = v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
-		if (ret)
-			err("s_power failed: %d", ret);
-
-		clk_disable(fimc->clock[CLK_CAM]);
-	}
-
-	/* Release the attached sensor subdevice. */
-	fimc_subdev_unregister(fimc);
-
-	return fimc_isp_subdev_init(fimc, i);
+	return i == 0 ? i : -EINVAL;
 }
 
-static int fimc_cap_g_input(struct file *file, void *priv,
-				       unsigned int *i)
+static int fimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
-
-	*i = cap->input_index;
+	*i = 0;
 	return 0;
 }
 
-- 
1.7.6

