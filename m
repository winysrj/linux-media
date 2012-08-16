Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34708 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab2HPA3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 20:29:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/5] dvb_frontend: do not allow statistic IOCTLs when sleeping
Date: Thu, 16 Aug 2012 03:28:39 +0300
Message-Id: <1345076921-9773-4-git-send-email-crope@iki.fi>
In-Reply-To: <1345076921-9773-1-git-send-email-crope@iki.fi>
References: <1345076921-9773-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Demodulator cannot perform statistic IOCTLs when it is not tuned.
Return -EAGAIN in such case.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2bc80b1..7d079fb 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2132,27 +2132,43 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			err = fe->ops.read_status(fe, status);
 		break;
 	}
+
 	case FE_READ_BER:
-		if (fe->ops.read_ber)
-			err = fe->ops.read_ber(fe, (__u32*) parg);
+		if (fe->ops.read_ber) {
+			if (fepriv->thread)
+				err = fe->ops.read_ber(fe, (__u32 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
 	case FE_READ_SIGNAL_STRENGTH:
-		if (fe->ops.read_signal_strength)
-			err = fe->ops.read_signal_strength(fe, (__u16*) parg);
+		if (fe->ops.read_signal_strength) {
+			if (fepriv->thread)
+				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
 	case FE_READ_SNR:
-		if (fe->ops.read_snr)
-			err = fe->ops.read_snr(fe, (__u16*) parg);
+		if (fe->ops.read_snr) {
+			if (fepriv->thread)
+				err = fe->ops.read_snr(fe, (__u16 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
 	case FE_READ_UNCORRECTED_BLOCKS:
-		if (fe->ops.read_ucblocks)
-			err = fe->ops.read_ucblocks(fe, (__u32*) parg);
+		if (fe->ops.read_ucblocks) {
+			if (fepriv->thread)
+				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
-
 	case FE_DISEQC_RESET_OVERLOAD:
 		if (fe->ops.diseqc_reset_overload) {
 			err = fe->ops.diseqc_reset_overload(fe);
-- 
1.7.11.2

