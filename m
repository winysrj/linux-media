Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41883 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbbEEV7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 17/21] rtl28xxu: set correct FC2580 tuner for RTL2832 demod
Date: Wed,  6 May 2015 00:58:38 +0300
Message-Id: <1430863122-9888-17-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rtl2832 demod driver has support for FC2580 tuner config, no need to
abuse FC0012 settings anymore.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 9a65291..41f8808 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -643,6 +643,11 @@ err:
 	return ret;
 }
 
+static const struct rtl2832_platform_data rtl2832_fc2580_platform_data = {
+	.clk = 28800000,
+	.tuner = TUNER_RTL2832_FC2580,
+};
+
 static const struct rtl2832_platform_data rtl2832_fc0012_platform_data = {
 	.clk = 28800000,
 	.tuner = TUNER_RTL2832_FC0012
@@ -804,8 +809,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 		*pdata = rtl2832_fc0013_platform_data;
 		break;
 	case TUNER_RTL2832_FC2580:
-		/* FIXME: do not abuse fc0012 settings */
-		*pdata = rtl2832_fc0012_platform_data;
+		*pdata = rtl2832_fc2580_platform_data;
 		break;
 	case TUNER_RTL2832_TUA9001:
 		*pdata = rtl2832_tua9001_platform_data;
-- 
http://palosaari.fi/

