Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:40592 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab0ESRAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 13:00:38 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 3/4] tm6000: bugfix video image
Date: Wed, 19 May 2010 18:58:26 +0200
Message-Id: <1274288307-2858-5-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1274288307-2858-3-git-send-email-stefan.ringel@arcor.de>
References: <1274288307-2858-3-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

bugfix image interference, what sometimes lines in a left shift has.



Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |   82 +++++++++++++++++----------------
 1 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index f1acd79..4d92a12 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -339,14 +339,23 @@ static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
 	return rc;
 }
 
-static int copy_streams(u8 *data, u8 *out_p, unsigned long len,
-			struct urb *urb, struct tm6000_buffer **buf)
+static int copy_streams(u8 *data, unsigned long len,
+			struct urb *urb)
 {
 	struct tm6000_dmaqueue  *dma_q = urb->context;
 	struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
 	u8 *ptr=data, *endp=data+len;
 	unsigned long header=0;
 	int rc=0;
+	struct tm6000_buffer *buf;
+	char *outp = NULL;
+
+	get_next_buf(dma_q, &buf);
+	if (buf)
+		outp = videobuf_to_vmalloc(&buf->vb);
+
+	if (!outp)
+		return 0;
 
 	for (ptr=data; ptr<endp;) {
 		if (!dev->isoc_ctl.cmd) {
@@ -394,7 +403,7 @@ static int copy_streams(u8 *data, u8 *out_p, unsigned long len,
 		}
 HEADER:
 		/* Copy or continue last copy */
-		rc=copy_packet(urb,header,&ptr,endp,out_p,buf);
+		rc=copy_packet(urb,header,&ptr,endp,outp,&buf);
 		if (rc<0) {
 			buf=NULL;
 			printk(KERN_ERR "tm6000: buffer underrun at %ld\n",
@@ -410,30 +419,39 @@ HEADER:
 /*
  * Identify the tm5600/6000 buffer header type and properly handles
  */
-static int copy_multiplexed(u8 *ptr, u8 *out_p, unsigned long len,
-			struct urb *urb, struct tm6000_buffer **buf)
+static int copy_multiplexed(u8 *ptr, unsigned long len,
+			struct urb *urb)
 {
 	struct tm6000_dmaqueue  *dma_q = urb->context;
 	struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
 	unsigned int pos=dev->isoc_ctl.pos,cpysize;
 	int rc=1;
+	struct tm6000_buffer *buf;
+	char *outp = NULL;
+
+	get_next_buf(dma_q, &buf);
+	if (buf)
+		outp = videobuf_to_vmalloc(&buf->vb);
+
+	if (!outp)
+		return 0;
 
 	while (len>0) {
-		cpysize=min(len,(*buf)->vb.size-pos);
-//printk("Copying %d bytes (max=%lu) from %p to %p[%u]\n",cpysize,(*buf)->vb.size,ptr,out_p,pos);
+		cpysize=min(len,buf->vb.size-pos);
+		//printk("Copying %d bytes (max=%lu) from %p to %p[%u]\n",cpysize,(*buf)->vb.size,ptr,out_p,pos);
 		memcpy(&out_p[pos], ptr, cpysize);
 		pos+=cpysize;
 		ptr+=cpysize;
 		len-=cpysize;
-		if (pos >= (*buf)->vb.size) {
+		if (pos >= buf->vb.size) {
 			pos=0;
 			/* Announces that a new buffer were filled */
-			buffer_filled (dev, dma_q, *buf);
+			buffer_filled (dev, dma_q, buf);
 			dprintk(dev, V4L2_DEBUG_ISOC, "new buffer filled\n");
-			get_next_buf (dma_q, buf);
-			if (!*buf)
+			get_next_buf (dma_q, &buf);
+			if (!buf)
 				break;
-			out_p = videobuf_to_vmalloc(&((*buf)->vb));
+			out_p = videobuf_to_vmalloc(&(buf->vb));
 			if (!out_p)
 				return rc;
 			pos = 0;
@@ -493,52 +511,36 @@ static inline int tm6000_isoc_copy(struct urb *urb)
 	struct tm6000_dmaqueue  *dma_q = urb->context;
 	struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
 	struct tm6000_buffer *buf;
-	int i, len=0, rc=1;
-	int size;
-	char *outp = NULL, *p;
-	unsigned long copied;
+	int i, len=0, rc=1, status;
+	char *p;
 
-	get_next_buf(dma_q, &buf);
-	if (buf)
-		outp = videobuf_to_vmalloc(&buf->vb);
-
-	if (!outp)
-		return 0;
-
-	size = buf->vb.size;
-
-	copied=0;
-
-	if (urb->status<0) {
-		print_err_status (dev,-1,urb->status);
+	if (urb->status < 0) {
+		print_err_status (dev, -1, urb->status);
 		return 0;
 	}
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		int status = urb->iso_frame_desc[i].status;
+		status = urb->iso_frame_desc[i].status;
 
 		if (status<0) {
 			print_err_status (dev,i,status);
 			continue;
 		}
 
-		len=urb->iso_frame_desc[i].actual_length;
+		len = urb->iso_frame_desc[i].actual_length;
 
-//		if (len>=TM6000_URB_MSG_LEN) {
-			p=urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		if (len > 0) {
+			p = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 			if (!urb->iso_frame_desc[i].status) {
-				if ((buf->fmt->fourcc)==V4L2_PIX_FMT_TM6000) {
-					rc=copy_multiplexed(p, outp, len, urb, &buf);
+				if ((dev->fourcc)==V4L2_PIX_FMT_TM6000) {
+					rc=copy_multiplexed(p, len, urb);
 					if (rc<=0)
 						return rc;
 				} else {
-					copy_streams(p, outp, len, urb, &buf);
+					copy_streams(p, len, urb);
 				}
 			}
-			copied += len;
-			if (copied >= size || !buf)
-				break;
-//		}
+		}
 	}
 	return rc;
 }
-- 
1.7.0.3

