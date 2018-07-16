Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:53711 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbeGPXXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 19:23:37 -0400
Date: Tue, 17 Jul 2018 00:53:57 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH RFC] usb: add usb_fill_iso_urb()
Message-ID: <20180716225357.v25f6rurz56q4yes@linutronix.de>
References: <20180620164945.xb24m7wlbtb6cys5@linutronix.de>
 <Pine.LNX.4.44L0.1806201322260.1758-100000@iolanthe.rowland.org>
 <20180712223527.5nmxndignujo7smt@linutronix.de>
 <20180713072923.GA31191@kroah.com>
 <20180713074728.itw7ua7zygazotuk@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20180713074728.itw7ua7zygazotuk@linutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-07-13 09:47:28 [+0200], To Greg Kroah-Hartman wrote:
> 
> sure. Let me refresh my old usb_fill_int_urb() series with this instead.

The series is at
   https://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/staging.git/log/?h=usb-iso

and needs double checking before it can be posted (and addressing the
few comments I had so far). Here are just the highlights:
- usb_fill_iso_urb() itself:

+static inline void usb_fill_iso_urb(struct urb *urb,
+                                   struct usb_device *dev,
+                                   unsigned int pipe,
+                                   void *transfer_buffer,
+                                   int buffer_length,
+                                   usb_complete_t complete_fn,
+                                   void *context,
+                                   int interval,
+                                   unsigned int packets,
+                                   unsigned int packet_size)
+{
+       unsigned int i;
+
+       urb->dev = dev;
+       urb->pipe = pipe;
+       urb->transfer_buffer = transfer_buffer;
+       urb->transfer_buffer_length = buffer_length;
+       urb->complete = complete_fn;
+       urb->context = context;
+
+       interval = clamp(interval, 1, 16);
+       urb->interval = 1 << (interval - 1);
+       urb->start_frame = -1;
+
+       if (packets)
+               urb->number_of_packets = packets;
+
+       if (packet_size) {
+               for (i = 0; i < packets; i++) {
+                       urb->iso_frame_desc[i].offset = packet_size * i;
+                       urb->iso_frame_desc[i].length = packet_size;
+               }
+       }
+}

My understanding is that ->start_frame is only a return parameter. The
value is either implicit zero (via kzalloc()/memset()) or explicit
assignment to 0 or -1. So since it is a return value an init to 0 would
not be required and an initialisation to -1 (like for INT) would be
okay. Am I wrong?

sound/ is (almost) the only part where struct usb_iso_packet_descriptor
init does not fit. It looks like it is done just before urb_submit() and
could be avoided there (moved to the init funtcion instead). However I
avoided changing it and added a zero check for `packet_size' so it can
be skipped. I also need to check if the `interval' value here to see if
it works as expected. Two examples:

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index c90607ebe155..f1d4e90e1d23 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -772,6 +772,8 @@ static int data_ep_set_params(struct snd_usb_endpoint *ep,
 	/* allocate and initialize data urbs */
 	for (i = 0; i < ep->nurbs; i++) {
 		struct snd_urb_ctx *u = &ep->urb[i];
+		void *buf;
+
 		u->index = i;
 		u->ep = ep;
 		u->packets = urb_packs;
@@ -783,16 +785,14 @@ static int data_ep_set_params(struct snd_usb_endpoint *ep,
 		if (!u->urb)
 			goto out_of_memory;
 
-		u->urb->transfer_buffer =
-			usb_alloc_coherent(ep->chip->dev, u->buffer_size,
-					   GFP_KERNEL, &u->urb->transfer_dma);
-		if (!u->urb->transfer_buffer)
+		buf = usb_alloc_coherent(ep->chip->dev, u->buffer_size,
+					 GFP_KERNEL, &u->urb->transfer_dma);
+		if (!buf)
 			goto out_of_memory;
-		u->urb->pipe = ep->pipe;
+		usb_fill_iso_urb(u->urb, NULL, ep->pipe, buf, u->buffer_size,
+				 snd_complete_urb, u, ep->datainterval + 1, 0,
+				 0);
 		u->urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
-		u->urb->interval = 1 << ep->datainterval;
-		u->urb->context = u;
-		u->urb->complete = snd_complete_urb;
 		INIT_LIST_HEAD(&u->ready_list);
 	}
 
@@ -823,15 +823,12 @@ static int sync_ep_set_params(struct snd_usb_endpoint *ep)
 		u->urb = usb_alloc_urb(1, GFP_KERNEL);
 		if (!u->urb)
 			goto out_of_memory;
-		u->urb->transfer_buffer = ep->syncbuf + i * 4;
+		usb_fill_iso_urb(u->urb, NULL, ep->pipe, ep->syncbuf + i * 4, 4,
+				 snd_complete_urb, u, ep->syncinterval + 1, 1,
+				 0);
+
 		u->urb->transfer_dma = ep->sync_dma + i * 4;
-		u->urb->transfer_buffer_length = 4;
-		u->urb->pipe = ep->pipe;
 		u->urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
-		u->urb->number_of_packets = 1;
-		u->urb->interval = 1 << ep->syncinterval;
-		u->urb->context = u;
-		u->urb->complete = snd_complete_urb;
 	}
 
 	ep->nurbs = SYNC_URBS;

diff --git a/sound/usb/usx2y/usx2yhwdeppcm.c b/sound/usb/usx2y/usx2yhwdeppcm.c
index 4fd9276b8e50..3928d0d50028 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -325,6 +325,8 @@ static int usX2Y_usbpcm_urbs_allocate(struct snd_usX2Y_substream *subs)
 	/* allocate and initialize data urbs */
 	for (i = 0; i < NRURBS; i++) {
 		struct urb **purb = subs->urb + i;
+		void *buf;
+
 		if (*purb) {
 			usb_kill_urb(*purb);
 			continue;
@@ -334,18 +336,18 @@ static int usX2Y_usbpcm_urbs_allocate(struct snd_usX2Y_substream *subs)
 			usX2Y_usbpcm_urbs_release(subs);
 			return -ENOMEM;
 		}
-		(*purb)->transfer_buffer = is_playback ?
-			subs->usX2Y->hwdep_pcm_shm->playback : (
-				subs->endpoint == 0x8 ?
-				subs->usX2Y->hwdep_pcm_shm->capture0x8 :
-				subs->usX2Y->hwdep_pcm_shm->capture0xA);
-
-		(*purb)->dev = dev;
-		(*purb)->pipe = pipe;
-		(*purb)->number_of_packets = nr_of_packs();
-		(*purb)->context = subs;
-		(*purb)->interval = 1;
-		(*purb)->complete = i_usX2Y_usbpcm_subs_startup;
+		if (is_playback) {
+			buf = subs->usX2Y->hwdep_pcm_shm->playback;
+		} else {
+			if (subs->endpoint == 0x8)
+				buf = subs->usX2Y->hwdep_pcm_shm->capture0x8;
+			else
+				buf = subs->usX2Y->hwdep_pcm_shm->capture0xA;
+		}
+		usb_fill_iso_urb(*purb, dev, pipe, buf,
+				 subs->maxpacksize * nr_of_packs(),
+				 i_usX2Y_usbpcm_subs_startup, subs, 1,
+				 nr_of_packs(), 0);
 	}
 	return 0;
 }

The users in media/ look almost always the same, a random one:

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 54b036d39c5b..2e60d6257596 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -358,7 +358,7 @@ static int pwc_isoc_init(struct pwc_device *pdev)
 {
 	struct usb_device *udev;
 	struct urb *urb;
-	int i, j, ret;
+	int i, ret;
 	struct usb_interface *intf;
 	struct usb_host_interface *idesc = NULL;
 	int compression = 0; /* 0..3 = uncompressed..high */
@@ -409,6 +409,8 @@ static int pwc_isoc_init(struct pwc_device *pdev)
 
 	/* Allocate and init Isochronuous urbs */
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		void *buf;
+
 		urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
 		if (urb == NULL) {
 			pwc_isoc_cleanup(pdev);
@@ -416,29 +418,19 @@ static int pwc_isoc_init(struct pwc_device *pdev)
 		}
 		pdev->urbs[i] = urb;
 		PWC_DEBUG_MEMORY("Allocated URB at 0x%p\n", urb);
-
-		urb->interval = 1; // devik
-		urb->dev = udev;
-		urb->pipe = usb_rcvisocpipe(udev, pdev->vendpoint);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer = usb_alloc_coherent(udev,
-							  ISO_BUFFER_SIZE,
-							  GFP_KERNEL,
-							  &urb->transfer_dma);
-		if (urb->transfer_buffer == NULL) {
+		buf = usb_alloc_coherent(udev, ISO_BUFFER_SIZE, GFP_KERNEL,
+					 &urb->transfer_dma);
+		if (buf == NULL) {
 			PWC_ERROR("Failed to allocate urb buffer %d\n", i);
 			pwc_isoc_cleanup(pdev);
 			return -ENOMEM;
 		}
-		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
-		urb->complete = pwc_isoc_handler;
-		urb->context = pdev;
-		urb->start_frame = 0;
-		urb->number_of_packets = ISO_FRAMES_PER_DESC;
-		for (j = 0; j < ISO_FRAMES_PER_DESC; j++) {
-			urb->iso_frame_desc[j].offset = j * ISO_MAX_FRAME_SIZE;
-			urb->iso_frame_desc[j].length = pdev->vmax_packet_size;
-		}
+		usb_fill_iso_urb(urb, udev,
+				 usb_rcvisocpipe(udev, pdev->vendpoint),
+				 buf, ISO_BUFFER_SIZE, pwc_isoc_handler, pdev,
+				 1, ISO_FRAMES_PER_DESC,
+				 pdev->vmax_packet_size);
 	}
 
 	/* link */

I remember Alan asked to mention that the `.length' value is always set
to the same value by the proposed function while it could have different
values (like [0].offset = 0, [0].length = 8, [1].offset = 8, [1].length
= 16, [2].offset = 24, …). Unless I missed something, everyone using the
same value for length. Except for usbfs which uses what userland passes:

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 476dcc5f2da3..54294f1a6ce5 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1436,7 +1436,8 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 	int i, ret, is_in, num_sgs = 0, ifnum = -1;
 	int number_of_packets = 0;
 	unsigned int stream_id = 0;
-	void *buf;
+	int pipe;
+	void *buf = NULL;
 	unsigned long mask =	USBDEVFS_URB_SHORT_NOT_OK |
 				USBDEVFS_URB_BULK_CONTINUATION |
 				USBDEVFS_URB_NO_FSBR |
@@ -1631,22 +1632,20 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 			}
 			totlen -= u;
 		}
+		buf = NULL;
 	} else if (uurb->buffer_length > 0) {
 		if (as->usbm) {
 			unsigned long uurb_start = (unsigned long)uurb->buffer;
 
-			as->urb->transfer_buffer = as->usbm->mem +
-					(uurb_start - as->usbm->vm_start);
+			buf = as->usbm->mem + (uurb_start - as->usbm->vm_start);
 		} else {
-			as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
-					GFP_KERNEL);
-			if (!as->urb->transfer_buffer) {
+			buf = kmalloc(uurb->buffer_length, GFP_KERNEL);
+			if (!buf) {
 				ret = -ENOMEM;
 				goto error;
 			}
 			if (!is_in) {
-				if (copy_from_user(as->urb->transfer_buffer,
-						   uurb->buffer,
+				if (copy_from_user(buf, uurb->buffer,
 						   uurb->buffer_length)) {
 					ret = -EFAULT;
 					goto error;
@@ -1658,16 +1657,10 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 				 * short. Clear the buffer so that the gaps
 				 * don't leak kernel data to userspace.
 				 */
-				memset(as->urb->transfer_buffer, 0,
-						uurb->buffer_length);
+				memset(buf, 0, uurb->buffer_length);
 			}
 		}
 	}
-	as->urb->dev = ps->dev;
-	as->urb->pipe = (uurb->type << 30) |
-			__create_pipe(ps->dev, uurb->endpoint & 0xf) |
-			(uurb->endpoint & USB_DIR_IN);
-
 	/* This tedious sequence is necessary because the URB_* flags
 	 * are internal to the kernel and subject to change, whereas
 	 * the USBDEVFS_URB_* flags are a user API and must not be changed.
@@ -1683,30 +1676,42 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 		u |= URB_NO_INTERRUPT;
 	as->urb->transfer_flags = u;
 
-	as->urb->transfer_buffer_length = uurb->buffer_length;
-	as->urb->setup_packet = (unsigned char *)dr;
-	dr = NULL;
+	pipe = (uurb->type << 30) | (uurb->endpoint & USB_DIR_IN) |
+		__create_pipe(ps->dev, uurb->endpoint & 0xf);
+	switch (uurb->type) {
+	case USBDEVFS_URB_TYPE_CONTROL:
+		usb_fill_control_urb(as->urb, ps->dev, pipe, (u8 *)dr, buf,
+				     uurb->buffer_length, async_completed, as);
+		dr = NULL;
+		break;
+
+	case USBDEVFS_URB_TYPE_BULK:
+		usb_fill_bulk_urb(as->urb, ps->dev, pipe, buf,
+				  uurb->buffer_length, async_completed, as);
+		break;
+
+	case USBDEVFS_URB_TYPE_INTERRUPT:
+		usb_fill_int_urb(as->urb, ps->dev, pipe, buf,
+				 uurb->buffer_length, async_completed, as,
+				 ep->desc.bInterval);
+		break;
+
+	case USBDEVFS_URB_TYPE_ISO:
+		usb_fill_iso_urb(as->urb, ps->dev, pipe, buf,
+				 uurb->buffer_length, async_completed, as,
+				 ep->desc.bInterval, number_of_packets, 0);
+		for (totlen = u = 0; u < number_of_packets; u++) {
+			as->urb->iso_frame_desc[u].offset = totlen;
+			as->urb->iso_frame_desc[u].length = isopkt[u].length;
+			totlen += isopkt[u].length;
+		}
+		break;
+
+	}
+	buf = NULL;
 	as->urb->start_frame = uurb->start_frame;
-	as->urb->number_of_packets = number_of_packets;
 	as->urb->stream_id = stream_id;
 
-	if (ep->desc.bInterval) {
-		if (uurb->type == USBDEVFS_URB_TYPE_ISO ||
-				ps->dev->speed == USB_SPEED_HIGH ||
-				ps->dev->speed >= USB_SPEED_SUPER)
-			as->urb->interval = 1 <<
-					min(15, ep->desc.bInterval - 1);
-		else
-			as->urb->interval = ep->desc.bInterval;
-	}
-
-	as->urb->context = as;
-	as->urb->complete = async_completed;
-	for (totlen = u = 0; u < number_of_packets; u++) {
-		as->urb->iso_frame_desc[u].offset = totlen;
-		as->urb->iso_frame_desc[u].length = isopkt[u].length;
-		totlen += isopkt[u].length;
-	}
 	kfree(isopkt);
 	isopkt = NULL;
 	as->ps = ps;
@@ -1777,6 +1782,7 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 		dec_usb_memory_use_count(as->usbm, &as->usbm->urb_use_count);
 	kfree(isopkt);
 	kfree(dr);
+	kfree(buf);
 	if (as)
 		free_async(as);
 	return ret;

> > thanks,
> > 
> > greg k-h

Sebastian
