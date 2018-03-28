Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38956 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753020AbeC1RPS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 13:15:18 -0400
Received: by mail-pf0-f196.google.com with SMTP id c78so1227134pfj.6
        for <linux-media@vger.kernel.org>; Wed, 28 Mar 2018 10:15:18 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 1/5] dvb-frontends/dvb-pll: add tda6651 ISDB-T pll_desc
Date: Thu, 29 Mar 2018 02:14:59 +0900
Message-Id: <20180328171503.30541-2-tskd08@gmail.com>
In-Reply-To: <20180328171503.30541-1-tskd08@gmail.com>
References: <20180328171503.30541-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch adds a PLL "description" of Philips TDA6651 for ISDB-T.
It was extracted from (the former) va1j5jf8007t.c of EarthSoft PT1,
thus the desc might include PT1 specific configs.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v1:
- use new style of specifying pll_desc of the tuner

 drivers/media/dvb-frontends/dvb-pll.c | 24 ++++++++++++++++++++++++
 drivers/media/dvb-frontends/dvb-pll.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index deb27aefb9b..62363786e98 100644
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
 	{DVB_PLL_TDEE4_NAME,                  DVB_PLL_TDEE4},
 	{DVB_PLL_THOMSON_DTT7520X_NAME,       DVB_PLL_THOMSON_DTT7520X},
 	{DVB_PLL_TUA6034_FRIIO_NAME,          DVB_PLL_TUA6034_FRIIO},
+	{DVB_PLL_TDA665X_EARTH_PT1_NAME,      DVB_PLL_TDA665X_EARTH_PT1},
 	{}
 };
 
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index c1c27c0d1b1..ddaa5d2efd8 100644
--- a/drivers/media/dvb-frontends/dvb-pll.h
+++ b/drivers/media/dvb-frontends/dvb-pll.h
@@ -30,6 +30,7 @@
 #define DVB_PLL_TDEE4		       18
 #define DVB_PLL_THOMSON_DTT7520X       19
 #define DVB_PLL_TUA6034_FRIIO          20
+#define DVB_PLL_TDA665X_EARTH_PT1      21
 
 #define DVB_PLL_THOMSON_DTT7579_NAME	    "dtt7579"
 #define DVB_PLL_THOMSON_DTT759X_NAME        "dtt759x"
@@ -51,6 +52,7 @@
 #define DVB_PLL_TDEE4_NAME                  "tdee4"
 #define DVB_PLL_THOMSON_DTT7520X_NAME       "dtt7520x"
 #define DVB_PLL_TUA6034_FRIIO_NAME          "tua6034_friio"
+#define DVB_PLL_TDA665X_EARTH_PT1_NAME      "tda665x_earthpt1"
 
 struct dvb_pll_config {
 	struct dvb_frontend *fe;
-- 
2.16.3
