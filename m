Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50273 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751871AbdINKhf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 06:37:35 -0400
Subject: [PATCH 7/8] [media] ttusb_dec: Add spaces for better code readability
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Message-ID: <69c23391-a033-97a0-2ee6-27581f48d539@users.sourceforge.net>
Date: Thu, 14 Sep 2017 12:37:15 +0200
MIME-Version: 1.0
In-Reply-To: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 13 Sep 2017 22:12:07 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: spaces required around that '=' (ctx:VxV)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 79 +++++++++++++++++----------------
 1 file changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index e9fe4c6142a5..58256d518fa6 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -209,47 +209,49 @@ static void dvb_filter_pes2ts_init(struct dvb_filter_pes2ts *p2ts,
 				   unsigned short pid,
 				   dvb_filter_pes2ts_cb_t *cb, void *priv)
 {
-	unsigned char *buf=p2ts->buf;
-
-	buf[0]=0x47;
-	buf[1]=(pid>>8);
-	buf[2]=pid&0xff;
-	p2ts->cc=0;
-	p2ts->cb=cb;
-	p2ts->priv=priv;
+	unsigned char *buf = p2ts->buf;
+
+	buf[0] = 0x47;
+	buf[1] = pid >> 8;
+	buf[2] = pid & 0xff;
+	p2ts->cc = 0;
+	p2ts->cb = cb;
+	p2ts->priv = priv;
 }
 
 static int dvb_filter_pes2ts(struct dvb_filter_pes2ts *p2ts,
 			     unsigned char *pes, int len, int payload_start)
 {
-	unsigned char *buf=p2ts->buf;
-	int ret=0, rest;
+	unsigned char *buf = p2ts->buf;
+	int ret = 0, rest;
 
 	//len=6+((pes[4]<<8)|pes[5]);
 
 	if (payload_start)
-		buf[1]|=0x40;
+		buf[1] |= 0x40;
 	else
-		buf[1]&=~0x40;
-	while (len>=184) {
-		buf[3]=0x10|((p2ts->cc++)&0x0f);
-		memcpy(buf+4, pes, 184);
-		if ((ret=p2ts->cb(p2ts->priv, buf)))
+		buf[1] &= ~0x40;
+	while (len >= 184) {
+		buf[3] = 0x10 | ((p2ts->cc++) & 0x0f);
+		memcpy(buf + 4, pes, 184);
+		ret = p2ts->cb(p2ts->priv, buf);
+		if (ret)
 			return ret;
-		len-=184; pes+=184;
-		buf[1]&=~0x40;
+		len -= 184;
+		pes += 184;
+		buf[1] &= ~0x40;
 	}
 	if (!len)
 		return 0;
-	buf[3]=0x30|((p2ts->cc++)&0x0f);
-	rest=183-len;
+	buf[3] = 0x30 | ((p2ts->cc++) & 0x0f);
+	rest = 183 - len;
 	if (rest) {
-		buf[5]=0x00;
-		if (rest-1)
-			memset(buf+6, 0xff, rest-1);
+		buf[5] = 0x00;
+		if (rest - 1)
+			memset(buf + 6, 0xff, rest - 1);
 	}
-	buf[4]=rest;
-	memcpy(buf+5+rest, pes, len);
+	buf[4] = rest;
+	memcpy(buf + 5 + rest, pes, len);
 	return p2ts->cb(p2ts->priv, buf);
 }
 
@@ -262,7 +264,7 @@ static void ttusb_dec_handle_irq( struct urb *urb)
 	char *buffer = dec->irq_buffer;
 	int retval;
 
-	switch(urb->status) {
+	switch (urb->status) {
 		case 0: /*success*/
 			break;
 		case -ECONNRESET:
@@ -275,7 +277,7 @@ static void ttusb_dec_handle_irq( struct urb *urb)
 			return;
 		default:
 			dprintk("%s:nonzero status received: %d\n",
-					__func__,urb->status);
+				__func__, urb->status);
 			goto exit;
 	}
 
@@ -1263,10 +1265,9 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
 
 	dec->rc_input_dev = input_dev;
 	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
-		printk("%s: usb_submit_urb failed\n",__func__);
+		printk("%s: usb_submit_urb failed\n", __func__);
 	/* enable irq pipe */
-	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
-
+	ttusb_dec_send_command(dec, 0xb0, sizeof(b), b, NULL, NULL);
 	return 0;
 }
 
@@ -1295,18 +1296,20 @@ static int ttusb_dec_init_usb(struct ttusb_dec *dec)
 	dec->out_pipe = usb_sndisocpipe(dec->udev, OUT_PIPE);
 	dec->irq_pipe = usb_rcvintpipe(dec->udev, IRQ_PIPE);
 
-	if(enable_rc) {
+	if (enable_rc) {
 		dec->irq_urb = usb_alloc_urb(0, GFP_KERNEL);
-		if(!dec->irq_urb) {
+		if (!dec->irq_urb)
 			return -ENOMEM;
-		}
-		dec->irq_buffer = usb_alloc_coherent(dec->udev,IRQ_PACKET_SIZE,
-					GFP_KERNEL, &dec->irq_dma_handle);
-		if(!dec->irq_buffer) {
+
+		dec->irq_buffer = usb_alloc_coherent(dec->udev,
+						     IRQ_PACKET_SIZE,
+						     GFP_KERNEL,
+						     &dec->irq_dma_handle);
+		if (!dec->irq_buffer) {
 			usb_free_urb(dec->irq_urb);
 			return -ENOMEM;
 		}
-		usb_fill_int_urb(dec->irq_urb, dec->udev,dec->irq_pipe,
+		usb_fill_int_urb(dec->irq_urb, dec->udev, dec->irq_pipe,
 				 dec->irq_buffer, IRQ_PACKET_SIZE,
 				 ttusb_dec_handle_irq, dec, 1);
 		dec->irq_urb->transfer_dma = dec->irq_dma_handle;
@@ -1739,7 +1742,7 @@ static void ttusb_dec_disconnect(struct usb_interface *intf)
 	if (dec->active) {
 		ttusb_dec_exit_tasklet(dec);
 		ttusb_dec_exit_filters(dec);
-		if(enable_rc)
+		if (enable_rc)
 			ttusb_dec_exit_rc(dec);
 		ttusb_dec_exit_usb(dec);
 		ttusb_dec_exit_dvb(dec);
-- 
2.14.1
