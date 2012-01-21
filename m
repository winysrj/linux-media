Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab2AUQEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:44 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4iXL003099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 17/35] [media] az6007: Simplify the code by removing an uneeded function
Date: Sat, 21 Jan 2012 14:04:19 -0200
Message-Id: <1327161877-16784-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-17-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Everything to reset the demod is already at
az6007_frontend_poweron().

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 8add81a..912ba67 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -259,34 +259,6 @@ error:
 	return ret;
 }
 
-static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
-{
-	struct usb_device *udev = adap->dev->udev;
-	int ret;
-
-	deb_info("az6007_frontend_reset adap=%p adap->dev=%p\n", adap, adap->dev);
-
-	/* reset demodulator */
-	ret = az6007_write(udev, FX2_SCON1, 1, 3, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(200);
-	ret = az6007_write(udev, FX2_SCON1, 0, 3, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(200);
-	ret = az6007_write(udev, FX2_SCON1, 1, 3, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(200);
-
-error:
-	if (ret < 0)
-		err("%s failed with error %d", __func__, ret);
-
-	return ret;
-}
-
 static int az6007_led_on_off(struct usb_interface *intf, int onoff)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -309,7 +281,6 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 	BUG_ON(!st);
 
 	az6007_frontend_poweron(adap);
-	az6007_frontend_reset(adap);
 
 	info("az6007: attaching demod drxk");
 	adap->fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
-- 
1.7.8

