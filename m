Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3L2Con (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 21:44:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] em28xx-audio: allocate URBs at device driver init
Date: Sun, 29 Dec 2013 00:44:22 -0200
Message-Id: <1388285062-29217-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388285062-29217-1-git-send-email-mchehab@redhat.com>
References: <1388285062-29217-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating/deallocating URBs and transfer buffers
every time stream is started/stopped, just do it once.

That reduces the memory allocation pressure and makes the
code that start/stop streaming a way simpler.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 128 ++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 55 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 825acf8bfb60..7dc890c211f9 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2006 Markus Rechberger <mrechberger@gmail.com>
  *
- *  Copyright (C) 2007-2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *  Copyright (C) 2007-2013 Mauro Carvalho Chehab
  *	- Port to work with the in-kernel driver
  *	- Cleanups, fixes, alsa-controls, etc.
  *
@@ -70,16 +70,6 @@ static int em28xx_deinit_isoc_audio(struct em28xx *dev)
 			usb_kill_urb(urb);
 		else
 			usb_unlink_urb(urb);
-
-		usb_free_coherent(dev->udev,
-				  urb->transfer_buffer_length,
-				  dev->adev.transfer_buffer[i],
-				  urb->transfer_dma);
-
-		dev->adev.transfer_buffer[i] = NULL;
-
-		usb_free_urb(urb);
-		dev->adev.urb[i] = NULL;
 	}
 
 	return 0;
@@ -174,53 +164,14 @@ static void em28xx_audio_isocirq(struct urb *urb)
 static int em28xx_init_audio_isoc(struct em28xx *dev)
 {
 	int       i, errCode;
-	const int sb_size = EM28XX_NUM_AUDIO_PACKETS *
-			    EM28XX_AUDIO_MAX_PACKET_SIZE;
 
 	dprintk("Starting isoc transfers\n");
 
+	/* Start streaming */
 	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
-		struct urb *urb;
-		int j, k;
-		void *buf;
-
-		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
-		if (!urb) {
-			em28xx_errdev("usb_alloc_urb failed!\n");
-			for (j = 0; j < i; j++) {
-				usb_free_urb(dev->adev.urb[j]);
-				kfree(dev->adev.transfer_buffer[j]);
-			}
-			return -ENOMEM;
-		}
-
-		buf = usb_alloc_coherent(dev->udev, sb_size, GFP_ATOMIC,
-					 &urb->transfer_dma);
-		if (!buf)
-			return -ENOMEM;
-		dev->adev.transfer_buffer[i] = buf;
-		memset(buf, 0x80, sb_size);
+		memset(dev->adev.transfer_buffer[i], 0x80,
+		       dev->adev.urb[i]->transfer_buffer_length);
 
-		urb->dev = dev->udev;
-		urb->context = dev;
-		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
-		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer = dev->adev.transfer_buffer[i];
-		urb->interval = 1;
-		urb->complete = em28xx_audio_isocirq;
-		urb->number_of_packets = EM28XX_NUM_AUDIO_PACKETS;
-		urb->transfer_buffer_length = sb_size;
-
-		for (j = k = 0; j < EM28XX_NUM_AUDIO_PACKETS;
-			     j++, k += EM28XX_AUDIO_MAX_PACKET_SIZE) {
-			urb->iso_frame_desc[j].offset = k;
-			urb->iso_frame_desc[j].length =
-			    EM28XX_AUDIO_MAX_PACKET_SIZE;
-		}
-		dev->adev.urb[i] = urb;
-	}
-
-	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
 		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
 		if (errCode) {
 			em28xx_errdev("submit of audio urb failed\n");
@@ -643,13 +594,37 @@ static struct snd_pcm_ops snd_em28xx_pcm_capture = {
 	.page      = snd_pcm_get_vmalloc_page,
 };
 
+
+static void em28xx_audio_free_urb(struct em28xx *dev)
+{
+	int i;
+
+	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+		struct urb *urb = dev->adev.urb[i];
+
+		if (!dev->adev.urb[i])
+			continue;
+
+		usb_free_coherent(dev->udev,
+				  urb->transfer_buffer_length,
+				  dev->adev.transfer_buffer[i],
+				  urb->transfer_dma);
+
+		usb_free_urb(urb);
+		dev->adev.urb[i] = NULL;
+		dev->adev.transfer_buffer[i] = NULL;
+	}
+}
+
 static int em28xx_audio_init(struct em28xx *dev)
 {
 	struct em28xx_audio *adev = &dev->adev;
 	struct snd_pcm      *pcm;
 	struct snd_card     *card;
 	static int          devnr;
-	int                 err;
+	int                 err, i;
+	const int sb_size = EM28XX_NUM_AUDIO_PACKETS *
+			    EM28XX_AUDIO_MAX_PACKET_SIZE;
 
 	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
 		/* This device does not support the extension (in this case
@@ -662,7 +637,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
 			 "Rechberger\n");
-	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab\n");
+	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2007-2013 Mauro Carvalho Chehab\n");
 
 	err = snd_card_create(index[devnr], "Em28xx Audio", THIS_MODULE, 0,
 			      &card);
@@ -704,6 +679,47 @@ static int em28xx_audio_init(struct em28xx *dev)
 		em28xx_cvol_new(card, dev, "Surround", AC97_SURROUND_MASTER);
 	}
 
+	/* Alloc URB and transfer buffers */
+	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+		struct urb *urb;
+		int j, k;
+		void *buf;
+
+		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
+		if (!urb) {
+			em28xx_errdev("usb_alloc_urb failed!\n");
+			em28xx_audio_free_urb(dev);
+			return -ENOMEM;
+		}
+		dev->adev.urb[i] = urb;
+
+		buf = usb_alloc_coherent(dev->udev, sb_size, GFP_ATOMIC,
+					 &urb->transfer_dma);
+		if (!buf) {
+			em28xx_errdev("usb_alloc_coherent failed!\n");
+			em28xx_audio_free_urb(dev);
+			return -ENOMEM;
+		}
+		dev->adev.transfer_buffer[i] = buf;
+
+		urb->dev = dev->udev;
+		urb->context = dev;
+		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_buffer = dev->adev.transfer_buffer[i];
+		urb->interval = 1;
+		urb->complete = em28xx_audio_isocirq;
+		urb->number_of_packets = EM28XX_NUM_AUDIO_PACKETS;
+		urb->transfer_buffer_length = sb_size;
+
+		for (j = k = 0; j < EM28XX_NUM_AUDIO_PACKETS;
+			     j++, k += EM28XX_AUDIO_MAX_PACKET_SIZE) {
+			urb->iso_frame_desc[j].offset = k;
+			urb->iso_frame_desc[j].length =
+			    EM28XX_AUDIO_MAX_PACKET_SIZE;
+		}
+	}
+
 	err = snd_card_register(card);
 	if (err < 0) {
 		snd_card_free(card);
@@ -728,6 +744,8 @@ static int em28xx_audio_fini(struct em28xx *dev)
 		return 0;
 	}
 
+	em28xx_audio_free_urb(dev);
+
 	if (dev->adev.sndcard) {
 		snd_card_free(dev->adev.sndcard);
 		dev->adev.sndcard = NULL;
-- 
1.8.3.1

