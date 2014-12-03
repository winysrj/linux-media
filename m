Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35271 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaLCXTS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 18:19:18 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl2832_sdr: control ADC
Date: Thu,  4 Dec 2014 01:19:11 +0200
Message-Id: <1417648751-15442-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recent rtl28xxu patch I made moved demod ADC enable from power control
to frontend control (due to slave demod support). Because of that we
need call USB interface frontend control too in order to enable ADC.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 7bf98cf..2896b47 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1013,6 +1013,10 @@ static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (s->d->props->power_ctrl)
 		s->d->props->power_ctrl(s->d, 1);
 
+	/* enable ADC */
+	if (s->d->props->frontend_ctrl)
+		s->d->props->frontend_ctrl(s->fe, 1);
+
 	set_bit(POWER_ON, &s->flags);
 
 	ret = rtl2832_sdr_set_tuner(s);
@@ -1064,6 +1068,10 @@ static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 
 	clear_bit(POWER_ON, &s->flags);
 
+	/* disable ADC */
+	if (s->d->props->frontend_ctrl)
+		s->d->props->frontend_ctrl(s->fe, 0);
+
 	if (s->d->props->power_ctrl)
 		s->d->props->power_ctrl(s->d, 0);
 
-- 
http://palosaari.fi/

