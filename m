Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64446 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2EMVVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 17:21:01 -0400
Received: by bkcji2 with SMTP id ji2so3312672bkc.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 14:21:00 -0700 (PDT)
From: Thomas Mair <thomas.mair86@googlemail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Thomas Mair <thomas.mair86@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] rtl28xxu: removed newlines from info strings
Date: Sun, 13 May 2012 23:18:57 +0200
Message-Id: <1336943937-19422-1-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com>
References: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/dvb/dvb-usb/rtl28xxu.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index ef02f0f..f10cac2 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -552,7 +552,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && buf[0] == 0xa1) {
 		priv->tuner = TUNER_RTL2832_FC0012;
 		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
-		info("%s: FC0012 tuner found\n", __func__);
+		info("%s: FC0012 tuner found", __func__);
 		goto found;
 	}
 
@@ -561,7 +561,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && buf[0] == 0xa3) {
 		priv->tuner = TUNER_RTL2832_FC0013;
 		rtl2832_config = &rtl28xxu_rtl2832_fc0013_config;
-		info("%s: FC0013 tuner found\n", __func__);
+		info("%s: FC0013 tuner found", __func__);
 		goto found;
 	}
 
@@ -570,7 +570,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && buf[0] == 0x85) {
 		priv->tuner = TUNER_RTL2832_MT2266;
 		/* TODO implement tuner */
-		info("%s: MT2266 tuner found\n", __func__);
+		info("%s: MT2266 tuner found", __func__);
 		goto found;
 	}
 
@@ -579,7 +579,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && buf[0] == 0x56) {
 		priv->tuner = TUNER_RTL2832_FC2580;
 		/* TODO implement tuner */
-		info("%s: FC2580 tuner found\n", __func__);
+		info("%s: FC2580 tuner found", __func__);
 		goto found;
 	}
 
@@ -588,7 +588,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && (buf[0] == 0x9e || buf[0] == 0x9c)) {
 		priv->tuner = TUNER_RTL2832_MT2063;
 		/* TODO implement tuner */
-		info("%s: MT2063 tuner found\n", __func__);
+		info("%s: MT2063 tuner found", __func__);
 		goto found;
 	}
 
@@ -597,7 +597,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && buf[0] == 0x38) {
 		priv->tuner = TUNER_RTL2832_MAX3543;
 		/* TODO implement tuner */
-		info("%s: MAX3534 tuner found\n", __func__);
+		info("%s: MAX3534 tuner found", __func__);
 		goto found;
 	}
 
@@ -606,7 +606,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
 		priv->tuner = TUNER_RTL2832_TUA9001;
 		/* TODO implement tuner */
-		info("%s: TUA9001 tuner found\n", __func__);
+		info("%s: TUA9001 tuner found", __func__);
 		goto found;
 	}
 
@@ -615,7 +615,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && buf[0] == 0x14) {
 		priv->tuner = TUNER_RTL2832_MXL5007T;
 		/* TODO implement tuner */
-		info("%s: MXL5007T tuner found\n", __func__);
+		info("%s: MXL5007T tuner found", __func__);
 		goto found;
 	}
 
@@ -624,7 +624,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && buf[0] == 0x40) {
 		priv->tuner = TUNER_RTL2832_E4000;
 		/* TODO implement tuner */
-		info("%s: E4000 tuner found\n", __func__);
+		info("%s: E4000 tuner found", __func__);
 		goto found;
 	}
 
@@ -633,7 +633,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret == 0 && (buf[0] == 0xc7 || buf[1] == 0x60)) {
 		priv->tuner = TUNER_RTL2832_TDA18272;
 		/* TODO implement tuner */
-		info("%s: TDA18272 tuner found\n", __func__);
+		info("%s: TDA18272 tuner found", __func__);
 		goto found;
 	}
 
-- 
1.7.7.6

