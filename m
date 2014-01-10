Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAJVtQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 16:49:16 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/4] em28xx: use bInterval on em28xx-audio
Date: Fri, 10 Jan 2014 16:45:36 -0200
Message-Id: <1389379539-31550-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
References: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just filling urb->interval with 1 is wrong, and causes a different
behaviour with xHCI.

With EHCI, the URB size is typically 192 bytes. However, as
xHCI specifies intervals in microframes, the URB size becomes
too short (24 bytes).

With this patch, the interval will be properly initialized, and
the device will behave the same if connected into a xHCI or an
EHCI device port.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 39 ++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 30ee389a07f0..8e6f04873422 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -620,10 +620,13 @@ static int em28xx_audio_init(struct em28xx *dev)
 	struct em28xx_audio *adev = &dev->adev;
 	struct snd_pcm      *pcm;
 	struct snd_card     *card;
+	struct usb_interface *intf;
+	struct usb_endpoint_descriptor *e, *ep = NULL;
 	static int          devnr;
 	int                 err, i;
 	const int sb_size = EM28XX_NUM_AUDIO_PACKETS *
 			    EM28XX_AUDIO_MAX_PACKET_SIZE;
+	u8 alt;
 
 	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
 		/* This device does not support the extension (in this case
@@ -679,6 +682,34 @@ static int em28xx_audio_init(struct em28xx *dev)
 		em28xx_cvol_new(card, dev, "Surround", AC97_SURROUND_MASTER);
 	}
 
+	if (dev->audio_ifnum)
+		alt = 1;
+	else
+		alt = 7;
+
+	intf = usb_ifnum_to_if(dev->udev, dev->audio_ifnum);
+
+	if (intf->num_altsetting <= alt) {
+		em28xx_errdev("alt %d doesn't exist on interface %d\n",
+			      dev->audio_ifnum, alt);
+		return -ENODEV;
+	}
+
+	for (i = 0; i < intf->altsetting[alt].desc.bNumEndpoints; i++) {
+		e = &intf->altsetting[alt].endpoint[i].desc;
+		if (!usb_endpoint_dir_in(e))
+			continue;
+		if (e->bEndpointAddress == EM28XX_EP_AUDIO) {
+			ep = e;
+			break;
+		}
+	}
+
+	if (!ep) {
+		em28xx_errdev("Couldn't find an audio endpoint");
+		return -ENODEV;
+	}
+
 	/* Alloc URB and transfer buffers */
 	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
 		struct urb *urb;
@@ -707,11 +738,17 @@ static int em28xx_audio_init(struct em28xx *dev)
 		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
-		urb->interval = 1;
+		urb->interval = 1 << (ep->bInterval - 1);
 		urb->complete = em28xx_audio_isocirq;
 		urb->number_of_packets = EM28XX_NUM_AUDIO_PACKETS;
 		urb->transfer_buffer_length = sb_size;
 
+		if (!i)
+			dprintk("Will use ep 0x%02x on intf %d alt %d interval = %d (rcv isoc pipe: 0x%08x)\n",
+				EM28XX_EP_AUDIO, dev->audio_ifnum, alt,
+				urb->interval,
+				urb->pipe);
+
 		for (j = k = 0; j < EM28XX_NUM_AUDIO_PACKETS;
 			     j++, k += EM28XX_AUDIO_MAX_PACKET_SIZE) {
 			urb->iso_frame_desc[j].offset = k;
-- 
1.8.3.1

