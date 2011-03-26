Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51655 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1CZX3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 19:29:36 -0400
Received: by wya21 with SMTP id 21so1976599wya.19
        for <linux-media@vger.kernel.org>; Sat, 26 Mar 2011 16:29:35 -0700 (PDT)
Subject: [PATCH] v1.82 DM04/QQBOX dvb-usb-lmedm04 diseqc timing changes
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 23:29:28 +0000
Message-ID: <1301182168.7060.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Frontend timing change for diseqc functions.

Timing on the STV0288 and STV0299 frontends cause initial disegc errors
on some applications.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index ec0f5a7..91f239c 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -179,8 +179,6 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 
 	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x01);
 
-	msleep(10);
-
 	ret |= usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x01));
 
 	ret |= lme2510_bulk_read(d->udev, buff, (rlen > 512) ?
@@ -364,6 +362,7 @@ static int lme2510_msg(struct dvb_usb_device *d,
 					msleep(80);
 				}
 			}
+			msleep(20);
 			break;
 		case TUNER_S7395:
 			if (wbuf[2] == 0xd0) {
@@ -376,7 +375,7 @@ static int lme2510_msg(struct dvb_usb_device *d,
 					}
 				}
 				if ((wbuf[3] != 0x6) & (wbuf[3] != 0x5))
-					msleep(5);
+					msleep(20);
 			}
 			break;
 		case TUNER_S0194:
@@ -389,6 +388,8 @@ static int lme2510_msg(struct dvb_usb_device *d,
 						st->i2c_talk_onoff = 0;
 					}
 				}
+				if ((wbuf[3] != 0x9) & (wbuf[3] != 0x0a))
+					msleep(20);
 			}
 			break;
 		default:
@@ -1222,5 +1223,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.81");
+MODULE_VERSION("1.82");
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

