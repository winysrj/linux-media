Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34892 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbcASMRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 07:17:15 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH] adv7604: fix SPA register location for ADV7612
Date: Tue, 19 Jan 2016 13:17:08 +0100
Message-Id: <1453205828-8814-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SPA location LSB register is at 0x70.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7604.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 3787f81..f78d36c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2149,6 +2149,10 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	if (info->type == ADV7604) {
 		rep_write(sd, 0x76, spa_loc & 0xff);
 		rep_write_clr_set(sd, 0x77, 0x40, (spa_loc & 0x100) >> 2);
+	} else if (info->type == ADV7612) {
+		/* ADV7612 Software Manual Rev. A, p. 15 */
+		rep_write(sd, 0x70, spa_loc & 0xff);
+		rep_write_clr_set(sd, 0x71, 0x01, (spa_loc & 0x100) >> 8);
 	} else {
 		/* FIXME: Where is the SPA location LSB register ? */
 		rep_write_clr_set(sd, 0x71, 0x01, (spa_loc & 0x100) >> 8);
-- 
2.6.4

