Return-path: <mchehab@pedra>
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:57518 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493Ab1EUGFm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 02:05:42 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: d.belimov@gmail.com, mchehab@redhat.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH v2] tm6000: fix uninitialized field, change prink to dprintk
Date: Sat, 21 May 2011 08:05:38 +0200
Message-Id: <1305957938-5830-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

fix uninitialized field, change prink to dprintk


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-usb-isoc.h |    2 +-
 drivers/staging/tm6000/tm6000-video.c    |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
index a9e61d9..084c2a8 100644
--- a/drivers/staging/tm6000/tm6000-usb-isoc.h
+++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
@@ -39,7 +39,7 @@ struct usb_isoc_ctl {
 	int				pos, size, pktsize;
 
 		/* Last field: ODD or EVEN? */
-	int				vfield;
+	int				vfield, field;
 
 		/* Stores incomplete commands */
 	u32				tmp_buf;
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 4802396..4264064 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -334,6 +334,7 @@ static int copy_streams(u8 *data, unsigned long len,
 			size = dev->isoc_ctl.size;
 			pos = dev->isoc_ctl.pos;
 			pktsize = dev->isoc_ctl.pktsize;
+			field = dev->isoc_ctl.field;
 		}
 		cpysize = (endp - ptr > size) ? size : endp - ptr;
 		if (cpysize) {
@@ -359,7 +360,8 @@ static int copy_streams(u8 *data, unsigned long len,
 				/* Need some code to copy pts */
 				u32 pts;
 				pts = *(u32 *)ptr;
-				printk(KERN_INFO "%s: field %d, PTS %x", dev->name, field, pts);
+				dprintk(dev, V4L2_DEBUG_ISOC, "field %d, PTS %x",
+					field, pts);
 				break;
 			}
 			}
@@ -371,6 +373,7 @@ static int copy_streams(u8 *data, unsigned long len,
 			dev->isoc_ctl.pos = pos + cpysize;
 			dev->isoc_ctl.size = size - cpysize;
 			dev->isoc_ctl.cmd = cmd;
+			dev->isoc_ctl.field = field;
 			dev->isoc_ctl.pktsize = pktsize - (endp - ptr);
 			ptr += endp - ptr;
 		} else {
-- 
1.7.4.2

