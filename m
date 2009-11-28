Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.216.173]:63239 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZK1LgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 06:36:24 -0500
Received: by pxi3 with SMTP id 3so1633943pxi.22
        for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 03:36:30 -0800 (PST)
Message-ID: <4B110B3A.3030401@gmail.com>
Date: Sat, 28 Nov 2009 19:36:26 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: v4l-dvb <linux-media@vger.kernel.org>
Subject: [PATCH] cxusb: Mygica D689 compilation warning fix and clean up
Content-Type: multipart/mixed;
 boundary="------------060802090505070805070805"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060802090505070805070805
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

   This patch fix compilation warning for cxusb mygica d689 and clean up 
unused code.

Regards,
David

Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>


--------------060802090505070805070805
Content-Type: text/x-patch;
 name="mygica_d689_fix_warnings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mygica_d689_fix_warnings.patch"

diff --git a/linux/drivers/media/dvb/dvb-usb/cxusb.c b/linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1195,7 +1195,6 @@
 static int cxusb_mygica_d689_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap->dev;
-	int n;
 
 	/* Select required USB configuration */
 	if (usb_set_interface(d->udev, 0, 0) < 0)
@@ -1209,15 +1208,6 @@
 	usb_clear_halt(d->udev,
 		usb_rcvbulkpipe(d->udev, d->props.adapter[0].stream.endpoint));
 
-#if 0
-	/* Drain USB pipes to avoid hang after reboot */
-	for (n = 0;  n < 5;  n++) {
-		cxusb_d680_dmb_drain_message(d);
-		cxusb_d680_dmb_drain_video(d);
-		msleep(200);
-	}
-#endif
-
 	/* Reset the tuner */
 	if (cxusb_d680_dmb_gpio_tuner(d, 0x07, 0) < 0) {
 		err("clear tuner gpio failed");

--------------060802090505070805070805--
