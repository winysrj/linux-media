Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33628 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760032Ab3LHWbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:55 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 12/18] m88ds3103: fix TS mode config
Date: Mon,  9 Dec 2013 00:31:29 +0200
Message-Id: <1386541895-8634-13-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TS mode was configured wrongly.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index bd9effa..f9d8967 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -321,32 +321,32 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	case M88DS3103_TS_SERIAL:
 		u8tmp1 = 0x00;
 		ts_clk = 0;
-		u8tmp = 0x04;
+		u8tmp = 0x46;
 		break;
 	case M88DS3103_TS_SERIAL_D7:
 		u8tmp1 = 0x20;
 		ts_clk = 0;
-		u8tmp = 0x04;
+		u8tmp = 0x46;
 		break;
 	case M88DS3103_TS_PARALLEL:
 		ts_clk = 24000;
-		u8tmp = 0x00;
+		u8tmp = 0x42;
 		break;
 	case M88DS3103_TS_PARALLEL_12:
 		ts_clk = 12000;
-		u8tmp = 0x00;
+		u8tmp = 0x42;
 		break;
 	case M88DS3103_TS_PARALLEL_16:
 		ts_clk = 16000;
-		u8tmp = 0x00;
+		u8tmp = 0x42;
 		break;
 	case M88DS3103_TS_PARALLEL_19_2:
 		ts_clk = 19200;
-		u8tmp = 0x00;
+		u8tmp = 0x42;
 		break;
 	case M88DS3103_TS_CI:
 		ts_clk = 6000;
-		u8tmp = 0x01;
+		u8tmp = 0x43;
 		break;
 	default:
 		dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n", __func__);
@@ -355,7 +355,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	}
 
 	/* TS mode */
-	ret = m88ds3103_wr_reg_mask(priv, 0xfd, u8tmp, 0x05);
+	ret = m88ds3103_wr_reg(priv, 0xfd, u8tmp);
 	if (ret)
 		goto err;
 
-- 
1.8.4.2

