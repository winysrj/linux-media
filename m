Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44863 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaBIItz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:55 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 02/86] rtl28xxu: attach SDR extension module
Date: Sun,  9 Feb 2014 10:48:07 +0200
Message-Id: <1391935771-18670-3-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With that extension module it supports SDR.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Makefile   | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 8 ++++++++
 2 files changed, 9 insertions(+)

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
index fda5c64..b398ebf 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -24,6 +24,7 @@
 
 #include "rtl2830.h"
 #include "rtl2832.h"
+#include "rtl2832_sdr.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
@@ -734,6 +735,9 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
 	struct rtl2832_config *rtl2832_config;
+	static const struct rtl2832_sdr_config rtl2832_sdr_config = {
+		.i2c_addr = 0x10,
+	};
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -775,6 +779,10 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	/* set fe callback */
 	adap->fe[0]->callback = rtl2832u_frontend_callback;
 
+	/* attach SDR */
+	dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+			&rtl2832_sdr_config);
+
 	return 0;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-- 
1.8.5.3

