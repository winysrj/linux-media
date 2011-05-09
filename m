Return-path: <mchehab@gaivota>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:47994 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754546Ab1EITyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:16 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 14/16] tm6000: add pts logging
Date: Mon,  9 May 2011 21:54:02 +0200
Message-Id: <1304970844-20955-14-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

add pts logging


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 2d83204..4802396 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -355,10 +355,14 @@ static int copy_streams(u8 *data, unsigned long len,
 			case TM6000_URB_MSG_VBI:
 				/* Need some code to copy vbi buffer */
 				break;
-			case TM6000_URB_MSG_PTS:
+			case TM6000_URB_MSG_PTS: {
 				/* Need some code to copy pts */
+				u32 pts;
+				pts = *(u32 *)ptr;
+				printk(KERN_INFO "%s: field %d, PTS %x", dev->name, field, pts);
 				break;
 			}
+			}
 		}
 		if (ptr + pktsize > endp) {
 			/* End of URB packet, but cmd processing is not
-- 
1.7.4.2

