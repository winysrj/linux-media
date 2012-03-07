Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41257 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2CGWGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 17:06:33 -0500
Received: by wgbdr13 with SMTP id dr13so5982967wgb.1
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 14:06:32 -0800 (PST)
Message-ID: <1331157983.11482.32.camel@tvbox>
Subject: [PATCH 1/4] lmedm04 v1.98 Remove clear halt
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 07 Mar 2012 22:06:23 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These were in the original lme2510 device driver.

Removing them significantly speeds up the driver.

All tuners tested.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb/lmedm04.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 3e6ed28..a251583 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -177,12 +177,8 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 	/* the read/write capped at 64 */
 	memcpy(buff, wbuf, (wlen < 64) ? wlen : 64);
 
-	ret |= usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, 0x01));
-
 	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x01);
 
-	ret |= usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x01));
-
 	ret |= lme2510_bulk_read(d->udev, buff, (rlen < 64) ?
 			rlen : 64 , 0x01);
 
@@ -1290,5 +1286,5 @@ module_usb_driver(lme2510_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.97");
+MODULE_VERSION("1.98");
 MODULE_LICENSE("GPL");
-- 
1.7.9


