Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3547 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2JBP5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 11:57:21 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/2] tda18271: properly report read errors in tda18271_get_id
Date: Tue,  2 Oct 2012 11:57:06 -0400
Message-Id: <1349193426-13313-2-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1349193426-13313-1-git-send-email-mkrufky@linuxtv.org>
References: <1349193426-13313-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Until now, if there is a read error in tda18271_get_id, the driver
reports "Unknown device..."  Instead, check the return value of
tda18271_read_regs and display the appropriate error message.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/tuners/tda18271-fe.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index ca202da..72c26fd 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -1159,11 +1159,19 @@ static int tda18271_get_id(struct dvb_frontend *fe)
 	struct tda18271_priv *priv = fe->tuner_priv;
 	unsigned char *regs = priv->tda18271_regs;
 	char *name;
+	int ret;
 
 	mutex_lock(&priv->lock);
-	tda18271_read_regs(fe);
+	ret = tda18271_read_regs(fe);
 	mutex_unlock(&priv->lock);
 
+	if (ret) {
+		tda_info("Error reading device ID @ %d-%04x, bailing out.\n",
+			 i2c_adapter_id(priv->i2c_props.adap),
+			 priv->i2c_props.addr);
+		return -EIO;
+	}
+
 	switch (regs[R_ID] & 0x7f) {
 	case 3:
 		name = "TDA18271HD/C1";
-- 
1.7.9.5

