Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934209Ab1IOTZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 15:25:21 -0400
Date: Thu, 15 Sep 2011 21:25:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH/RFC] preserve video-device parent, set by the driver
Message-ID: <Pine.LNX.4.64.1109152119130.11565@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There doesn't seem to be any real requirement to override video-device 
parent, set by the driver, even if a v4l2-device is linked to the 
video-device, being registered. Let the driver control the parent pointer, 
if it needs to.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Marked as RFC, because I'm not sure, that there's no some hidden meaning 
in this parent pointer manipulation. However, I haven't been able to find 
any.

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 06f1400..728ebaf 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -576,7 +576,7 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	vdev->vfl_type = type;
 	vdev->cdev = NULL;
 	if (vdev->v4l2_dev) {
-		if (vdev->v4l2_dev->dev)
+		if (vdev->v4l2_dev->dev && !vdev->parent)
 			vdev->parent = vdev->v4l2_dev->dev;
 		if (vdev->ctrl_handler == NULL)
 			vdev->ctrl_handler = vdev->v4l2_dev->ctrl_handler;
