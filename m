Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36871 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbeDHRkT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 13:40:19 -0400
Received: by mail-pf0-f196.google.com with SMTP id p6so774193pfn.4
        for <linux-media@vger.kernel.org>; Sun, 08 Apr 2018 10:40:19 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        hiranotaka@zng.info
Subject: [PATCH v3 1/5] dvb-frontends/dvb-pll: add tda6651 ISDB-T pll_desc
Date: Mon,  9 Apr 2018 02:39:49 +0900
Message-Id: <20180408173953.11076-2-tskd08@gmail.com>
In-Reply-To: <20180408173953.11076-1-tskd08@gmail.com>
References: <20180408173953.11076-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch adds a PLL "description" of Philips TDA6651 for ISDB-T.
It was extracted from (the former) va1j5jf8007t.c of EarthSoft PT1,
thus the desc might include PT1 specific configs.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v2:
- do not #define chip name constant

Changes since v1:
- use new style of specifying pll_desc of the tuner

 drivers/media/dvb-frontends/dvb-pll.c | 24 ++++++++++++++++++++++++
 drivers/media/dvb-frontends/dvb-pll.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index f7d444d09cf..e3894ff403d 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -550,6 +550,28 @@ static const struct dvb_pll_desc dvb_pll_tua6034_friio = {
 	}
 };
 
+/* Philips TDA6651 ISDB-T, used in Earthsoft PT1 */
+static const struct dvb_pll_desc dvb_pll_tda665x_earth_pt1 = {
+	.name   = "Philips TDA6651 ISDB-T (EarthSoft PT1)",
+	.min    =  90000000,
+	.max    = 770000000,
+	.iffreq =  57000000,
+	.initdata = (u8[]){ 5, 0x0e, 0x7f, 0xc1, 0x80, 0x80 },
+	.count = 10,
+	.entries = {
+		{ 140000000, 142857, 0xc1, 0x81 },
+		{ 170000000, 142857, 0xc1, 0xa1 },
+		{ 220000000, 142857, 0xc1, 0x62 },
+		{ 330000000, 142857, 0xc1, 0xa2 },
+		{ 402000000, 142857, 0xc1, 0xe2 },
+		{ 450000000, 142857, 0xc1, 0x64 },
+		{ 550000000, 142857, 0xc1, 0x84 },
+		{ 600000000, 142857, 0xc1, 0xa4 },
+		{ 700000000, 142857, 0xc1, 0xc4 },
+		{ 770000000, 142857, 0xc1, 0xe4 },
+	}
+};
+
 /* ----------------------------------------------------------- */
 
 static const struct dvb_pll_desc *pll_list[] = {
@@ -574,6 +596,7 @@ static const struct dvb_pll_desc *pll_list[] = {
 	[DVB_PLL_SAMSUNG_TBDU18132]	 = &dvb_pll_samsung_tbdu18132,
 	[DVB_PLL_SAMSUNG_TBMU24112]      = &dvb_pll_samsung_tbmu24112,
 	[DVB_PLL_TUA6034_FRIIO]          = &dvb_pll_tua6034_friio,
+	[DVB_PLL_TDA665X_EARTH_PT1]      = &dvb_pll_tda665x_earth_pt1,
 };
 
 /* ----------------------------------------------------------- */
@@ -896,6 +919,7 @@ static const struct i2c_device_id dvb_pll_id[] = {
 	{"tdee4",		DVB_PLL_TDEE4},
 	{"dtt7520x",		DVB_PLL_THOMSON_DTT7520X},
 	{"tua6034_friio",	DVB_PLL_TUA6034_FRIIO},
+	{"tda665x_earthpt1",	DVB_PLL_TDA665X_EARTH_PT1},
 	{}
 };
 
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index 7555407c2cc..973a66a82e2 100644
--- a/drivers/media/dvb-frontends/dvb-pll.h
+++ b/drivers/media/dvb-frontends/dvb-pll.h
@@ -30,6 +30,7 @@
 #define DVB_PLL_TDEE4		       18
 #define DVB_PLL_THOMSON_DTT7520X       19
 #define DVB_PLL_TUA6034_FRIIO          20
+#define DVB_PLL_TDA665X_EARTH_PT1      21
 
 struct dvb_pll_config {
 	struct dvb_frontend *fe;
-- 
2.17.0
