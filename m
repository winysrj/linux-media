Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49561 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932996AbaDJAHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 20:07:34 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 295C321025
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 20:07:34 -0400 (EDT)
Date: Wed, 9 Apr 2014 20:07:28 -0400
From: Anthony DeStefano <adx@fastmail.fm>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: rtl2832_sdr: fixup checkpatch/style issues
Message-ID: <20140410000722.GA64332@pluto-arch.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rtl2832_sdr.c: fixup checkpatch issues about long lines

Signed-off-by: Anthony DeStefano <adx@fastmail.fm>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 104ee8a..0e6c6fa 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -935,7 +935,9 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_state *s)
 	/*
 	 * bandwidth (Hz)
 	 */
-	bandwidth_auto = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
+	bandwidth_auto = v4l2_ctrl_find(&s->hdl,
+		V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
+
 	bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH);
 	if (v4l2_ctrl_g_ctrl(bandwidth_auto)) {
 		c->bandwidth_hz = s->f_adc;
@@ -1332,9 +1334,11 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 			/* Round towards the closest legal value */
 			s32 val = s->f_adc + s->bandwidth->step / 2;
 			u32 offset;
-			val = clamp(val, s->bandwidth->minimum, s->bandwidth->maximum);
+			val = clamp(val, s->bandwidth->minimum,
+				s->bandwidth->maximum);
 			offset = val - s->bandwidth->minimum;
-			offset = s->bandwidth->step * (offset / s->bandwidth->step);
+			offset = s->bandwidth->step *
+				(offset / s->bandwidth->step);
 			s->bandwidth->val = s->bandwidth->minimum + offset;
 		}
 
@@ -1423,15 +1427,20 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		break;
 	case RTL2832_TUNER_R820T:
 		v4l2_ctrl_handler_init(&s->hdl, 2);
-		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
-		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_RF_TUNER_BANDWIDTH, 0, 8000000, 100000, 0);
+		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
+		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_RF_TUNER_BANDWIDTH, 0, 8000000, 100000, 0);
 		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
 		break;
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
 		v4l2_ctrl_handler_init(&s->hdl, 2);
-		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
-		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_RF_TUNER_BANDWIDTH, 6000000, 8000000, 1000000, 6000000);
+		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
+		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_RF_TUNER_BANDWIDTH, 6000000, 8000000, 1000000,
+			6000000);
 		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
 		break;
 	default:
-- 
1.9.0

