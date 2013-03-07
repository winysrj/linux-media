Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward2.mail.yandex.net ([77.88.46.7]:44309 "EHLO
	forward2.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3CGAWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 19:22:44 -0500
Received: from web22d.yandex.ru (web22d.yandex.ru [77.88.46.52])
	by forward2.mail.yandex.net (Yandex) with ESMTP id 11A5E12A1F34
	for <linux-media@vger.kernel.org>; Thu,  7 Mar 2013 04:16:31 +0400 (MSK)
From: CrazyCat <crazycat69@yandex.ua>
To: linux-media@vger.kernel.org
Subject: [PATCH] cxd2820r_t2: Multistream support (MultiPLP)
MIME-Version: 1.0
Message-Id: <302151362615390@web22d.yandex.ru>
Date: Thu, 07 Mar 2013 02:16:30 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MultiPLP filtering support for CXD2820r, not tested.
Somebody from Russia please test (exclude Moscow, because used singlePLP). Usual used PLP 0 (4TV + 3 radio) and 1 (4TV). PLP 2,3 reserved (regional channels).

P.S. You can use my scan-s2 with multistream support - https://bitbucket.org/CrazyCat/scan-s2. Generated channel list compatible with current VDR 1.7.3x

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 9b658c1..7ca5c69 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -660,7 +660,8 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
 			FE_CAN_GUARD_INTERVAL_AUTO	|
 			FE_CAN_HIERARCHY_AUTO		|
 			FE_CAN_MUTE_TS			|
-			FE_CAN_2G_MODULATION
+			FE_CAN_2G_MODULATION		|
+			FE_CAN_MULTISTREAM
 		},
 
 	.release		= cxd2820r_release,
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index e82d82a..c2bfea7 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -124,6 +124,23 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 	buf[1] = ((if_ctl >>  8) & 0xff);
 	buf[2] = ((if_ctl >>  0) & 0xff);
 
+	/* PLP filtering */
+	if (c->stream_id < 0 || c->stream_id > 255) {
+		dev_dbg(&priv->i2c->dev, "%s: Disable PLP filtering\n", __func__);
+		ret = cxd2820r_wr_reg(priv, 0x023ad , 0);
+		if (ret)
+			goto error;
+	} else {
+		dev_dbg(&priv->i2c->dev, "%s: Enable PLP filtering = %d\n", __func__,
+				c->stream_id);
+		ret = cxd2820r_wr_reg(priv, 0x023af , c->stream_id & 0xFF);
+		if (ret)
+			goto error;
+		ret = cxd2820r_wr_reg(priv, 0x023ad , 1);
+		if (ret)
+			goto error;
+	}
+
 	ret = cxd2820r_wr_regs(priv, 0x020b6, buf, 3);
 	if (ret)
 		goto error;
