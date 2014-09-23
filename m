Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:9199 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaIWJwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 05:52:17 -0400
Subject: [2/2] af9033: fix snr value not correct issue
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi
Content-Type: multipart/mixed; boundary="=-oWOBiJkBKgURVmN3WWC8"
Date: Tue, 23 Sep 2014 17:55:04 +0800
Message-ID: <1411466104.2258.1.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-oWOBiJkBKgURVmN3WWC8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Snr returns value not correct. Fix it.

--=-oWOBiJkBKgURVmN3WWC8
Content-Disposition: attachment; filename="0002-af9033-fix-snr-value-not-correct-issue.patch"
Content-Type: text/x-patch; name="0002-af9033-fix-snr-value-not-correct-issue.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From f3d5c9e2b01e666eca7aa66cd15b67609a0589ea Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Tue, 23 Sep 2014 17:23:31 +0800
Subject: [PATCH 2/2] af9033: fix snr value not correct issue

Snr returns value not correct. Fix it.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/dvb-frontends/af9033.c      |   46 +++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/af9033_priv.h |    5 ++-
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 0a0aeaf..37bd624 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -840,7 +840,7 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct af9033_state *state = fe->demodulator_priv;
 	int ret, i, len;
-	u8 buf[3], tmp;
+	u8 buf[3], tmp, tmp2;
 	u32 snr_val;
 	const struct val_snr *uninitialized_var(snr_lut);
 
@@ -851,6 +851,33 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	snr_val = (buf[2] << 16) | (buf[1] << 8) | buf[0];
 
+	/* read superframe number */
+	ret = af9033_rd_reg(state, 0x80f78b, &tmp);
+	if (ret < 0)
+		goto err;
+
+	if (tmp)
+		snr_val /= tmp;
+
+	/* read current transmission mode */
+	ret = af9033_rd_reg(state, 0x80f900, &tmp);
+	if (ret < 0)
+		goto err;
+
+	switch ((tmp >> 0) & 3) {
+	case 0:
+		snr_val *= 4;
+		break;
+	case 1:
+		snr_val *= 1;
+		break;
+	case 2:
+		snr_val *= 2;
+		break;
+	default:
+		goto err;
+	}
+
 	/* read current modulation */
 	ret = af9033_rd_reg(state, 0x80f903, &tmp);
 	if (ret < 0)
@@ -874,13 +901,26 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	}
 
 	for (i = 0; i < len; i++) {
-		tmp = snr_lut[i].snr;
+		tmp2 = snr_lut[i].snr;
 
 		if (snr_val < snr_lut[i].val)
 			break;
 	}
 
-	*snr = tmp * 10; /* dB/10 */
+	/* scale value to 0x0000-0xffff */
+	switch ((tmp >> 0) & 3) {
+	case 0:
+		*snr = tmp2 * 0xFFFF / 23;
+		break;
+	case 1:
+		*snr = tmp2 * 0xFFFF / 26;
+		break;
+	case 2:
+		*snr = tmp2 * 0xFFFF / 32;
+		break;
+	default:
+		goto err;
+	}
 
 	return 0;
 
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 58315e0..6351626 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -180,7 +180,10 @@ static const struct val_snr qam64_snr_lut[] = {
 	{ 0x05570d, 26 },
 	{ 0x059feb, 27 },
 	{ 0x05bf38, 28 },
-	{ 0xffffff, 29 },
+	{ 0x05f78f, 29 },
+	{ 0x0612c3, 30 },
+	{ 0x0626be, 31 },
+	{ 0xffffff, 32 },
 };
 
 static const struct reg_val ofsm_init[] = {
-- 
1.7.0.4


--=-oWOBiJkBKgURVmN3WWC8--

