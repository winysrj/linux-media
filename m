Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34099 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbcCBRRB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 12:17:01 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v2 3/9] adv7604: fix SPA register location for ADV7612
Date: Wed,  2 Mar 2016 18:16:31 +0100
Message-Id: <1456938997-29971-4-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1456938997-29971-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1456938997-29971-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SPA location LSB register is at 0x70.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7604.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 2097c48..1680c0e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2110,7 +2110,8 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		rep_write(sd, 0x76, spa_loc & 0xff);
 		rep_write_clr_set(sd, 0x77, 0x40, (spa_loc & 0x100) >> 2);
 	} else {
-		/* FIXME: Where is the SPA location LSB register ? */
+		/* ADV7612 Software Manual Rev. A, p. 15 */
+		rep_write(sd, 0x70, spa_loc & 0xff);
 		rep_write_clr_set(sd, 0x71, 0x01, (spa_loc & 0x100) >> 8);
 	}
 
-- 
2.6.4

