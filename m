Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52953 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbcFTTL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:11:57 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 09/24] v4l: vsp1: Don't create LIF entity when the userspace API is enabled
Date: Mon, 20 Jun 2016 22:10:27 +0300
Message-Id: <1466449842-29502-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LIF is only used when feeding the VSP output to the DU. The only way
to do so is by controlling the VSP directly from the DU driver and
disabling the VSP userspace API. There is thus no need to create a LIF
entity when the userspace API is enabled, as it can't be used in that
case.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index cd56cad3abd9..7b9d95a6af23 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -182,19 +182,15 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 
 	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		/* Connect the video device to the WPF. All connections are
-		 * immutable except for the WPF0 source link if a LIF is
-		 * present.
+		 * immutable.
 		 */
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
-		unsigned int flags = MEDIA_LNK_FL_ENABLED;
-
-		if (!(vsp1->info->features & VSP1_HAS_LIF) || i != 0)
-			flags |= MEDIA_LNK_FL_IMMUTABLE;
 
 		ret = media_create_pad_link(&wpf->entity.subdev.entity,
 					    RWPF_PAD_SOURCE,
 					    &wpf->video->video.entity, 0,
-					    flags);
+					    MEDIA_LNK_FL_IMMUTABLE |
+					    MEDIA_LNK_FL_ENABLED);
 		if (ret < 0)
 			return ret;
 	}
@@ -293,7 +289,11 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->hgo->entity.list_dev, &vsp1->entities);
 	}
 
-	if (vsp1->info->features & VSP1_HAS_LIF) {
+	/* The LIF is only supported when used in conjunction with the DU, in
+	 * which case the userspace API is disabled. If the userspace API is
+	 * enabled skip the LIF, even when present.
+	 */
+	if (vsp1->info->features & VSP1_HAS_LIF && !vsp1->info->uapi) {
 		vsp1->lif = vsp1_lif_create(vsp1);
 		if (IS_ERR(vsp1->lif)) {
 			ret = PTR_ERR(vsp1->lif);
-- 
Regards,

Laurent Pinchart

