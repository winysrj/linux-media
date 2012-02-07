Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41473 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2BGKoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 05:44:37 -0500
Received: by eaah12 with SMTP id h12so2776187eaa.19
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2012 02:44:36 -0800 (PST)
Message-ID: <4F310091.80107@gmail.com>
Date: Tue, 07 Feb 2012 11:44:33 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Furniss <andyqos@ukfsn.org>, linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org>	<4F2ADDCB.4060200@gmail.com>	<CAGoCfiyTHNkr3gNAZUefeZN88-5Vd9SEyGUeFjYO-ddG1WqgzA@mail.gmail.com>	<4F2B16DF.3040400@gmail.com> <CAGoCfiybOLL2Owz2KaPG2AuMueHYKmN18A8tQ7WXVkhTuRobZQ@mail.gmail.com>
In-Reply-To: <CAGoCfiybOLL2Owz2KaPG2AuMueHYKmN18A8tQ7WXVkhTuRobZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
I compared the memory allocation strategies for isoc transfers of the
dvb-usb and em28xx drivers.

There are 3 main differences:

1) dvb-usb drivers allocate the URBs when the device is connected, and
they are never freed/reallocated until the device is disconnected; on
the other hand, the em28xx driver allocates the URBs only when the data
starts streaming and frees them when the stream stops, so the URBs are
freed/reallocated every time the user zaps to a new channel;

2) dvb-usb drivers typically allocate 10 URBs each with a 4k buffer (but
the exact size of the buffer is board dependent); instead, em28xx
allocates 5 URBs with buffers of size 64xMaxPacketSize (which is 940
byte for the PCTV 290e).

This means a typical dvb-usb driver uses about 40k of coherent memory,
while the PCTV 290e takes about 300k! And this 300k of coherent memory
are freed/reallocated each time the user selects a new channel.

I played a bit with the size of the buffers; I found out that both the
PCTV 290e and the Terratec Hybrid XS work perfectly fine with 4k
buffers, just like the usb-dvb drivers. So the PCTV 290e only needs 20k
of coherent memory instead of the 300k currently allocated (this is
equivalent to set EM28XX_DVB_MAX_PACKETS to just 4 instead of 64).

Also, I prepared a proof-of-concept patch to mimic the usb-dvb URB
management; this means the URBs are allocated when the USB device is
probed, and are freed when the device is disconnected (the patch code
checks for changes in the requested buffer size, but this can never
happen in digital mode).

Also the patch adds a module parameter "transfer_buf_size" that allows
to override the default buffer size.

For example:

modprobe em28xx transfer_buf_size=4096

will force the URB buffer size to 4k instead of 64*MaxPacketSize.

I've tested the patch (with 4k buffers) with both my em28xx sticks and
both work perfectly fine on my PC as well as on my MIPS set-top-box.
Analog mode is not tested.

If you think there is any chance to have some of this changes in the
upstream kernel, I can spend some more time to clean up the code.

Regards,
Gianluca

---
 drivers/media/video/em28xx/em28xx-cards.c |   12 ++-
 drivers/media/video/em28xx/em28xx-core.c  |  167
+++++++++++++++++------------
 drivers/media/video/em28xx/em28xx-dvb.c   |    7 +-
 drivers/media/video/em28xx/em28xx-video.c |    5 +-
 drivers/media/video/em28xx/em28xx.h       |   10 ++-
 5 files changed, 122 insertions(+), 79 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c
b/drivers/media/video/em28xx/em28xx-cards.c
index 2aa772a..3fb7744 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3321,6 +3321,14 @@ static int em28xx_usb_probe(struct usb_interface
*interface,
 	 */
 	em28xx_init_extension(dev);

+	if (has_dvb && dev->dvb_max_pkt_size > 0) {
+		/* pre-alloc isoc transfer buffers */
+		em28xx_init_isoc(dev, EM28XX_DVB_MAX_PACKETS,
+			EM28XX_DVB_NUM_BUFS, dev->dvb_max_pkt_size,
+			false, NULL);
+		dev->isoc_ctl.preallocated_transfer_bufs = true;
+	}
+
 	return 0;

 unlock_and_free:
@@ -3372,6 +3380,9 @@ static void em28xx_usb_disconnect(struct
usb_interface *interface)

 	v4l2_device_disconnect(&dev->v4l2_dev);

+	dev->isoc_ctl.preallocated_transfer_bufs = false;
+	em28xx_uninit_isoc(dev, true);
+
 	if (dev->users) {
 		em28xx_warn
 		    ("device %s is open! Deregistration and memory "
@@ -3379,7 +3390,6 @@ static void em28xx_usb_disconnect(struct
usb_interface *interface)
 		     video_device_node_name(dev->vdev));

 		dev->state |= DEV_MISCONFIGURED;
-		em28xx_uninit_isoc(dev);
 		dev->state |= DEV_DISCONNECTED;
 		wake_up_interruptible(&dev->wait_frame);
 		wake_up_interruptible(&dev->wait_stream);
diff --git a/drivers/media/video/em28xx/em28xx-core.c
b/drivers/media/video/em28xx/em28xx-core.c
index 0aacc96..9c84f48 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -59,6 +59,10 @@ static unsigned int disable_vbi;
 module_param(disable_vbi, int, 0644);
 MODULE_PARM_DESC(disable_vbi, "disable vbi support");

+static unsigned int transfer_buf_size;
+module_param(transfer_buf_size, int, 0644);
+MODULE_PARM_DESC(transfer_buf_size, "override USB isoc transfer buffer
size");
+
 /* FIXME */
 #define em28xx_isocdbg(fmt, arg...) do {\
 	if (core_debug) \
@@ -961,14 +965,18 @@ static void em28xx_irq_callback(struct urb *urb)
 /*
  * Stop and Deallocate URBs
  */
-void em28xx_uninit_isoc(struct em28xx *dev)
+void em28xx_uninit_isoc(struct em28xx *dev, bool start)
 {
 	struct urb *urb;
 	int i;

 	em28xx_isocdbg("em28xx: called em28xx_uninit_isoc\n");

+	if (dev->isoc_ctl.preallocated_transfer_bufs)
+		return;
+
 	dev->isoc_ctl.nfields = -1;
+	printk ("free %d isoc transfer buffers\n", dev->isoc_ctl.num_bufs);
 	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
 		urb = dev->isoc_ctl.urb[i];
 		if (urb) {
@@ -996,7 +1004,8 @@ void em28xx_uninit_isoc(struct em28xx *dev)
 	dev->isoc_ctl.transfer_buffer = NULL;
 	dev->isoc_ctl.num_bufs = 0;

-	em28xx_capture_start(dev, 0);
+	if (start)
+		em28xx_capture_start(dev, 0);
 }
 EXPORT_SYMBOL_GPL(em28xx_uninit_isoc);

@@ -1004,7 +1013,7 @@ EXPORT_SYMBOL_GPL(em28xx_uninit_isoc);
  * Allocate URBs and start IRQ
  */
 int em28xx_init_isoc(struct em28xx *dev, int max_packets,
-		     int num_bufs, int max_pkt_size,
+		     int num_bufs, int max_pkt_size, bool start,
 		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb))
 {
 	struct em28xx_dmaqueue *dma_q = &dev->vidq;
@@ -1017,78 +1026,99 @@ int em28xx_init_isoc(struct em28xx *dev, int
max_packets,

 	em28xx_isocdbg("em28xx: called em28xx_prepare_isoc\n");

-	/* De-allocates all pending stuff */
-	em28xx_uninit_isoc(dev);
-
-	dev->isoc_ctl.isoc_copy = isoc_copy;
-	dev->isoc_ctl.num_bufs = num_bufs;
-
-	dev->isoc_ctl.urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
-	if (!dev->isoc_ctl.urb) {
-		em28xx_errdev("cannot alloc memory for usb buffers\n");
-		return -ENOMEM;
-	}
-
-	dev->isoc_ctl.transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
-					      GFP_KERNEL);
-	if (!dev->isoc_ctl.transfer_buffer) {
-		em28xx_errdev("cannot allocate memory for usb transfer\n");
-		kfree(dev->isoc_ctl.urb);
-		return -ENOMEM;
-	}
-
-	dev->isoc_ctl.max_pkt_size = max_pkt_size;
-	dev->isoc_ctl.vid_buf = NULL;
-	dev->isoc_ctl.vbi_buf = NULL;
-
-	sb_size = max_packets * dev->isoc_ctl.max_pkt_size;
-
-	/* allocate urbs and transfer buffers */
-	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
-		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
-		if (!urb) {
-			em28xx_err("cannot alloc isoc_ctl.urb %i\n", i);
-			em28xx_uninit_isoc(dev);
+	if (transfer_buf_size && max_pkt_size > 0) {
+		sb_size = transfer_buf_size;
+		max_packets = sb_size / max_pkt_size;
+		printk ("overridden sb_size:%d and max_packets:%d\n",
+			sb_size, max_packets);
+	} else
+		sb_size = max_packets * max_pkt_size;
+
+	if (dev->isoc_ctl.transfer_buffer == NULL
+	    || dev->isoc_ctl.num_bufs != num_bufs
+	    || dev->isoc_ctl.max_pkt_size != max_pkt_size
+	    || (dev->isoc_ctl.num_bufs > 0
+	     && dev->isoc_ctl.urb[0]->number_of_packets != max_packets)) {
+		/* De-allocates all pending stuff */
+		dev->isoc_ctl.preallocated_transfer_bufs = false;
+		em28xx_uninit_isoc(dev, start);
+
+		dev->isoc_ctl.num_bufs = num_bufs;
+
+		dev->isoc_ctl.urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
+		if (!dev->isoc_ctl.urb) {
+			em28xx_errdev("cannot alloc memory for usb buffers\n");
 			return -ENOMEM;
 		}
-		dev->isoc_ctl.urb[i] = urb;
-
-		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->udev,
-			sb_size, GFP_KERNEL, &urb->transfer_dma);
-		if (!dev->isoc_ctl.transfer_buffer[i]) {
-			em28xx_err("unable to allocate %i bytes for transfer"
-					" buffer %i%s\n",
-					sb_size, i,
-					in_interrupt() ? " while in int" : "");
-			em28xx_uninit_isoc(dev);
+
+		dev->isoc_ctl.transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
+									GFP_KERNEL);
+		if (!dev->isoc_ctl.transfer_buffer) {
+			em28xx_errdev("cannot allocate memory for usb transfer\n");
+			kfree(dev->isoc_ctl.urb);
 			return -ENOMEM;
 		}
-		memset(dev->isoc_ctl.transfer_buffer[i], 0, sb_size);

-		/* FIXME: this is a hack - should be
-			'desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK'
-			should also be using 'desc.bInterval'
-		 */
-		pipe = usb_rcvisocpipe(dev->udev,
-				       dev->mode == EM28XX_ANALOG_MODE ?
-				       EM28XX_EP_ANALOG : EM28XX_EP_DIGITAL);
-
-		usb_fill_int_urb(urb, dev->udev, pipe,
-				 dev->isoc_ctl.transfer_buffer[i], sb_size,
-				 em28xx_irq_callback, dev, 1);
-
-		urb->number_of_packets = max_packets;
-		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-
-		k = 0;
-		for (j = 0; j < max_packets; j++) {
-			urb->iso_frame_desc[j].offset = k;
-			urb->iso_frame_desc[j].length =
-						dev->isoc_ctl.max_pkt_size;
-			k += dev->isoc_ctl.max_pkt_size;
+		dev->isoc_ctl.max_pkt_size = max_pkt_size;
+		dev->isoc_ctl.vid_buf = NULL;
+		dev->isoc_ctl.vbi_buf = NULL;
+
+		printk ("alloc %d buffers of %d bytes (each containing %d packets of
%d bytes)\n",
+			dev->isoc_ctl.num_bufs, sb_size, max_packets,
dev->isoc_ctl.max_pkt_size);
+		/* allocate urbs and transfer buffers */
+		for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
+			urb = usb_alloc_urb(max_packets, GFP_KERNEL);
+			if (!urb) {
+				em28xx_err("cannot alloc isoc_ctl.urb %i\n", i);
+				em28xx_uninit_isoc(dev, start);
+				return -ENOMEM;
+			}
+			dev->isoc_ctl.urb[i] = urb;
+
+			dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->udev,
+				sb_size, GFP_KERNEL, &urb->transfer_dma);
+			if (!dev->isoc_ctl.transfer_buffer[i]) {
+				em28xx_err("unable to allocate %i bytes for transfer"
+						" buffer %i%s\n",
+						sb_size, i,
+						in_interrupt() ? " while in int" : "");
+				em28xx_uninit_isoc(dev, start);
+				return -ENOMEM;
+			}
+			memset(dev->isoc_ctl.transfer_buffer[i], 0, sb_size);
+
+			/* FIXME: this is a hack - should be
+				'desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK'
+				should also be using 'desc.bInterval'
+			*/
+			pipe = usb_rcvisocpipe(dev->udev,
+								dev->mode == EM28XX_ANALOG_MODE ?
+								EM28XX_EP_ANALOG : EM28XX_EP_DIGITAL);
+
+			usb_fill_int_urb(urb, dev->udev, pipe,
+					dev->isoc_ctl.transfer_buffer[i], sb_size,
+					em28xx_irq_callback, dev, 1);
+
+			urb->number_of_packets = max_packets;
+			urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+
+			k = 0;
+			for (j = 0; j < max_packets; j++) {
+				urb->iso_frame_desc[j].offset = k;
+				urb->iso_frame_desc[j].length =
+							dev->isoc_ctl.max_pkt_size;
+				k += dev->isoc_ctl.max_pkt_size;
+			}
 		}
+	} else {
+		printk ("no need to realloc isoc transfer buffers (size not changed)\n");
 	}

+	dev->isoc_ctl.isoc_copy = isoc_copy;
+
+	if (!start)
+		return 0;
+
 	init_waitqueue_head(&dma_q->wq);
 	init_waitqueue_head(&vbi_dma_q->wq);

@@ -1100,7 +1130,8 @@ int em28xx_init_isoc(struct em28xx *dev, int
max_packets,
 		if (rc) {
 			em28xx_err("submit of urb %i failed (error=%i)\n", i,
 				   rc);
-			em28xx_uninit_isoc(dev);
+			dev->isoc_ctl.preallocated_transfer_bufs = false;
+			em28xx_uninit_isoc(dev, start);
 			return rc;
 		}
 	}
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c
b/drivers/media/video/em28xx/em28xx-dvb.c
index aabbf48..13272ad 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -61,9 +61,6 @@ if (debug >= level) 						\
 	printk(KERN_DEBUG "%s/2-dvb: " fmt, dev->name, ## arg);	\
 } while (0)

-#define EM28XX_DVB_NUM_BUFS 5
-#define EM28XX_DVB_MAX_PACKETS 64
-
 struct em28xx_dvb {
 	struct dvb_frontend        *fe[2];

@@ -178,15 +175,13 @@ static int em28xx_start_streaming(struct
em28xx_dvb *dvb)

 	return em28xx_init_isoc(dev, EM28XX_DVB_MAX_PACKETS,
 				EM28XX_DVB_NUM_BUFS, max_dvb_packet_size,
-				em28xx_dvb_isoc_copy);
+				true, em28xx_dvb_isoc_copy);
 }

 static int em28xx_stop_streaming(struct em28xx_dvb *dvb)
 {
 	struct em28xx *dev = dvb->adapter.priv;

-	em28xx_uninit_isoc(dev);
-
 	em28xx_set_mode(dev, EM28XX_SUSPEND);

 	return 0;
diff --git a/drivers/media/video/em28xx/em28xx-video.c
b/drivers/media/video/em28xx/em28xx-video.c
index 613300b..35b4096 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -764,15 +764,18 @@ buffer_prepare(struct videobuf_queue *vq, struct
videobuf_buffer *vb,
 		urb_init = 1;

 	if (urb_init) {
+		dev->isoc_ctl.preallocated_transfer_bufs = false;
 		if (em28xx_vbi_supported(dev) == 1)
 			rc = em28xx_init_isoc(dev, EM28XX_NUM_PACKETS,
 					      EM28XX_NUM_BUFS,
 					      dev->max_pkt_size,
+					      true,
 					      em28xx_isoc_copy_vbi);
 		else
 			rc = em28xx_init_isoc(dev, EM28XX_NUM_PACKETS,
 					      EM28XX_NUM_BUFS,
 					      dev->max_pkt_size,
+					      true,
 					      em28xx_isoc_copy);
 		if (rc < 0)
 			goto fail;
@@ -2267,7 +2270,7 @@ static int em28xx_v4l2_close(struct file *filp)
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);

 		/* do this before setting alternate! */
-		em28xx_uninit_isoc(dev);
+		em28xx_uninit_isoc(dev, true);
 		em28xx_set_mode(dev, EM28XX_SUSPEND);

 		/* set alternate 0 */
diff --git a/drivers/media/video/em28xx/em28xx.h
b/drivers/media/video/em28xx/em28xx.h
index 22e252b..fcbd60a 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -151,12 +151,14 @@

 /* number of buffers for isoc transfers */
 #define EM28XX_NUM_BUFS 5
+#define EM28XX_DVB_NUM_BUFS 5

 /* number of packets for each buffer
    windows requests only 64 packets .. so we better do the same
    this is what I found out for all alternate numbers there!
  */
 #define EM28XX_NUM_PACKETS 64
+#define EM28XX_DVB_MAX_PACKETS 64

 #define EM28XX_INTERLACED_DEFAULT 1

@@ -228,9 +230,11 @@ struct em28xx_usb_isoc_ctl {
 		/* Stores the number of received fields */
 	int				nfields;

+		/* Signals if the transfer buffers were preallocated */
+	bool preallocated_transfer_bufs;
+
 		/* isoc urb callback */
 	int (*isoc_copy) (struct em28xx *dev, struct urb *urb);
-
 };

 /* Struct to enumberate video formats */
@@ -677,9 +681,9 @@ int em28xx_set_outfmt(struct em28xx *dev);
 int em28xx_resolution_set(struct em28xx *dev);
 int em28xx_set_alternate(struct em28xx *dev);
 int em28xx_init_isoc(struct em28xx *dev, int max_packets,
-		     int num_bufs, int max_pkt_size,
+		     int num_bufs, int max_pkt_size, bool start,
 		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb));
-void em28xx_uninit_isoc(struct em28xx *dev);
+void em28xx_uninit_isoc(struct em28xx *dev, bool start);
 int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev);
 int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode);
 int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio);
-- 
1.7.0.4

