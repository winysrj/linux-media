Return-path: <mchehab@pedra>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:50588 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520Ab1EUFzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 01:55:54 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: d.belimov@gmail.com, mchehab@redhat.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: fix uninitialized field, change prink to dprintk
Date: Sat, 21 May 2011 07:55:49 +0200
Message-Id: <1305957349-5388-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

fix uninitialized field, change prink to dprintk


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 4802396..3baee84 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -228,7 +228,7 @@ static int copy_streams(u8 *data, unsigned long len,
 	u8 *ptr = data, *endp = data+len, c;
 	unsigned long header = 0;
 	int rc = 0;
-	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
+	unsigned int cmd, cpysize, pktsize, size, field = 0, block, line, pos = 0;
 	struct tm6000_buffer *vbuf = NULL;
 	char *voutp = NULL;
 	unsigned int linewidth;
@@ -359,7 +359,8 @@ static int copy_streams(u8 *data, unsigned long len,
 				/* Need some code to copy pts */
 				u32 pts;
 				pts = *(u32 *)ptr;
-				printk(KERN_INFO "%s: field %d, PTS %x", dev->name, field, pts);
+				dprintk(dev, V4L2_DEBUG_ISOC, "field %d, PTS %x",
+					field, pts);
 				break;
 			}
 			}
-- 
1.7.4.2

