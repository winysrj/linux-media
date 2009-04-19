Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47786 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbZDSUDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 16:03:17 -0400
Received: by fxm2 with SMTP id 2so1649989fxm.37
        for <linux-media@vger.kernel.org>; Sun, 19 Apr 2009 13:03:15 -0700 (PDT)
Subject: [patch review] uvc_driver: fix compile warning
From: Alexey Klimov <klimov.linux@gmail.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 00:03:09 +0400
Message-Id: <1240171389.12537.3.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all
I saw warnings in v4l-dvb daily build.
May this patch be helpful?

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r cda79523a93c linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Thu Apr 16 18:30:38 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Sun Apr 19 23:58:02 2009 +0400
@@ -1726,7 +1726,7 @@
 static int __uvc_resume(struct usb_interface *intf, int reset)
 {
 	struct uvc_device *dev = usb_get_intfdata(intf);
-	int ret;
+	int ret = 0;
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Resuming interface %u\n",
 		intf->cur_altsetting->desc.bInterfaceNumber);
 



-- 
Best regards, Klimov Alexey

