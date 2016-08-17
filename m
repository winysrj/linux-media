Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44804 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbcHQMUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 08:20:25 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 4/4] v4l: vsp1: Don't create HGO entity when the userspace API is disabled
Date: Wed, 17 Aug 2016 15:20:30 +0300
Message-Id: <1471436430-26245-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1471436430-26245-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471436430-26245-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HGO is never used in the DRM pipeline, there is thus no need to
create an HGO entity when the userspace API is disabled.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 327066c25144..9684abf3ce3a 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -290,7 +290,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
 
-	if (vsp1->info->features & VSP1_HAS_HGO) {
+	if (vsp1->info->features & VSP1_HAS_HGO && vsp1->info->uapi) {
 		vsp1->hgo = vsp1_hgo_create(vsp1);
 		if (IS_ERR(vsp1->hgo)) {
 			ret = PTR_ERR(vsp1->hgo);
-- 
Regards,

Laurent Pinchart

