Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57232 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759995Ab2HIWZm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 18:25:42 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 3/3] dvb_frontend: do not allow statistic IOCTLs when sleeping
Date: Fri, 10 Aug 2012 01:25:01 +0300
Message-Id: <1344551101-16700-4-git-send-email-crope@iki.fi>
In-Reply-To: <1344551101-16700-1-git-send-email-crope@iki.fi>
References: <1344551101-16700-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Demodulator cannot perform statistic IOCTLs when it is not tuned.
Return -EPERM in such case.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c | 34 +++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 4fc11eb..40efcde 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -2157,27 +2157,43 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
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
+				err = -EPERM;
+		}
 		break;
 
 	case FE_READ_SIGNAL_STRENGTH:
-		if (fe->ops.read_signal_strength)
-			err = fe->ops.read_signal_strength(fe, (__u16*) parg);
+		if (fe->ops.read_signal_strength) {
+			if (fepriv->thread)
+				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
+			else
+				err = -EPERM;
+		}
 		break;
 
 	case FE_READ_SNR:
-		if (fe->ops.read_snr)
-			err = fe->ops.read_snr(fe, (__u16*) parg);
+		if (fe->ops.read_snr) {
+			if (fepriv->thread)
+				err = fe->ops.read_snr(fe, (__u16 *) parg);
+			else
+				err = -EPERM;
+		}
 		break;
 
 	case FE_READ_UNCORRECTED_BLOCKS:
-		if (fe->ops.read_ucblocks)
-			err = fe->ops.read_ucblocks(fe, (__u32*) parg);
+		if (fe->ops.read_ucblocks) {
+			if (fepriv->thread)
+				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
+			else
+				err = -EPERM;
+		}
 		break;
 
-
 	case FE_DISEQC_RESET_OVERLOAD:
 		if (fe->ops.diseqc_reset_overload) {
 			err = fe->ops.diseqc_reset_overload(fe);
-- 
1.7.11.2

