Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55955 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeKFAYC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:24:02 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC] media: imx: queue subdevice events on the video device in the same pipeline
Date: Mon,  5 Nov 2018 16:03:49 +0100
Message-Id: <20181105150349.8882-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While subdevice and video device are in the same pipeline, pass
subdevice events on to userspace via the video device node.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
This would allow to see source change events from the source subdevice
on the video device node, for example.
---
 drivers/staging/media/imx/imx-media-dev.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 4b344a4a3706..2fe6fdf2faf1 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -442,6 +442,23 @@ static const struct media_device_ops imx_media_md_ops = {
 	.link_notify = imx_media_link_notify,
 };
 
+static void imx_media_notify(struct v4l2_subdev *sd, unsigned int notification,
+			     void *arg)
+{
+	struct imx_media_dev *imxmd;
+	struct imx_media_video_dev *vdev;
+
+	imxmd = container_of(sd->v4l2_dev, struct imx_media_dev, v4l2_dev);
+	list_for_each_entry(vdev, &imxmd->vdev_list, list) {
+		if (sd->entity.pipe &&
+		    sd->entity.pipe == vdev->vfd->entity.pipe &&
+		    notification == V4L2_DEVICE_NOTIFY_EVENT) {
+			v4l2_event_queue(vdev->vfd, arg);
+			break;
+		}
+	}
+}
+
 static int imx_media_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -464,6 +481,7 @@ static int imx_media_probe(struct platform_device *pdev)
 	imxmd->v4l2_dev.mdev = &imxmd->md;
 	strscpy(imxmd->v4l2_dev.name, "imx-media",
 		sizeof(imxmd->v4l2_dev.name));
+	imxmd->v4l2_dev.notify = imx_media_notify;
 
 	media_device_init(&imxmd->md);
 
-- 
2.19.1
