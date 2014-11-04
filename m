Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55944 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaKDBHR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 20:07:17 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Bimow Chen <Bimow.Chen@ite.com.tw>
Subject: [PATCH 5/6] af9033: return 0.1 dB DVBv3 SNR for AF9030 family
Date: Tue,  4 Nov 2014 03:07:03 +0200
Message-Id: <1415063224-28453-5-git-send-email-crope@iki.fi>
In-Reply-To: <1415063224-28453-1-git-send-email-crope@iki.fi>
References: <1415063224-28453-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previous patch changed both AF9030 and IT9130 SNR reporting from
dB to relative. Restore AF9030 to old behavior as it has been always
returning 0.1 dB value. Leave IT9130 relative as old IT9130 was
returning relative values.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 43 +++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index a490033..e640701 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -854,26 +854,33 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	/* use DVBv5 CNR */
 	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL) {
-		*snr = div_s64(c->cnr.stat[0].svalue, 1000);
+		/* Return 0.1 dB for AF9030 and 0-0xffff for IT9130. */
+		if (dev->is_af9035) {
+			/* 1000x => 10x (0.1 dB) */
+			*snr = div_s64(c->cnr.stat[0].svalue, 100);
+		} else {
+			/* 1000x => 1x (1 dB) */
+			*snr = div_s64(c->cnr.stat[0].svalue, 1000);
 
-		/* read current modulation */
-		ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
-		if (ret)
-			goto err;
+			/* read current modulation */
+			ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
+			if (ret)
+				goto err;
 
-		/* scale value to 0x0000-0xffff */
-		switch ((u8tmp >> 0) & 3) {
-		case 0:
-			*snr = *snr * 0xFFFF / 23;
-			break;
-		case 1:
-			*snr = *snr * 0xFFFF / 26;
-			break;
-		case 2:
-			*snr = *snr * 0xFFFF / 32;
-			break;
-		default:
-			goto err;
+			/* scale value to 0x0000-0xffff */
+			switch ((u8tmp >> 0) & 3) {
+			case 0:
+				*snr = *snr * 0xffff / 23;
+				break;
+			case 1:
+				*snr = *snr * 0xffff / 26;
+				break;
+			case 2:
+				*snr = *snr * 0xffff / 32;
+				break;
+			default:
+				goto err;
+			}
 		}
 	} else {
 		*snr = 0;
-- 
http://palosaari.fi/

