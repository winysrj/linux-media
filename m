Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:43492 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752318AbeCZSI0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 14:08:26 -0400
Received: by mail-pf0-f193.google.com with SMTP id j2so7829529pff.10
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2018 11:08:26 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 2/5] dvb-frontends/dvb-pll: add tua6034 ISDB-T tuner used in Friio
Date: Tue, 27 Mar 2018 03:06:49 +0900
Message-Id: <20180326180652.5385-3-tskd08@gmail.com>
In-Reply-To: <20180326180652.5385-1-tskd08@gmail.com>
References: <20180326180652.5385-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This driver already contains tua6034-based device settings,
but they are not for ISDB-T and have different parameters.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v2:
(patch #27927 dvb: tua6034: add a new driver for Infineon tua6034 tuner)
- extends dvb-pll instead of creating a new driver

 drivers/media/dvb-frontends/dvb-pll.c | 18 ++++++++++++++++++
 drivers/media/dvb-frontends/dvb-pll.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 614a5ea3b00..76c091b2cb1 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -533,6 +533,23 @@ static const struct dvb_pll_desc dvb_pll_alps_tdee4 = {
 	}
 };
 
+/* Infineon TUA6034 ISDB-T, used in Friio */
+/* CP cur. 50uA, AGC takeover: 103dBuV, PORT3 on */
+static const struct dvb_pll_desc dvb_pll_tua6034_friio = {
+	.name   = "Infineon TUA6034 ISDB-T (Friio)",
+	.min    =  90000000,
+	.max    = 770000000,
+	.iffreq =  57000000,
+	.initdata = (u8[]){ 4, 0x9a, 0x50, 0xb2, 0x08 },
+	.sleepdata = (u8[]){ 4, 0x9a, 0x70, 0xb3, 0x0b },
+	.count = 3,
+	.entries = {
+		{ 170000000, 142857, 0xba, 0x09 },
+		{ 470000000, 142857, 0xba, 0x0a },
+		{ 770000000, 142857, 0xb2, 0x08 },
+	}
+};
+
 /* ----------------------------------------------------------- */
 
 static const struct dvb_pll_desc *pll_list[] = {
@@ -556,6 +573,7 @@ static const struct dvb_pll_desc *pll_list[] = {
 	[DVB_PLL_SAMSUNG_TDTC9251DH0]    = &dvb_pll_samsung_tdtc9251dh0,
 	[DVB_PLL_SAMSUNG_TBDU18132]	 = &dvb_pll_samsung_tbdu18132,
 	[DVB_PLL_SAMSUNG_TBMU24112]      = &dvb_pll_samsung_tbmu24112,
+	[DVB_PLL_TUA6034_FRIIO]          = &dvb_pll_tua6034_friio,
 };
 
 /* ----------------------------------------------------------- */
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index 15bda0d0c15..f1f3ea4c0d5 100644
--- a/drivers/media/dvb-frontends/dvb-pll.h
+++ b/drivers/media/dvb-frontends/dvb-pll.h
@@ -29,6 +29,7 @@
 #define DVB_PLL_SAMSUNG_TBMU24112      17
 #define DVB_PLL_TDEE4		       18
 #define DVB_PLL_THOMSON_DTT7520X       19
+#define DVB_PLL_TUA6034_FRIIO          20
 
 struct dvb_pll_config {
 	struct dvb_frontend *fe;
-- 
2.16.2
