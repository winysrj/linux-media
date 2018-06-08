Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33800 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752889AbeFHVp7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 17:45:59 -0400
Received: by mail-qt0-f195.google.com with SMTP id d3-v6so14934451qto.1
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 14:45:59 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2] media: i2c: adv748x: csi2: set entity function to video interface bridge
Date: Fri,  8 Jun 2018 14:45:51 -0700
Message-Id: <1528494351-16585-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV748x CSI-2 subdevices are HDMI/AFE to MIPI CSI-2 bridges.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Changes since v1:
- fix typo in commit message.
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 820b44e..469be87 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -284,7 +284,7 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
 	adv748x_csi2_set_virtual_channel(tx, 0);
 
 	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
-			    MEDIA_ENT_F_UNKNOWN,
+			    MEDIA_ENT_F_VID_IF_BRIDGE,
 			    is_txa(tx) ? "txa" : "txb");
 
 	/* Ensure that matching is based upon the endpoint fwnodes */
-- 
2.7.4
