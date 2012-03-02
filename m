Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62331 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2CBWTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 17:19:39 -0500
Received: by wibhm2 with SMTP id hm2so899326wib.19
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2012 14:19:38 -0800 (PST)
Message-ID: <1330726770.20647.13.camel@tvbox>
Subject: [PATCH] lmedm04 ver 1.97 Remove delays required for STV0288
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Fri, 02 Mar 2012 22:19:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove delays added for STV0288 frontend.

This patch significantly speeds up channel change and scan.

It requires patch 10161-STV0288 increase delay between carrier search.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index a5ad561..948e325 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -181,8 +181,6 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 
 	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x01);
 
-	msleep(10);
-
 	ret |= usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x01));
 
 	ret |= lme2510_bulk_read(d->udev, buff, (rlen < 64) ?
@@ -455,8 +453,6 @@ static int lme2510_msg(struct dvb_usb_device *d,
 						st->i2c_talk_onoff = 0;
 					}
 				}
-				if ((wbuf[3] != 0x6) & (wbuf[3] != 0x5))
-					msleep(5);
 			}
 			break;
 		case TUNER_S0194:
@@ -1294,5 +1290,5 @@ module_usb_driver(lme2510_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.96");
+MODULE_VERSION("1.97");
 MODULE_LICENSE("GPL");
-- 
1.7.9




