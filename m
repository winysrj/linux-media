Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:57549 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0APQlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 11:41:47 -0500
Message-ID: <4B51EC47.8090702@freemail.hu>
Date: Sat, 16 Jan 2010 17:41:43 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@netup.ru>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] stv0900: make more local functions static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Some functions are only used locally so mark them static.

This will remove the following sparse warnings (see "make C=1"):
 * symbol 'extract_mask_pos' was not declared. Should it be static?
 * symbol 'stv0900_initialize' was not declared. Should it be static?
 * symbol 'stv0900_get_mclk_freq' was not declared. Should it be static?
 * symbol 'stv0900_set_mclk' was not declared. Should it be static?
 * symbol 'stv0900_get_err_count' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 5bcdcc072b6d linux/drivers/media/dvb/frontends/stv0900_core.c
--- a/linux/drivers/media/dvb/frontends/stv0900_core.c	Sat Jan 16 07:25:43 2010 +0100
+++ b/linux/drivers/media/dvb/frontends/stv0900_core.c	Sat Jan 16 17:37:59 2010 +0100
@@ -177,7 +177,7 @@
 	return buf;
 }

-void extract_mask_pos(u32 label, u8 *mask, u8 *pos)
+static void extract_mask_pos(u32 label, u8 *mask, u8 *pos)
 {
 	u8 position = 0, i = 0;

@@ -218,7 +218,7 @@
 	return val;
 }

-enum fe_stv0900_error stv0900_initialize(struct stv0900_internal *intp)
+static enum fe_stv0900_error stv0900_initialize(struct stv0900_internal *intp)
 {
 	s32 i;

@@ -282,7 +282,7 @@
 	return STV0900_NO_ERROR;
 }

-u32 stv0900_get_mclk_freq(struct stv0900_internal *intp, u32 ext_clk)
+static u32 stv0900_get_mclk_freq(struct stv0900_internal *intp, u32 ext_clk)
 {
 	u32 mclk = 90000000, div = 0, ad_div = 0;

@@ -296,7 +296,7 @@
 	return mclk;
 }

-enum fe_stv0900_error stv0900_set_mclk(struct stv0900_internal *intp, u32 mclk)
+static enum fe_stv0900_error stv0900_set_mclk(struct stv0900_internal *intp, u32 mclk)
 {
 	u32 m_div, clk_sel;

@@ -334,7 +334,7 @@
 	return STV0900_NO_ERROR;
 }

-u32 stv0900_get_err_count(struct stv0900_internal *intp, int cntr,
+static u32 stv0900_get_err_count(struct stv0900_internal *intp, int cntr,
 					enum fe_stv0900_demod_num demod)
 {
 	u32 lsb, msb, hsb, err_val;
