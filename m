Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44904 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932079AbdGJNya (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 09:54:30 -0400
From: Colin King <colin.king@canonical.com>
To: Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-frontends/cxd2841er: make several arrays static
Date: Mon, 10 Jul 2017 14:54:27 +0100
Message-Id: <20170710135427.27141-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate arrays on the stack but make them static.  Makes
the object code smaller:

Before:
   text	   data	    bss	    dec	    hex	filename
  89299	  21704	     64	 111067	  1b1db	cxd2841er.o

After:
   text	   data	    bss	    dec	    hex	filename
  85823	  23432	     64	 109319	  1ab07	cxd2841er.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 48 ++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 12bff778c97f..c5e1b4dd0765 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -2178,42 +2178,42 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 	u32 iffreq, ifhz;
 	u8 data[MAX_WRITE_REGSIZE];
 
-	const uint8_t nominalRate8bw[3][5] = {
+	static const uint8_t nominalRate8bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x11, 0xF0, 0x00, 0x00, 0x00}, /* 20.5MHz XTal */
 		{0x15, 0x00, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x11, 0xF0, 0x00, 0x00, 0x00}  /* 41MHz XTal */
 	};
 
-	const uint8_t nominalRate7bw[3][5] = {
+	static const uint8_t nominalRate7bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x14, 0x80, 0x00, 0x00, 0x00}, /* 20.5MHz XTal */
 		{0x18, 0x00, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x14, 0x80, 0x00, 0x00, 0x00}  /* 41MHz XTal */
 	};
 
-	const uint8_t nominalRate6bw[3][5] = {
+	static const uint8_t nominalRate6bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x17, 0xEA, 0xAA, 0xAA, 0xAA}, /* 20.5MHz XTal */
 		{0x1C, 0x00, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x17, 0xEA, 0xAA, 0xAA, 0xAA}  /* 41MHz XTal */
 	};
 
-	const uint8_t nominalRate5bw[3][5] = {
+	static const uint8_t nominalRate5bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x1C, 0xB3, 0x33, 0x33, 0x33}, /* 20.5MHz XTal */
 		{0x21, 0x99, 0x99, 0x99, 0x99}, /* 24MHz XTal */
 		{0x1C, 0xB3, 0x33, 0x33, 0x33}  /* 41MHz XTal */
 	};
 
-	const uint8_t nominalRate17bw[3][5] = {
+	static const uint8_t nominalRate17bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x58, 0xE2, 0xAF, 0xE0, 0xBC}, /* 20.5MHz XTal */
 		{0x68, 0x0F, 0xA2, 0x32, 0xD0}, /* 24MHz XTal */
 		{0x58, 0xE2, 0xAF, 0xE0, 0xBC}  /* 41MHz XTal */
 	};
 
-	const uint8_t itbCoef8bw[3][14] = {
+	static const uint8_t itbCoef8bw[3][14] = {
 		{0x26, 0xAF, 0x06, 0xCD, 0x13, 0xBB, 0x28, 0xBA,
 			0x23, 0xA9, 0x1F, 0xA8, 0x2C, 0xC8}, /* 20.5MHz XTal */
 		{0x2F, 0xBA, 0x28, 0x9B, 0x28, 0x9D, 0x28, 0xA1,
@@ -2222,7 +2222,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 			0x23, 0xA9, 0x1F, 0xA8, 0x2C, 0xC8}  /* 41MHz XTal   */
 	};
 
-	const uint8_t itbCoef7bw[3][14] = {
+	static const uint8_t itbCoef7bw[3][14] = {
 		{0x2C, 0xBD, 0x02, 0xCF, 0x04, 0xF8, 0x23, 0xA6,
 			0x29, 0xB0, 0x26, 0xA9, 0x21, 0xA5}, /* 20.5MHz XTal */
 		{0x30, 0xB1, 0x29, 0x9A, 0x28, 0x9C, 0x28, 0xA0,
@@ -2231,7 +2231,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 			0x29, 0xB0, 0x26, 0xA9, 0x21, 0xA5}  /* 41MHz XTal   */
 	};
 
-	const uint8_t itbCoef6bw[3][14] = {
+	static const uint8_t itbCoef6bw[3][14] = {
 		{0x27, 0xA7, 0x28, 0xB3, 0x02, 0xF0, 0x01, 0xE8,
 			0x00, 0xCF, 0x00, 0xE6, 0x23, 0xA4}, /* 20.5MHz XTal */
 		{0x31, 0xA8, 0x29, 0x9B, 0x27, 0x9C, 0x28, 0x9E,
@@ -2240,7 +2240,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 			0x00, 0xCF, 0x00, 0xE6, 0x23, 0xA4}  /* 41MHz XTal   */
 	};
 
-	const uint8_t itbCoef5bw[3][14] = {
+	static const uint8_t itbCoef5bw[3][14] = {
 		{0x27, 0xA7, 0x28, 0xB3, 0x02, 0xF0, 0x01, 0xE8,
 			0x00, 0xCF, 0x00, 0xE6, 0x23, 0xA4}, /* 20.5MHz XTal */
 		{0x31, 0xA8, 0x29, 0x9B, 0x27, 0x9C, 0x28, 0x9E,
@@ -2249,7 +2249,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 			0x00, 0xCF, 0x00, 0xE6, 0x23, 0xA4}  /* 41MHz XTal   */
 	};
 
-	const uint8_t itbCoef17bw[3][14] = {
+	static const uint8_t itbCoef17bw[3][14] = {
 		{0x25, 0xA0, 0x36, 0x8D, 0x2E, 0x94, 0x28, 0x9B,
 			0x32, 0x90, 0x2C, 0x9D, 0x29, 0x99}, /* 20.5MHz XTal */
 		{0x33, 0x8E, 0x2B, 0x97, 0x2D, 0x95, 0x37, 0x8B,
@@ -2423,32 +2423,32 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 {
 	u8 data[MAX_WRITE_REGSIZE];
 	u32 iffreq, ifhz;
-	u8 nominalRate8bw[3][5] = {
+	static const u8 nominalRate8bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x11, 0xF0, 0x00, 0x00, 0x00}, /* 20.5MHz XTal */
 		{0x15, 0x00, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x11, 0xF0, 0x00, 0x00, 0x00}  /* 41MHz XTal */
 	};
-	u8 nominalRate7bw[3][5] = {
+	static const u8 nominalRate7bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x14, 0x80, 0x00, 0x00, 0x00}, /* 20.5MHz XTal */
 		{0x18, 0x00, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x14, 0x80, 0x00, 0x00, 0x00}  /* 41MHz XTal */
 	};
-	u8 nominalRate6bw[3][5] = {
+	static const u8 nominalRate6bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x17, 0xEA, 0xAA, 0xAA, 0xAA}, /* 20.5MHz XTal */
 		{0x1C, 0x00, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x17, 0xEA, 0xAA, 0xAA, 0xAA}  /* 41MHz XTal */
 	};
-	u8 nominalRate5bw[3][5] = {
+	static const u8 nominalRate5bw[3][5] = {
 		/* TRCG Nominal Rate [37:0] */
 		{0x1C, 0xB3, 0x33, 0x33, 0x33}, /* 20.5MHz XTal */
 		{0x21, 0x99, 0x99, 0x99, 0x99}, /* 24MHz XTal */
 		{0x1C, 0xB3, 0x33, 0x33, 0x33}  /* 41MHz XTal */
 	};
 
-	u8 itbCoef8bw[3][14] = {
+	static const u8 itbCoef8bw[3][14] = {
 		{0x26, 0xAF, 0x06, 0xCD, 0x13, 0xBB, 0x28, 0xBA, 0x23, 0xA9,
 			0x1F, 0xA8, 0x2C, 0xC8}, /* 20.5MHz XTal */
 		{0x2F, 0xBA, 0x28, 0x9B, 0x28, 0x9D, 0x28, 0xA1, 0x29, 0xA5,
@@ -2456,7 +2456,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		{0x26, 0xAF, 0x06, 0xCD, 0x13, 0xBB, 0x28, 0xBA, 0x23, 0xA9,
 			0x1F, 0xA8, 0x2C, 0xC8}  /* 41MHz XTal   */
 	};
-	u8 itbCoef7bw[3][14] = {
+	static const u8 itbCoef7bw[3][14] = {
 		{0x2C, 0xBD, 0x02, 0xCF, 0x04, 0xF8, 0x23, 0xA6, 0x29, 0xB0,
 			0x26, 0xA9, 0x21, 0xA5}, /* 20.5MHz XTal */
 		{0x30, 0xB1, 0x29, 0x9A, 0x28, 0x9C, 0x28, 0xA0, 0x29, 0xA2,
@@ -2464,7 +2464,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		{0x2C, 0xBD, 0x02, 0xCF, 0x04, 0xF8, 0x23, 0xA6, 0x29, 0xB0,
 			0x26, 0xA9, 0x21, 0xA5}  /* 41MHz XTal   */
 	};
-	u8 itbCoef6bw[3][14] = {
+	static const u8 itbCoef6bw[3][14] = {
 		{0x27, 0xA7, 0x28, 0xB3, 0x02, 0xF0, 0x01, 0xE8, 0x00, 0xCF,
 			0x00, 0xE6, 0x23, 0xA4}, /* 20.5MHz XTal */
 		{0x31, 0xA8, 0x29, 0x9B, 0x27, 0x9C, 0x28, 0x9E, 0x29, 0xA4,
@@ -2472,7 +2472,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		{0x27, 0xA7, 0x28, 0xB3, 0x02, 0xF0, 0x01, 0xE8, 0x00, 0xCF,
 			0x00, 0xE6, 0x23, 0xA4}  /* 41MHz XTal   */
 	};
-	u8 itbCoef5bw[3][14] = {
+	static const u8 itbCoef5bw[3][14] = {
 		{0x27, 0xA7, 0x28, 0xB3, 0x02, 0xF0, 0x01, 0xE8, 0x00, 0xCF,
 			0x00, 0xE6, 0x23, 0xA4}, /* 20.5MHz XTal */
 		{0x31, 0xA8, 0x29, 0x9B, 0x27, 0x9C, 0x28, 0x9E, 0x29, 0xA4,
@@ -2652,39 +2652,39 @@ static int cxd2841er_sleep_tc_to_active_i_band(
 	u8 data[3];
 
 	/* TRCG Nominal Rate */
-	u8 nominalRate8bw[3][5] = {
+	static const u8 nominalRate8bw[3][5] = {
 		{0x00, 0x00, 0x00, 0x00, 0x00}, /* 20.5MHz XTal */
 		{0x11, 0xB8, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x00, 0x00, 0x00, 0x00, 0x00}  /* 41MHz XTal */
 	};
 
-	u8 nominalRate7bw[3][5] = {
+	static const u8 nominalRate7bw[3][5] = {
 		{0x00, 0x00, 0x00, 0x00, 0x00}, /* 20.5MHz XTal */
 		{0x14, 0x40, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x00, 0x00, 0x00, 0x00, 0x00}  /* 41MHz XTal */
 	};
 
-	u8 nominalRate6bw[3][5] = {
+	static const u8 nominalRate6bw[3][5] = {
 		{0x14, 0x2E, 0x00, 0x00, 0x00}, /* 20.5MHz XTal */
 		{0x17, 0xA0, 0x00, 0x00, 0x00}, /* 24MHz XTal */
 		{0x14, 0x2E, 0x00, 0x00, 0x00}  /* 41MHz XTal */
 	};
 
-	u8 itbCoef8bw[3][14] = {
+	static const u8 itbCoef8bw[3][14] = {
 		{0x00}, /* 20.5MHz XTal */
 		{0x2F, 0xBA, 0x28, 0x9B, 0x28, 0x9D, 0x28, 0xA1, 0x29,
 			0xA5, 0x2A, 0xAC, 0x29, 0xB5}, /* 24MHz Xtal */
 		{0x0}, /* 41MHz XTal   */
 	};
 
-	u8 itbCoef7bw[3][14] = {
+	static const u8 itbCoef7bw[3][14] = {
 		{0x00}, /* 20.5MHz XTal */
 		{0x30, 0xB1, 0x29, 0x9A, 0x28, 0x9C, 0x28, 0xA0, 0x29,
 			0xA2, 0x2B, 0xA6, 0x2B, 0xAD}, /* 24MHz Xtal */
 		{0x00}, /* 41MHz XTal   */
 	};
 
-	u8 itbCoef6bw[3][14] = {
+	static const u8 itbCoef6bw[3][14] = {
 		{0x27, 0xA7, 0x28, 0xB3, 0x02, 0xF0, 0x01, 0xE8, 0x00,
 			0xCF, 0x00, 0xE6, 0x23, 0xA4}, /* 20.5MHz XTal */
 		{0x31, 0xA8, 0x29, 0x9B, 0x27, 0x9C, 0x28, 0x9E, 0x29,
-- 
2.11.0
