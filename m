Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:63510 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaHEFot (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 01:44:49 -0400
Received: from ms2.internal.ite.com.tw (ms2.internal.ite.com.tw [192.168.15.236])
	by mse.ite.com.tw with ESMTP id s755ihxG001932
	for <linux-media@vger.kernel.org>; Tue, 5 Aug 2014 13:44:43 +0800 (CST)
	(envelope-from Bimow.Chen@ite.com.tw)
Received: from [192.168.190.2] (unknown [192.168.190.2])
	by ms2.internal.ite.com.tw (Postfix) with ESMTP id 56DAA45307
	for <linux-media@vger.kernel.org>; Tue,  5 Aug 2014 13:44:39 +0800 (CST)
Subject: [PATCH 2/4] V4L/DVB: Update tuner script for new firmware
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-i10Y4XCu7O80BXpL+IfP"
Date: Tue, 05 Aug 2014 13:45:43 +0800
Message-ID: <1407217543.2988.5.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-i10Y4XCu7O80BXpL+IfP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-i10Y4XCu7O80BXpL+IfP
Content-Disposition: attachment; filename="0002-Update-tuner-script-for-new-firmware.patch"
Content-Type: text/x-patch; name="0002-Update-tuner-script-for-new-firmware.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From b3f9eb6e410ac317042cebdce5833dac8e276c1a Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Tue, 5 Aug 2014 10:31:46 +0800
Subject: [PATCH 2/4] Update tuner script for new firmware.


Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/dvb-frontends/af9033.c      |   14 ++++++++++++++
 drivers/media/dvb-frontends/af9033_priv.h |   20 +++++++++-----------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index be4bec2..22cb62a 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -274,6 +274,20 @@ static int af9033_init(struct dvb_frontend *fe)
 		{ 0x800045, state->cfg.adc_multiplier, 0xff },
 	};
 
+	/* power up tuner - for performance */
+	switch (state->cfg.tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		ret = af9033_wr_reg(state, 0x80ec40, 0x1);
+		ret |= af9033_wr_reg(state, 0x80fba8, 0x0);
+		if (ret < 0)
+			goto err;
+	}
+
 	/* program clock control */
 	clock_cw = af9033_div(state, state->cfg.clock, 1000000ul, 19ul);
 	buf[0] = (clock_cw >>  0) & 0xff;
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index fc2ad58..ded7b67 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -1418,7 +1418,7 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x800068, 0x0a },
 	{ 0x80006a, 0x03 },
 	{ 0x800070, 0x0a },
-	{ 0x800071, 0x05 },
+	{ 0x800071, 0x0a },
 	{ 0x800072, 0x02 },
 	{ 0x800075, 0x8c },
 	{ 0x800076, 0x8c },
@@ -1484,7 +1484,6 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x800104, 0x02 },
 	{ 0x800105, 0xbe },
 	{ 0x800106, 0x00 },
-	{ 0x800109, 0x02 },
 	{ 0x800115, 0x0a },
 	{ 0x800116, 0x03 },
 	{ 0x80011a, 0xbe },
@@ -1510,7 +1509,6 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x80014b, 0x8c },
 	{ 0x80014d, 0xac },
 	{ 0x80014e, 0xc6 },
-	{ 0x80014f, 0x03 },
 	{ 0x800151, 0x1e },
 	{ 0x800153, 0xbc },
 	{ 0x800178, 0x09 },
@@ -1522,9 +1520,10 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x80018d, 0x5f },
 	{ 0x80018f, 0xa0 },
 	{ 0x800190, 0x5a },
-	{ 0x80ed02, 0xff },
-	{ 0x80ee42, 0xff },
-	{ 0x80ee82, 0xff },
+	{ 0x800191, 0x00 },
+	{ 0x80ed02, 0x40 },
+	{ 0x80ee42, 0x40 },
+	{ 0x80ee82, 0x40 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f01f, 0x8c },
 	{ 0x80f020, 0x00 },
@@ -1699,7 +1698,6 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x800104, 0x02 },
 	{ 0x800105, 0xc8 },
 	{ 0x800106, 0x00 },
-	{ 0x800109, 0x02 },
 	{ 0x800115, 0x0a },
 	{ 0x800116, 0x03 },
 	{ 0x80011a, 0xc6 },
@@ -1725,7 +1723,6 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x80014b, 0x8c },
 	{ 0x80014d, 0xa8 },
 	{ 0x80014e, 0xc6 },
-	{ 0x80014f, 0x03 },
 	{ 0x800151, 0x28 },
 	{ 0x800153, 0xcc },
 	{ 0x800178, 0x09 },
@@ -1737,9 +1734,10 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x80018d, 0x5f },
 	{ 0x80018f, 0xfb },
 	{ 0x800190, 0x5c },
-	{ 0x80ed02, 0xff },
-	{ 0x80ee42, 0xff },
-	{ 0x80ee82, 0xff },
+	{ 0x800191, 0x00 },
+	{ 0x80ed02, 0x40 },
+	{ 0x80ee42, 0x40 },
+	{ 0x80ee82, 0x40 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f01f, 0x8c },
 	{ 0x80f020, 0x00 },
-- 
1.7.0.4


--=-i10Y4XCu7O80BXpL+IfP--

