Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:33623 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbeC0PRC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 11:17:02 -0400
Received: by mail-pl0-f67.google.com with SMTP id c11-v6so14276617plo.0
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 08:17:01 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hiranotaka@zng.info,
        Akihiro Tsukada <tskd08@gmail.com>, kraxel@bytesex.org
Subject: [PATCH 1/5] dvb-frontends/dvb-pll: add tda6651 ISDB-T pll_desc
Date: Wed, 28 Mar 2018 00:15:58 +0900
Message-Id: <20180327151602.12250-2-tskd08@gmail.com>
In-Reply-To: <20180327151602.12250-1-tskd08@gmail.com>
References: <20180327151602.12250-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch adds a PLL "description" of Philips TDA6651 for ISDB-T.
It was extracted from (the former) va1j5jf8007t.c of EarthSoft PT1,
thus the desc might include PT1 specific configs.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/dvb-pll.c | 23 +++++++++++++++++++++++
 drivers/media/dvb-frontends/dvb-pll.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 76c091b2cb1..ba1dc3d1641 100644
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
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index f1f3ea4c0d5..41b3df36212 100644
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
2.16.3
