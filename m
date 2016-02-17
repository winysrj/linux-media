Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35759 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161577AbcBQPtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 10:49:07 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH/RFC 3/9] adv7604: fix SPA register location for ADV7612
Date: Wed, 17 Feb 2016 16:48:39 +0100
Message-Id: <1455724125-13004-4-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
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

