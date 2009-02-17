Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:5462 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZBQNq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 08:46:29 -0500
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LZRL1-0005S5-MU
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Tue, 17 Feb 2009 15:54:20 +0100
Date: Tue, 17 Feb 2009 14:46:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-dvb] Drop test for kernel version 2.6.15
Message-ID: <20090217144622.276519be@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l-dvb repository supports kernel versions 2.6.16 and later only,
so no need to test for kernel version 2.6.15.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/dvb/dvb-usb/af9015.c |    3 ---
 1 file changed, 3 deletions(-)

--- v4l-dvb-zoran.orig/linux/drivers/media/dvb/dvb-usb/af9015.c	2009-02-15 16:59:30.000000000 +0100
+++ v4l-dvb-zoran/linux/drivers/media/dvb/dvb-usb/af9015.c	2009-02-17 14:09:06.000000000 +0100
@@ -1493,9 +1493,6 @@ static void af9015_usb_device_exit(struc
 
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver af9015_usb_driver = {
-#if LINUX_VERSION_CODE <=  KERNEL_VERSION(2, 6, 15)
-	.owner = THIS_MODULE,
-#endif
 	.name = "dvb_usb_af9015",
 	.probe = af9015_usb_probe,
 	.disconnect = af9015_usb_device_exit,


-- 
Jean Delvare
