Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52953 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbcFTTLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:11:55 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 07/24] v4l: vsp1: Base link creation on availability of entities
Date: Mon, 20 Jun 2016 22:10:25 +0300
Message-Id: <1466449842-29502-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check the entity pointer instead of the feature flag to see if the
entity is available before creating related links. The two methods are
currently equivalent, but will differ in the future as we implement
support for ignoring some of the entities present in the hardware.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 0d3624a05ef1..c42576825ad4 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -149,7 +149,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
-	if (vsp1->info->features & VSP1_HAS_HGO) {
+	if (vsp1->hgo) {
 		ret = media_create_pad_link(&vsp1->hgo->entity.subdev.entity,
 					    HGO_PAD_SOURCE,
 					    &vsp1->hgo->histo.video.entity, 0,
@@ -159,7 +159,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
-	if (vsp1->info->features & VSP1_HAS_LIF) {
+	if (vsp1->lif) {
 		ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
 					    RWPF_PAD_SOURCE,
 					    &vsp1->lif->entity.subdev.entity,
-- 
Regards,

Laurent Pinchart

