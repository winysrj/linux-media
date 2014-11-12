Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32853 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbaKLEXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:23:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/8] r820t: add DVB-C config
Date: Wed, 12 Nov 2014 06:23:03 +0200
Message-Id: <1415766190-24482-2-git-send-email-crope@iki.fi>
In-Reply-To: <1415766190-24482-1-git-send-email-crope@iki.fi>
References: <1415766190-24482-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add config values for SYS_DVBC_ANNEX_A.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/r820t.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index a759742..8e040cf 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -959,6 +959,18 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 		lt_att = 0x00;		/* r31[7], lt att enable */
 		flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
 		polyfil_cur = 0x60;	/* r25[6:5]:min */
+	} else if (delsys == SYS_DVBC_ANNEX_A) {
+		if_khz = 5070;
+		filt_cal_lo = 73500;
+		filt_gain = 0x10;	/* +3db, 6mhz on */
+		img_r = 0x00;		/* image negative */
+		filt_q = 0x10;		/* r10[4]:low q(1'b1) */
+		hp_cor = 0x0b;		/* 1.7m disable, +0cap, 1.0mhz */
+		ext_enable = 0x40;	/* r30[6]=1 ext enable; r30[5]:1 ext at lna max-1 */
+		loop_through = 0x00;	/* r5[7], lt on */
+		lt_att = 0x00;		/* r31[7], lt att enable */
+		flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
+		polyfil_cur = 0x60;	/* r25[6:5]:min */
 	} else {
 		if (bw <= 6) {
 			if_khz = 3570;
-- 
http://palosaari.fi/

