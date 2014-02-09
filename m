Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33365 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaBIIt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:58 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 27/86] rtl2832_sdr: calculate bandwidth if not set by user
Date: Sun,  9 Feb 2014 10:48:32 +0200
Message-Id: <1391935771-18670-28-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calculate bandwidth from sampling rate if it is not set by user.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 1cc7bf7..2c9b703 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -881,6 +881,10 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	if (fe->ops.tuner_ops.init)
 		fe->ops.tuner_ops.init(fe);
 
+	/* user has not requested bandwidth so calculate automatically */
+	if (bandwidth == 0)
+		bandwidth = s->f_adc;
+
 	c->bandwidth_hz = bandwidth;
 	c->frequency = f_rf;
 
@@ -1254,9 +1258,9 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		.id     = RTL2832_SDR_CID_TUNER_BW,
 		.type   = V4L2_CTRL_TYPE_INTEGER,
 		.name   = "Tuner BW",
-		.min    =  200000,
-		.max    = 8000000,
-		.def    =  600000,
+		.min    = 0,
+		.max    = INT_MAX,
+		.def    = 0,
 		.step   = 1,
 	};
 	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
-- 
1.8.5.3

