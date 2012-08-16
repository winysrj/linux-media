Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48623 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab2HPA3R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 20:29:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/5] rtl2832: remove dummy callback implementations
Date: Thu, 16 Aug 2012 03:28:41 +0300
Message-Id: <1345076921-9773-6-git-send-email-crope@iki.fi>
In-Reply-To: <1345076921-9773-1-git-send-email-crope@iki.fi>
References: <1345076921-9773-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let the dvb-frontend return -ENOTTY for those unimplemented IOCTLs.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 28269cc..18e1ae3 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -668,31 +668,6 @@ err:
 	return ret;
 }
 
-static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	*snr = 0;
-	return 0;
-}
-
-static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	*ber = 0;
-	return 0;
-}
-
-static int rtl2832_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	*ucblocks = 0;
-	return 0;
-}
-
-
-static int rtl2832_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
-{
-	*strength = 0;
-	return 0;
-}
-
 static struct dvb_frontend_ops rtl2832_ops;
 
 static void rtl2832_release(struct dvb_frontend *fe)
@@ -776,10 +751,6 @@ static struct dvb_frontend_ops rtl2832_ops = {
 	.set_frontend = rtl2832_set_frontend,
 
 	.read_status = rtl2832_read_status,
-	.read_snr = rtl2832_read_snr,
-	.read_ber = rtl2832_read_ber,
-	.read_ucblocks = rtl2832_read_ucblocks,
-	.read_signal_strength = rtl2832_read_signal_strength,
 	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
 };
 
-- 
1.7.11.2

