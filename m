Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28670 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756381AbcHaHoJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 03:44:09 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id F220E2084C
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2016 10:43:00 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] smiapp: Constify the regs argument to smiapp_write_8s()
Date: Wed, 31 Aug 2016 10:42:04 +0300
Message-Id: <1472629325-30875-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The data may now be const as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-quirk.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index d7e22bc..cb128ea 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -26,7 +26,7 @@ static int smiapp_write_8(struct smiapp_sensor *sensor, u16 reg, u8 val)
 }
 
 static int smiapp_write_8s(struct smiapp_sensor *sensor,
-			   struct smiapp_reg_8 *regs, int len)
+			   const struct smiapp_reg_8 *regs, int len)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
@@ -71,7 +71,7 @@ static int jt8ew9_limits(struct smiapp_sensor *sensor)
 
 static int jt8ew9_post_poweron(struct smiapp_sensor *sensor)
 {
-	struct smiapp_reg_8 regs[] = {
+	const struct smiapp_reg_8 regs[] = {
 		{ 0x30a3, 0xd8 }, /* Output port control : LVDS ports only */
 		{ 0x30ae, 0x00 }, /* 0x0307 pll_multiplier maximum value on PLL input 9.6MHz ( 19.2MHz is divided on pre_pll_div) */
 		{ 0x30af, 0xd0 }, /* 0x0307 pll_multiplier maximum value on PLL input 9.6MHz ( 19.2MHz is divided on pre_pll_div) */
@@ -115,7 +115,7 @@ const struct smiapp_quirk smiapp_jt8ew9_quirk = {
 static int imx125es_post_poweron(struct smiapp_sensor *sensor)
 {
 	/* Taken from v02. No idea what the other two are. */
-	struct smiapp_reg_8 regs[] = {
+	const struct smiapp_reg_8 regs[] = {
 		/*
 		 * 0x3302: clk during frame blanking:
 		 * 0x00 - HS mode, 0x01 - LP11
@@ -145,8 +145,7 @@ static int jt8ev1_post_poweron(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
-
-	struct smiapp_reg_8 regs[] = {
+	const struct smiapp_reg_8 regs[] = {
 		{ 0x3031, 0xcd }, /* For digital binning (EQ_MONI) */
 		{ 0x30a3, 0xd0 }, /* FLASH STROBE enable */
 		{ 0x3237, 0x00 }, /* For control of pulse timing for ADC */
@@ -167,8 +166,7 @@ static int jt8ev1_post_poweron(struct smiapp_sensor *sensor)
 		{ 0x33cf, 0xec }, /* For Black sun */
 		{ 0x3328, 0x80 }, /* Ugh. No idea what's this. */
 	};
-
-	struct smiapp_reg_8 regs_96[] = {
+	const struct smiapp_reg_8 regs_96[] = {
 		{ 0x30ae, 0x00 }, /* For control of ADC clock */
 		{ 0x30af, 0xd0 },
 		{ 0x30b0, 0x01 },
-- 
2.7.4

