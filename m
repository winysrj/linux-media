Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:51527 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3ADVAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:08 -0500
Received: by mail-vc0-f178.google.com with SMTP id l6so3155275vcl.9
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:00:07 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 15/15] em28xx: convert to videobuf2
Date: Fri,  4 Jan 2013 15:59:45 -0500
Message-Id: <1357333186-8466-16-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch converts the em28xx driver over to videobuf2.  It is
likely that em28xx_fh can go away entirely, but that will come in
a separate patch.

[mchehab@redhat.com: fix a non-trivial merge conflict with some VBI
 patches]

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/Kconfig        |    3 +-
 drivers/media/usb/em28xx/em28xx-cards.c |    7 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   |    4 +-
 drivers/media/usb/em28xx/em28xx-vbi.c   |  123 ++---
 drivers/media/usb/em28xx/em28xx-video.c |  743 +++++++++++--------------------
 drivers/media/usb/em28xx/em28xx.h       |   30 +-
 6 files changed, 327 insertions(+), 583 deletions(-)

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index 094c4ec..c754a80 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_EM28XX
 	depends on VIDEO_DEV && I2C
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	select VIDEOBUF_VMALLOC
+	select VIDEOBUF2_VMALLOC
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_MSP3400 if MEDIA_SUBDRV_AUTOSELECT
@@ -48,7 +48,6 @@ config VIDEO_EM28XX_DVB
 	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
-	select VIDEOBUF_DVB
 	---help---
 	  This adds support for DVB cards based on the
 	  Empiatech em28xx chips.
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4117d38..0a4c868 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -57,7 +57,7 @@ module_param(disable_usb_speed_check, int, 0444);
 MODULE_PARM_DESC(disable_usb_speed_check,
 		 "override min bandwidth requirement of 480M bps");
 
-static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
+static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card,     "card type");
 
@@ -2965,6 +2965,8 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	const char *chip_name = default_chip_name;
 
 	dev->udev = udev;
+	mutex_init(&dev->vb_queue_lock);
+	mutex_init(&dev->vb_vbi_queue_lock);
 	mutex_init(&dev->ctrl_urb_lock);
 	spin_lock_init(&dev->slock);
 
@@ -3411,6 +3413,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
 
+	/* initialize videobuf2 stuff */
+	em28xx_vb2_setup(dev);
+
 	/* allocate device struct */
 	mutex_init(&dev->lock);
 	mutex_lock(&dev->lock);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a70b19e..01bb800 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -27,7 +27,9 @@
 
 #include "em28xx.h"
 #include <media/v4l2-common.h>
-#include <media/videobuf-vmalloc.h>
+#include <dvb_demux.h>
+#include <dvb_net.h>
+#include <dmxdev.h>
 #include <media/tuner.h>
 #include "tuner-simple.h"
 #include <linux/gpio.h>
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index d74713b..9fcfc910 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -41,105 +41,72 @@ MODULE_PARM_DESC(vbi_debug, "enable debug messages [vbi]");
 
 /* ------------------------------------------------------------------ */
 
-static void
-free_buffer(struct videobuf_queue *vq, struct em28xx_buffer *buf)
+static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+                           unsigned int *nbuffers, unsigned int *nplanes,
+                           unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct em28xx_fh     *fh  = vq->priv_data;
-	struct em28xx        *dev = fh->dev;
-	unsigned long flags = 0;
-	if (in_interrupt())
-		BUG();
-
-	/* We used to wait for the buffer to finish here, but this didn't work
-	   because, as we were keeping the state as VIDEOBUF_QUEUED,
-	   videobuf_queue_cancel marked it as finished for us.
-	   (Also, it could wedge forever if the hardware was misconfigured.)
-
-	   This should be safe; by the time we get here, the buffer isn't
-	   queued anymore. If we ever start marking the buffers as
-	   VIDEOBUF_ACTIVE, it won't be, though.
-	*/
-	spin_lock_irqsave(&dev->slock, flags);
-	if (dev->usb_ctl.vbi_buf == buf)
-		dev->usb_ctl.vbi_buf = NULL;
-	spin_unlock_irqrestore(&dev->slock, flags);
+	struct em28xx *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
 
-	videobuf_vmalloc_free(&buf->vb);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
-}
+	if (fmt)
+		size = fmt->fmt.pix.sizeimage;
+	else
+		size = dev->vbi_width * dev->vbi_height * 2;
 
-static int
-vbi_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
-{
-	struct em28xx_fh     *fh  = q->priv_data;
-	struct em28xx        *dev = fh->dev;
+	if (0 == *nbuffers)
+		*nbuffers = 32;
+	if (*nbuffers < 2)
+		*nbuffers = 2;
+	if (*nbuffers > 32)
+		*nbuffers = 32;
 
-	*size = dev->vbi_width * dev->vbi_height * 2;
+	*nplanes = 1;
+	sizes[0] = size;
 
-	if (0 == *count)
-		*count = vbibufs;
-	if (*count < 2)
-		*count = 2;
-	if (*count > 32)
-		*count = 32;
 	return 0;
 }
 
-static int
-vbi_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-	    enum v4l2_field field)
+static int vbi_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct em28xx_fh     *fh  = q->priv_data;
-	struct em28xx        *dev = fh->dev;
+	struct em28xx        *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
-	int                  rc = 0;
+	unsigned long        size;
 
-	buf->vb.size = dev->vbi_width * dev->vbi_height * 2;
+	size = dev->vbi_width * dev->vbi_height * 2;
 
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
+	if (vb2_plane_size(vb, 0) < size) {
+		printk(KERN_INFO "%s data will not fit into plane (%lu < %lu)\n",
+		       __func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
-
-	buf->vb.width  = dev->vbi_width;
-	buf->vb.height = dev->vbi_height;
-	buf->vb.field  = field;
-
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		rc = videobuf_iolock(q, &buf->vb, NULL);
-		if (rc < 0)
-			goto fail;
 	}
+	vb2_set_plane_payload(&buf->vb, 0, size);
 
-	buf->vb.state = VIDEOBUF_PREPARED;
 	return 0;
-
-fail:
-	free_buffer(q, buf);
-	return rc;
 }
 
 static void
-vbi_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-	struct em28xx_buffer    *buf     = container_of(vb,
-							struct em28xx_buffer,
-							vb);
-	struct em28xx_fh        *fh      = vq->priv_data;
-	struct em28xx           *dev     = fh->dev;
-	struct em28xx_dmaqueue  *vbiq    = &dev->vbiq;
-
-	buf->vb.state = VIDEOBUF_QUEUED;
-	list_add_tail(&buf->vb.queue, &vbiq->active);
-}
-
-static void vbi_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+vbi_buffer_queue(struct vb2_buffer *vb)
 {
+	struct em28xx *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
-	free_buffer(q, buf);
+	struct em28xx_dmaqueue *vbiq = &dev->vbiq;
+	unsigned long flags = 0;
+
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	list_add_tail(&buf->list, &vbiq->active);
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-struct videobuf_queue_ops em28xx_vbi_qops = {
-	.buf_setup    = vbi_setup,
-	.buf_prepare  = vbi_prepare,
-	.buf_queue    = vbi_queue,
-	.buf_release  = vbi_release,
+
+struct vb2_ops em28xx_vbi_qops = {
+	.queue_setup    = vbi_queue_setup,
+	.buf_prepare    = vbi_buffer_prepare,
+	.buf_queue      = vbi_buffer_queue,
+	.start_streaming = em28xx_start_analog_streaming,
+	.stop_streaming = em28xx_stop_vbi_streaming,
+	.wait_prepare   = vb2_ops_wait_prepare,
+	.wait_finish    = vb2_ops_wait_finish,
 };
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3adaa7b..4dbd7aa 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -76,9 +76,9 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EM28XX_VERSION);
 
-static unsigned int video_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
-static unsigned int vbi_nr[]   = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
-static unsigned int radio_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
+static unsigned int video_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
+static unsigned int vbi_nr[]   = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
+static unsigned int radio_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
 
 module_param_array(video_nr, int, NULL, 0444);
 module_param_array(vbi_nr, int, NULL, 0444);
@@ -136,12 +136,13 @@ static struct em28xx_fmt format[] = {
 static inline void finish_buffer(struct em28xx *dev,
 				 struct em28xx_buffer *buf)
 {
-	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
-	buf->vb.state = VIDEOBUF_DONE;
-	buf->vb.field_count++;
-	v4l2_get_timestamp(&buf->vb.ts);
-	list_del(&buf->vb.queue);
-	wake_up(&buf->vb.done);
+	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
+
+	buf->vb.v4l2_buf.sequence = dev->field_count++;
+	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 }
 
 /*
@@ -156,8 +157,8 @@ static void em28xx_copy_video(struct em28xx *dev,
 	int  linesdone, currlinedone, offset, lencopy, remain;
 	int bytesperline = dev->width << 1;
 
-	if (buf->pos + len > buf->vb.size)
-		len = buf->vb.size - buf->pos;
+	if (buf->pos + len > buf->length)
+		len = buf->length - buf->pos;
 
 	startread = usb_buf;
 	remain = len;
@@ -179,11 +180,11 @@ static void em28xx_copy_video(struct em28xx *dev,
 	lencopy = bytesperline - currlinedone;
 	lencopy = lencopy > remain ? remain : lencopy;
 
-	if ((char *)startwrite + lencopy > (char *)buf->vb_buf + buf->vb.size) {
+	if ((char *)startwrite + lencopy > (char *)buf->vb_buf + buf->length) {
 		em28xx_isocdbg("Overflow of %zi bytes past buffer end (1)\n",
 			      ((char *)startwrite + lencopy) -
-			      ((char *)buf->vb_buf + buf->vb.size));
-		remain = (char *)buf->vb_buf + buf->vb.size -
+			      ((char *)buf->vb_buf + buf->length));
+		remain = (char *)buf->vb_buf + buf->length -
 			 (char *)startwrite;
 		lencopy = remain;
 	}
@@ -205,13 +206,13 @@ static void em28xx_copy_video(struct em28xx *dev,
 			lencopy = bytesperline;
 
 		if ((char *)startwrite + lencopy > (char *)buf->vb_buf +
-		    buf->vb.size) {
+		    buf->length) {
 			em28xx_isocdbg("Overflow of %zi bytes past buffer end"
 				       "(2)\n",
 				       ((char *)startwrite + lencopy) -
-				       ((char *)buf->vb_buf + buf->vb.size));
-			lencopy = remain = (char *)buf->vb_buf + buf->vb.size -
-					   (char *)startwrite;
+				       ((char *)buf->vb_buf + buf->length));
+			lencopy = remain = (char *)buf->vb_buf + buf->length -
+				(char *)startwrite;
 		}
 		if (lencopy <= 0)
 			break;
@@ -234,8 +235,8 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 {
 	unsigned int offset;
 
-	if (buf->pos + len > buf->vb.size)
-		len = buf->vb.size - buf->pos;
+	if (buf->pos + len > buf->length)
+		len = buf->length - buf->pos;
 
 	offset = buf->pos;
 	/* Make sure the bottom field populates the second half of the frame */
@@ -292,7 +293,6 @@ static inline struct em28xx_buffer *get_next_buf(struct em28xx *dev,
 						 struct em28xx_dmaqueue *dma_q)
 {
 	struct em28xx_buffer *buf;
-	char *outp;
 
 	if (list_empty(&dma_q->active)) {
 		em28xx_isocdbg("No active queue to serve\n");
@@ -300,12 +300,11 @@ static inline struct em28xx_buffer *get_next_buf(struct em28xx *dev,
 	}
 
 	/* Get the next buffer */
-	buf = list_entry(dma_q->active.next, struct em28xx_buffer, vb.queue);
+	buf = list_entry(dma_q->active.next, struct em28xx_buffer, list);
 	/* Cleans up buffer - Useful for testing for frame/URB loss */
-	outp = videobuf_to_vmalloc(&buf->vb);
-	memset(outp, 0, buf->vb.size);
+	list_del(&buf->list);
 	buf->pos = 0;
-	buf->vb_buf = outp;
+	buf->vb_buf = buf->mem;
 
 	return buf;
 }
@@ -467,92 +466,118 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 }
 
 
+static int get_ressource(enum v4l2_buf_type f_type)
+{
+	switch (f_type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return EM28XX_RESOURCE_VIDEO;
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+		return EM28XX_RESOURCE_VBI;
+	default:
+		BUG();
+		return 0;
+	}
+}
+
+/* Usage lock check functions */
+static int res_get(struct em28xx *dev, enum v4l2_buf_type f_type)
+{
+	int res_type = get_ressource(f_type);
+
+	/* is it free? */
+	if (dev->resources & res_type) {
+		/* no, someone else uses it */
+		return -EBUSY;
+	}
+
+	/* it's free, grab it */
+	dev->resources |= res_type;
+	em28xx_videodbg("res: get %d\n", res_type);
+	return 0;
+}
+
+static void res_free(struct em28xx *dev, enum v4l2_buf_type f_type)
+{
+	int res_type = get_ressource(f_type);
+
+	dev->resources &= ~res_type;
+	em28xx_videodbg("res: put %d\n", res_type);
+}
+
 /* ------------------------------------------------------------------
-	Videobuf operations
+	Videobuf2 operations
    ------------------------------------------------------------------*/
 
-static int
-buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned int *nbuffers, unsigned int *nplanes,
+		       unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct em28xx_fh *fh = vq->priv_data;
-	struct em28xx        *dev = fh->dev;
-	struct v4l2_frequency f;
-
-	*size = (fh->dev->width * fh->dev->height * dev->format->depth + 7)
-		>> 3;
+	struct em28xx *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
 
-	if (0 == *count)
-		*count = EM28XX_DEF_BUF;
+	if (fmt)
+		size = fmt->fmt.pix.sizeimage;
+	else
+		size = (dev->width * dev->height * dev->format->depth + 7) >> 3;
 
-	if (*count < EM28XX_MIN_BUF)
-		*count = EM28XX_MIN_BUF;
+	if (size == 0)
+		return -EINVAL;
 
-	/* Ask tuner to go to analog or radio mode */
-	memset(&f, 0, sizeof(f));
-	f.frequency = dev->ctl_freq;
-	f.type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	if (0 == *nbuffers)
+		*nbuffers = 32;
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
+	*nplanes = 1;
+	sizes[0] = size;
 
 	return 0;
 }
 
-/* This is called *without* dev->slock held; please keep it that way */
-static void free_buffer(struct videobuf_queue *vq, struct em28xx_buffer *buf)
+static int
+buffer_prepare(struct vb2_buffer *vb)
 {
-	struct em28xx_fh     *fh  = vq->priv_data;
-	struct em28xx        *dev = fh->dev;
-	unsigned long flags = 0;
-	if (in_interrupt())
-		BUG();
+	struct em28xx        *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
+	unsigned long size;
 
-	/* We used to wait for the buffer to finish here, but this didn't work
-	   because, as we were keeping the state as VIDEOBUF_QUEUED,
-	   videobuf_queue_cancel marked it as finished for us.
-	   (Also, it could wedge forever if the hardware was misconfigured.)
+	em28xx_videodbg("%s, field=%d\n", __func__, vb->v4l2_buf.field);
 
-	   This should be safe; by the time we get here, the buffer isn't
-	   queued anymore. If we ever start marking the buffers as
-	   VIDEOBUF_ACTIVE, it won't be, though.
-	*/
-	spin_lock_irqsave(&dev->slock, flags);
-	if (dev->usb_ctl.vid_buf == buf)
-		dev->usb_ctl.vid_buf = NULL;
-	spin_unlock_irqrestore(&dev->slock, flags);
+	size = (dev->width * dev->height * dev->format->depth + 7) >> 3;
 
-	videobuf_vmalloc_free(&buf->vb);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+	if (vb2_plane_size(vb, 0) < size) {
+		em28xx_videodbg("%s data will not fit into plane (%lu < %lu)\n",
+				__func__, vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+	vb2_set_plane_payload(&buf->vb, 0, size);
+
+	return 0;
 }
 
-static int
-buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
-						enum v4l2_field field)
+int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct em28xx_fh     *fh  = vq->priv_data;
-	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
-	struct em28xx        *dev = fh->dev;
-	int                  rc = 0, urb_init = 0;
+	struct em28xx *dev = vb2_get_drv_priv(vq);
+	struct v4l2_frequency f;
+	int rc = 0;
 
-	buf->vb.size = (fh->dev->width * fh->dev->height * dev->format->depth
-			+ 7) >> 3;
+	em28xx_videodbg("%s\n", __func__);
 
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
-		return -EINVAL;
+	/* Make sure streaming is not already in progress for this type
+	   of filehandle (e.g. video, vbi) */
+	rc = res_get(dev, vq->type);
+	if (rc)
+		return rc;
 
-	buf->vb.width  = dev->width;
-	buf->vb.height = dev->height;
-	buf->vb.field  = field;
+	if (dev->streaming_users++ == 0) {
+		/* First active streaming user, so allocate all the URBs */
 
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		rc = videobuf_iolock(vq, &buf->vb, NULL);
-		if (rc < 0)
-			goto fail;
-	}
+		/* Allocate the USB bandwidth */
+		em28xx_set_alternate(dev);
 
-	if (!dev->usb_ctl.analog_bufs.num_bufs)
-		urb_init = 1;
+		/* Needed, since GPIO might have disabled power of
+		   some i2c device
+		*/
+		em28xx_wake_i2c(dev);
 
-	if (urb_init) {
 		dev->capture_type = -1;
 		rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
 					  dev->analog_xfer_bulk,
@@ -562,52 +587,142 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 					  em28xx_urb_data_copy);
 		if (rc < 0)
 			goto fail;
-	}
 
-	buf->vb.state = VIDEOBUF_PREPARED;
-	return 0;
+		/* djh: it's not clear whether this code is still needed.  I'm
+		   leaving it in here for now entirely out of concern for backward
+		   compatibility (the old code did it) */
+
+		/* Ask tuner to go to analog or radio mode */
+		memset(&f, 0, sizeof(f));
+		f.frequency = dev->ctl_freq;
+		if (vq->owner && vq->owner->vdev->vfl_type == VFL_TYPE_RADIO)
+			f.type = V4L2_TUNER_RADIO;
+		else
+			f.type = V4L2_TUNER_ANALOG_TV;
+		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
+	}
 
 fail:
-	free_buffer(vq, buf);
 	return rc;
 }
 
-static void
-buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+int em28xx_stop_streaming(struct vb2_queue *vq)
 {
-	struct em28xx_buffer    *buf     = container_of(vb,
-							struct em28xx_buffer,
-							vb);
-	struct em28xx_fh        *fh      = vq->priv_data;
-	struct em28xx           *dev     = fh->dev;
-	struct em28xx_dmaqueue  *vidq    = &dev->vidq;
+	struct em28xx *dev = vb2_get_drv_priv(vq);
+	struct em28xx_dmaqueue *vidq = &dev->vidq;
+	unsigned long flags = 0;
+
+	em28xx_videodbg("%s\n", __func__);
+
+	res_free(dev, vq->type);
 
-	buf->vb.state = VIDEOBUF_QUEUED;
-	list_add_tail(&buf->vb.queue, &vidq->active);
+	if (dev->streaming_users-- == 1) {
+		/* Last active user, so shutdown all the URBS */
+		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
+	}
 
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&vidq->active)) {
+		struct em28xx_buffer *buf;
+		buf = list_entry(vidq->active.next, struct em28xx_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	dev->usb_ctl.vid_buf = NULL;
+	spin_unlock_irqrestore(&dev->slock, flags);
+
+	return 0;
 }
 
-static void buffer_release(struct videobuf_queue *vq,
-				struct videobuf_buffer *vb)
+int em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 {
-	struct em28xx_buffer   *buf  = container_of(vb,
-						    struct em28xx_buffer,
-						    vb);
-	struct em28xx_fh       *fh   = vq->priv_data;
-	struct em28xx          *dev  = (struct em28xx *)fh->dev;
+	struct em28xx *dev = vb2_get_drv_priv(vq);
+	struct em28xx_dmaqueue *vbiq = &dev->vbiq;
+	unsigned long flags = 0;
+
+	em28xx_videodbg("%s\n", __func__);
 
-	em28xx_isocdbg("em28xx: called buffer_release\n");
+	res_free(dev, vq->type);
 
-	free_buffer(vq, buf);
+	if (dev->streaming_users-- == 1) {
+		/* Last active user, so shutdown all the URBS */
+		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
+	}
+
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&vbiq->active)) {
+		struct em28xx_buffer *buf;
+		buf = list_entry(vbiq->active.next, struct em28xx_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	dev->usb_ctl.vbi_buf = NULL;
+	spin_unlock_irqrestore(&dev->slock, flags);
+
+	return 0;
 }
 
-static struct videobuf_queue_ops em28xx_video_qops = {
-	.buf_setup      = buffer_setup,
+static void
+buffer_queue(struct vb2_buffer *vb)
+{
+	struct em28xx *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_dmaqueue *vidq = &dev->vidq;
+	unsigned long flags = 0;
+
+	em28xx_videodbg("%s\n", __func__);
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	list_add_tail(&buf->list, &vidq->active);
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+static struct vb2_ops em28xx_video_qops = {
+	.queue_setup    = queue_setup,
 	.buf_prepare    = buffer_prepare,
 	.buf_queue      = buffer_queue,
-	.buf_release    = buffer_release,
+	.start_streaming = em28xx_start_analog_streaming,
+	.stop_streaming = em28xx_stop_streaming,
+	.wait_prepare   = vb2_ops_wait_prepare,
+	.wait_finish    = vb2_ops_wait_finish,
 };
 
+int em28xx_vb2_setup(struct em28xx *dev)
+{
+	int rc;
+	struct vb2_queue *q;
+
+	/* Setup Videobuf2 for Video capture */
+	q = &dev->vb_vidq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct em28xx_buffer);
+	q->ops = &em28xx_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+
+	rc = vb2_queue_init(q);
+	if (rc < 0)
+		return rc;
+
+	/* Setup Videobuf2 for VBI capture */
+	q = &dev->vb_vbiq;
+	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
+	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct em28xx_buffer);
+	q->ops = &em28xx_vbi_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+
+	rc = vb2_queue_init(q);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
 /*********************  v4l2 interface  **************************************/
 
 static void video_mux(struct em28xx *dev, int index)
@@ -640,61 +755,6 @@ static void video_mux(struct em28xx *dev, int index)
 	em28xx_audio_analog_set(dev);
 }
 
-/* Usage lock check functions */
-static int res_get(struct em28xx_fh *fh, unsigned int bit)
-{
-	struct em28xx    *dev = fh->dev;
-
-	if (fh->resources & bit)
-		/* have it already allocated */
-		return 1;
-
-	/* is it free? */
-	if (dev->resources & bit) {
-		/* no, someone else uses it */
-		return 0;
-	}
-	/* it's free, grab it */
-	fh->resources  |= bit;
-	dev->resources |= bit;
-	em28xx_videodbg("res: get %d\n", bit);
-	return 1;
-}
-
-static int res_check(struct em28xx_fh *fh, unsigned int bit)
-{
-	return fh->resources & bit;
-}
-
-static int res_locked(struct em28xx *dev, unsigned int bit)
-{
-	return dev->resources & bit;
-}
-
-static void res_free(struct em28xx_fh *fh, unsigned int bits)
-{
-	struct em28xx    *dev = fh->dev;
-
-	BUG_ON((fh->resources & bits) != bits);
-
-	fh->resources  &= ~bits;
-	dev->resources &= ~bits;
-	em28xx_videodbg("res: put %d\n", bits);
-}
-
-static int get_ressource(struct em28xx_fh *fh)
-{
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		return EM28XX_RESOURCE_VIDEO;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		return EM28XX_RESOURCE_VBI;
-	default:
-		BUG();
-		return 0;
-	}
-}
-
 void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
 {
 	struct em28xx *dev = priv;
@@ -875,7 +935,6 @@ static int em28xx_set_video_format(struct em28xx *dev, unsigned int fourcc,
 	/* set new image size */
 	get_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
 
-	em28xx_set_alternate(dev);
 	em28xx_resolution_set(dev);
 
 	return 0;
@@ -884,21 +943,13 @@ static int em28xx_set_video_format(struct em28xx *dev, unsigned int fourcc,
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *f)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
+	struct em28xx *dev = video_drvdata(file);
 
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
+	if (dev->streaming_users > 0)
+		return -EBUSY;
 
 	vidioc_try_fmt_vid_cap(file, priv, f);
 
-	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		em28xx_errdev("%s queue busy\n", __func__);
-		return -EBUSY;
-	}
-
 	return em28xx_set_video_format(dev, f->fmt.pix.pixelformat,
 				f->fmt.pix.width, f->fmt.pix.height);
 }
@@ -952,10 +1003,8 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	if (rc < 0)
 		return rc;
 
-	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		em28xx_errdev("%s queue busy\n", __func__);
+	if (dev->streaming_users > 0)
 		return -EBUSY;
-	}
 
 	dev->norm = *norm;
 
@@ -1358,69 +1407,6 @@ static int vidioc_cropcap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_streamon(struct file *file, void *priv,
-					enum v4l2_buf_type type)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc = -EINVAL;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (unlikely(type != fh->type))
-		return -EINVAL;
-
-	em28xx_videodbg("vidioc_streamon fh=%p t=%d fh->res=%d dev->res=%d\n",
-			fh, type, fh->resources, dev->resources);
-
-	if (unlikely(!res_get(fh, get_ressource(fh))))
-		return -EBUSY;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		rc = videobuf_streamon(&fh->vb_vidq);
-	else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
-		rc = videobuf_streamon(&fh->vb_vbiq);
-
-	return rc;
-}
-
-static int vidioc_streamoff(struct file *file, void *priv,
-					enum v4l2_buf_type type)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    fh->type != V4L2_BUF_TYPE_VBI_CAPTURE)
-		return -EINVAL;
-	if (type != fh->type)
-		return -EINVAL;
-
-	em28xx_videodbg("vidioc_streamoff fh=%p t=%d fh->res=%d dev->res=%d\n",
-			fh, type, fh->resources, dev->resources);
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (res_check(fh, EM28XX_RESOURCE_VIDEO)) {
-			videobuf_streamoff(&fh->vb_vidq);
-			res_free(fh, EM28XX_RESOURCE_VIDEO);
-		}
-	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		if (res_check(fh, EM28XX_RESOURCE_VBI)) {
-			videobuf_streamoff(&fh->vb_vbiq);
-			res_free(fh, EM28XX_RESOURCE_VBI);
-		}
-	}
-
-	return 0;
-}
-
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
@@ -1566,83 +1552,6 @@ static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *rb)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return videobuf_reqbufs(&fh->vb_vidq, rb);
-	else
-		return videobuf_reqbufs(&fh->vb_vbiq, rb);
-}
-
-static int vidioc_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *b)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return videobuf_querybuf(&fh->vb_vidq, b);
-	else {
-		/* FIXME: I'm not sure yet whether this is a bug in zvbi or
-		   the videobuf framework, but we probably shouldn't be
-		   returning a buffer larger than that which was asked for.
-		   At a minimum, it causes a crash in zvbi since it does
-		   a memcpy based on the source buffer length */
-		int result = videobuf_querybuf(&fh->vb_vbiq, b);
-		b->length = dev->vbi_width * dev->vbi_height * 2;
-
-		return result;
-	}
-}
-
-static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return videobuf_qbuf(&fh->vb_vidq, b);
-	else
-		return videobuf_qbuf(&fh->vb_vbiq, b);
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return videobuf_dqbuf(&fh->vb_vidq, b, file->f_flags &
-				      O_NONBLOCK);
-	else
-		return videobuf_dqbuf(&fh->vb_vbiq, b, file->f_flags &
-				      O_NONBLOCK);
-}
-
 /* ----------------------------------------------------------- */
 /* RADIO ESPECIFIC IOCTLS                                      */
 /* ----------------------------------------------------------- */
@@ -1682,12 +1591,10 @@ static int radio_s_tuner(struct file *file, void *priv,
  */
 static int em28xx_v4l2_open(struct file *filp)
 {
-	int errCode = 0, radio = 0;
 	struct video_device *vdev = video_devdata(filp);
 	struct em28xx *dev = video_drvdata(filp);
 	enum v4l2_buf_type fh_type = 0;
 	struct em28xx_fh *fh;
-	enum v4l2_field field;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -1696,9 +1603,6 @@ static int em28xx_v4l2_open(struct file *filp)
 	case VFL_TYPE_VBI:
 		fh_type = V4L2_BUF_TYPE_VBI_CAPTURE;
 		break;
-	case VFL_TYPE_RADIO:
-		radio = 1;
-		break;
 	}
 
 	em28xx_videodbg("open dev=%s type=%s users=%d\n",
@@ -1716,13 +1620,11 @@ static int em28xx_v4l2_open(struct file *filp)
 	}
 	v4l2_fh_init(&fh->fh, vdev);
 	fh->dev = dev;
-	fh->radio = radio;
 	fh->type = fh_type;
 	filp->private_data = fh;
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
-		em28xx_set_alternate(dev);
 		em28xx_resolution_set(dev);
 
 		/* Needed, since GPIO might have disabled power of
@@ -1731,32 +1633,18 @@ static int em28xx_v4l2_open(struct file *filp)
 		em28xx_wake_i2c(dev);
 
 	}
-	if (fh->radio) {
+
+	if (vdev->vfl_type == VFL_TYPE_RADIO) {
 		em28xx_videodbg("video_open: setting radio device\n");
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
 	}
 
 	dev->users++;
 
-	if (dev->progressive)
-		field = V4L2_FIELD_NONE;
-	else
-		field = V4L2_FIELD_INTERLACED;
-
-	videobuf_queue_vmalloc_init(&fh->vb_vidq, &em28xx_video_qops,
-				    NULL, &dev->slock,
-				    V4L2_BUF_TYPE_VIDEO_CAPTURE, field,
-				    sizeof(struct em28xx_buffer), fh, &dev->lock);
-
-	videobuf_queue_vmalloc_init(&fh->vb_vbiq, &em28xx_vbi_qops,
-				    NULL, &dev->slock,
-				    V4L2_BUF_TYPE_VBI_CAPTURE,
-				    V4L2_FIELD_SEQ_TB,
-				    sizeof(struct em28xx_buffer), fh, &dev->lock);
 	mutex_unlock(&dev->lock);
 	v4l2_fh_add(&fh->fh);
 
-	return errCode;
+	return 0;
 }
 
 /*
@@ -1810,15 +1698,7 @@ static int em28xx_v4l2_close(struct file *filp)
 	em28xx_videodbg("users=%d\n", dev->users);
 
 	mutex_lock(&dev->lock);
-	if (res_check(fh, EM28XX_RESOURCE_VIDEO)) {
-		videobuf_stop(&fh->vb_vidq);
-		res_free(fh, EM28XX_RESOURCE_VIDEO);
-	}
-
-	if (res_check(fh, EM28XX_RESOURCE_VBI)) {
-		videobuf_stop(&fh->vb_vbiq);
-		res_free(fh, EM28XX_RESOURCE_VBI);
-	}
+	vb2_fop_release(filp);
 
 	if (dev->users == 1) {
 		/* the device is already disconnect,
@@ -1828,7 +1708,6 @@ static int em28xx_v4l2_close(struct file *filp)
 			kfree(dev->alt_max_pkt_size_isoc);
 			mutex_unlock(&dev->lock);
 			kfree(dev);
-			kfree(fh);
 			return 0;
 		}
 
@@ -1836,7 +1715,6 @@ static int em28xx_v4l2_close(struct file *filp)
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
 
 		/* do this before setting alternate! */
-		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 		em28xx_set_mode(dev, EM28XX_SUSPEND);
 
 		/* set alternate 0 */
@@ -1848,141 +1726,19 @@ static int em28xx_v4l2_close(struct file *filp)
 					"0 (error=%i)\n", errCode);
 		}
 	}
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
 
-	videobuf_mmap_free(&fh->vb_vidq);
-	videobuf_mmap_free(&fh->vb_vbiq);
-	kfree(fh);
 	dev->users--;
 	mutex_unlock(&dev->lock);
 	return 0;
 }
 
-/*
- * em28xx_v4l2_read()
- * will allocate buffers when called for the first time
- */
-static ssize_t
-em28xx_v4l2_read(struct file *filp, char __user *buf, size_t count,
-		 loff_t *pos)
-{
-	struct em28xx_fh *fh = filp->private_data;
-	struct em28xx *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (mutex_lock_interruptible(&dev->lock))
-		return -ERESTARTSYS;
-	/* FIXME: read() is not prepared to allow changing the video
-	   resolution while streaming. Seems a bug at em28xx_set_fmt
-	 */
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (res_locked(dev, EM28XX_RESOURCE_VIDEO))
-			rc = -EBUSY;
-		else
-			rc = videobuf_read_stream(&fh->vb_vidq, buf, count, pos, 0,
-					filp->f_flags & O_NONBLOCK);
-	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		if (!res_get(fh, EM28XX_RESOURCE_VBI))
-			rc = -EBUSY;
-		else
-			rc = videobuf_read_stream(&fh->vb_vbiq, buf, count, pos, 0,
-					filp->f_flags & O_NONBLOCK);
-	}
-	mutex_unlock(&dev->lock);
-
-	return rc;
-}
-
-/*
- * em28xx_poll()
- * will allocate buffers when called for the first time
- */
-static unsigned int em28xx_poll(struct file *filp, poll_table *wait)
-{
-	struct em28xx_fh *fh = filp->private_data;
-	unsigned long req_events = poll_requested_events(wait);
-	struct em28xx *dev = fh->dev;
-	unsigned int res = 0;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return DEFAULT_POLLMASK;
-
-	if (v4l2_event_pending(&fh->fh))
-		res = POLLPRI;
-	else if (req_events & POLLPRI)
-		poll_wait(filp, &fh->fh.wait, wait);
-
-	if (req_events & (POLLIN | POLLRDNORM)) {
-		if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-			if (!res_get(fh, EM28XX_RESOURCE_VIDEO))
-				return res | POLLERR;
-			return videobuf_poll_stream(filp, &fh->vb_vidq, wait);
-		}
-		if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-			if (!res_get(fh, EM28XX_RESOURCE_VBI))
-				return res | POLLERR;
-			return res | videobuf_poll_stream(filp, &fh->vb_vbiq, wait);
-		}
-	}
-	return res;
-}
-
-static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table *wait)
-{
-	struct em28xx_fh *fh = filp->private_data;
-	struct em28xx *dev = fh->dev;
-	unsigned int res;
-
-	mutex_lock(&dev->lock);
-	res = em28xx_poll(filp, wait);
-	mutex_unlock(&dev->lock);
-	return res;
-}
-
-/*
- * em28xx_v4l2_mmap()
- */
-static int em28xx_v4l2_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct em28xx_fh *fh    = filp->private_data;
-	struct em28xx	 *dev   = fh->dev;
-	int		 rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (mutex_lock_interruptible(&dev->lock))
-		return -ERESTARTSYS;
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		rc = videobuf_mmap_mapper(&fh->vb_vidq, vma);
-	else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
-		rc = videobuf_mmap_mapper(&fh->vb_vbiq, vma);
-	mutex_unlock(&dev->lock);
-
-	em28xx_videodbg("vma start=0x%08lx, size=%ld, ret=%d\n",
-		(unsigned long)vma->vm_start,
-		(unsigned long)vma->vm_end-(unsigned long)vma->vm_start,
-		rc);
-
-	return rc;
-}
-
 static const struct v4l2_file_operations em28xx_v4l_fops = {
 	.owner         = THIS_MODULE,
 	.open          = em28xx_v4l2_open,
 	.release       = em28xx_v4l2_close,
-	.read          = em28xx_v4l2_read,
-	.poll          = em28xx_v4l2_poll,
-	.mmap          = em28xx_v4l2_mmap,
+	.read          = vb2_fop_read,
+	.poll          = vb2_fop_poll,
+	.mmap          = vb2_fop_mmap,
 	.unlocked_ioctl = video_ioctl2,
 };
 
@@ -2000,10 +1756,13 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_audio             = vidioc_s_audio,
 	.vidioc_cropcap             = vidioc_cropcap,
 
-	.vidioc_reqbufs             = vidioc_reqbufs,
-	.vidioc_querybuf            = vidioc_querybuf,
-	.vidioc_qbuf                = vidioc_qbuf,
-	.vidioc_dqbuf               = vidioc_dqbuf,
+	.vidioc_reqbufs             = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs         = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf         = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf            = vb2_ioctl_querybuf,
+	.vidioc_qbuf                = vb2_ioctl_qbuf,
+	.vidioc_dqbuf               = vb2_ioctl_dqbuf,
+
 	.vidioc_g_std               = vidioc_g_std,
 	.vidioc_querystd            = vidioc_querystd,
 	.vidioc_s_std               = vidioc_s_std,
@@ -2012,8 +1771,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input          = vidioc_enum_input,
 	.vidioc_g_input             = vidioc_g_input,
 	.vidioc_s_input             = vidioc_s_input,
-	.vidioc_streamon            = vidioc_streamon,
-	.vidioc_streamoff           = vidioc_streamoff,
+	.vidioc_streamon            = vb2_ioctl_streamon,
+	.vidioc_streamoff           = vb2_ioctl_streamoff,
 	.vidioc_g_tuner             = vidioc_g_tuner,
 	.vidioc_s_tuner             = vidioc_s_tuner,
 	.vidioc_g_frequency         = vidioc_g_frequency,
@@ -2029,7 +1788,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 
 static const struct video_device em28xx_video_template = {
 	.fops                       = &em28xx_v4l_fops,
-	.release                    = video_device_release,
+	.release                    = video_device_release_empty,
 	.ioctl_ops 		    = &video_ioctl_ops,
 
 	.tvnorms                    = V4L2_STD_ALL,
@@ -2078,7 +1837,6 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 
 	*vfd		= *template;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
-	vfd->release	= video_device_release;
 	vfd->debug	= video_debug;
 	vfd->lock	= &dev->lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
@@ -2139,6 +1897,8 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		em28xx_errdev("cannot allocate video_device.\n");
 		return -ENODEV;
 	}
+	dev->vdev->queue = &dev->vb_vidq;
+	dev->vdev->queue->lock = &dev->vb_queue_lock;
 
 	/* register v4l2 video video_device */
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
@@ -2154,6 +1914,9 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		dev->vbi_dev = em28xx_vdev_init(dev, &em28xx_video_template,
 						"vbi");
 
+		dev->vbi_dev->queue = &dev->vb_vbiq;
+		dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
+
 		/* register v4l2 vbi video_device */
 		ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
 					    vbi_nr[dev->devno]);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7432be4..bf0a790 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -31,15 +31,12 @@
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 
-#include <media/videobuf-vmalloc.h>
+#include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/rc-core.h>
-#if defined(CONFIG_VIDEO_EM28XX_DVB) || defined(CONFIG_VIDEO_EM28XX_DVB_MODULE)
-#include <media/videobuf-dvb.h>
-#endif
 #include "tuner-xc2028.h"
 #include "xc5000.h"
 #include "em28xx-reg.h"
@@ -252,8 +249,11 @@ struct em28xx_fmt {
 /* buffer for one video frame */
 struct em28xx_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
+	struct vb2_buffer vb;
+	struct list_head list;
 
+	void *mem;
+	unsigned int length;
 	int top_field;
 
 	/* counter to control buffer fill */
@@ -480,11 +480,6 @@ struct em28xx;
 struct em28xx_fh {
 	struct v4l2_fh fh;
 	struct em28xx *dev;
-	int           radio;
-	unsigned int  resources;
-
-	struct videobuf_queue        vb_vidq;
-	struct videobuf_queue        vb_vbiq;
 
 	enum v4l2_buf_type           type;
 };
@@ -545,6 +540,7 @@ struct em28xx {
 	struct i2c_client i2c_client;
 	/* video for linux */
 	int users;		/* user count for exclusive use */
+	int streaming_users;    /* Number of actively streaming users */
 	struct video_device *vdev;	/* video for linux device struct */
 	v4l2_std_id norm;	/* selected tv norm */
 	int ctl_freq;		/* selected frequency */
@@ -587,6 +583,12 @@ struct em28xx {
 	struct video_device *vbi_dev;
 	struct video_device *radio_dev;
 
+	/* Videobuf2 */
+	struct vb2_queue vb_vidq;
+	struct vb2_queue vb_vbiq;
+	struct mutex vb_queue_lock;
+	struct mutex vb_vbi_queue_lock;
+
 	/* resources in use */
 	unsigned int resources;
 
@@ -598,6 +600,9 @@ struct em28xx {
 	struct em28xx_usb_ctl usb_ctl;
 	spinlock_t slock;
 
+	unsigned int field_count;
+	unsigned int vbi_field_count;
+
 	/* usb transfer */
 	struct usb_device *udev;	/* the usb device */
 	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
@@ -709,9 +714,12 @@ void em28xx_init_extension(struct em28xx *dev);
 void em28xx_close_extension(struct em28xx *dev);
 
 /* Provided by em28xx-video.c */
+int em28xx_vb2_setup(struct em28xx *dev);
 int em28xx_register_analog_devices(struct em28xx *dev);
 void em28xx_release_analog_resources(struct em28xx *dev);
 void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv);
+int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
+int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
 extern const struct v4l2_ctrl_ops em28xx_ctrl_ops;
 
 /* Provided by em28xx-cards.c */
@@ -723,7 +731,7 @@ int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_release_resources(struct em28xx *dev);
 
 /* Provided by em28xx-vbi.c */
-extern struct videobuf_queue_ops em28xx_vbi_qops;
+extern struct vb2_ops em28xx_vbi_qops;
 
 /* printk macros */
 
-- 
1.7.9.5

