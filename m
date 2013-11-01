Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25708 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3KAKmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 06:42:45 -0400
Date: Fri, 1 Nov 2013 13:34:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Alf =?iso-8859-1?Q?H=F8gemark?= <alf@i100.no>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Johannes Erdfelt <johannes@erdfelt.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Matt Gomboc <gomboc0@gmail.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] [media] cx231xx: use after free on error path in probe
Message-ID: <20131101103440.GP29795@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We dereference "dev" after it has already been freed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index e9d017b..528cce9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1412,8 +1412,8 @@ err_v4l2:
 	usb_set_intfdata(interface, NULL);
 err_if:
 	usb_put_dev(udev);
-	kfree(dev);
 	clear_bit(dev->devno, &cx231xx_devused);
+	kfree(dev);
 	return retval;
 }
 
