Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46619 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933969AbaDIWFS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 18:05:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv3 2/2] rtl28xxu: silence error log about disabled rtl2832_sdr module
Date: Thu, 10 Apr 2014 01:05:07 +0300
Message-Id: <1397081107-2249-3-git-send-email-crope@iki.fi>
In-Reply-To: <1397081107-2249-1-git-send-email-crope@iki.fi>
References: <1397081107-2249-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It printed a little bit too heavy looking error log "DVB: Unable to
find symbol rtl2832_sdr_attach()" when staging module was disabled.
Silence that error by introducing own version of dvb_attach() macro
without the error logging.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 8d7c5f2..8bab912 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -55,6 +55,25 @@ static inline struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 }
 #endif
 
+#ifdef CONFIG_MEDIA_ATTACH
+#define dvb_attach_sdr(FUNCTION, ARGS...) ({ \
+	void *__r = NULL; \
+	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
+	if (__a) { \
+		__r = (void *) __a(ARGS); \
+		if (__r == NULL) \
+			symbol_put(FUNCTION); \
+	} \
+	__r; \
+})
+
+#else
+#define dvb_attach_sdr(FUNCTION, ARGS...) ({ \
+	FUNCTION(ARGS); \
+})
+
+#endif
+
 static int rtl28xxu_disable_rc;
 module_param_named(disable_rc, rtl28xxu_disable_rc, int, 0644);
 MODULE_PARM_DESC(disable_rc, "disable RTL2832U remote controller");
@@ -927,7 +946,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 
 		/* attach SDR */
-		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_fc0012_config, NULL);
 		break;
 	case TUNER_RTL2832_FC0013:
@@ -939,7 +958,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 
 		/* attach SDR */
-		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_fc0013_config, NULL);
 		break;
 	case TUNER_RTL2832_E4000: {
@@ -970,7 +989,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			i2c_set_adapdata(i2c_adap_internal, d);
 
 			/* attach SDR */
-			dvb_attach(rtl2832_sdr_attach, adap->fe[0],
+			dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0],
 					i2c_adap_internal,
 					&rtl28xxu_rtl2832_e4000_config, sd);
 		}
@@ -1001,7 +1020,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 
 		/* attach SDR */
-		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_r820t_config, NULL);
 		break;
 	case TUNER_RTL2832_R828D:
-- 
1.9.0

