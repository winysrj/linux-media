Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49554 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933717AbeCEJfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 04:35:51 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: [PATCH 7/7] media: sun6i: Expose controls on the v4l2_device
Date: Mon,  5 Mar 2018 10:35:34 +0100
Message-Id: <20180305093535.11801-8-maxime.ripard@bootlin.com>
In-Reply-To: <20180305093535.11801-1-maxime.ripard@bootlin.com>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
 <20180305093535.11801-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c   | 8 ++++++++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h   | 2 ++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c | 6 ++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index a93bc25ff372..26d57e6053df 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -729,7 +729,15 @@ static int sun6i_csi_v4l2_init(struct sun6i_csi *csi)
 
 	media_device_init(&csi->media_dev);
 
+	ret = v4l2_ctrl_handler_init(&csi->ctrl_handler, 0);
+	if (ret) {
+		dev_err(csi->dev, "V4L2 controls handler init failed (%d)\n",
+			ret);
+		goto clean_media;
+	}
+
 	csi->v4l2_dev.mdev = &csi->media_dev;
+	csi->v4l2_dev.ctrl_handler = &csi->ctrl_handler;
 	ret = v4l2_device_register(csi->dev, &csi->v4l2_dev);
 	if (ret) {
 		dev_err(csi->dev, "V4L2 device registration failed (%d)\n",
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
index c1a1e3aefaa8..c0e8b14073d1 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
@@ -8,6 +8,7 @@
 #ifndef __SUN6I_CSI_H__
 #define __SUN6I_CSI_H__
 
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fwnode.h>
 
@@ -33,6 +34,7 @@ struct sun6i_csi_config {
 
 struct sun6i_csi {
 	struct device			*dev;
+	struct v4l2_ctrl_handler	ctrl_handler;
 	struct v4l2_device		v4l2_dev;
 	struct media_device		media_dev;
 
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
index c74565d15014..bf7c0d1d1d47 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
@@ -8,6 +8,7 @@
 #include <linux/of.h>
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mc.h>
 #include <media/videobuf2-dma-contig.h>
@@ -497,6 +498,11 @@ static const struct v4l2_ioctl_ops sun6i_video_ioctl_ops = {
 	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
 	.vidioc_streamon		= vb2_ioctl_streamon,
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.14.3
