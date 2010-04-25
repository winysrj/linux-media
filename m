Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:57578 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0DYG5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 02:57:12 -0400
Received: by gxk9 with SMTP id 9so43452gxk.8
        for <linux-media@vger.kernel.org>; Sat, 24 Apr 2010 23:57:11 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 25 Apr 2010 14:57:11 +0800
Message-ID: <h2n6e8e83e21004242357pb00773f2qbbd4b6ca8272a1e2@mail.gmail.com>
Subject: [PATCH 2/2] tm6000 : Fix filling up of buffer for video frame
From: Bee Hock Goh <beehock@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid(until there is a better fix) cleaning up of buffer as it will
cause partital green screen when there are frame dropped.

Fix video line couting corruption when cmd is not a video packet.

Signed-off-by: Bee Hock Goh <beehock@gmail.com>

diff --git a/drivers/staging/tm6000/tm6000-video.c
b/drivers/staging/tm6000/tm6000-video.c
index c53de47..50b12ac 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -133,7 +133,7 @@ static inline void get_next_buf(struct
tm6000_dmaqueue *dma_q,
 			       struct tm6000_buffer   **buf)
 {
 	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
-	char *outp;
+//	char *outp;

 	if (list_empty(&dma_q->active)) {
 		dprintk(dev, V4L2_DEBUG_QUEUE, "No active queue to serve\n");
@@ -148,8 +148,8 @@ static inline void get_next_buf(struct
tm6000_dmaqueue *dma_q,
 		return;

 	/* Cleans up buffer - Usefull for testing for frame/URB loss */
-	outp = videobuf_to_vmalloc(&(*buf)->vb);
-	memset(outp, 0, (*buf)->vb.size);
+//	outp = videobuf_to_vmalloc(&(*buf)->vb);
+//	memset(outp, 0, (*buf)->vb.size);

 	return;
 }
@@ -282,7 +282,8 @@ static int copy_packet(struct urb *urb, u32
header, u8 **ptr, u8 *endp,
 			start_line=line;
 			last_field=field;
 		}
-		last_line=line;
+		if (cmd == TM6000_URB_MSG_VIDEO)
+			last_line=line;

 		pktsize = TM6000_URB_MSG_LEN;
 	} else {
