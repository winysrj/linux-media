Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34895 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbbEEVmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:42:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] msi2500: cleanups
Date: Wed,  6 May 2015 00:42:02 +0300
Message-Id: <1430862122-9326-4-git-send-email-crope@iki.fi>
In-Reply-To: <1430862122-9326-1-git-send-email-crope@iki.fi>
References: <1430862122-9326-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename state to dev.
Correct some indentations.
Remove FSF address.
Fix some style issues reported by checkpatch.pl.
Correct some style issues I liked.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 610 ++++++++++++++++++------------------
 1 file changed, 306 insertions(+), 304 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 8605b96..3f276d9 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1,4 +1,5 @@
 /*
+ * Mirics MSi2500 driver
  * Mirics MSi3101 SDR Dongle driver
  *
  * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
@@ -13,10 +14,6 @@
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
  *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
  * That driver is somehow based of pwc driver:
  *  (C) 1999-2004 Nemosoft Unv.
  *  (C) 2004-2006 Luc Saillard (luc@saillard.org)
@@ -119,7 +116,7 @@ struct msi2500_frame_buf {
 	struct list_head list;
 };
 
-struct msi2500_state {
+struct msi2500_dev {
 	struct device *dev;
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
@@ -158,19 +155,19 @@ struct msi2500_state {
 
 /* Private functions */
 static struct msi2500_frame_buf *msi2500_get_next_fill_buf(
-		struct msi2500_state *s)
+							struct msi2500_dev *dev)
 {
 	unsigned long flags;
 	struct msi2500_frame_buf *buf = NULL;
 
-	spin_lock_irqsave(&s->queued_bufs_lock, flags);
-	if (list_empty(&s->queued_bufs))
+	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
+	if (list_empty(&dev->queued_bufs))
 		goto leave;
 
-	buf = list_entry(s->queued_bufs.next, struct msi2500_frame_buf, list);
+	buf = list_entry(dev->queued_bufs.next, struct msi2500_frame_buf, list);
 	list_del(&buf->list);
 leave:
-	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 	return buf;
 }
 
@@ -256,8 +253,8 @@ leave:
  * signed 14-bit sample
  */
 
-static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
-		unsigned int src_len)
+static int msi2500_convert_stream(struct msi2500_dev *dev, u8 *dst, u8 *src,
+				  unsigned int src_len)
 {
 	unsigned int i, j, transactions, dst_len = 0;
 	u32 sample[3];
@@ -268,26 +265,27 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 	for (i = 0; i < transactions; i++) {
 		sample[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 |
 				src[0] << 0;
-		if (i == 0 && s->next_sample != sample[0]) {
-			dev_dbg_ratelimited(s->dev,
-					"%d samples lost, %d %08x:%08x\n",
-					sample[0] - s->next_sample,
-					src_len, s->next_sample, sample[0]);
+		if (i == 0 && dev->next_sample != sample[0]) {
+			dev_dbg_ratelimited(dev->dev,
+					    "%d samples lost, %d %08x:%08x\n",
+					    sample[0] - dev->next_sample,
+					    src_len, dev->next_sample,
+					    sample[0]);
 		}
 
 		/*
 		 * Dump all unknown 'garbage' data - maybe we will discover
 		 * someday if there is something rational...
 		 */
-		dev_dbg_ratelimited(s->dev, "%*ph\n", 12, &src[4]);
+		dev_dbg_ratelimited(dev->dev, "%*ph\n", 12, &src[4]);
 
 		src += 16; /* skip header */
 
-		switch (s->pixelformat) {
+		switch (dev->pixelformat) {
 		case V4L2_SDR_FMT_CU8: /* 504 x IQ samples */
 		{
-			s8 *s8src = (s8 *) src;
-			u8 *u8dst = (u8 *) dst;
+			s8 *s8src = (s8 *)src;
+			u8 *u8dst = (u8 *)dst;
 
 			for (j = 0; j < 1008; j++)
 				*u8dst++ = *s8src++ + 128;
@@ -295,13 +293,13 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 			src += 1008;
 			dst += 1008;
 			dst_len += 1008;
-			s->next_sample = sample[i] + 504;
+			dev->next_sample = sample[i] + 504;
 			break;
 		}
 		case  V4L2_SDR_FMT_CU16LE: /* 252 x IQ samples */
 		{
-			s16 *s16src = (s16 *) src;
-			u16 *u16dst = (u16 *) dst;
+			s16 *s16src = (s16 *)src;
+			u16 *u16dst = (u16 *)dst;
 			struct {signed int x:14; } se; /* sign extension */
 			unsigned int utmp;
 
@@ -317,38 +315,38 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 			src += 1008;
 			dst += 1008;
 			dst_len += 1008;
-			s->next_sample = sample[i] + 252;
+			dev->next_sample = sample[i] + 252;
 			break;
 		}
 		case MSI2500_PIX_FMT_SDR_MSI2500_384: /* 384 x IQ samples */
 			/* Dump unknown 'garbage' data */
-			dev_dbg_ratelimited(s->dev, "%*ph\n", 24, &src[1000]);
+			dev_dbg_ratelimited(dev->dev, "%*ph\n", 24, &src[1000]);
 			memcpy(dst, src, 984);
 			src += 984 + 24;
 			dst += 984;
 			dst_len += 984;
-			s->next_sample = sample[i] + 384;
+			dev->next_sample = sample[i] + 384;
 			break;
 		case V4L2_SDR_FMT_CS8:         /* 504 x IQ samples */
 			memcpy(dst, src, 1008);
 			src += 1008;
 			dst += 1008;
 			dst_len += 1008;
-			s->next_sample = sample[i] + 504;
+			dev->next_sample = sample[i] + 504;
 			break;
 		case MSI2500_PIX_FMT_SDR_S12:  /* 336 x IQ samples */
 			memcpy(dst, src, 1008);
 			src += 1008;
 			dst += 1008;
 			dst_len += 1008;
-			s->next_sample = sample[i] + 336;
+			dev->next_sample = sample[i] + 336;
 			break;
 		case V4L2_SDR_FMT_CS14LE:      /* 252 x IQ samples */
 			memcpy(dst, src, 1008);
 			src += 1008;
 			dst += 1008;
 			dst_len += 1008;
-			s->next_sample = sample[i] + 252;
+			dev->next_sample = sample[i] + 252;
 			break;
 		default:
 			break;
@@ -356,17 +354,17 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 	}
 
 	/* calculate sample rate and output it in 10 seconds intervals */
-	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
+	if (unlikely(time_is_before_jiffies(dev->jiffies_next))) {
 		#define MSECS 10000UL
 		unsigned int msecs = jiffies_to_msecs(jiffies -
-				s->jiffies_next + msecs_to_jiffies(MSECS));
-		unsigned int samples = s->next_sample - s->sample;
-
-		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
-		s->sample = s->next_sample;
-		dev_dbg(s->dev, "size=%u samples=%u msecs=%u sample rate=%lu\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs);
+				dev->jiffies_next + msecs_to_jiffies(MSECS));
+		unsigned int samples = dev->next_sample - dev->sample;
+
+		dev->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
+		dev->sample = dev->next_sample;
+		dev_dbg(dev->dev, "size=%u samples=%u msecs=%u sample rate=%lu\n",
+			src_len, samples, msecs,
+			samples * 1000UL / msecs);
 	}
 
 	return dst_len;
@@ -378,27 +376,28 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
  */
 static void msi2500_isoc_handler(struct urb *urb)
 {
-	struct msi2500_state *s = (struct msi2500_state *)urb->context;
+	struct msi2500_dev *dev = (struct msi2500_dev *)urb->context;
 	int i, flen, fstatus;
 	unsigned char *iso_buf = NULL;
 	struct msi2500_frame_buf *fbuf;
 
-	if (unlikely(urb->status == -ENOENT || urb->status == -ECONNRESET ||
-			urb->status == -ESHUTDOWN)) {
-		dev_dbg(s->dev, "URB (%p) unlinked %ssynchronuously\n",
-				urb, urb->status == -ENOENT ? "" : "a");
+	if (unlikely(urb->status == -ENOENT ||
+		     urb->status == -ECONNRESET ||
+		     urb->status == -ESHUTDOWN)) {
+		dev_dbg(dev->dev, "URB (%p) unlinked %ssynchronuously\n",
+			urb, urb->status == -ENOENT ? "" : "a");
 		return;
 	}
 
 	if (unlikely(urb->status != 0)) {
-		dev_dbg(s->dev, "called with status %d\n", urb->status);
+		dev_dbg(dev->dev, "called with status %d\n", urb->status);
 		/* Give up after a number of contiguous errors */
-		if (++s->isoc_errors > MAX_ISOC_ERRORS)
-			dev_dbg(s->dev, "Too many ISOC errors, bailing out\n");
+		if (++dev->isoc_errors > MAX_ISOC_ERRORS)
+			dev_dbg(dev->dev, "Too many ISOC errors, bailing out\n");
 		goto handler_end;
 	} else {
 		/* Reset ISOC error counter. We did get here, after all. */
-		s->isoc_errors = 0;
+		dev->isoc_errors = 0;
 	}
 
 	/* Compact data */
@@ -408,9 +407,9 @@ static void msi2500_isoc_handler(struct urb *urb)
 		/* Check frame error */
 		fstatus = urb->iso_frame_desc[i].status;
 		if (unlikely(fstatus)) {
-			dev_dbg_ratelimited(s->dev,
-					"frame=%d/%d has error %d skipping\n",
-					i, urb->number_of_packets, fstatus);
+			dev_dbg_ratelimited(dev->dev,
+					    "frame=%d/%d has error %d skipping\n",
+					    i, urb->number_of_packets, fstatus);
 			continue;
 		}
 
@@ -422,18 +421,18 @@ static void msi2500_isoc_handler(struct urb *urb)
 		iso_buf = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 
 		/* Get free framebuffer */
-		fbuf = msi2500_get_next_fill_buf(s);
+		fbuf = msi2500_get_next_fill_buf(dev);
 		if (unlikely(fbuf == NULL)) {
-			s->vb_full++;
-			dev_dbg_ratelimited(s->dev,
-					"videobuf is full, %d packets dropped\n",
-					s->vb_full);
+			dev->vb_full++;
+			dev_dbg_ratelimited(dev->dev,
+					    "videobuf is full, %d packets dropped\n",
+					    dev->vb_full);
 			continue;
 		}
 
 		/* fill framebuffer */
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		flen = msi2500_convert_stream(s, ptr, iso_buf, flen);
+		flen = msi2500_convert_stream(dev, ptr, iso_buf, flen);
 		vb2_set_plane_payload(&fbuf->vb, 0, flen);
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
 	}
@@ -441,66 +440,66 @@ static void msi2500_isoc_handler(struct urb *urb)
 handler_end:
 	i = usb_submit_urb(urb, GFP_ATOMIC);
 	if (unlikely(i != 0))
-		dev_dbg(s->dev, "Error (%d) re-submitting urb\n", i);
+		dev_dbg(dev->dev, "Error (%d) re-submitting urb\n", i);
 }
 
-static void msi2500_iso_stop(struct msi2500_state *s)
+static void msi2500_iso_stop(struct msi2500_dev *dev)
 {
 	int i;
 
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
 	/* Unlinking ISOC buffers one by one */
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
-		if (s->urbs[i]) {
-			dev_dbg(s->dev, "Unlinking URB %p\n", s->urbs[i]);
-			usb_kill_urb(s->urbs[i]);
+		if (dev->urbs[i]) {
+			dev_dbg(dev->dev, "Unlinking URB %p\n", dev->urbs[i]);
+			usb_kill_urb(dev->urbs[i]);
 		}
 	}
 }
 
-static void msi2500_iso_free(struct msi2500_state *s)
+static void msi2500_iso_free(struct msi2500_dev *dev)
 {
 	int i;
 
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
 	/* Freeing ISOC buffers one by one */
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
-		if (s->urbs[i]) {
-			dev_dbg(s->dev, "Freeing URB\n");
-			if (s->urbs[i]->transfer_buffer) {
-				usb_free_coherent(s->udev,
-					s->urbs[i]->transfer_buffer_length,
-					s->urbs[i]->transfer_buffer,
-					s->urbs[i]->transfer_dma);
+		if (dev->urbs[i]) {
+			dev_dbg(dev->dev, "Freeing URB\n");
+			if (dev->urbs[i]->transfer_buffer) {
+				usb_free_coherent(dev->udev,
+					dev->urbs[i]->transfer_buffer_length,
+					dev->urbs[i]->transfer_buffer,
+					dev->urbs[i]->transfer_dma);
 			}
-			usb_free_urb(s->urbs[i]);
-			s->urbs[i] = NULL;
+			usb_free_urb(dev->urbs[i]);
+			dev->urbs[i] = NULL;
 		}
 	}
 }
 
 /* Both v4l2_lock and vb_queue_lock should be locked when calling this */
-static void msi2500_isoc_cleanup(struct msi2500_state *s)
+static void msi2500_isoc_cleanup(struct msi2500_dev *dev)
 {
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
-	msi2500_iso_stop(s);
-	msi2500_iso_free(s);
+	msi2500_iso_stop(dev);
+	msi2500_iso_free(dev);
 }
 
 /* Both v4l2_lock and vb_queue_lock should be locked when calling this */
-static int msi2500_isoc_init(struct msi2500_state *s)
+static int msi2500_isoc_init(struct msi2500_dev *dev)
 {
 	struct urb *urb;
 	int i, j, ret;
 
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
-	s->isoc_errors = 0;
+	dev->isoc_errors = 0;
 
-	ret = usb_set_interface(s->udev, 0, 1);
+	ret = usb_set_interface(dev->udev, 0, 1);
 	if (ret)
 		return ret;
 
@@ -508,29 +507,29 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
 		if (urb == NULL) {
-			dev_err(s->dev, "Failed to allocate urb %d\n", i);
-			msi2500_isoc_cleanup(s);
+			dev_err(dev->dev, "Failed to allocate urb %d\n", i);
+			msi2500_isoc_cleanup(dev);
 			return -ENOMEM;
 		}
-		s->urbs[i] = urb;
-		dev_dbg(s->dev, "Allocated URB at 0x%p\n", urb);
+		dev->urbs[i] = urb;
+		dev_dbg(dev->dev, "Allocated URB at 0x%p\n", urb);
 
 		urb->interval = 1;
-		urb->dev = s->udev;
-		urb->pipe = usb_rcvisocpipe(s->udev, 0x81);
+		urb->dev = dev->udev;
+		urb->pipe = usb_rcvisocpipe(dev->udev, 0x81);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer = usb_alloc_coherent(s->udev,
+		urb->transfer_buffer = usb_alloc_coherent(dev->udev,
 				ISO_BUFFER_SIZE,
 				GFP_KERNEL, &urb->transfer_dma);
 		if (urb->transfer_buffer == NULL) {
-			dev_err(s->dev, "Failed to allocate urb buffer %d\n",
-					i);
-			msi2500_isoc_cleanup(s);
+			dev_err(dev->dev,
+				"Failed to allocate urb buffer %d\n", i);
+			msi2500_isoc_cleanup(dev);
 			return -ENOMEM;
 		}
 		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
 		urb->complete = msi2500_isoc_handler;
-		urb->context = s;
+		urb->context = dev;
 		urb->start_frame = 0;
 		urb->number_of_packets = ISO_FRAMES_PER_DESC;
 		for (j = 0; j < ISO_FRAMES_PER_DESC; j++) {
@@ -541,14 +540,15 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 
 	/* link */
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
-		ret = usb_submit_urb(s->urbs[i], GFP_KERNEL);
+		ret = usb_submit_urb(dev->urbs[i], GFP_KERNEL);
 		if (ret) {
-			dev_err(s->dev, "usb_submit_urb %d failed with error %d\n",
-					i, ret);
-			msi2500_isoc_cleanup(s);
+			dev_err(dev->dev,
+				"usb_submit_urb %d failed with error %d\n",
+				i, ret);
+			msi2500_isoc_cleanup(dev);
 			return ret;
 		}
-		dev_dbg(s->dev, "URB 0x%p submitted.\n", s->urbs[i]);
+		dev_dbg(dev->dev, "URB 0x%p submitted.\n", dev->urbs[i]);
 	}
 
 	/* All is done... */
@@ -556,56 +556,56 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 }
 
 /* Must be called with vb_queue_lock hold */
-static void msi2500_cleanup_queued_bufs(struct msi2500_state *s)
+static void msi2500_cleanup_queued_bufs(struct msi2500_dev *dev)
 {
 	unsigned long flags;
 
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
-	spin_lock_irqsave(&s->queued_bufs_lock, flags);
-	while (!list_empty(&s->queued_bufs)) {
+	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
+	while (!list_empty(&dev->queued_bufs)) {
 		struct msi2500_frame_buf *buf;
 
-		buf = list_entry(s->queued_bufs.next, struct msi2500_frame_buf,
-				 list);
+		buf = list_entry(dev->queued_bufs.next,
+				 struct msi2500_frame_buf, list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
-	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
 
 /* The user yanked out the cable... */
 static void msi2500_disconnect(struct usb_interface *intf)
 {
 	struct v4l2_device *v = usb_get_intfdata(intf);
-	struct msi2500_state *s =
-			container_of(v, struct msi2500_state, v4l2_dev);
+	struct msi2500_dev *dev =
+			container_of(v, struct msi2500_dev, v4l2_dev);
 
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
-	mutex_lock(&s->vb_queue_lock);
-	mutex_lock(&s->v4l2_lock);
+	mutex_lock(&dev->vb_queue_lock);
+	mutex_lock(&dev->v4l2_lock);
 	/* No need to keep the urbs around after disconnection */
-	s->udev = NULL;
-	v4l2_device_disconnect(&s->v4l2_dev);
-	video_unregister_device(&s->vdev);
-	spi_unregister_master(s->master);
-	mutex_unlock(&s->v4l2_lock);
-	mutex_unlock(&s->vb_queue_lock);
-
-	v4l2_device_put(&s->v4l2_dev);
+	dev->udev = NULL;
+	v4l2_device_disconnect(&dev->v4l2_dev);
+	video_unregister_device(&dev->vdev);
+	spi_unregister_master(dev->master);
+	mutex_unlock(&dev->v4l2_lock);
+	mutex_unlock(&dev->vb_queue_lock);
+
+	v4l2_device_put(&dev->v4l2_dev);
 }
 
 static int msi2500_querycap(struct file *file, void *fh,
-		struct v4l2_capability *cap)
+			    struct v4l2_capability *cap)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
-	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
+	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -614,43 +614,46 @@ static int msi2500_querycap(struct file *file, void *fh,
 
 /* Videobuf2 operations */
 static int msi2500_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbuffers,
-		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+			       const struct v4l2_format *fmt,
+			       unsigned int *nbuffers,
+			       unsigned int *nplanes, unsigned int sizes[],
+			       void *alloc_ctxs[])
 {
-	struct msi2500_state *s = vb2_get_drv_priv(vq);
+	struct msi2500_dev *dev = vb2_get_drv_priv(vq);
 
-	dev_dbg(s->dev, "nbuffers=%d\n", *nbuffers);
+	dev_dbg(dev->dev, "nbuffers=%d\n", *nbuffers);
 
 	/* Absolute min and max number of buffers available for mmap() */
 	*nbuffers = clamp_t(unsigned int, *nbuffers, 8, 32);
 	*nplanes = 1;
-	sizes[0] = PAGE_ALIGN(s->buffersize);
-	dev_dbg(s->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
+	sizes[0] = PAGE_ALIGN(dev->buffersize);
+	dev_dbg(dev->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
 	return 0;
 }
 
 static void msi2500_buf_queue(struct vb2_buffer *vb)
 {
-	struct msi2500_state *s = vb2_get_drv_priv(vb->vb2_queue);
-	struct msi2500_frame_buf *buf =
-			container_of(vb, struct msi2500_frame_buf, vb);
+	struct msi2500_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct msi2500_frame_buf *buf = container_of(vb,
+						     struct msi2500_frame_buf,
+						     vb);
 	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
-	if (unlikely(!s->udev)) {
+	if (unlikely(!dev->udev)) {
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
-	spin_lock_irqsave(&s->queued_bufs_lock, flags);
-	list_add_tail(&buf->list, &s->queued_bufs);
-	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
+	list_add_tail(&buf->list, &dev->queued_bufs);
+	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
 
 #define CMD_WREG               0x41
 #define CMD_START_STREAMING    0x43
 #define CMD_STOP_STREAMING     0x45
-#define CMD_READ_UNKNOW        0x48
+#define CMD_READ_UNKNOWN       0x48
 
 #define msi2500_dbg_usb_control_msg(_dev, _r, _t, _v, _i, _b, _l) { \
 	char *_direction; \
@@ -663,7 +666,7 @@ static void msi2500_buf_queue(struct vb2_buffer *vb)
 			_l & 0xff, _l >> 8, _direction, _l, _b); \
 }
 
-static int msi2500_ctrl_msg(struct msi2500_state *s, u8 cmd, u32 data)
+static int msi2500_ctrl_msg(struct msi2500_dev *dev, u8 cmd, u32 data)
 {
 	int ret;
 	u8 request = cmd;
@@ -671,18 +674,18 @@ static int msi2500_ctrl_msg(struct msi2500_state *s, u8 cmd, u32 data)
 	u16 value = (data >> 0) & 0xffff;
 	u16 index = (data >> 16) & 0xffff;
 
-	msi2500_dbg_usb_control_msg(s->dev,
-			request, requesttype, value, index, NULL, 0);
-	ret = usb_control_msg(s->udev, usb_sndctrlpipe(s->udev, 0),
-			request, requesttype, value, index, NULL, 0, 2000);
+	msi2500_dbg_usb_control_msg(dev->dev, request, requesttype,
+				    value, index, NULL, 0);
+	ret = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0), request,
+			      requesttype, value, index, NULL, 0, 2000);
 	if (ret)
-		dev_err(s->dev, "failed %d, cmd %02x, data %04x\n",
-				ret, cmd, data);
+		dev_err(dev->dev, "failed %d, cmd %02x, data %04x\n",
+			ret, cmd, data);
 
 	return ret;
 }
 
-static int msi2500_set_usb_adc(struct msi2500_state *s)
+static int msi2500_set_usb_adc(struct msi2500_dev *dev)
 {
 	int ret;
 	unsigned int f_vco, f_sr, div_n, k, k_cw, div_out;
@@ -690,19 +693,19 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 	struct v4l2_ctrl *bandwidth_auto;
 	struct v4l2_ctrl *bandwidth;
 
-	f_sr = s->f_adc;
+	f_sr = dev->f_adc;
 
 	/* set tuner, subdev, filters according to sampling rate */
-	bandwidth_auto = v4l2_ctrl_find(&s->hdl,
+	bandwidth_auto = v4l2_ctrl_find(&dev->hdl,
 			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
 	if (v4l2_ctrl_g_ctrl(bandwidth_auto)) {
-		bandwidth = v4l2_ctrl_find(&s->hdl,
+		bandwidth = v4l2_ctrl_find(&dev->hdl,
 				V4L2_CID_RF_TUNER_BANDWIDTH);
-		v4l2_ctrl_s_ctrl(bandwidth, s->f_adc);
+		v4l2_ctrl_s_ctrl(bandwidth, dev->f_adc);
 	}
 
 	/* select stream format */
-	switch (s->pixelformat) {
+	switch (dev->pixelformat) {
 	case V4L2_SDR_FMT_CU8:
 		reg7 = 0x000c9407; /* 504 */
 		break;
@@ -787,7 +790,7 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 
 	for (div_out = 4; div_out < 16; div_out += 2) {
 		f_vco = f_sr * div_out * DIV_LO_OUT;
-		dev_dbg(s->dev, "div_out=%d f_vco=%d\n", div_out, f_vco);
+		dev_dbg(dev->dev, "div_out=%u f_vco=%u\n", div_out, f_vco);
 		if (f_vco >= 202000000)
 			break;
 	}
@@ -801,39 +804,39 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 	reg3 |= ((k_cw >> 20) & 0x000001) << 15; /* [20] */
 	reg4 |= ((k_cw >>  0) & 0x0fffff) <<  8; /* [19:0] */
 
-	dev_dbg(s->dev,
+	dev_dbg(dev->dev,
 		"f_sr=%u f_vco=%u div_n=%u k=%u div_out=%u reg3=%08x reg4=%08x\n",
 		f_sr, f_vco, div_n, k, div_out, reg3, reg4);
 
-	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00608008);
+	ret = msi2500_ctrl_msg(dev, CMD_WREG, 0x00608008);
 	if (ret)
 		goto err;
 
-	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00000c05);
+	ret = msi2500_ctrl_msg(dev, CMD_WREG, 0x00000c05);
 	if (ret)
 		goto err;
 
-	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00020000);
+	ret = msi2500_ctrl_msg(dev, CMD_WREG, 0x00020000);
 	if (ret)
 		goto err;
 
-	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00480102);
+	ret = msi2500_ctrl_msg(dev, CMD_WREG, 0x00480102);
 	if (ret)
 		goto err;
 
-	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00f38008);
+	ret = msi2500_ctrl_msg(dev, CMD_WREG, 0x00f38008);
 	if (ret)
 		goto err;
 
-	ret = msi2500_ctrl_msg(s, CMD_WREG, reg7);
+	ret = msi2500_ctrl_msg(dev, CMD_WREG, reg7);
 	if (ret)
 		goto err;
 
-	ret = msi2500_ctrl_msg(s, CMD_WREG, reg4);
+	ret = msi2500_ctrl_msg(dev, CMD_WREG, reg4);
 	if (ret)
 		goto err;
 
-	ret = msi2500_ctrl_msg(s, CMD_WREG, reg3);
+	ret = msi2500_ctrl_msg(dev, CMD_WREG, reg3);
 	if (ret)
 		goto err;
 err:
@@ -842,57 +845,57 @@ err:
 
 static int msi2500_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct msi2500_state *s = vb2_get_drv_priv(vq);
+	struct msi2500_dev *dev = vb2_get_drv_priv(vq);
 	int ret;
 
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
-	if (!s->udev)
+	if (!dev->udev)
 		return -ENODEV;
 
-	if (mutex_lock_interruptible(&s->v4l2_lock))
+	if (mutex_lock_interruptible(&dev->v4l2_lock))
 		return -ERESTARTSYS;
 
 	/* wake-up tuner */
-	v4l2_subdev_call(s->v4l2_subdev, core, s_power, 1);
+	v4l2_subdev_call(dev->v4l2_subdev, core, s_power, 1);
 
-	ret = msi2500_set_usb_adc(s);
+	ret = msi2500_set_usb_adc(dev);
 
-	ret = msi2500_isoc_init(s);
+	ret = msi2500_isoc_init(dev);
 	if (ret)
-		msi2500_cleanup_queued_bufs(s);
+		msi2500_cleanup_queued_bufs(dev);
 
-	ret = msi2500_ctrl_msg(s, CMD_START_STREAMING, 0);
+	ret = msi2500_ctrl_msg(dev, CMD_START_STREAMING, 0);
 
-	mutex_unlock(&s->v4l2_lock);
+	mutex_unlock(&dev->v4l2_lock);
 
 	return ret;
 }
 
 static void msi2500_stop_streaming(struct vb2_queue *vq)
 {
-	struct msi2500_state *s = vb2_get_drv_priv(vq);
+	struct msi2500_dev *dev = vb2_get_drv_priv(vq);
 
-	dev_dbg(s->dev, "\n");
+	dev_dbg(dev->dev, "\n");
 
-	mutex_lock(&s->v4l2_lock);
+	mutex_lock(&dev->v4l2_lock);
 
-	if (s->udev)
-		msi2500_isoc_cleanup(s);
+	if (dev->udev)
+		msi2500_isoc_cleanup(dev);
 
-	msi2500_cleanup_queued_bufs(s);
+	msi2500_cleanup_queued_bufs(dev);
 
 	/* according to tests, at least 700us delay is required  */
 	msleep(20);
-	if (!msi2500_ctrl_msg(s, CMD_STOP_STREAMING, 0)) {
+	if (!msi2500_ctrl_msg(dev, CMD_STOP_STREAMING, 0)) {
 		/* sleep USB IF / ADC */
-		msi2500_ctrl_msg(s, CMD_WREG, 0x01000003);
+		msi2500_ctrl_msg(dev, CMD_WREG, 0x01000003);
 	}
 
 	/* sleep tuner */
-	v4l2_subdev_call(s->v4l2_subdev, core, s_power, 0);
+	v4l2_subdev_call(dev->v4l2_subdev, core, s_power, 0);
 
-	mutex_unlock(&s->v4l2_lock);
+	mutex_unlock(&dev->v4l2_lock);
 }
 
 static struct vb2_ops msi2500_vb2_ops = {
@@ -905,13 +908,13 @@ static struct vb2_ops msi2500_vb2_ops = {
 };
 
 static int msi2500_enum_fmt_sdr_cap(struct file *file, void *priv,
-		struct v4l2_fmtdesc *f)
+				    struct v4l2_fmtdesc *f)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 
-	dev_dbg(s->dev, "index=%d\n", f->index);
+	dev_dbg(dev->dev, "index=%d\n", f->index);
 
-	if (f->index >= s->num_formats)
+	if (f->index >= dev->num_formats)
 		return -EINVAL;
 
 	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
@@ -921,45 +924,45 @@ static int msi2500_enum_fmt_sdr_cap(struct file *file, void *priv,
 }
 
 static int msi2500_g_fmt_sdr_cap(struct file *file, void *priv,
-		struct v4l2_format *f)
+				 struct v4l2_format *f)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 
-	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n",
-			(char *)&s->pixelformat);
+	dev_dbg(dev->dev, "pixelformat fourcc %4.4s\n",
+		(char *)&dev->pixelformat);
 
-	f->fmt.sdr.pixelformat = s->pixelformat;
-	f->fmt.sdr.buffersize = s->buffersize;
+	f->fmt.sdr.pixelformat = dev->pixelformat;
+	f->fmt.sdr.buffersize = dev->buffersize;
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 
 	return 0;
 }
 
 static int msi2500_s_fmt_sdr_cap(struct file *file, void *priv,
-		struct v4l2_format *f)
+				 struct v4l2_format *f)
 {
-	struct msi2500_state *s = video_drvdata(file);
-	struct vb2_queue *q = &s->vb_queue;
+	struct msi2500_dev *dev = video_drvdata(file);
+	struct vb2_queue *q = &dev->vb_queue;
 	int i;
 
-	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n",
-			(char *)&f->fmt.sdr.pixelformat);
+	dev_dbg(dev->dev, "pixelformat fourcc %4.4s\n",
+		(char *)&f->fmt.sdr.pixelformat);
 
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
-	for (i = 0; i < s->num_formats; i++) {
+	for (i = 0; i < dev->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
-			s->pixelformat = formats[i].pixelformat;
-			s->buffersize = formats[i].buffersize;
+			dev->pixelformat = formats[i].pixelformat;
+			dev->buffersize = formats[i].buffersize;
 			f->fmt.sdr.buffersize = formats[i].buffersize;
 			return 0;
 		}
 	}
 
-	s->pixelformat = formats[0].pixelformat;
-	s->buffersize = formats[0].buffersize;
+	dev->pixelformat = formats[0].pixelformat;
+	dev->buffersize = formats[0].buffersize;
 	f->fmt.sdr.pixelformat = formats[0].pixelformat;
 	f->fmt.sdr.buffersize = formats[0].buffersize;
 
@@ -967,16 +970,16 @@ static int msi2500_s_fmt_sdr_cap(struct file *file, void *priv,
 }
 
 static int msi2500_try_fmt_sdr_cap(struct file *file, void *priv,
-		struct v4l2_format *f)
+				   struct v4l2_format *f)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 	int i;
 
-	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n",
-			(char *)&f->fmt.sdr.pixelformat);
+	dev_dbg(dev->dev, "pixelformat fourcc %4.4s\n",
+		(char *)&f->fmt.sdr.pixelformat);
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
-	for (i = 0; i < s->num_formats; i++) {
+	for (i = 0; i < dev->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
 			f->fmt.sdr.buffersize = formats[i].buffersize;
 			return 0;
@@ -990,17 +993,17 @@ static int msi2500_try_fmt_sdr_cap(struct file *file, void *priv,
 }
 
 static int msi2500_s_tuner(struct file *file, void *priv,
-		const struct v4l2_tuner *v)
+			   const struct v4l2_tuner *v)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 	int ret;
 
-	dev_dbg(s->dev, "index=%d\n", v->index);
+	dev_dbg(dev->dev, "index=%d\n", v->index);
 
 	if (v->index == 0)
 		ret = 0;
 	else if (v->index == 1)
-		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, s_tuner, v);
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, s_tuner, v);
 	else
 		ret = -EINVAL;
 
@@ -1009,10 +1012,10 @@ static int msi2500_s_tuner(struct file *file, void *priv,
 
 static int msi2500_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 	int ret;
 
-	dev_dbg(s->dev, "index=%d\n", v->index);
+	dev_dbg(dev->dev, "index=%d\n", v->index);
 
 	if (v->index == 0) {
 		strlcpy(v->name, "Mirics MSi2500", sizeof(v->name));
@@ -1022,7 +1025,7 @@ static int msi2500_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 		v->rangehigh = 15000000;
 		ret = 0;
 	} else if (v->index == 1) {
-		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, g_tuner, v);
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, g_tuner, v);
 	} else {
 		ret = -EINVAL;
 	}
@@ -1031,19 +1034,19 @@ static int msi2500_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 }
 
 static int msi2500_g_frequency(struct file *file, void *priv,
-		struct v4l2_frequency *f)
+			       struct v4l2_frequency *f)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 	int ret  = 0;
 
-	dev_dbg(s->dev, "tuner=%d type=%d\n", f->tuner, f->type);
+	dev_dbg(dev->dev, "tuner=%d type=%d\n", f->tuner, f->type);
 
 	if (f->tuner == 0) {
-		f->frequency = s->f_adc;
+		f->frequency = dev->f_adc;
 		ret = 0;
 	} else if (f->tuner == 1) {
 		f->type = V4L2_TUNER_RF;
-		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, g_frequency, f);
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, g_frequency, f);
 	} else {
 		ret = -EINVAL;
 	}
@@ -1052,22 +1055,22 @@ static int msi2500_g_frequency(struct file *file, void *priv,
 }
 
 static int msi2500_s_frequency(struct file *file, void *priv,
-		const struct v4l2_frequency *f)
+			       const struct v4l2_frequency *f)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 	int ret;
 
-	dev_dbg(s->dev, "tuner=%d type=%d frequency=%u\n",
-			f->tuner, f->type, f->frequency);
+	dev_dbg(dev->dev, "tuner=%d type=%d frequency=%u\n",
+		f->tuner, f->type, f->frequency);
 
 	if (f->tuner == 0) {
-		s->f_adc = clamp_t(unsigned int, f->frequency,
-				bands[0].rangelow,
-				bands[0].rangehigh);
-		dev_dbg(s->dev, "ADC frequency=%u Hz\n", s->f_adc);
-		ret = msi2500_set_usb_adc(s);
+		dev->f_adc = clamp_t(unsigned int, f->frequency,
+				     bands[0].rangelow,
+				     bands[0].rangehigh);
+		dev_dbg(dev->dev, "ADC frequency=%u Hz\n", dev->f_adc);
+		ret = msi2500_set_usb_adc(dev);
 	} else if (f->tuner == 1) {
-		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, s_frequency, f);
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, s_frequency, f);
 	} else {
 		ret = -EINVAL;
 	}
@@ -1076,13 +1079,13 @@ static int msi2500_s_frequency(struct file *file, void *priv,
 }
 
 static int msi2500_enum_freq_bands(struct file *file, void *priv,
-		struct v4l2_frequency_band *band)
+				   struct v4l2_frequency_band *band)
 {
-	struct msi2500_state *s = video_drvdata(file);
+	struct msi2500_dev *dev = video_drvdata(file);
 	int ret;
 
-	dev_dbg(s->dev, "tuner=%d type=%d index=%d\n",
-			band->tuner, band->type, band->index);
+	dev_dbg(dev->dev, "tuner=%d type=%d index=%d\n",
+		band->tuner, band->type, band->index);
 
 	if (band->tuner == 0) {
 		if (band->index >= ARRAY_SIZE(bands)) {
@@ -1092,8 +1095,8 @@ static int msi2500_enum_freq_bands(struct file *file, void *priv,
 			ret = 0;
 		}
 	} else if (band->tuner == 1) {
-		ret = v4l2_subdev_call(s->v4l2_subdev, tuner,
-				enum_freq_bands, band);
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner,
+				       enum_freq_bands, band);
 	} else {
 		ret = -EINVAL;
 	}
@@ -1150,29 +1153,28 @@ static struct video_device msi2500_template = {
 
 static void msi2500_video_release(struct v4l2_device *v)
 {
-	struct msi2500_state *s =
-			container_of(v, struct msi2500_state, v4l2_dev);
+	struct msi2500_dev *dev = container_of(v, struct msi2500_dev, v4l2_dev);
 
-	v4l2_ctrl_handler_free(&s->hdl);
-	v4l2_device_unregister(&s->v4l2_dev);
-	kfree(s);
+	v4l2_ctrl_handler_free(&dev->hdl);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	kfree(dev);
 }
 
 static int msi2500_transfer_one_message(struct spi_master *master,
-		struct spi_message *m)
+					struct spi_message *m)
 {
-	struct msi2500_state *s = spi_master_get_devdata(master);
+	struct msi2500_dev *dev = spi_master_get_devdata(master);
 	struct spi_transfer *t;
 	int ret = 0;
 	u32 data;
 
 	list_for_each_entry(t, &m->transfers, transfer_list) {
-		dev_dbg(s->dev, "msg=%*ph\n", t->len, t->tx_buf);
+		dev_dbg(dev->dev, "msg=%*ph\n", t->len, t->tx_buf);
 		data = 0x09; /* reg 9 is SPI adapter */
 		data |= ((u8 *)t->tx_buf)[0] << 8;
 		data |= ((u8 *)t->tx_buf)[1] << 16;
 		data |= ((u8 *)t->tx_buf)[2] << 24;
-		ret = msi2500_ctrl_msg(s, CMD_WREG, data);
+		ret = msi2500_ctrl_msg(dev, CMD_WREG, data);
 	}
 
 	m->status = ret;
@@ -1181,9 +1183,9 @@ static int msi2500_transfer_one_message(struct spi_master *master,
 }
 
 static int msi2500_probe(struct usb_interface *intf,
-		const struct usb_device_id *id)
+			 const struct usb_device_id *id)
 {
-	struct msi2500_state *s;
+	struct msi2500_dev *dev;
 	struct v4l2_subdev *sd;
 	struct spi_master *master;
 	int ret;
@@ -1194,65 +1196,65 @@ static int msi2500_probe(struct usb_interface *intf,
 		.max_speed_hz		= 12000000,
 	};
 
-	s = kzalloc(sizeof(struct msi2500_state), GFP_KERNEL);
-	if (s == NULL) {
-		dev_err(&intf->dev, "Could not allocate memory for state\n");
-		return -ENOMEM;
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
 	}
 
-	mutex_init(&s->v4l2_lock);
-	mutex_init(&s->vb_queue_lock);
-	spin_lock_init(&s->queued_bufs_lock);
-	INIT_LIST_HEAD(&s->queued_bufs);
-	s->dev = &intf->dev;
-	s->udev = interface_to_usbdev(intf);
-	s->f_adc = bands[0].rangelow;
-	s->pixelformat = formats[0].pixelformat;
-	s->buffersize = formats[0].buffersize;
-	s->num_formats = NUM_FORMATS;
+	mutex_init(&dev->v4l2_lock);
+	mutex_init(&dev->vb_queue_lock);
+	spin_lock_init(&dev->queued_bufs_lock);
+	INIT_LIST_HEAD(&dev->queued_bufs);
+	dev->dev = &intf->dev;
+	dev->udev = interface_to_usbdev(intf);
+	dev->f_adc = bands[0].rangelow;
+	dev->pixelformat = formats[0].pixelformat;
+	dev->buffersize = formats[0].buffersize;
+	dev->num_formats = NUM_FORMATS;
 	if (!msi2500_emulated_fmt)
-		s->num_formats -= 2;
+		dev->num_formats -= 2;
 
 	/* Init videobuf2 queue structure */
-	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
-	s->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
-	s->vb_queue.drv_priv = s;
-	s->vb_queue.buf_struct_size = sizeof(struct msi2500_frame_buf);
-	s->vb_queue.ops = &msi2500_vb2_ops;
-	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
-	s->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	ret = vb2_queue_init(&s->vb_queue);
+	dev->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
+	dev->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	dev->vb_queue.drv_priv = dev;
+	dev->vb_queue.buf_struct_size = sizeof(struct msi2500_frame_buf);
+	dev->vb_queue.ops = &msi2500_vb2_ops;
+	dev->vb_queue.mem_ops = &vb2_vmalloc_memops;
+	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	ret = vb2_queue_init(&dev->vb_queue);
 	if (ret) {
-		dev_err(s->dev, "Could not initialize vb2 queue\n");
+		dev_err(dev->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
 	}
 
 	/* Init video_device structure */
-	s->vdev = msi2500_template;
-	s->vdev.queue = &s->vb_queue;
-	s->vdev.queue->lock = &s->vb_queue_lock;
-	video_set_drvdata(&s->vdev, s);
+	dev->vdev = msi2500_template;
+	dev->vdev.queue = &dev->vb_queue;
+	dev->vdev.queue->lock = &dev->vb_queue_lock;
+	video_set_drvdata(&dev->vdev, dev);
 
 	/* Register the v4l2_device structure */
-	s->v4l2_dev.release = msi2500_video_release;
-	ret = v4l2_device_register(&intf->dev, &s->v4l2_dev);
+	dev->v4l2_dev.release = msi2500_video_release;
+	ret = v4l2_device_register(&intf->dev, &dev->v4l2_dev);
 	if (ret) {
-		dev_err(s->dev, "Failed to register v4l2-device (%d)\n", ret);
+		dev_err(dev->dev, "Failed to register v4l2-device (%d)\n", ret);
 		goto err_free_mem;
 	}
 
 	/* SPI master adapter */
-	master = spi_alloc_master(s->dev, 0);
+	master = spi_alloc_master(dev->dev, 0);
 	if (master == NULL) {
 		ret = -ENOMEM;
 		goto err_unregister_v4l2_dev;
 	}
 
-	s->master = master;
+	dev->master = master;
 	master->bus_num = 0;
 	master->num_chipselect = 1;
 	master->transfer_one_message = msi2500_transfer_one_message;
-	spi_master_set_devdata(master, s);
+	spi_master_set_devdata(master, dev);
 	ret = spi_register_master(master);
 	if (ret) {
 		spi_master_put(master);
@@ -1260,57 +1262,57 @@ static int msi2500_probe(struct usb_interface *intf,
 	}
 
 	/* load v4l2 subdevice */
-	sd = v4l2_spi_new_subdev(&s->v4l2_dev, master, &board_info);
-	s->v4l2_subdev = sd;
+	sd = v4l2_spi_new_subdev(&dev->v4l2_dev, master, &board_info);
+	dev->v4l2_subdev = sd;
 	if (sd == NULL) {
-		dev_err(s->dev, "cannot get v4l2 subdevice\n");
+		dev_err(dev->dev, "cannot get v4l2 subdevice\n");
 		ret = -ENODEV;
 		goto err_unregister_master;
 	}
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->hdl, 0);
-	if (s->hdl.error) {
-		ret = s->hdl.error;
-		dev_err(s->dev, "Could not initialize controls\n");
+	v4l2_ctrl_handler_init(&dev->hdl, 0);
+	if (dev->hdl.error) {
+		ret = dev->hdl.error;
+		dev_err(dev->dev, "Could not initialize controls\n");
 		goto err_free_controls;
 	}
 
 	/* currently all controls are from subdev */
-	v4l2_ctrl_add_handler(&s->hdl, sd->ctrl_handler, NULL);
+	v4l2_ctrl_add_handler(&dev->hdl, sd->ctrl_handler, NULL);
 
-	s->v4l2_dev.ctrl_handler = &s->hdl;
-	s->vdev.v4l2_dev = &s->v4l2_dev;
-	s->vdev.lock = &s->v4l2_lock;
+	dev->v4l2_dev.ctrl_handler = &dev->hdl;
+	dev->vdev.v4l2_dev = &dev->v4l2_dev;
+	dev->vdev.lock = &dev->v4l2_lock;
 
-	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
+	ret = video_register_device(&dev->vdev, VFL_TYPE_SDR, -1);
 	if (ret) {
-		dev_err(s->dev, "Failed to register as video device (%d)\n",
-				ret);
+		dev_err(dev->dev,
+			"Failed to register as video device (%d)\n", ret);
 		goto err_unregister_v4l2_dev;
 	}
-	dev_info(s->dev, "Registered as %s\n",
-			video_device_node_name(&s->vdev));
-	dev_notice(s->dev, "SDR API is still slightly experimental and functionality changes may follow\n");
-
+	dev_info(dev->dev, "Registered as %s\n",
+		 video_device_node_name(&dev->vdev));
+	dev_notice(dev->dev,
+		   "SDR API is still slightly experimental and functionality changes may follow\n");
 	return 0;
-
 err_free_controls:
-	v4l2_ctrl_handler_free(&s->hdl);
+	v4l2_ctrl_handler_free(&dev->hdl);
 err_unregister_master:
-	spi_unregister_master(s->master);
+	spi_unregister_master(dev->master);
 err_unregister_v4l2_dev:
-	v4l2_device_unregister(&s->v4l2_dev);
+	v4l2_device_unregister(&dev->v4l2_dev);
 err_free_mem:
-	kfree(s);
+	kfree(dev);
+err:
 	return ret;
 }
 
 /* USB device ID list */
 static struct usb_device_id msi2500_id_table[] = {
-	{ USB_DEVICE(0x1df7, 0x2500) }, /* Mirics MSi3101 SDR Dongle */
-	{ USB_DEVICE(0x2040, 0xd300) }, /* Hauppauge WinTV 133559 LF */
-	{ }
+	{USB_DEVICE(0x1df7, 0x2500)}, /* Mirics MSi3101 SDR Dongle */
+	{USB_DEVICE(0x2040, 0xd300)}, /* Hauppauge WinTV 133559 LF */
+	{}
 };
 MODULE_DEVICE_TABLE(usb, msi2500_id_table);
 
-- 
http://palosaari.fi/

