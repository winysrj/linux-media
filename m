Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46593 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0DEEPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 00:15:20 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
	Olivier Grenie <Olivier.Grenie@dibcom.fr>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon,  5 Apr 2010 06:14:26 +0200
Message-Id: <1270440866-23421-1-git-send-email-w.sang@pengutronix.de>
Subject: [PATCH] dvb/dib8000: fix build warning
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  In file included from drivers/media/dvb/dvb-usb/dib0700_devices.c:14:
  drivers/media/dvb/frontends/dib8000.h: In function 'dib8000_get_adc_power':
  drivers/media/dvb/frontends/dib8000.h:112: warning: no return statement in function returning non-void

Fixed by adding a return to the dummy function.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Olivier Grenie <Olivier.Grenie@dibcom.fr>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/dvb/frontends/dib8000.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib8000.h b/drivers/media/dvb/frontends/dib8000.h
index b1ee207..e0a9ded 100644
--- a/drivers/media/dvb/frontends/dib8000.h
+++ b/drivers/media/dvb/frontends/dib8000.h
@@ -109,6 +109,7 @@ static inline void dib8000_pwm_agc_reset(struct dvb_frontend *fe)
 static inline s32 dib8000_get_adc_power(struct dvb_frontend *fe, u8 mode)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return 0;
 }
 #endif
 
-- 
1.7.0

