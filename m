Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59083 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbaBDBkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Feb 2014 20:40:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] rtl28xxu: attach SDR module later
Date: Tue,  4 Feb 2014 03:39:57 +0200
Message-Id: <1391478000-24239-2-git-send-email-crope@iki.fi>
In-Reply-To: <1391478000-24239-1-git-send-email-crope@iki.fi>
References: <1391478000-24239-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SDR module was attached between demod and tuner. Change it happen
after tuner attached. We are going to implement V4L controls for
tuner drivers and those controls are loaded during SDR attach. Due to
that (tuner controls), tuner driver must be loaded before SDR module.

Also as we are here, limit SDR module loading only for those tuners
we support.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 76cf0de..73348bf 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -777,10 +777,6 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	/* set fe callback */
 	adap->fe[0]->callback = rtl2832u_frontend_callback;
 
-	/* attach SDR */
-	dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
-			rtl2832_config);
-
 	return 0;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
@@ -906,6 +902,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		 * that to the tuner driver */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
+		/* attach SDR */
+		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+				&rtl28xxu_rtl2832_fc0012_config);
 		return 0;
 		break;
 	case TUNER_RTL2832_FC0013:
@@ -915,6 +915,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* fc0013 also supports signal strength reading */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
+		/* attach SDR */
+		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+				&rtl28xxu_rtl2832_fc0013_config);
 		return 0;
 	case TUNER_RTL2832_E4000: {
 			struct e4000_config e4000_config = {
@@ -928,6 +932,11 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 
 			request_module("e4000");
 			priv->client = i2c_new_device(&d->i2c_adap, &info);
+
+			/* attach SDR */
+			dvb_attach(rtl2832_sdr_attach, adap->fe[0],
+					&d->i2c_adap,
+					&rtl28xxu_rtl2832_e4000_config);
 		}
 		break;
 	case TUNER_RTL2832_FC2580:
@@ -954,6 +963,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* Use tuner to get the signal strength */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
+		/* attach SDR */
+		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+				&rtl28xxu_rtl2832_r820t_config);
 		break;
 	case TUNER_RTL2832_R828D:
 		/* power off mn88472 demod on GPIO0 */
-- 
1.8.5.3

