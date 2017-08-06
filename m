Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48856 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751263AbdHFLEH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Aug 2017 07:04:07 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-api: log the reason for the -EINVAL in cec_s_mode
Message-ID: <c38f37df-f07e-c91f-3421-a3f068b06c9d@xs4all.nl>
Date: Sun, 6 Aug 2017 13:04:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If cec_debug >= 1 then log why the requested mode returned -EINVAL.

It can be hard to debug this since -EINVAL can be returned for many
reasons. So this should help.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-api.c | 48 +++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 981d199ae4b4..4b03b4f20f11 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -357,34 +357,47 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,

 	if (copy_from_user(&mode, parg, sizeof(mode)))
 		return -EFAULT;
-	if (mode & ~(CEC_MODE_INITIATOR_MSK | CEC_MODE_FOLLOWER_MSK))
+	if (mode & ~(CEC_MODE_INITIATOR_MSK | CEC_MODE_FOLLOWER_MSK)) {
+		dprintk(1, "%s: invalid mode bits set\n", __func__);
 		return -EINVAL;
+	}

 	mode_initiator = mode & CEC_MODE_INITIATOR_MSK;
 	mode_follower = mode & CEC_MODE_FOLLOWER_MSK;

 	if (mode_initiator > CEC_MODE_EXCL_INITIATOR ||
-	    mode_follower > CEC_MODE_MONITOR_ALL)
+	    mode_follower > CEC_MODE_MONITOR_ALL) {
+		dprintk(1, "%s: unknown mode\n", __func__);
 		return -EINVAL;
+	}

 	if (mode_follower == CEC_MODE_MONITOR_ALL &&
-	    !(adap->capabilities & CEC_CAP_MONITOR_ALL))
+	    !(adap->capabilities & CEC_CAP_MONITOR_ALL)) {
+		dprintk(1, "%s: MONITOR_ALL not supported\n", __func__);
 		return -EINVAL;
+	}

 	if (mode_follower == CEC_MODE_MONITOR_PIN &&
-	    !(adap->capabilities & CEC_CAP_MONITOR_PIN))
+	    !(adap->capabilities & CEC_CAP_MONITOR_PIN)) {
+		dprintk(1, "%s: MONITOR_PIN not supported\n", __func__);
 		return -EINVAL;
+	}

 	/* Follower modes should always be able to send CEC messages */
 	if ((mode_initiator == CEC_MODE_NO_INITIATOR ||
 	     !(adap->capabilities & CEC_CAP_TRANSMIT)) &&
 	    mode_follower >= CEC_MODE_FOLLOWER &&
-	    mode_follower <= CEC_MODE_EXCL_FOLLOWER_PASSTHRU)
+	    mode_follower <= CEC_MODE_EXCL_FOLLOWER_PASSTHRU) {
+		dprintk(1, "%s: cannot transmit\n", __func__);
 		return -EINVAL;
+	}

 	/* Monitor modes require CEC_MODE_NO_INITIATOR */
-	if (mode_initiator && mode_follower >= CEC_MODE_MONITOR_PIN)
+	if (mode_initiator && mode_follower >= CEC_MODE_MONITOR_PIN) {
+		dprintk(1, "%s: monitor modes require NO_INITIATOR\n",
+			__func__);
 		return -EINVAL;
+	}

 	/* Monitor modes require CAP_NET_ADMIN */
 	if (mode_follower >= CEC_MODE_MONITOR_PIN && !capable(CAP_NET_ADMIN))
@@ -465,8 +478,8 @@ static long cec_error_inj(struct cec_adapter *adap, struct cec_fh *fh,
 			  u32 __user *parg)
 {
 	struct cec_error_inj error_inj;
-	bool low_drive, inv_bit, stop_after_bit;
-	u8 low_drive_pos, inv_bit_pos, stop_after_bit_pos;
+	bool invalid_ack, low_drive, inv_bit, stop_after_bit;
+	u8 invalid_ack_pos, low_drive_pos, inv_bit_pos, stop_after_bit_pos;

 	if (!(adap->capabilities & CEC_CAP_ERROR_INJ))
 		return -ENOTTY;
@@ -486,8 +499,9 @@ static long cec_error_inj(struct cec_adapter *adap, struct cec_fh *fh,
 	}
 	error_inj.rx_error &= 0x0000ffff;
 	error_inj.tx_error &= 0x00ffff1f;
-	if (!(error_inj.rx_error & CEC_ERROR_INJ_RX_INVALID_ACK))
-		error_inj.rx_error &= ~0xf0;
+	invalid_ack = error_inj.rx_error & CEC_ERROR_INJ_RX_INVALID_ACK;
+	if (!invalid_ack)
+		error_inj.rx_error &= ~0x00f0;
 	low_drive = error_inj.rx_error & CEC_ERROR_INJ_RX_LOW_DRIVE;
 	if (!low_drive)
 		error_inj.rx_error &= ~0xff00;
@@ -497,6 +511,7 @@ static long cec_error_inj(struct cec_adapter *adap, struct cec_fh *fh,
 	stop_after_bit = error_inj.tx_error & CEC_ERROR_INJ_TX_STOP_EARLY;
 	if (!stop_after_bit)
 		error_inj.tx_error &= ~0xff0000;
+	invalid_ack_pos = (error_inj.rx_error & 0x00f0) >> 4;
 	low_drive_pos = (error_inj.rx_error & 0xff00) >> 8;
 	inv_bit_pos = (error_inj.tx_error & 0xff00) >> 8;
 	stop_after_bit_pos = (error_inj.tx_error & 0xff0000) >> 16;
@@ -505,11 +520,14 @@ static long cec_error_inj(struct cec_adapter *adap, struct cec_fh *fh,
 		dprintk(1, "%s: bit position > 160\n", __func__);
 		return -EINVAL;
 	}
-	if (error_inj.cmd < 256 &&
-	    ((low_drive && low_drive_pos <= 16) ||
-	     (inv_bit && inv_bit_pos <= 16) ||
-	     (stop_after_bit && stop_after_bit_pos <= 16))) {
-		dprintk(1, "%s: bit position <= 16 when cmd < 256\n", __func__);
+	if (error_inj.cmd < 256 && low_drive && low_drive_pos <= 18) {
+		dprintk(1, "%s: low drive bit position <= 18 when cmd < 256\n",
+			__func__);
+		return -EINVAL;
+	}
+	if (error_inj.cmd < 256 && invalid_ack && !invalid_ack_pos) {
+		dprintk(1, "%s: invalid ack bit position == 0 when cmd < 256\n",
+			__func__);
 		return -EINVAL;
 	}
 	if (inv_bit_pos &&
-- 
2.13.2
