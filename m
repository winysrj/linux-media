Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60992 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaCJTer (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 15:34:47 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [FINAL PATCH 3/6] rtl2832_sdr: clamp bandwidth to nearest legal value in automode
Date: Mon, 10 Mar 2014 21:34:09 +0200
Message-Id: <1394480052-6003-3-git-send-email-crope@iki.fi>
In-Reply-To: <1394480052-6003-1-git-send-email-crope@iki.fi>
References: <1394480052-6003-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clamp bandwidth to nearest legal value in automode in order to pass
v4l2-compliance test.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index bcc632a..c2c3c3d 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -1324,8 +1324,16 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH:
-		if (s->bandwidth_auto->val)
-			s->bandwidth->val = s->f_adc;
+		/* TODO: these controls should be moved to tuner drivers */
+		if (s->bandwidth_auto->val) {
+			/* Round towards the closest legal value */
+			s32 val = s->f_adc + s->bandwidth->step / 2;
+			u32 offset;
+			val = clamp(val, s->bandwidth->minimum, s->bandwidth->maximum);
+			offset = val - s->bandwidth->minimum;
+			offset = s->bandwidth->step * (offset / s->bandwidth->step);
+			s->bandwidth->val = s->bandwidth->minimum + offset;
+		}
 
 		c->bandwidth_hz = s->bandwidth->val;
 
-- 
1.8.5.3

