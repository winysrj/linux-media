Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48429 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1HFJwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2011 05:52:42 -0400
Received: by wyf22 with SMTP id 22so1695671wyf.19
        for <linux-media@vger.kernel.org>; Sat, 06 Aug 2011 02:52:41 -0700 (PDT)
Subject: [PATCH 2/2] IT9135 add MFE support to driver
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: jasondong <jason.dong@ite.com.tw>
In-Reply-To: <1312539895.2763.33.camel@Jason-Linux>
References: <1312539895.2763.33.camel@Jason-Linux>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Aug 2011 10:52:34 +0100
Message-ID: <1312624354.2353.17.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add MFE Support.

 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb/it9135.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it9135.c b/drivers/media/dvb/dvb-usb/it9135.c
index 772adf4..a8ab028 100644
--- a/drivers/media/dvb/dvb-usb/it9135.c
+++ b/drivers/media/dvb/dvb-usb/it9135.c
@@ -1781,8 +1781,7 @@ static struct dvb_frontend_ops it9135_ops = {
 
 static int it9135_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	struct it9135_dev_ctx *dev =
-	    (struct it9135_dev_ctx *)adap->fe->demodulator_priv;
+	struct it9135_dev_ctx *dev = adap->fe[0]->demodulator_priv;
 	int ret = 0;
 
 	deb_info("%s: onoff:%d\n", __func__, onoff);
@@ -1813,8 +1812,7 @@ static int it9135_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 static int it9135_pid_filter(struct dvb_usb_adapter *adap, int index,
 			     u16 pidnum, int onoff)
 {
-	struct it9135_dev_ctx *dev =
-	    (struct it9135_dev_ctx *)adap->fe->demodulator_priv;
+	struct it9135_dev_ctx *dev = adap->fe[0]->demodulator_priv;
 	unsigned short pid;
 	int ret = 0;
 
@@ -2234,7 +2232,7 @@ static int it9135_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	deb_func("Enter %s Function - chip=%d\n", __func__, adap->id);
 
-	adap->fe = it9135_attach(adap);
+	adap->fe[0] = it9135_attach(adap);
 
 	return adap->fe == NULL ? -ENODEV : 0;
 }
-- 
1.7.4.1


