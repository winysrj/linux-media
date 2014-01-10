Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaAKMvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 07:51:17 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/4] em28xx: don't hardcode audio URB calculus
Date: Fri, 10 Jan 2014 16:45:38 -0200
Message-Id: <1389379539-31550-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
References: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code hardcodes the number of audio URBs, the number
of packets per URB and the maximum URB size.

This is not a good idea, as it:

- wastes more bandwidth than necessary, by using a very
  large number of packets;

- those constants are bound to an specific scenario, with
  a bandwidth of 48 kHz;

- don't take the maximum endpoint size into account;

- with urb->interval = 1 on xHCI, those constraints cause a "funny"
  setup: URBs with 64 packets inside, with only 24 bytes total. E. g.
  a complete waste of space.

Change the code to do dynamic URB audio calculus and allocation.

For now, use the same constraints as used before this patch, to
avoid regressions.

A good scenario (tested) seems to use those defines, instead:

	#define EM28XX_MAX_AUDIO_BUFS          8
	#define EM28XX_MIN_AUDIO_PACKETS       2

But let's not do such change here, letting the optimization to
happen on latter patches, after more tests.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 141 ++++++++++++++++++++++++--------
 drivers/media/usb/em28xx/em28xx.h       |   8 +-
 2 files changed, 111 insertions(+), 38 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 4ee3488960e1..6c7d34600294 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -50,6 +50,8 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "activates debug info");
 
+#define EM28XX_MAX_AUDIO_BUFS		5
+#define EM28XX_MIN_AUDIO_PACKETS	64
 #define dprintk(fmt, arg...) do {					\
 	    if (debug)							\
 		printk(KERN_INFO "em28xx-audio %s: " fmt,		\
@@ -63,7 +65,7 @@ static int em28xx_deinit_isoc_audio(struct em28xx *dev)
 	int i;
 
 	dprintk("Stopping isoc\n");
-	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+	for (i = 0; i < dev->adev.num_urb; i++) {
 		struct urb *urb = dev->adev.urb[i];
 
 		if (!irqs_disabled())
@@ -168,7 +170,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 	dprintk("Starting isoc transfers\n");
 
 	/* Start streaming */
-	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+	for (i = 0; i < dev->adev.num_urb; i++) {
 		memset(dev->adev.transfer_buffer[i], 0x80,
 		       dev->adev.urb[i]->transfer_buffer_length);
 
@@ -598,21 +600,35 @@ static void em28xx_audio_free_urb(struct em28xx *dev)
 {
 	int i;
 
-	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+	for (i = 0; i < dev->adev.num_urb; i++) {
 		struct urb *urb = dev->adev.urb[i];
 
-		if (!dev->adev.urb[i])
+		if (!urb)
 			continue;
 
-		usb_free_coherent(dev->udev,
-				  urb->transfer_buffer_length,
-				  dev->adev.transfer_buffer[i],
-				  urb->transfer_dma);
+		if (dev->adev.transfer_buffer[i])
+			usb_free_coherent(dev->udev,
+					  urb->transfer_buffer_length,
+					  dev->adev.transfer_buffer[i],
+					  urb->transfer_dma);
 
 		usb_free_urb(urb);
-		dev->adev.urb[i] = NULL;
-		dev->adev.transfer_buffer[i] = NULL;
 	}
+	kfree(dev->adev.urb);
+	kfree(dev->adev.transfer_buffer);
+	dev->adev.num_urb = 0;
+}
+
+/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
+static int em28xx_audio_ep_packet_size(struct usb_device *udev,
+					struct usb_endpoint_descriptor *e)
+{
+	int size = le16_to_cpu(e->wMaxPacketSize);
+
+	if (udev->speed == USB_SPEED_HIGH)
+		return (size & 0x7ff) *  (1 + (((size) >> 11) & 0x03));
+
+	return size & 0x7ff;
 }
 
 static int em28xx_audio_init(struct em28xx *dev)
@@ -623,9 +639,8 @@ static int em28xx_audio_init(struct em28xx *dev)
 	struct usb_interface *intf;
 	struct usb_endpoint_descriptor *e, *ep = NULL;
 	static int          devnr;
-	int                 err, i;
-	const int sb_size = EM28XX_NUM_AUDIO_PACKETS *
-			    EM28XX_AUDIO_MAX_PACKET_SIZE;
+	int                 err, i, ep_size, interval, num_urb, npackets;
+	int		    urb_size, bytes_per_transfer;
 	u8 alt;
 
 	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
@@ -648,6 +663,9 @@ static int em28xx_audio_init(struct em28xx *dev)
 		return err;
 
 	spin_lock_init(&adev->slock);
+	adev->sndcard = card;
+	adev->udev = dev->udev;
+
 	err = snd_pcm_new(card, "Em28xx Audio", 0, 0, 1, &pcm);
 	if (err < 0) {
 		snd_card_free(card);
@@ -712,25 +730,92 @@ static int em28xx_audio_init(struct em28xx *dev)
 		return -ENODEV;
 	}
 
-	/* Alloc URB and transfer buffers */
-	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+	ep_size = em28xx_audio_ep_packet_size(dev->udev, ep);
+	interval = 1 << (ep->bInterval - 1);
+
+	em28xx_info("Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
+		     EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
+		     dev->audio_ifnum, alt,
+		     interval,
+		     ep_size);
+
+	/* Calculate the number and size of URBs to better fit the audio samples */
+
+	/*
+	 * Estimate the number of bytes per DMA transfer.
+	 *
+	 * This is given by the bit rate (for now, only 48000 Hz) multiplied
+	 * by 2 channels and 2 bytes/sample divided by the number of microframe
+	 * intervals and by the microframe rate (125 us)
+	 */
+	bytes_per_transfer = DIV_ROUND_UP(48000 * 2 * 2, 125 * interval);
+
+	/*
+	 * Estimate the number of transfer URBs. Don't let it go past the
+	 * maximum number of URBs that is known to be supported by the device.
+	 */
+	num_urb = DIV_ROUND_UP(bytes_per_transfer, ep_size);
+	if (num_urb > EM28XX_MAX_AUDIO_BUFS)
+		num_urb = EM28XX_MAX_AUDIO_BUFS;
+
+	/*
+	 * Now that we know the number of bytes per transfer and the number of
+	 * URBs, estimate the typical size of an URB, in order to adjust the
+	 * minimal number of packets.
+	 */
+	urb_size = bytes_per_transfer / num_urb;
+
+	/*
+	 * Now, calculate the amount of audio packets to be filled on each
+	 * URB. In order to preserve the old behaviour, use a minimal
+	 * threshold for this value.
+	 */
+	npackets = EM28XX_MIN_AUDIO_PACKETS;
+	if (urb_size > ep_size * npackets)
+		npackets = DIV_ROUND_UP(urb_size, ep_size);
+
+	em28xx_info("Number of URBs: %d, with %d packets and %d size",
+		    num_urb, npackets, urb_size);
+
+	/* Allocate space to store the number of URBs to be used */
+
+	dev->adev.transfer_buffer = kcalloc(num_urb,
+					    sizeof(*dev->adev.transfer_buffer),
+					    GFP_ATOMIC);
+	if (!dev->adev.transfer_buffer) {
+		snd_card_free(card);
+		return -ENOMEM;
+	}
+
+	dev->adev.urb = kcalloc(num_urb, sizeof(*dev->adev.urb), GFP_ATOMIC);
+	if (!dev->adev.urb) {
+		snd_card_free(card);
+		kfree(dev->adev.transfer_buffer);
+		return -ENOMEM;
+	}
+
+	/* Alloc memory for each URB and for each transfer buffer */
+	dev->adev.num_urb = num_urb;
+	for (i = 0; i < num_urb; i++) {
 		struct urb *urb;
 		int j, k;
 		void *buf;
 
-		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
+		urb = usb_alloc_urb(npackets, GFP_ATOMIC);
 		if (!urb) {
 			em28xx_errdev("usb_alloc_urb failed!\n");
 			em28xx_audio_free_urb(dev);
+			snd_card_free(card);
 			return -ENOMEM;
 		}
 		dev->adev.urb[i] = urb;
 
-		buf = usb_alloc_coherent(dev->udev, sb_size, GFP_ATOMIC,
+		buf = usb_alloc_coherent(dev->udev, npackets * ep_size, GFP_ATOMIC,
 					 &urb->transfer_dma);
 		if (!buf) {
 			em28xx_errdev("usb_alloc_coherent failed!\n");
 			em28xx_audio_free_urb(dev);
+			snd_card_free(card);
 			return -ENOMEM;
 		}
 		dev->adev.transfer_buffer[i] = buf;
@@ -739,23 +824,15 @@ static int em28xx_audio_init(struct em28xx *dev)
 		urb->context = dev;
 		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer = dev->adev.transfer_buffer[i];
-		urb->interval = 1 << (ep->bInterval - 1);
+		urb->transfer_buffer = buf;
+		urb->interval = interval;
 		urb->complete = em28xx_audio_isocirq;
-		urb->number_of_packets = EM28XX_NUM_AUDIO_PACKETS;
-		urb->transfer_buffer_length = sb_size;
-
-		if (!i)
-			dprintk("Will use ep 0x%02x on intf %d alt %d interval = %d (rcv isoc pipe: 0x%08x)\n",
-				EM28XX_EP_AUDIO, dev->audio_ifnum, alt,
-				urb->interval,
-				urb->pipe);
+		urb->number_of_packets = npackets;
+		urb->transfer_buffer_length = ep_size * npackets;
 
-		for (j = k = 0; j < EM28XX_NUM_AUDIO_PACKETS;
-			     j++, k += EM28XX_AUDIO_MAX_PACKET_SIZE) {
+		for (j = k = 0; j < npackets; j++, k += ep_size) {
 			urb->iso_frame_desc[j].offset = k;
-			urb->iso_frame_desc[j].length =
-			    EM28XX_AUDIO_MAX_PACKET_SIZE;
+			urb->iso_frame_desc[j].length = ep_size;
 		}
 	}
 
@@ -765,8 +842,6 @@ static int em28xx_audio_init(struct em28xx *dev)
 		snd_card_free(card);
 		return err;
 	}
-	adev->sndcard = card;
-	adev->udev = dev->udev;
 
 	em28xx_info("Audio extension successfully initialized\n");
 	return 0;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index efdf38642768..e76f993e3195 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -481,9 +481,6 @@ struct em28xx_eeprom {
 	u8 string_idx_table;
 };
 
-#define EM28XX_AUDIO_BUFS 5
-#define EM28XX_NUM_AUDIO_PACKETS 64
-#define EM28XX_AUDIO_MAX_PACKET_SIZE 196 /* static value */
 #define EM28XX_CAPTURE_STREAM_EN 1
 
 /* em28xx extensions */
@@ -498,8 +495,9 @@ struct em28xx_eeprom {
 
 struct em28xx_audio {
 	char name[50];
-	char *transfer_buffer[EM28XX_AUDIO_BUFS];
-	struct urb *urb[EM28XX_AUDIO_BUFS];
+	unsigned num_urb;
+	char **transfer_buffer;
+	struct urb **urb;
 	struct usb_device *udev;
 	unsigned int capture_transfer_done;
 	struct snd_pcm_substream   *capture_pcm_substream;
-- 
1.8.3.1

