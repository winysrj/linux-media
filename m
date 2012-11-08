Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2KHTMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:47 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1190326eaa.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:46 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 16/21] em28xx: rename usb debugging module parameter and macro
Date: Thu,  8 Nov 2012 20:11:48 +0200
Message-Id: <1352398313-3698-17-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename module parameter isoc_debug to usb_debug and macro
em28xx_isocdbg to em28xx_usb dbg to reflect that they are
used for isoc and bulk USB transfers.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   58 +++++++++++++++----------------
 1 Datei geändert, 28 Zeilen hinzugefügt(+), 30 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index d6de1cc..f435206 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -58,13 +58,13 @@
 		printk(KERN_INFO "%s %s :"fmt, \
 			 dev->name, __func__ , ##arg); } while (0)
 
-static unsigned int isoc_debug;
-module_param(isoc_debug, int, 0644);
-MODULE_PARM_DESC(isoc_debug, "enable debug messages [isoc transfers]");
+static unsigned int usb_debug;
+module_param(usb_debug, int, 0644);
+MODULE_PARM_DESC(usb_debug, "enable debug messages [isoc transfers]");
 
-#define em28xx_isocdbg(fmt, arg...) \
+#define em28xx_usbdbg(fmt, arg...) \
 do {\
-	if (isoc_debug) { \
+	if (usb_debug) { \
 		printk(KERN_INFO "%s %s :"fmt, \
 			 dev->name, __func__ , ##arg); \
 	} \
@@ -161,7 +161,7 @@ static inline void buffer_filled(struct em28xx *dev,
 				  struct em28xx_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
+	em28xx_usbdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
 	do_gettimeofday(&buf->vb.ts);
@@ -177,7 +177,7 @@ static inline void vbi_buffer_filled(struct em28xx *dev,
 				     struct em28xx_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
+	em28xx_usbdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
@@ -226,9 +226,9 @@ static void em28xx_copy_video(struct em28xx *dev,
 	lencopy = lencopy > remain ? remain : lencopy;
 
 	if ((char *)startwrite + lencopy > (char *)outp + buf->vb.size) {
-		em28xx_isocdbg("Overflow of %zi bytes past buffer end (1)\n",
-			       ((char *)startwrite + lencopy) -
-			       ((char *)outp + buf->vb.size));
+		em28xx_usbdbg("Overflow of %zi bytes past buffer end (1)\n",
+			      ((char *)startwrite + lencopy) -
+			      ((char *)outp + buf->vb.size));
 		remain = (char *)outp + buf->vb.size - (char *)startwrite;
 		lencopy = remain;
 	}
@@ -251,7 +251,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 
 		if ((char *)startwrite + lencopy > (char *)outp +
 		    buf->vb.size) {
-			em28xx_isocdbg("Overflow of %zi bytes past buffer end"
+			em28xx_usbdbg("Overflow of %zi bytes past buffer end"
 				       "(2)\n",
 				       ((char *)startwrite + lencopy) -
 				       ((char *)outp + buf->vb.size));
@@ -280,24 +280,24 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 	int bytesperline;
 
 	if (dev == NULL) {
-		em28xx_isocdbg("dev is null\n");
+		em28xx_usbdbg("dev is null\n");
 		return;
 	}
 	bytesperline = dev->vbi_width;
 
 	if (dma_q == NULL) {
-		em28xx_isocdbg("dma_q is null\n");
+		em28xx_usbdbg("dma_q is null\n");
 		return;
 	}
 	if (buf == NULL) {
 		return;
 	}
 	if (p == NULL) {
-		em28xx_isocdbg("p is null\n");
+		em28xx_usbdbg("p is null\n");
 		return;
 	}
 	if (outp == NULL) {
-		em28xx_isocdbg("outp is null\n");
+		em28xx_usbdbg("outp is null\n");
 		return;
 	}
 
@@ -351,9 +351,9 @@ static inline void print_err_status(struct em28xx *dev,
 		break;
 	}
 	if (packet < 0) {
-		em28xx_isocdbg("URB status %d [%s].\n",	status, errmsg);
+		em28xx_usbdbg("URB status %d [%s].\n",	status, errmsg);
 	} else {
-		em28xx_isocdbg("URB packet %d, status %d [%s].\n",
+		em28xx_usbdbg("URB packet %d, status %d [%s].\n",
 			       packet, status, errmsg);
 	}
 }
@@ -368,7 +368,7 @@ static inline void get_next_buf(struct em28xx_dmaqueue *dma_q,
 	char *outp;
 
 	if (list_empty(&dma_q->active)) {
-		em28xx_isocdbg("No active queue to serve\n");
+		em28xx_usbdbg("No active queue to serve\n");
 		dev->usb_ctl.vid_buf = NULL;
 		*buf = NULL;
 		return;
@@ -396,7 +396,7 @@ static inline void vbi_get_next_buf(struct em28xx_dmaqueue *dma_q,
 	char *outp;
 
 	if (list_empty(&dma_q->active)) {
-		em28xx_isocdbg("No active queue to serve\n");
+		em28xx_usbdbg("No active queue to serve\n");
 		dev->usb_ctl.vbi_buf = NULL;
 		*buf = NULL;
 		return;
@@ -457,8 +457,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 
 			actual_length = urb->iso_frame_desc[i].actual_length;
 			if (actual_length > dev->max_pkt_size) {
-				em28xx_isocdbg("packet bigger than "
-					       "packet size");
+				em28xx_usbdbg("packet bigger than packet size");
 				continue;
 			}
 
@@ -476,12 +475,12 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 		   logic simpler. Impacts of those changes should be evaluated
 		 */
 		if (p[0] == 0x33 && p[1] == 0x95 && p[2] == 0x00) {
-			em28xx_isocdbg("VBI HEADER!!!\n");
+			em28xx_usbdbg("VBI HEADER!!!\n");
 			/* FIXME: Should add vbi copy */
 			continue;
 		}
 		if (p[0] == 0x22 && p[1] == 0x5a) {
-			em28xx_isocdbg("Video frame %d, length=%i, %s\n", p[2],
+			em28xx_usbdbg("Video frame %d, length=%i, %s\n", p[2],
 				       len, (p[2] & 1) ? "odd" : "even");
 
 			if (dev->progressive || !(p[2] & 1)) {
@@ -507,7 +506,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 			if (p[0] != 0x88 && p[0] != 0x22) {
 				/* NOTE: no intermediate data packet header
 				 * 88 88 88 88 when using bulk transfers */
-				em28xx_isocdbg("frame is not complete\n");
+				em28xx_usbdbg("frame is not complete\n");
 				len = actual_length;
 			} else {
 				len = actual_length - 4;
@@ -569,8 +568,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 
 			actual_length = urb->iso_frame_desc[i].actual_length;
 			if (actual_length > dev->max_pkt_size) {
-				em28xx_isocdbg("packet bigger than "
-					       "packet size");
+				em28xx_usbdbg("packet bigger than packet size");
 				continue;
 			}
 
@@ -590,7 +588,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 		if (p[0] == 0x33 && p[1] == 0x95) {
 			dev->capture_type = 0;
 			dev->vbi_read = 0;
-			em28xx_isocdbg("VBI START HEADER!!!\n");
+			em28xx_usbdbg("VBI START HEADER!!!\n");
 			dev->cur_field = p[2];
 			p += 4;
 			len = actual_length - 4;
@@ -615,7 +613,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 			if (dev->vbi_read >= vbi_size) {
 				/* We've already read all the VBI data, so
 				   treat the rest as video */
-				em28xx_isocdbg("dev->vbi_read > vbi_size\n");
+				em28xx_usbdbg("dev->vbi_read > vbi_size\n");
 			} else if ((dev->vbi_read + len) < vbi_size) {
 				/* This entire frame is VBI data */
 				if (dev->vbi_read == 0 &&
@@ -687,7 +685,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 				len -= 4;
 			}
 			if (len >= 4 && p[0] == 0x22 && p[1] == 0x5a) {
-				em28xx_isocdbg("Video frame %d, len=%i, %s\n",
+				em28xx_usbdbg("Video frame %d, len=%i, %s\n",
 					       p[2], len, (p[2] & 1) ?
 					       "odd" : "even");
 				p += 4;
@@ -837,7 +835,7 @@ static void buffer_release(struct videobuf_queue *vq,
 	struct em28xx_fh       *fh   = vq->priv_data;
 	struct em28xx          *dev  = (struct em28xx *)fh->dev;
 
-	em28xx_isocdbg("em28xx: called buffer_release\n");
+	em28xx_usbdbg("em28xx: called buffer_release\n");
 
 	free_buffer(vq, buf);
 }
-- 
1.7.10.4

