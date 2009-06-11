Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58188 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756897AbZFKHM4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 03:12:56 -0400
Date: Thu, 11 Jun 2009 09:13:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: [PATCH 4/4] sh_mobile_ceu_camera: add a control for the camera
 low-pass filter
In-Reply-To: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
Message-ID: <Pine.LNX.4.64.0906101606460.4817@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the V4L2_CID_SHARPNESS control to switch SH-mobile camera low-pass filter.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Is this a suitable control for this filter?

 drivers/media/video/sh_mobile_ceu_camera.c |   54 +++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 7ac4d92..8274fb1 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -499,7 +499,6 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	ceu_write(pcdev, CAPWR, (height << 16) | width);
 	ceu_write(pcdev, CFLCR, 0); /* no scaling */
 	ceu_write(pcdev, CFSZR, (height << 16) | cfszr_width);
-	ceu_write(pcdev, CLFCR, 0); /* no lowpass filter */
 
 	/* A few words about byte order (observed in Big Endian mode)
 	 *
@@ -784,6 +783,55 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 				       icd);
 }
 
+static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
+				  struct v4l2_control *ctrl)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	u32 val;
+
+	switch (ctrl->id) {
+	case V4L2_CID_SHARPNESS:
+		val = ceu_read(pcdev, CLFCR);
+		ctrl->value = val ^ 1;
+		return 0;
+	}
+	return -ENOIOCTLCMD;
+}
+
+static int sh_mobile_ceu_set_ctrl(struct soc_camera_device *icd,
+				  struct v4l2_control *ctrl)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+
+	switch (ctrl->id) {
+	case V4L2_CID_SHARPNESS:
+		switch (icd->current_fmt->fourcc) {
+		case V4L2_PIX_FMT_NV12:
+		case V4L2_PIX_FMT_NV21:
+		case V4L2_PIX_FMT_NV16:
+		case V4L2_PIX_FMT_NV61:
+			ceu_write(pcdev, CLFCR, !ctrl->value);
+			return 0;
+		}
+		return -EINVAL;
+	}
+	return -ENOIOCTLCMD;
+}
+
+static const struct v4l2_queryctrl sh_mobile_ceu_controls[] = {
+	{
+		.id		= V4L2_CID_SHARPNESS,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Low-pass filter",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+};
+
 static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= sh_mobile_ceu_add_device,
@@ -792,11 +840,15 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.set_crop	= sh_mobile_ceu_set_crop,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
+	.set_ctrl	= sh_mobile_ceu_set_ctrl,
+	.get_ctrl	= sh_mobile_ceu_get_ctrl,
 	.reqbufs	= sh_mobile_ceu_reqbufs,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
 	.set_bus_param	= sh_mobile_ceu_set_bus_param,
 	.init_videobuf	= sh_mobile_ceu_init_videobuf,
+	.controls	= sh_mobile_ceu_controls,
+	.num_controls	= ARRAY_SIZE(sh_mobile_ceu_controls),
 };
 
 static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
-- 
1.6.2.4

