Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44378 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0AIKqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 05:46:53 -0500
Received: by fxm25 with SMTP id 25so13294869fxm.21
        for <linux-media@vger.kernel.org>; Sat, 09 Jan 2010 02:46:51 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 9 Jan 2010 11:46:51 +0100
Message-ID: <7b41dd971001090246k5a4aed9dtf7c9b2b9c05d339a@mail.gmail.com>
Subject: [PATCH] drivers/media/dvb/bt8xx/dst.c:fixes for DVB-C Twinhan VP2031
	in Linux-2.6.32
From: klaas de waal <klaas.de.waal@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove check  "state->dst_type == DST_DTYPE_IS_CABLE"  in function
dst_get_tuna (around line 1352) to select the correct checksum
computation

Fill in the .caps field in struct dst_dvbc_ops (around line 1824) with
all the supported QAM modulation methods to match the capabilities of
the card as implemented in function dst_set_modulation (around line
502). Note that beginning with linux kernel version 2.6.32 the
modulation method is checked (by function
dvb_frontend_check_parameters in file
drivers/media/dvb/dvb-core/dvb_frontend.c) and thus tuning fails if
you use a modulation method that is not present in the .caps field.

This patch has been tested on a Twinhan VP2031A DVB-C card with the
2.6.32.2 kernel.


Signed-off-by: Klaas de Waal <klaas.de.waal@gmail.com>

------------------------------------------

diff -r b6b82258cf5e linux/drivers/media/dvb/bt8xx/dst.c
--- a/linux/drivers/media/dvb/bt8xx/dst.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/dvb/bt8xx/dst.c	Sat Jan 09 11:41:52 2010 +0100
@@ -1352,7 +1352,7 @@
 		return retval;
 	}
 	if ((state->type_flags & DST_TYPE_HAS_VLF) &&
-		!(state->dst_type == DST_TYPE_IS_CABLE) &&
+		/* !(state->dst_type == DST_TYPE_IS_CABLE) && */
 		!(state->dst_type == DST_TYPE_IS_ATSC)) {

 		if (state->rx_tuna[9] != dst_check_sum(&state->rx_tuna[0], 9)) {
@@ -1821,7 +1821,7 @@
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 	/*     . symbol_rate_tolerance	=	???,*/
-		.caps = FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO
+		.caps = FE_CAN_FEC_AUTO | FE_CAN_QAM_16 | FE_CAN_QAM_32 |
FE_CAN_QAM_64 | FE_CAN_QAM_128 | FE_CAN_QAM_256
 	},

 	.release = dst_release,
