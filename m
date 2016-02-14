Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35957 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbcBNCl1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 21:41:27 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] mn88473: add DVB-T2 PLP support
Date: Sun, 14 Feb 2016 04:41:06 +0200
Message-Id: <1455417666-17755-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds PLP ID filtering for DVB-T2.

It is untested as I don't have any signal having PLP ID other than 0.
There is only 2 extra registers, 0x32 and 0x36 on bank2, that are
programmed for DVB-T2 but not for DVB-T and all the rest are
programmed similarly - so it is likely PLP.

Testing required!!
---
 drivers/media/dvb-frontends/mn88473.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index 6c5d5921..0ab8faa 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -223,6 +223,13 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	/* PLP */
+	if (c->delivery_system == SYS_DVBT2) {
+		ret = regmap_write(dev->regmap[2], 0x36, c->stream_id);
+		if (ret)
+			goto err;
+	}
+
 	/* Reset FSM */
 	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
 	if (ret)
@@ -429,7 +436,8 @@ static const struct dvb_frontend_ops mn88473_ops = {
 			FE_CAN_GUARD_INTERVAL_AUTO     |
 			FE_CAN_HIERARCHY_AUTO          |
 			FE_CAN_MUTE_TS                 |
-			FE_CAN_2G_MODULATION
+			FE_CAN_2G_MODULATION           |
+			FE_CAN_MULTISTREAM
 	},
 
 	.get_tune_settings = mn88473_get_tune_settings,
-- 
http://palosaari.fi/

