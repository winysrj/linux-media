Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaHJCOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 22:14:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] xc5000: be sure that the firmware is there before set params
Date: Sat,  9 Aug 2014 23:14:22 -0300
Message-Id: <1407636862-19394-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
References: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that xc5000_set_params() is also called during resume,
move the code that checks for the firmware to happen there.

This way, the firmware will be loaded either for analog or
digital TV when .resume callback is called.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index c1905784b08e..512fe508bcd2 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1040,6 +1040,11 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 
+	if (xc_load_fw_and_init_tuner(fe, 0) != 0) {
+		dprintk(1, "Unable to load firmware and init tuner\n");
+		return -EINVAL;
+	}
+
 	switch (priv->mode) {
 	case V4L2_TUNER_RADIO:
 		return xc5000_set_radio_freq(fe);
@@ -1061,11 +1066,6 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 	if (priv->i2c_props.adap == NULL)
 		return -EINVAL;
 
-	if (xc_load_fw_and_init_tuner(fe, 0) != 0) {
-		dprintk(1, "Unable to load firmware and init tuner\n");
-		return -EINVAL;
-	}
-
 	switch (params->mode) {
 	case V4L2_TUNER_RADIO:
 		ret = xc5000_config_radio(fe, params);
-- 
1.9.3

