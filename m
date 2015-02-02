Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964952AbbBBM41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 07:56:27 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] cx231xx: don't use dev it not allocated
Date: Mon,  2 Feb 2015 10:56:09 -0200
Message-Id: <8e827a2b8a8c1f4178360c92e5f662a65bbef97d.1422881740.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 5eeb3014827f added a fixup at the error check
code. However, it introduced a new error:

	drivers/media/usb/cx231xx/cx231xx-cards.c:1586 cx231xx_usb_probe() error: we previously assumed 'dev' could be null (see line 1430)

This happens when dev = kmalloc() fails. So, instead of relying
on it to succeed, just change the parameter of clear_bit() from
'dev->devno' to 'nr'.

Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 33c2fa2e7596..da03733690bd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1583,7 +1583,7 @@ err_v4l2:
 	usb_set_intfdata(interface, NULL);
 err_if:
 	usb_put_dev(udev);
-	clear_bit(dev->devno, &cx231xx_devused);
+	clear_bit(nr, &cx231xx_devused);
 	return retval;
 }
 
-- 
2.1.0

