Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756E8C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F4CA21773
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbfAILIl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:08:41 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52455 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730616AbfAILIl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 06:08:41 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ghBix-0002Wv-J8; Wed, 09 Jan 2019 12:08:39 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
Subject: [PATCH v2 1/3] media: imx: add capture compose rectangle
Date:   Wed,  9 Jan 2019 12:08:29 +0100
Message-Id: <20190109110831.23395-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Allowing to compose captured images into larger memory buffers
will let us lift alignment restrictions on CSI crop width.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v1:
 - remove NATIVE_SIZE selection target
 - fixed typo in capture_s_fmt_vid_cap
---
 drivers/staging/media/imx/imx-ic-prpencvf.c   |  3 +-
 drivers/staging/media/imx/imx-media-capture.c | 37 +++++++++++++++++++
 drivers/staging/media/imx/imx-media-csi.c     |  3 +-
 drivers/staging/media/imx/imx-media-vdic.c    |  4 +-
 drivers/staging/media/imx/imx-media.h         |  2 +
 5 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 28f41caba05d..fe5a77baa592 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -366,8 +366,7 @@ static int prp_setup_channel(struct prp_priv *priv,
 
 	memset(&image, 0, sizeof(image));
 	image.pix = vdev->fmt.fmt.pix;
-	image.rect.width = image.pix.width;
-	image.rect.height = image.pix.height;
+	image.rect = vdev->compose;
 
 	if (rot_swap_width_height) {
 		swap(image.pix.width, image.pix.height);
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index b37e1186eb2f..fb985e68f9ab 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -262,6 +262,10 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 	priv->vdev.fmt.fmt.pix = f->fmt.pix;
 	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat,
 					      CS_SEL_ANY, true);
+	priv->vdev.compose.left = 0;
+	priv->vdev.compose.top = 0;
+	priv->vdev.compose.width = f->fmt.pix.width;
+	priv->vdev.compose.height = f->fmt.pix.height;
 
 	return 0;
 }
@@ -290,6 +294,34 @@ static int capture_s_std(struct file *file, void *fh, v4l2_std_id std)
 	return v4l2_subdev_call(priv->src_sd, video, s_std, std);
 }
 
+static int capture_g_selection(struct file *file, void *fh,
+			       struct v4l2_selection *s)
+{
+	struct capture_priv *priv = video_drvdata(file);
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_PADDED:
+		s->r = priv->vdev.compose;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int capture_s_selection(struct file *file, void *fh,
+			       struct v4l2_selection *s)
+{
+	return capture_g_selection(file, fh, s);
+}
+
 static int capture_g_parm(struct file *file, void *fh,
 			  struct v4l2_streamparm *a)
 {
@@ -350,6 +382,9 @@ static const struct v4l2_ioctl_ops capture_ioctl_ops = {
 	.vidioc_g_std           = capture_g_std,
 	.vidioc_s_std           = capture_s_std,
 
+	.vidioc_g_selection	= capture_g_selection,
+	.vidioc_s_selection	= capture_s_selection,
+
 	.vidioc_g_parm          = capture_g_parm,
 	.vidioc_s_parm          = capture_s_parm,
 
@@ -687,6 +722,8 @@ int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
 	vdev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
 				      &fmt_src.format, NULL);
+	vdev->compose.width = fmt_src.format.width;
+	vdev->compose.height = fmt_src.format.height;
 	vdev->cc = imx_media_find_format(vdev->fmt.fmt.pix.pixelformat,
 					 CS_SEL_ANY, false);
 
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4223f8d418ae..c4523afe7b48 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -413,8 +413,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 
 	memset(&image, 0, sizeof(image));
 	image.pix = vdev->fmt.fmt.pix;
-	image.rect.width = image.pix.width;
-	image.rect.height = image.pix.height;
+	image.rect = vdev->compose;
 
 	csi_idmac_setup_vb2_buf(priv, phys);
 
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 482250d47e7c..e08d296cf4eb 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -263,10 +263,10 @@ static int setup_vdi_channel(struct vdic_priv *priv,
 
 	memset(&image, 0, sizeof(image));
 	image.pix = vdev->fmt.fmt.pix;
+	image.rect = vdev->compose;
 	/* one field to VDIC channels */
 	image.pix.height /= 2;
-	image.rect.width = image.pix.width;
-	image.rect.height = image.pix.height;
+	image.rect.height /= 2;
 	image.phys0 = phys0;
 	image.phys1 = phys1;
 
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index bc7feb81937c..7a0e658753f0 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -80,6 +80,8 @@ struct imx_media_video_dev {
 
 	/* the user format */
 	struct v4l2_format fmt;
+	/* the compose rectangle */
+	struct v4l2_rect compose;
 	const struct imx_media_pixfmt *cc;
 
 	/* links this vdev to master list */
-- 
2.20.1

