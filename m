Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35550 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbaCNAOv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:51 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/17] rtl28xxu: attach SDR extension module
Date: Fri, 14 Mar 2014 02:14:22 +0200
Message-Id: <1394756071-22410-9-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-1-git-send-email-crope@iki.fi>
References: <1394756071-22410-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With that extension module it supports SDR.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Makefile   |  1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
index bc38f03..7407b83 100644
--- a/drivers/media/usb/dvb-usb-v2/Makefile
+++ b/drivers/media/usb/dvb-usb-v2/Makefile
@@ -41,3 +41,4 @@ ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/common
+ccflags-y += -I$(srctree)/drivers/staging/media/rtl2832u_sdr
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index db98f1c..61b420c 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -24,6 +24,7 @@
 
 #include "rtl2830.h"
 #include "rtl2832.h"
+#include "rtl2832_sdr.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
@@ -902,6 +903,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		 * that to the tuner driver */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
+		/* attach SDR */
+		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+				&rtl28xxu_rtl2832_fc0012_config, NULL);
 		return 0;
 		break;
 	case TUNER_RTL2832_FC0013:
@@ -911,8 +916,13 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* fc0013 also supports signal strength reading */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
+		/* attach SDR */
+		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+				&rtl28xxu_rtl2832_fc0013_config, NULL);
 		return 0;
 	case TUNER_RTL2832_E4000: {
+			struct v4l2_subdev *sd;
 			struct e4000_config e4000_config = {
 				.fe = adap->fe[0],
 				.clock = 28800000,
@@ -933,6 +943,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			}
 
 			priv->client = client;
+			sd = i2c_get_clientdata(client);
+
+			/* attach SDR */
+			dvb_attach(rtl2832_sdr_attach, adap->fe[0],
+					&d->i2c_adap,
+					&rtl28xxu_rtl2832_e4000_config, sd);
 		}
 		break;
 	case TUNER_RTL2832_FC2580:
@@ -959,6 +975,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* Use tuner to get the signal strength */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
+		/* attach SDR */
+		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+				&rtl28xxu_rtl2832_r820t_config, NULL);
 		break;
 	case TUNER_RTL2832_R828D:
 		/* power off mn88472 demod on GPIO0 */
-- 
1.8.5.3

