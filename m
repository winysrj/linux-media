Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:42521 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab0BCUhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:37:11 -0500
Message-ID: <4B69DE57.4030509@arcor.de>
Date: Wed, 03 Feb 2010 21:36:39 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 13/15] - xc2028 bugfix for firmware 3.6 -> Zarlink use without
 shift in DTV8 or DTV78
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1114,7 +1122,11 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 
     /* All S-code tables need a 200kHz shift */
     if (priv->ctrl.demod) {
-        demod = priv->ctrl.demod + 200;
+        if ((priv->ctrl.fname == "xc3028L-v36.fw") && (priv->ctrl.demod
== XC3028_FE_ZARLINK456) && ((type & DTV78) | (type & DTV8)) ) {
+            demod = priv->ctrl.demod;
+        } else {
+            demod = priv->ctrl.demod + 200;
+        }
         /*
          * The DTV7 S-code table needs a 700 kHz shift.
          * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
@@ -1123,8 +1135,8 @@ static int xc2028_set_params(struct dvb_frontend *fe,
          * use this firmware after initialization, but a tune to a UHF
          * channel should then cause DTV78 to be used.
          */
-        if (type & DTV7)
-            demod += 500;
+        if (type & DTV7)
+            demod += 500;
     }
 
     return generic_set_freq(fe, p->frequency,
@@ -1240,6 +1252,10 @@ static const struct dvb_tuner_ops
xc2028_dvb_tuner_ops = {
     .get_rf_strength   = xc2028_signal,
     .set_params        = xc2028_set_params,
     .sleep             = xc2028_sleep,
+#if 0
+    int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
+    int (*get_status)(struct dvb_frontend *fe, u32 *status);
+#endif
 };
 
