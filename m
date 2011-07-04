Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43518 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab1GDRzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 04 Jul 2011 19:54:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 05/19] s5p-fimc: Limit number of available inputs to one
In-reply-to: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-6-git-send-email-s.nawrocki@samsung.com>
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Camera sensors at FIMC input are no longer selected with S_INPUT ioctl.
They will be attached to required FIMC entity through pipeline
re-configuration at the media device level.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   43 ++++-----------------------
 1 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index a806e48..5b08b69 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -562,57 +562,26 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
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
1.7.5.4

