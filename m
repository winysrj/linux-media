Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59382 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbbEEV7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 18/21] fc2580: calculate filter control word dynamically
Date: Wed,  6 May 2015 00:58:39 +0300
Message-Id: <1430863122-9888-18-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calculate low-pass filter control word dynamically from given radio
channel bandwidth.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c      | 8 ++++----
 drivers/media/tuners/fc2580_priv.h | 9 ++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 08838b4..30cee76 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -46,7 +46,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	int ret, i;
 	unsigned int uitmp, div_ref, div_ref_val, div_n, k, k_cw, div_out;
 	u64 f_vco;
-	u8 u8tmp, synth_config;
+	u8 synth_config;
 	unsigned long timeout;
 
 	dev_dbg(&client->dev,
@@ -249,9 +249,9 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	u8tmp = div_u64((u64) dev->clk * fc2580_if_filter_lut[i].mul,
-			1000000000);
-	ret = regmap_write(dev->regmap, 0x37, u8tmp);
+	uitmp = (unsigned int) 8058000 - (c->bandwidth_hz * 122 / 100 / 2);
+	uitmp = div64_u64((u64) dev->clk * uitmp, 1000000000000ULL);
+	ret = regmap_write(dev->regmap, 0x37, uitmp);
 	if (ret)
 		goto err;
 
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
index 60f8f6c..bd88b01 100644
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -64,16 +64,15 @@ static const struct fc2580_pll fc2580_pll_lut[] = {
 
 struct fc2580_if_filter {
 	u32 freq;
-	u16 mul;
 	u8 r36_val;
 	u8 r39_val;
 };
 
 static const struct fc2580_if_filter fc2580_if_filter_lut[] = {
-	{   6000000, 4400, 0x18, 0x00},
-	{   7000000, 3910, 0x18, 0x80},
-	{   8000000, 3300, 0x18, 0x80},
-	{0xffffffff, 3300, 0x18, 0x80},
+	{   6000000, 0x18, 0x00},
+	{   7000000, 0x18, 0x80},
+	{   8000000, 0x18, 0x80},
+	{0xffffffff, 0x18, 0x80},
 };
 
 struct fc2580_freq_regs {
-- 
http://palosaari.fi/

