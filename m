Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40539 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbaAYRLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:01 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/52] rtl2832_sdr: implement sampling rate
Date: Sat, 25 Jan 2014 19:10:00 +0200
Message-Id: <1390669846-8131-7-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now it is possible to set desired sampling rate via v4l2 controls.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index c4b72c1..0e12e1a 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -38,6 +38,8 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
 
+#include <linux/math64.h>
+
 /* TODO: These should be moved to V4L2 API */
 #define RTL2832_SDR_CID_SAMPLING_MODE       ((V4L2_CID_USER_BASE | 0xf000) +  0)
 #define RTL2832_SDR_CID_SAMPLING_RATE       ((V4L2_CID_USER_BASE | 0xf000) +  1)
@@ -643,7 +645,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	struct dvb_frontend *fe = s->fe;
 	int ret;
 	unsigned int f_sr, f_if;
-	u8 buf[3], tmp;
+	u8 buf[4], tmp;
 	u64 u64tmp;
 	u32 u32tmp;
 
@@ -696,8 +698,17 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x19f, "\x03\x84", 2);
-	ret = rtl2832_sdr_wr_regs(s, 0x1a1, "\x00\x00", 2);
+	/* program sampling rate (resampling down) */
+	u32tmp = div_u64(s->cfg->xtal * 0x400000ULL, f_sr * 4U);
+	u32tmp <<= 2;
+	buf[0] = (u32tmp >> 24) & 0xff;
+	buf[1] = (u32tmp >> 16) & 0xff;
+	buf[2] = (u32tmp >>  8) & 0xff;
+	buf[3] = (u32tmp >>  0) & 0xff;
+	ret = rtl2832_sdr_wr_regs(s, 0x19f, buf, 4);
+	if (ret)
+		goto err;
+
 	ret = rtl2832_sdr_wr_regs(s, 0x11c, "\xca", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x11d, "\xdc", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x11e, "\xd7", 1);
@@ -1090,8 +1101,8 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		.id	= RTL2832_SDR_CID_SAMPLING_RATE,
 		.type	= V4L2_CTRL_TYPE_INTEGER64,
 		.name	= "Sampling Rate",
-		.min	=  500000,
-		.max	= 4000000,
+		.min	=  900001,
+		.max	= 2800000,
 		.def    = 2048000,
 		.step	= 1,
 	};
-- 
1.8.5.3

