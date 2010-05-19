Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:47822 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233Ab0ESRAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 13:00:36 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 2/4] tm6000: add vbi message
Date: Wed, 19 May 2010 18:58:25 +0200
Message-Id: <1274288307-2858-4-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1274288307-2858-3-git-send-email-stefan.ringel@arcor.de>
References: <1274288307-2858-3-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

add case line for vbi message

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index e5f8b57..f1acd79 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -311,10 +311,12 @@ static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
 		case TM6000_URB_MSG_PTS:
 			break;
 		case TM6000_URB_MSG_AUDIO:
-/* Need some code to process audio */
-printk ("%ld: cmd=%s, size=%d\n", jiffies,
+			/* Need some code to process audio */
+			printk ("%ld: cmd=%s, size=%d\n", jiffies,
 				tm6000_msg_type[cmd],size);
 			break;
+		case TM6000_URB_MSG_VBI:
+			break;
 		default:
 			dprintk (dev, V4L2_DEBUG_ISOC, "cmd=%s, size=%d\n",
 						tm6000_msg_type[cmd],size);
-- 
1.7.0.3

