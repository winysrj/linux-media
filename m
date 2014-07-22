Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43078 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaGVDSg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 23:18:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] rtl2832_sdr: remove plain 64-bit divisions
Date: Tue, 22 Jul 2014 06:18:19 +0300
Message-Id: <1405999099-13860-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0ba2aeb6dab80920edd9cf5b93b1ea4d6913b8f3
(v4l2-ctrls: increase internal min/max/step/def to 64 bit)
changes v4l2 controls to 64-bit. Driver it not working on 32-bit
arch as it uses directly control 'step' which is changed to 64-bit.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index f58bd74..023e0f4 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1364,17 +1364,16 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 		/* TODO: these controls should be moved to tuner drivers */
 		if (s->bandwidth_auto->val) {
 			/* Round towards the closest legal value */
-			s32 val = s->f_adc + s->bandwidth->step / 2;
+			s32 val = s->f_adc + div_u64(s->bandwidth->step, 2);
 			u32 offset;
 
 			val = clamp_t(s32, val, s->bandwidth->minimum,
 				      s->bandwidth->maximum);
 			offset = val - s->bandwidth->minimum;
 			offset = s->bandwidth->step *
-				(offset / s->bandwidth->step);
+				div_u64(offset, s->bandwidth->step);
 			s->bandwidth->val = s->bandwidth->minimum + offset;
 		}
-
 		c->bandwidth_hz = s->bandwidth->val;
 
 		if (!test_bit(POWER_ON, &s->flags))
-- 
http://palosaari.fi/

