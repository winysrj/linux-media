Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37088 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbbLVK10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 05:27:26 -0500
Date: Tue, 22 Dec 2015 10:27:21 +0000
From: Okash Khawaja <okash.khawaja@gmail.com>
To: mchehab@osg.samsung.com, javier@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] next: media: cx231xx: add #ifdef to fix compile error
Message-ID: <20151222102721.GA1892@bytefire-computer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compiling linux-next gave this warning:

drivers/media/usb/cx231xx/cx231xx-cards.c: In function
‘cx231xx_usb_probe’:
drivers/media/usb/cx231xx/cx231xx-cards.c:1754:36: error: ‘struct
cx231xx’ has no member named ‘media_dev’
  retval = media_device_register(dev->media_dev);

Looking at the refactoring in past two commits, following seems like a
decent fix, i.e. to surround dev->media_dev by #ifdef
CONFIG_MEDIA_CONTROLLER.

Signed-off-by: Okash Khawaja <okash.khawaja@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 35692d1..220a5db 100644
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
2.5.2

