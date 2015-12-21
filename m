Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59805 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbbLUPHb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 10:07:31 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] cx231xx: fix compilation when !CONFIG_MEDIA_CONTROLLER
Date: Mon, 21 Dec 2015 12:07:12 -0300
Message-Id: <1450710432-25715-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 1590ad7b5271 ("[media] media-device: split media initialization
and registration") split the media dev initialization and registration
but introduced a build error since media_device_register() was called
unconditionally even when the MEDIA_CONTROLLER config was not enabled:

   drivers/media/usb/cx231xx/cx231xx-cards.c: In function 'cx231xx_usb_probe':
   drivers/media/usb/cx231xx/cx231xx-cards.c:1741:36: error: 'struct cx231xx' has no member named 'media_dev'
     retval = media_device_register(dev->media_dev);

Fixes: 1590ad7b5271 ("[media] media-device: split media initialization and registration")
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/usb/cx231xx/cx231xx-cards.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 35692d19b652..220a5dba8a2d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1751,7 +1751,9 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	if (retval < 0)
 		goto done;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 	retval = media_device_register(dev->media_dev);
+#endif
 
 done:
 	if (retval < 0)
-- 
2.4.3

