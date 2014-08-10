Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 18/18] [media] xc5000: better name the functions
Date: Sat,  9 Aug 2014 21:47:24 -0300
Message-Id: <1407631644-11990-19-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

xc5000_set_params() is a bad name for a function that
handles only digital TV. Rename it to xc5000_set_digital_params(),
and proper name the generic function that works for both
digital and analog.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 140c537bcfcc..c1905784b08e 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -754,7 +754,7 @@ static int xc5000_tune_digital(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int xc5000_set_params(struct dvb_frontend *fe)
+static int xc5000_set_digital_params(struct dvb_frontend *fe)
 {
 	int b;
 	struct xc5000_priv *priv = fe->tuner_priv;
@@ -1036,7 +1036,7 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int xc5000_apply_params(struct dvb_frontend *fe)
+static int xc5000_set_params(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 
@@ -1080,7 +1080,7 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 	}
 	priv->mode = params->mode;
 
-	return xc5000_apply_params(fe);
+	return xc5000_set_params(fe);
 }
 
 static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
@@ -1354,10 +1354,10 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.init		   = xc5000_init,
 	.sleep		   = xc5000_sleep,
 	.suspend	   = xc5000_suspend,
-	.resume		   = xc5000_apply_params,
+	.resume		   = xc5000_set_params,
 
 	.set_config	   = xc5000_set_config,
-	.set_params	   = xc5000_set_params,
+	.set_params	   = xc5000_set_digital_params,
 	.set_analog_params = xc5000_set_analog_params,
 	.get_frequency	   = xc5000_get_frequency,
 	.get_if_frequency  = xc5000_get_if_frequency,
-- 
1.9.3

