Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33144 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbaCNAOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/17] rtl2832_sdr: clamp bandwidth to nearest legal value in automode
Date: Fri, 14 Mar 2014 02:14:30 +0200
Message-Id: <1394756071-22410-17-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-1-git-send-email-crope@iki.fi>
References: <1394756071-22410-1-git-send-email-crope@iki.fi>
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
index 141fc8b..b09f7d8 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -1322,8 +1322,16 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
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

