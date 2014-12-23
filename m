Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38818 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbaLWUud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:33 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 35/66] rtl2832: implement DVBv5 signal strength statistics
Date: Tue, 23 Dec 2014 22:49:28 +0200
Message-Id: <1419367799-14263-35-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Estimate signal strength from IF digital AGC.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 531099b..39c8f34 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -474,6 +474,8 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		goto err;
 #endif
 	/* init stats here in order signal app which stats are supported */
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->cnr.len = 1;
 	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_error.len = 1;
@@ -823,6 +825,24 @@ static void rtl2832_stat_work(struct work_struct *work)
 
 	dev_dbg(&client->dev, "\n");
 
+	/* signal strength */
+	if (dev->fe_status & FE_HAS_SIGNAL) {
+		/* read digital AGC */
+		ret = rtl2832_bulk_read(client, 0x305, &u8tmp, 1);
+		if (ret)
+			goto err;
+
+		dev_dbg(&client->dev, "digital agc=%02x", u8tmp);
+
+		u8tmp = ~u8tmp;
+		u16tmp = u8tmp << 8 | u8tmp << 0;
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

