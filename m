Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbD2XGZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:25 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 25/27] usbvision: fix bad indentation
Date: Wed, 29 Apr 2015 20:06:10 -0300
Message-Id: <059321071ca9d62dab15cff63d1a6ffc68701fc1.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/usbvision/usbvision-core.c:2395 usbvision_init_isoc() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 44b0c28d69b6..7c04ef697fb6 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -2390,8 +2390,8 @@ int usbvision_init_isoc(struct usb_usbvision *usbvision)
 
 	/* Submit all URBs */
 	for (buf_idx = 0; buf_idx < USBVISION_NUMSBUF; buf_idx++) {
-			err_code = usb_submit_urb(usbvision->sbuf[buf_idx].urb,
-						 GFP_KERNEL);
+		err_code = usb_submit_urb(usbvision->sbuf[buf_idx].urb,
+					 GFP_KERNEL);
 		if (err_code) {
 			dev_err(&usbvision->dev->dev,
 				"%s: usb_submit_urb(%d) failed: error %d\n",
-- 
2.1.0

