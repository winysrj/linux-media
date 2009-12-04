Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43557 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZLDWP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 17:15:59 -0500
Received: by bwz27 with SMTP id 27so2315992bwz.21
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 14:16:04 -0800 (PST)
MIME-Version: 1.0
From: John S Gruber <johnsgruber@gmail.com>
Date: Fri, 4 Dec 2009 17:15:44 -0500
Message-ID: <44c6f3de0912041415r54d8ab6fq486f2a82edb91a68@mail.gmail.com>
Subject: [PATCH] sound/usb: Relax urb data alignment restriciton for HVR-950Q
	only
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Addressing audio quality problem.

In sound/usb/usbaudio.c, for the Hauppage HVR-950Q only, change
retire_capture_urb to copy the entire byte stream while still counting
entire audio frames. urbs unaligned on channel sample boundaries are
still truncated to the next lowest stride (audio slot) size to try to
retain channel alignment in cases of data loss over usb.

With the HVR950Q the left and right channel samples can be split between
two different urbs. Throwing away extra channel samples causes a sound
quality problem for stereo streams as the left and right channels are
swapped repeatedly.

	modified:   sound/usb/usbaudio.c

Signed-off-by: John S. Gruber <JohnSGruber@gmail.com>
---
 sound/usb/usbaudio.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 44b9cdc..64d9d3a 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -107,8 +107,9 @@ MODULE_PARM_DESC(ignore_ctl_error,
 #define MAX_PACKS_HS	(MAX_PACKS * 8)	/* in high speed mode */
 #define MAX_URBS	8
 #define SYNC_URBS	4	/* always four urbs for sync */
 #define MAX_QUEUE	24	/* try not to exceed this queue length, in ms */
+#define ALLOW_SUBSLOT_BOUNDARIES 0x01	/* quirk */

 struct audioformat {
 	struct list_head list;
 	snd_pcm_format_t format;	/* format type */
@@ -126,8 +127,9 @@ struct audioformat {
 	unsigned int rates;		/* rate bitmasks */
 	unsigned int rate_min, rate_max;	/* min/max rates */
 	unsigned int nr_rates;		/* number of rate table entries */
 	unsigned int *rate_table;	/* rate table */
+	unsigned int txfr_quirks;	/* transfer quirks */
 };

 struct snd_usb_substream;

@@ -174,8 +176,11 @@ struct snd_usb_substream {

 	unsigned int running: 1;	/* running status */

 	unsigned int hwptr_done;			/* processed frame position in the buffer */
+	unsigned int byteptr;		/* position, in bytes, of next move */
+	unsigned int remainder;		/* extra bytes moved to buffer */
+	unsigned int txfr_quirks;		/* substream transfer quirks */
 	unsigned int transfer_done;		/* processed frames since last period update */
 	unsigned long active_mask;	/* bitmask of active urbs */
 	unsigned long unlink_mask;	/* bitmask of unlinked urbs */

@@ -342,9 +347,9 @@ static int retire_capture_urb(struct
snd_usb_substream *subs,
 {
 	unsigned long flags;
 	unsigned char *cp;
 	int i;
-	unsigned int stride, len, oldptr;
+	unsigned int stride, len, bytelen, oldbyteptr;
 	int period_elapsed = 0;

 	stride = runtime->frame_bits >> 3;

@@ -353,31 +358,44 @@ static int retire_capture_urb(struct
snd_usb_substream *subs,
 		if (urb->iso_frame_desc[i].status) {
 			snd_printd(KERN_ERR "frame %d active: %d\n", i,
urb->iso_frame_desc[i].status);
 			// continue;
 		}
-		len = urb->iso_frame_desc[i].actual_length / stride;
-		if (! len)
+		bytelen = (urb->iso_frame_desc[i].actual_length);
+		if (!bytelen)
 			continue;
+		if (!(subs->txfr_quirks & ALLOW_SUBSLOT_BOUNDARIES))
+			bytelen = (bytelen/stride)*stride;
+		if (bytelen%(runtime->sample_bits>>3) != 0) {
+			int oldbytelen = bytelen;
+			bytelen = ((bytelen/stride)*stride);
+			printk(KERN_DEBUG "Corrected urb data len. %d -> %d\n",
+				oldbytelen, bytelen);
+		}
 		/* update the current pointer */
 		spin_lock_irqsave(&subs->lock, flags);
-		oldptr = subs->hwptr_done;
+		len = (bytelen + subs->remainder) / stride;
+		subs->remainder = (bytelen + subs->remainder) % stride;
+		oldbyteptr = subs->byteptr;
 		subs->hwptr_done += len;
 		if (subs->hwptr_done >= runtime->buffer_size)
 			subs->hwptr_done -= runtime->buffer_size;
 		subs->transfer_done += len;
 		if (subs->transfer_done >= runtime->period_size) {
 			subs->transfer_done -= runtime->period_size;
 			period_elapsed = 1;
 		}
+		subs->byteptr += bytelen;
+		if (subs->byteptr >= runtime->buffer_size*stride)
+			subs->byteptr -= runtime->buffer_size*stride;
 		spin_unlock_irqrestore(&subs->lock, flags);
 		/* copy a data chunk */
-		if (oldptr + len > runtime->buffer_size) {
-			unsigned int cnt = runtime->buffer_size - oldptr;
-			unsigned int blen = cnt * stride;
-			memcpy(runtime->dma_area + oldptr * stride, cp, blen);
-			memcpy(runtime->dma_area, cp + blen, len * stride - blen);
+		if ((oldbyteptr +  bytelen) > (runtime->buffer_size*stride)) {
+			unsigned int blen;
+			blen = (runtime->buffer_size*stride) - oldbyteptr;
+			memcpy(runtime->dma_area + oldbyteptr, cp, blen);
+			memcpy(runtime->dma_area, cp + blen,  bytelen - blen);
 		} else {
-			memcpy(runtime->dma_area + oldptr * stride, cp, len * stride);
+			memcpy(runtime->dma_area + oldbyteptr, cp, bytelen);
 		}
 	}
 	if (period_elapsed)
 		snd_pcm_period_elapsed(subs->pcm_substream);
@@ -1360,8 +1378,9 @@ static int set_format(struct snd_usb_substream
*subs, struct audioformat *fmt)
 	subs->datainterval = fmt->datainterval;
 	subs->syncpipe = subs->syncinterval = 0;
 	subs->maxpacksize = fmt->maxpacksize;
 	subs->fill_max = 0;
+	subs->txfr_quirks = fmt->txfr_quirks;

 	/* we need a sync pipe in async OUT or adaptive IN mode */
 	/* check the number of EP, since some devices have broken
 	 * descriptors which fool us.  if it has only one EP,
@@ -1529,8 +1548,10 @@ static int snd_usb_pcm_prepare(struct
snd_pcm_substream *substream)

 	/* reset the pointer */
 	subs->hwptr_done = 0;
 	subs->transfer_done = 0;
+	subs->remainder = 0;
+	subs->byteptr = 0;
 	subs->phase = 0;
 	runtime->delay = 0;

 	/* clear urbs (to be sure) */
@@ -2773,8 +2794,9 @@ static int parse_audio_endpoints(struct
snd_usb_audio *chip, int iface_no)
 		if (snd_usb_get_speed(dev) == USB_SPEED_HIGH)
 			fp->maxpacksize = (((fp->maxpacksize >> 11) & 3) + 1)
 					* (fp->maxpacksize & 0x7ff);
 		fp->attributes = csep ? csep[3] : 0;
+		fp->txfr_quirks = 0;

 		/* some quirks for attributes here */

 		switch (chip->usb_id) {
@@ -2801,8 +2823,11 @@ static int parse_audio_endpoints(struct
snd_usb_audio *chip, int iface_no)
 				fp->ep_attr |= EP_ATTR_ADAPTIVE;
 			else
 				fp->ep_attr |= EP_ATTR_SYNC;
 			break;
+		case USB_ID(0x2040, 0x7200): /* Hauppage hvr950Q */
+			fp->txfr_quirks |= ALLOW_SUBSLOT_BOUNDARIES;
+			break;
 		}

 		/* ok, let's parse further... */
 		if (parse_audio_format(chip, fp, format, fmt, stream) < 0) {
-- 
1.6.3.3
