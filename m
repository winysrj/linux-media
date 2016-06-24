Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60479 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbcFXL3B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 07:29:01 -0400
Date: Fri, 24 Jun 2016 13:28:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 1/3] uvcvideo: initialise the entity function field
In-Reply-To: <Pine.LNX.4.64.1606241312130.23461@axis700.grange>
Message-ID: <Pine.LNX.4.64.1606241326030.23461@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since a recent commit:

[media] media-device: move media entity register/unregister functions

drivers have to set entity function before registering an entity. Fix
the uvcvideo driver to comply with this.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/usb/uvc/uvc_entity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index ac386bb..d93f413 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -88,6 +88,11 @@ static int uvc_mc_init_entity(struct uvc_video_chain *chain,
 		if (ret < 0)
 			return ret;
 
+		if (UVC_ENTITY_TYPE(entity) == UVC_ITT_CAMERA)
+			entity->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+		else
+			entity->subdev.entity.function = MEDIA_ENT_F_IO_V4L;
+
 		ret = v4l2_device_register_subdev(&chain->dev->vdev,
 						  &entity->subdev);
 	} else if (entity->vdev != NULL) {
-- 
1.9.3

