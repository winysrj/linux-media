Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.211.194]:35153 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0DVFOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 01:14:40 -0400
Received: by ywh32 with SMTP id 32so4601357ywh.33
        for <linux-media@vger.kernel.org>; Wed, 21 Apr 2010 22:14:39 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 Apr 2010 13:14:39 +0800
Message-ID: <u2u6e8e83e21004212214i8c186922he28162cbed66d292@mail.gmail.com>
Subject: tm6000: Patch that will fixed analog video (tested on tm5600)
From: Bee Hock Goh <beehock@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

Anyone who have a tm6000 compatible analog device, please do try out this patch.

Its working for me on a tm5600 using mplayer. It can be compile
against the latest hg tree.


diff -r a539e5b68945 linux/drivers/staging/tm6000/tm6000-video.c
--- a/linux/drivers/staging/tm6000/tm6000-video.c	Sat Mar 27 23:09:47 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-video.c	Thu Apr 22 13:08:19 2010 +0800
@@ -157,7 +157,7 @@

 	/* Cleans up buffer - Usefull for testing for frame/URB loss */
 	outp = videobuf_to_vmalloc(&(*buf)->vb);
-	memset(outp, 0, (*buf)->vb.size);
+//	memset(outp, 0, (*buf)->vb.size);
 #endif

 	return;
@@ -291,7 +291,8 @@
 			start_line=line;
 			last_field=field;
 		}
-		last_line=line;
+		if (cmd == TM6000_URB_MSG_VIDEO)
+			last_line=line;

 		pktsize = TM6000_URB_MSG_LEN;
 	} else {
@@ -502,7 +503,7 @@
 	unsigned long copied;

 	get_next_buf(dma_q, &buf);
-	if (!buf)
+	if (buf)
 		outp = videobuf_to_vmalloc(&buf->vb);

 	if (!outp)
