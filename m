Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47386 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbdHHM4U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 08:56:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 5/5] uvcvideo: Constify video_subdev structures
Date: Tue,  8 Aug 2017 15:56:24 +0300
Message-Id: <20170808125624.11328-6-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
References: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

uvc_subdev_ops is only passed as the second argument of
v4l2_subdev_init, which is const, so uvc_subdev_ops can be
const as well.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_entity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index ac386bb547e6..554063c07d7a 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -61,7 +61,7 @@ static int uvc_mc_create_links(struct uvc_video_chain *chain,
 	return 0;
 }
 
-static struct v4l2_subdev_ops uvc_subdev_ops = {
+static const struct v4l2_subdev_ops uvc_subdev_ops = {
 };
 
 void uvc_mc_cleanup_entity(struct uvc_entity *entity)
-- 
Regards,

Laurent Pinchart
