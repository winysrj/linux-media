Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52953 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbcFTTME (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:12:04 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 13/24] v4l: vsp1: lut: Initialize the mutex
Date: Mon, 20 Jun 2016 22:10:31 +0300
Message-Id: <1466449842-29502-14-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LUT mutex isn't initialized when creating the LUT, fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lut.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 2c367cb9755c..9a2c55b3570a 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -201,6 +201,8 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	if (lut == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&lut->lock);
+
 	lut->entity.ops = &lut_entity_ops;
 	lut->entity.type = VSP1_ENTITY_LUT;
 
-- 
Regards,

Laurent Pinchart

