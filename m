Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35280 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbaB0Aal (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:30:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 10/16] rtl28xxu: attach SDR extension module
Date: Thu, 27 Feb 2014 02:30:19 +0200
Message-Id: <1393461025-11857-11-git-send-email-crope@iki.fi>
In-Reply-To: <1393461025-11857-1-git-send-email-crope@iki.fi>
References: <1393461025-11857-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With that extension module it supports SDR.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Makefile   |  1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
index 2c06714..bfe67f9 100644
--- a/drivers/media/usb/dvb-usb-v2/Makefile
+++ b/drivers/media/usb/dvb-usb-v2/Makefile
@@ -44,3 +44,4 @@ ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/common
+ccflags-y += -I$(srctree)/drivers/staging/media/rtl2832u_sdr
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 00d9440..73348bf 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -24,6 +24,7 @@
 
 #include "rtl2830.h"
 #include "rtl2832.h"
+#include "rtl2832_sdr.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
@@ -901,6 +902,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
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
@@ -910,6 +915,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
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
@@ -923,6 +932,11 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 
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
@@ -949,6 +963,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
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

