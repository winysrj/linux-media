Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:51497 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbbBOAxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2015 19:53:03 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] r820t: add DVBC profile in sysfreq_sel
Date: Sun, 15 Feb 2015 01:52:56 +0100
Message-Id: <1423961576-15038-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/tuners/r820t.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 8e040cf..639c220 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -775,6 +775,19 @@ static int r820t_sysfreq_sel(struct r820t_priv *priv, u32 freq,
 		div_buf_cur = 0x30;	/* 11, 150u */
 		filter_cur = 0x40;	/* 10, low */
 		break;
+	case SYS_DVBC_ANNEX_A:
+		mixer_top = 0x24;       /* mixer top:13 , top-1, low-discharge */
+		lna_top = 0xe5;
+		lna_vth_l = 0x62;
+		mixer_vth_l = 0x75;
+		air_cable1_in = 0x60;
+		cable2_in = 0x00;
+		pre_dect = 0x40;
+		lna_discharge = 14;
+		cp_cur = 0x38;          /* 111, auto */
+		div_buf_cur = 0x30;     /* 11, 150u */
+		filter_cur = 0x40;      /* 10, low */
+		break;
 	default: /* DVB-T 8M */
 		mixer_top = 0x24;	/* mixer top:13 , top-1, low-discharge */
 		lna_top = 0xe5;		/* detect bw 3, lna top:4, predet top:2 */
-- 
2.1.0

