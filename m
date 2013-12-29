Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3L2Com (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 21:44:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] em28xx: use usb_alloc_coherent() for audio
Date: Sun, 29 Dec 2013 00:44:21 -0200
Message-Id: <1388285062-29217-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388285062-29217-1-git-send-email-mchehab@redhat.com>
References: <1388285062-29217-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Instead of allocating transfer buffers with kmalloc() use
usb_alloc_coherent().

That makes it work also with arm CPUs.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 54f4eb6d513c..825acf8bfb60 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -64,16 +64,22 @@ static int em28xx_deinit_isoc_audio(struct em28xx *dev)
 
 	dprintk("Stopping isoc\n");
 	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+		struct urb *urb = dev->adev.urb[i];
+
 		if (!irqs_disabled())
-			usb_kill_urb(dev->adev.urb[i]);
+			usb_kill_urb(urb);
 		else
-			usb_unlink_urb(dev->adev.urb[i]);
+			usb_unlink_urb(urb);
 
-		usb_free_urb(dev->adev.urb[i]);
-		dev->adev.urb[i] = NULL;
+		usb_free_coherent(dev->udev,
+				  urb->transfer_buffer_length,
+				  dev->adev.transfer_buffer[i],
+				  urb->transfer_dma);
 
-		kfree(dev->adev.transfer_buffer[i]);
 		dev->adev.transfer_buffer[i] = NULL;
+
+		usb_free_urb(urb);
+		dev->adev.urb[i] = NULL;
 	}
 
 	return 0;
@@ -176,12 +182,8 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
 		struct urb *urb;
 		int j, k;
+		void *buf;
 
-		dev->adev.transfer_buffer[i] = kmalloc(sb_size, GFP_ATOMIC);
-		if (!dev->adev.transfer_buffer[i])
-			return -ENOMEM;
-
-		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
 			em28xx_errdev("usb_alloc_urb failed!\n");
@@ -192,10 +194,17 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 			return -ENOMEM;
 		}
 
+		buf = usb_alloc_coherent(dev->udev, sb_size, GFP_ATOMIC,
+					 &urb->transfer_dma);
+		if (!buf)
+			return -ENOMEM;
+		dev->adev.transfer_buffer[i] = buf;
+		memset(buf, 0x80, sb_size);
+
 		urb->dev = dev->udev;
 		urb->context = dev;
 		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
-		urb->transfer_flags = 0;
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->interval = 1;
 		urb->complete = em28xx_audio_isocirq;
-- 
1.8.3.1

