Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:58060 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758734Ab0E0USZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 16:18:25 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: bugfix outp in function copy_multiplexed
Date: Thu, 27 May 2010 22:16:29 +0200
Message-Id: <1274991389-6439-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

bugfix outp in function copy_multiplexed


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 31c574f..96cbbf7 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -358,7 +358,7 @@ static int copy_multiplexed(u8 *ptr, unsigned long len,
 	while (len>0) {
 		cpysize=min(len,buf->vb.size-pos);
 		//printk("Copying %d bytes (max=%lu) from %p to %p[%u]\n",cpysize,(*buf)->vb.size,ptr,out_p,pos);
-		memcpy(&out_p[pos], ptr, cpysize);
+		memcpy(&outp[pos], ptr, cpysize);
 		pos+=cpysize;
 		ptr+=cpysize;
 		len-=cpysize;
@@ -370,8 +370,8 @@ static int copy_multiplexed(u8 *ptr, unsigned long len,
 			get_next_buf (dma_q, &buf);
 			if (!buf)
 				break;
-			out_p = videobuf_to_vmalloc(&(buf->vb));
-			if (!out_p)
+			outp = videobuf_to_vmalloc(&(buf->vb));
+			if (!outp)
 				return rc;
 			pos = 0;
 		}
-- 
1.7.0.3

