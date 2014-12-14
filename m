Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46204 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaLNI3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/18] rtl2830: implement DVBv5 signal strength statistics
Date: Sun, 14 Dec 2014 10:28:35 +0200
Message-Id: <1418545723-9536-10-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Estimate signal strength from IF AGC.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index c484634..641047b 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -246,6 +246,8 @@ static int rtl2830_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* init stats here in order signal app which stats are supported */
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->cnr.len = 1;
 	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	/* start statistics polling */
@@ -693,6 +695,28 @@ static void rtl2830_stat_work(struct work_struct *work)
 
 	dev_dbg(&client->dev, "\n");
 
+	/* signal strength */
+	if (dev->fe_status & FE_HAS_SIGNAL) {
+		struct {signed int x:14; } s;
+
+		/* read IF AGC */
+		ret = rtl2830_rd_regs(client, 0x359, buf, 2);
+		if (ret)
+			goto err;
+
+		u16tmp = buf[0] << 8 | buf[1] << 0;
+		u16tmp &= 0x3fff; /* [13:0] */
+		tmp = s.x = u16tmp; /* 14-bit bin to 2 complement */
+		u16tmp = clamp_val(-4 * tmp + 32767, 0x0000, 0xffff);
+
+		dev_dbg(&client->dev, "IF AGC=%d\n", tmp);
+
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		c->strength.stat[0].uvalue = u16tmp;
+	} else {
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	/* CNR */
 	if (dev->fe_status & FE_HAS_VITERBI) {
 		unsigned hierarchy, constellation;
-- 
http://palosaari.fi/

