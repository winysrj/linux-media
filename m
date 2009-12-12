Return-path: <linux-media-owner@vger.kernel.org>
Received: from snail.duncangibb.com ([217.169.3.184]:4625 "EHLO
	snail.duncangibb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759753AbZLLNQI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 08:16:08 -0500
Received: from edna.duncangibb.com ([217.169.3.179])
	by snail.duncangibb.com with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <dg@duncangibb.com>)
	id 1NJRS6-000788-69
	for linux-media@vger.kernel.org; Sat, 12 Dec 2009 12:52:04 +0000
Message-ID: <4B2391F1.4000908@duncangibb.com>
Date: Sat, 12 Dec 2009 12:52:01 +0000
From: Duncan Gibb <dg@duncangibb.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH] Fix some cut-and-paste noise in dib0090.h
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

This patch against current http://linuxtv.org/hg/v4l-dvb
removes what looks to me like slips of the mouse/keyboard
leaving something which builds.

Cheers

Duncan


Signed-off-by: Duncan Gibb <dg@duncangibb.com>
---
diff -r db37ff59927f linux/drivers/media/dvb/frontends/dib0090.h
--- a/linux/drivers/media/dvb/frontends/dib0090.h       Thu Dec 10 18:17:49 2009 -0200
+++ b/linux/drivers/media/dvb/frontends/dib0090.h       Sat Dec 12 12:41:23 2009 +0000
@@ -57,7 +57,6 @@
 extern int dib0090_gain_control(struct dvb_frontend *fe);
 extern enum frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe);
 extern int dib0090_set_tune_state(struct dvb_frontend *fe, enum frontend_tune_state tune_state);
-extern enum frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe);
 extern void dib0090_get_current_gain(struct dvb_frontend *fe, u16 * rf, u16 * bb, u16 * rf_gain_limit, u16 * rflt);
 #else
 static inline struct dvb_frontend *dib0090_register(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct dib0090_config *config)
@@ -100,11 +99,6 @@
        return -ENODEV;
 }

-static inline num frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe)
-{
-       printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-return CT_SHUTDOWN,}
-
 static inline void dib0090_get_current_gain(struct dvb_frontend *fe, u16 * rf, u16 * bb, u16 * rf_gain_limit, u16 * rflt)
 {
        printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);

