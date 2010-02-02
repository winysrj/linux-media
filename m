Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:43679 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab0BBOXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 09:23:35 -0500
Message-ID: <4B6836DA.8030907@gmail.com>
Date: Tue, 02 Feb 2010 15:29:46 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb: return -ENOMEM if kzalloc failed in dvb_usb_device_init()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If in a cold state and the download succeeded ret is zero, but we
should return -ENOMEM.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or shouldn't we?

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
index e331db8..5d91f70 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
@@ -243,7 +243,7 @@ int dvb_usb_device_init(struct usb_interface *intf,
 		d = kzalloc(sizeof(struct dvb_usb_device),GFP_KERNEL);
 	if (d == NULL) {
 		err("no memory for 'struct dvb_usb_device'");
-		return ret;
+		return -ENOMEM;
 	}
 
 	d->udev = udev;
