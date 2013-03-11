Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1670 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab3CKLrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 34/42] go7007: convert to core locking and vb2.
Date: Mon, 11 Mar 2013 12:46:12 +0100
Message-Id: <bcab489848f0872e2551a746a394eb1d7f80a01a.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert this driver to videobuf2 and core locking.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/Kconfig          |    2 +-
 drivers/staging/media/go7007/go7007-driver.c  |  156 ++++---
 drivers/staging/media/go7007/go7007-priv.h    |   27 +-
 drivers/staging/media/go7007/go7007-usb.c     |    9 +-
 drivers/staging/media/go7007/go7007-v4l2.c    |  535 ++++++-------------------
 drivers/staging/media/go7007/saa7134-go7007.c |    2 +-
 6 files changed, 205 insertions(+), 526 deletions(-)

diff --git a/drivers/staging/media/go7007/Kconfig b/drivers/staging/media/go7007/Kconfig
index da32031..46cb7bf 100644
--- a/drivers/staging/media/go7007/Kconfig
+++ b/drivers/staging/media/go7007/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
 	depends on VIDEO_DEV && PCI && I2C
 	depends on SND
-	select VIDEOBUF_DMA_SG
+	select VIDEOBUF2_VMALLOC
 	depends on RC_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 732b452..075de4d 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -363,48 +363,54 @@ start_error:
 /*
  * Store a byte in the current video buffer, if there is one.
  */
-static inline void store_byte(struct go7007_buffer *gobuf, u8 byte)
+static inline void store_byte(struct go7007_buffer *vb, u8 byte)
 {
-	if (gobuf != NULL && gobuf->bytesused < GO7007_BUF_SIZE) {
-		unsigned int pgidx = gobuf->offset >> PAGE_SHIFT;
-		unsigned int pgoff = gobuf->offset & ~PAGE_MASK;
+	if (vb && vb->vb.v4l2_planes[0].bytesused < GO7007_BUF_SIZE) {
+		u8 *ptr = vb2_plane_vaddr(&vb->vb, 0);
 
-		*((u8 *)page_address(gobuf->pages[pgidx]) + pgoff) = byte;
-		++gobuf->offset;
-		++gobuf->bytesused;
+		ptr[vb->vb.v4l2_planes[0].bytesused++] = byte;
 	}
 }
 
 /*
  * Deliver the last video buffer and get a new one to start writing to.
  */
-static void frame_boundary(struct go7007 *go)
+static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buffer *vb)
 {
-	struct go7007_buffer *gobuf;
+	struct go7007_buffer *vb_tmp = NULL;
+	u32 *bytesused = &vb->vb.v4l2_planes[0].bytesused;
 	int i;
 
-	if (go->active_buf) {
-		if (go->active_buf->modet_active) {
-			if (go->active_buf->bytesused + 216 < GO7007_BUF_SIZE) {
+	if (vb) {
+		if (vb->modet_active) {
+			if (*bytesused + 216 < GO7007_BUF_SIZE) {
 				for (i = 0; i < 216; ++i)
-					store_byte(go->active_buf,
-							go->active_map[i]);
-				go->active_buf->bytesused -= 216;
+					store_byte(vb, go->active_map[i]);
+				*bytesused -= 216;
 			} else
-				go->active_buf->modet_active = 0;
+				vb->modet_active = 0;
 		}
-		go->active_buf->state = BUF_STATE_DONE;
-		wake_up_interruptible(&go->frame_waitq);
-		go->active_buf = NULL;
+		vb->vb.v4l2_buf.sequence = go->next_seq++;
+		v4l2_get_timestamp(&vb->vb.v4l2_buf.timestamp);
+		vb_tmp = vb;
+		spin_lock(&go->spinlock);
+		list_del(&vb->list);
+		if (list_empty(&go->vidq_active))
+			vb = NULL;
+		else
+			vb = list_first_entry(&go->vidq_active, struct go7007_buffer, list);
+		go->active_buf = vb;
+		spin_unlock(&go->spinlock);
+		vb2_buffer_done(&vb_tmp->vb, VB2_BUF_STATE_DONE);
+		return vb;
 	}
-	list_for_each_entry(gobuf, &go->stream, stream)
-		if (gobuf->state == BUF_STATE_QUEUED) {
-			gobuf->seq = go->next_seq;
-			do_gettimeofday(&gobuf->timestamp);
-			go->active_buf = gobuf;
-			break;
-		}
-	++go->next_seq;
+	spin_lock(&go->spinlock);
+	if (!list_empty(&go->vidq_active))
+		vb = go->active_buf =
+			list_first_entry(&go->vidq_active, struct go7007_buffer, list);
+	spin_unlock(&go->spinlock);
+	go->next_seq++;
+	return vb;
 }
 
 static void write_bitmap_word(struct go7007 *go)
@@ -428,10 +434,9 @@ static void write_bitmap_word(struct go7007 *go)
  */
 void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 {
+	struct go7007_buffer *vb = go->active_buf;
 	int i, seq_start_code = -1, frame_start_code = -1;
 
-	spin_lock(&go->spinlock);
-
 	switch (go->format) {
 	case V4L2_PIX_FMT_MPEG4:
 		seq_start_code = 0xB0;
@@ -445,13 +450,12 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 	}
 
 	for (i = 0; i < length; ++i) {
-		if (go->active_buf != NULL &&
-			    go->active_buf->bytesused >= GO7007_BUF_SIZE - 3) {
+		if (vb && vb->vb.v4l2_planes[0].bytesused >= GO7007_BUF_SIZE - 3) {
 			v4l2_info(&go->v4l2_dev, "dropping oversized frame\n");
-			go->active_buf->offset -= go->active_buf->bytesused;
-			go->active_buf->bytesused = 0;
-			go->active_buf->modet_active = 0;
-			go->active_buf = NULL;
+			vb->vb.v4l2_planes[0].bytesused = 0;
+			vb->frame_offset = 0;
+			vb->modet_active = 0;
+			vb = go->active_buf = NULL;
 		}
 
 		switch (go->state) {
@@ -464,7 +468,7 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 				go->state = STATE_FF;
 				break;
 			default:
-				store_byte(go->active_buf, buf[i]);
+				store_byte(vb, buf[i]);
 				break;
 			}
 			break;
@@ -474,12 +478,12 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 				go->state = STATE_00_00;
 				break;
 			case 0xFF:
-				store_byte(go->active_buf, 0x00);
+				store_byte(vb, 0x00);
 				go->state = STATE_FF;
 				break;
 			default:
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, buf[i]);
+				store_byte(vb, 0x00);
+				store_byte(vb, buf[i]);
 				go->state = STATE_DATA;
 				break;
 			}
@@ -487,21 +491,21 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 		case STATE_00_00:
 			switch (buf[i]) {
 			case 0x00:
-				store_byte(go->active_buf, 0x00);
+				store_byte(vb, 0x00);
 				/* go->state remains STATE_00_00 */
 				break;
 			case 0x01:
 				go->state = STATE_00_00_01;
 				break;
 			case 0xFF:
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, 0x00);
+				store_byte(vb, 0x00);
+				store_byte(vb, 0x00);
 				go->state = STATE_FF;
 				break;
 			default:
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, buf[i]);
+				store_byte(vb, 0x00);
+				store_byte(vb, 0x00);
+				store_byte(vb, buf[i]);
 				go->state = STATE_DATA;
 				break;
 			}
@@ -509,10 +513,10 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 		case STATE_00_00_01:
 			if (buf[i] == 0xF8 && go->modet_enable == 0) {
 				/* MODET start code, but MODET not enabled */
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, 0x01);
-				store_byte(go->active_buf, 0xF8);
+				store_byte(vb, 0x00);
+				store_byte(vb, 0x00);
+				store_byte(vb, 0x01);
+				store_byte(vb, 0xF8);
 				go->state = STATE_DATA;
 				break;
 			}
@@ -521,19 +525,14 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 			if ((go->format == V4L2_PIX_FMT_MPEG1 ||
 			     go->format == V4L2_PIX_FMT_MPEG2 ||
 			     go->format == V4L2_PIX_FMT_MPEG4) &&
-					(buf[i] == seq_start_code ||
-						buf[i] == 0xB8 || /* GOP code */
-						buf[i] == frame_start_code)) {
-				if (go->active_buf == NULL || go->seen_frame)
-					frame_boundary(go);
-				if (buf[i] == frame_start_code) {
-					if (go->active_buf != NULL)
-						go->active_buf->frame_offset =
-							go->active_buf->offset;
-					go->seen_frame = 1;
-				} else {
-					go->seen_frame = 0;
-				}
+			    (buf[i] == seq_start_code ||
+			     buf[i] == 0xB8 || /* GOP code */
+			     buf[i] == frame_start_code)) {
+				if (vb == NULL || go->seen_frame)
+					vb = frame_boundary(go, vb);
+				go->seen_frame = buf[i] == frame_start_code;
+				if (vb && go->seen_frame)
+					vb->frame_offset = vb->vb.v4l2_planes[0].bytesused;
 			}
 			/* Handle any special chunk types, or just write the
 			 * start code to the (potentially new) buffer */
@@ -552,16 +551,16 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 				go->state = STATE_MODET_MAP;
 				break;
 			case 0xFF: /* Potential JPEG start code */
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, 0x01);
+				store_byte(vb, 0x00);
+				store_byte(vb, 0x00);
+				store_byte(vb, 0x01);
 				go->state = STATE_FF;
 				break;
 			default:
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, 0x00);
-				store_byte(go->active_buf, 0x01);
-				store_byte(go->active_buf, buf[i]);
+				store_byte(vb, 0x00);
+				store_byte(vb, 0x00);
+				store_byte(vb, 0x01);
+				store_byte(vb, buf[i]);
 				go->state = STATE_DATA;
 				break;
 			}
@@ -569,20 +568,20 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 		case STATE_FF:
 			switch (buf[i]) {
 			case 0x00:
-				store_byte(go->active_buf, 0xFF);
+				store_byte(vb, 0xFF);
 				go->state = STATE_00;
 				break;
 			case 0xFF:
-				store_byte(go->active_buf, 0xFF);
+				store_byte(vb, 0xFF);
 				/* go->state remains STATE_FF */
 				break;
 			case 0xD8:
 				if (go->format == V4L2_PIX_FMT_MJPEG)
-					frame_boundary(go);
+					vb = frame_boundary(go, vb);
 				/* fall through */
 			default:
-				store_byte(go->active_buf, 0xFF);
-				store_byte(go->active_buf, buf[i]);
+				store_byte(vb, 0xFF);
+				store_byte(vb, buf[i]);
 				go->state = STATE_DATA;
 				break;
 			}
@@ -605,8 +604,8 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 					write_bitmap_word(go);
 				} else
 					go->modet_word = buf[i] << 8;
-			} else if (go->parse_length == 207 && go->active_buf) {
-				go->active_buf->modet_active = buf[i];
+			} else if (go->parse_length == 207 && vb) {
+				vb->modet_active = buf[i];
 			}
 			if (++go->parse_length == 208)
 				go->state = STATE_DATA;
@@ -617,8 +616,6 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 			break;
 		}
 	}
-
-	spin_unlock(&go->spinlock);
 }
 EXPORT_SYMBOL(go7007_parse_video_stream);
 
@@ -648,14 +645,12 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	go->i2c_adapter_online = 0;
 	go->interrupt_available = 0;
 	init_waitqueue_head(&go->interrupt_waitq);
-	go->in_use = 0;
 	go->input = 0;
 	go7007_update_board(go);
 	go->encoder_h_halve = 0;
 	go->encoder_v_halve = 0;
 	go->encoder_subsample = 0;
 	go->format = V4L2_PIX_FMT_MJPEG;
-	go->streaming = 0;
 	go->bitrate = 1500000;
 	go->fps_scale = 1;
 	go->pali = 0;
@@ -674,7 +669,6 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 		go->modet_map[i] = 0;
 	go->audio_deliver = NULL;
 	go->audio_enabled = 0;
-	INIT_LIST_HEAD(&go->stream);
 
 	return go;
 }
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 2c0afb1..30148eb 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -24,6 +24,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
+#include <media/videobuf2-core.h>
 
 struct go7007;
 
@@ -125,20 +126,10 @@ struct go7007_hpi_ops {
 #define	GO7007_BUF_SIZE		(GO7007_BUF_PAGES << PAGE_SHIFT)
 
 struct go7007_buffer {
-	struct go7007 *go; /* Reverse reference for VMA ops */
-	int index; /* Reverse reference for DQBUF */
-	enum { BUF_STATE_IDLE, BUF_STATE_QUEUED, BUF_STATE_DONE } state;
-	u32 seq;
-	struct timeval timestamp;
-	struct list_head stream;
-	struct page *pages[GO7007_BUF_PAGES + 1]; /* extra for straddling */
-	unsigned long user_addr;
-	unsigned int page_count;
-	unsigned int offset;
-	unsigned int bytesused;
+	struct vb2_buffer vb;
+	struct list_head list;
 	unsigned int frame_offset;
 	u32 modet_active;
-	int mapped;
 };
 
 #define GO7007_RATIO_1_1	0
@@ -178,8 +169,7 @@ struct go7007 {
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
 	spinlock_t spinlock;
 	struct mutex hw_lock;
-	int streaming;
-	int in_use;
+	struct mutex serialize_lock;
 	int audio_enabled;
 	struct v4l2_subdev *sd_video;
 	struct v4l2_subdev *sd_audio;
@@ -226,17 +216,16 @@ struct go7007 {
 	unsigned char active_map[216];
 
 	/* Video streaming */
-	struct go7007_buffer *active_buf;
+	struct mutex queue_lock;
+	struct vb2_queue vidq;
 	enum go7007_parser_state state;
 	int parse_length;
 	u16 modet_word;
 	int seen_frame;
 	u32 next_seq;
-	struct list_head stream;
+	struct list_head vidq_active;
 	wait_queue_head_t frame_waitq;
-	int buf_count;
-	struct go7007_buffer *bufs;
-	struct v4l2_fh *bufs_owner;
+	struct go7007_buffer *active_buf;
 
 	/* Audio streaming */
 	void (*audio_deliver)(struct go7007 *go, u8 *buf, int length);
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 5c7a19e6..c95538c 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -780,7 +780,7 @@ static void go7007_usb_read_video_pipe_complete(struct urb *urb)
 	struct go7007 *go = (struct go7007 *)urb->context;
 	int r, status = urb->status;
 
-	if (!go->streaming) {
+	if (!vb2_is_streaming(&go->vidq)) {
 		wake_up_interruptible(&go->frame_waitq);
 		return;
 	}
@@ -804,7 +804,7 @@ static void go7007_usb_read_audio_pipe_complete(struct urb *urb)
 	struct go7007 *go = (struct go7007 *)urb->context;
 	int r, status = urb->status;
 
-	if (!go->streaming)
+	if (!vb2_is_streaming(&go->vidq))
 		return;
 	if (status) {
 		printk(KERN_ERR "go7007-usb: error in audio pipe: %d\n",
@@ -1316,12 +1316,17 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 {
 	struct go7007 *go = to_go7007(usb_get_intfdata(intf));
 
+	mutex_lock(&go->queue_lock);
+	mutex_lock(&go->serialize_lock);
+
 	if (go->audio_enabled)
 		go7007_snd_remove(go);
 
 	go->status = STATUS_SHUTDOWN;
 	v4l2_device_disconnect(&go->v4l2_dev);
 	video_unregister_device(go->video_dev);
+	mutex_unlock(&go->serialize_lock);
+	mutex_unlock(&go->queue_lock);
 
 	v4l2_device_put(&go->v4l2_dev);
 }
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 191af80..46db491 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -35,6 +35,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-vmalloc.h>
 #include <media/saa7115.h>
 
 #include "go7007.h"
@@ -43,66 +44,6 @@
 #define call_all(dev, o, f, args...) \
 	v4l2_device_call_until_err(dev, 0, o, f, ##args)
 
-static void deactivate_buffer(struct go7007_buffer *gobuf)
-{
-	int i;
-
-	if (gobuf->state != BUF_STATE_IDLE) {
-		list_del(&gobuf->stream);
-		gobuf->state = BUF_STATE_IDLE;
-	}
-	if (gobuf->page_count > 0) {
-		for (i = 0; i < gobuf->page_count; ++i)
-			page_cache_release(gobuf->pages[i]);
-		gobuf->page_count = 0;
-	}
-}
-
-static void abort_queued(struct go7007 *go)
-{
-	struct go7007_buffer *gobuf, *next;
-
-	list_for_each_entry_safe(gobuf, next, &go->stream, stream) {
-		deactivate_buffer(gobuf);
-	}
-}
-
-static int go7007_streamoff(struct go7007 *go)
-{
-	unsigned long flags;
-
-	mutex_lock(&go->hw_lock);
-	if (go->streaming) {
-		go->streaming = 0;
-		go7007_stream_stop(go);
-		spin_lock_irqsave(&go->spinlock, flags);
-		abort_queued(go);
-		spin_unlock_irqrestore(&go->spinlock, flags);
-		go7007_reset_encoder(go);
-	}
-	mutex_unlock(&go->hw_lock);
-	v4l2_ctrl_grab(go->mpeg_video_gop_size, false);
-	v4l2_ctrl_grab(go->mpeg_video_gop_closure, false);
-	v4l2_ctrl_grab(go->mpeg_video_bitrate, false);
-	v4l2_ctrl_grab(go->mpeg_video_aspect_ratio, false);
-	return 0;
-}
-
-static int go7007_release(struct file *file)
-{
-	struct go7007 *go = video_drvdata(file);
-
-	if (file->private_data == go->bufs_owner && go->buf_count > 0) {
-		go7007_streamoff(go);
-		go->in_use = 0;
-		kfree(go->bufs);
-		go->bufs = NULL;
-		go->buf_count = 0;
-		go->bufs_owner = NULL;
-	}
-	return v4l2_fh_release(file);
-}
-
 static bool valid_pixelformat(u32 pixelformat)
 {
 	switch (pixelformat) {
@@ -116,15 +57,15 @@ static bool valid_pixelformat(u32 pixelformat)
 	}
 }
 
-static u32 get_frame_type_flag(struct go7007_buffer *gobuf, int format)
+static u32 get_frame_type_flag(struct go7007_buffer *vb, int format)
 {
-	u8 *f = page_address(gobuf->pages[0]);
+	u8 *ptr = vb2_plane_vaddr(&vb->vb, 0);
 
 	switch (format) {
 	case V4L2_PIX_FMT_MJPEG:
 		return V4L2_BUF_FLAG_KEYFRAME;
 	case V4L2_PIX_FMT_MPEG4:
-		switch ((f[gobuf->frame_offset + 4] >> 6) & 0x3) {
+		switch ((ptr[vb->frame_offset + 4] >> 6) & 0x3) {
 		case 0:
 			return V4L2_BUF_FLAG_KEYFRAME;
 		case 1:
@@ -136,7 +77,7 @@ static u32 get_frame_type_flag(struct go7007_buffer *gobuf, int format)
 		}
 	case V4L2_PIX_FMT_MPEG1:
 	case V4L2_PIX_FMT_MPEG2:
-		switch ((f[gobuf->frame_offset + 5] >> 3) & 0x7) {
+		switch ((ptr[vb->frame_offset + 5] >> 3) & 0x7) {
 		case 1:
 			return V4L2_BUF_FLAG_KEYFRAME;
 		case 2:
@@ -412,7 +353,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, go->name, sizeof(cap->card));
 	strlcpy(cap->bus_info, go->bus_info, sizeof(cap->bus_info));
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+				V4L2_CAP_STREAMING;
 
 	if (go->board_info->num_aud_inputs)
 		cap->device_caps |= V4L2_CAP_AUDIO;
@@ -485,293 +427,125 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct go7007 *go = video_drvdata(file);
 
-	if (go->streaming)
+	if (vb2_is_busy(&go->vidq))
 		return -EBUSY;
 
 	return set_capture_size(go, fmt, 0);
 }
 
-static int vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *req)
+static int go7007_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+		unsigned int *num_buffers, unsigned int *num_planes,
+		unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct go7007 *go = video_drvdata(file);
-	int retval = -EBUSY;
-	unsigned int count, i;
-
-	if (go->streaming)
-		return retval;
-
-	if (req->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-			req->memory != V4L2_MEMORY_MMAP)
-		return -EINVAL;
-
-	for (i = 0; i < go->buf_count; ++i)
-		if (go->bufs[i].mapped > 0)
-			goto unlock_and_return;
-
-	set_formatting(go);
-	mutex_lock(&go->hw_lock);
-	if (go->in_use > 0 && go->buf_count == 0) {
-		mutex_unlock(&go->hw_lock);
-		goto unlock_and_return;
-	}
+	sizes[0] = GO7007_BUF_SIZE;
+	*num_planes = 1;
 
-	if (go->buf_count > 0)
-		kfree(go->bufs);
-
-	retval = -ENOMEM;
-	count = req->count;
-	if (count > 0) {
-		if (count < 2)
-			count = 2;
-		if (count > 32)
-			count = 32;
-
-		go->bufs = kcalloc(count, sizeof(struct go7007_buffer),
-				     GFP_KERNEL);
-
-		if (!go->bufs) {
-			mutex_unlock(&go->hw_lock);
-			goto unlock_and_return;
-		}
-
-		for (i = 0; i < count; ++i) {
-			go->bufs[i].go = go;
-			go->bufs[i].index = i;
-			go->bufs[i].state = BUF_STATE_IDLE;
-			go->bufs[i].mapped = 0;
-		}
-
-		go->in_use = 1;
-		go->bufs_owner = file->private_data;
-	} else {
-		go->in_use = 0;
-		go->bufs_owner = NULL;
-	}
-
-	go->buf_count = count;
-	mutex_unlock(&go->hw_lock);
-
-	memset(req, 0, sizeof(*req));
-
-	req->count = count;
-	req->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	req->memory = V4L2_MEMORY_MMAP;
+	if (*num_buffers < 2)
+		*num_buffers = 2;
 
 	return 0;
-
-unlock_and_return:
-	return retval;
 }
 
-static int vidioc_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
+static void go7007_buf_queue(struct vb2_buffer *vb)
 {
-	struct go7007 *go = video_drvdata(file);
-	int retval = -EINVAL;
-	unsigned int index;
-
-	if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return retval;
-
-	index = buf->index;
-
-	if (index >= go->buf_count)
-		goto unlock_and_return;
-
-	memset(buf, 0, sizeof(*buf));
-	buf->index = index;
-	buf->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	switch (go->bufs[index].state) {
-	case BUF_STATE_QUEUED:
-		buf->flags = V4L2_BUF_FLAG_QUEUED;
-		break;
-	case BUF_STATE_DONE:
-		buf->flags = V4L2_BUF_FLAG_DONE;
-		break;
-	default:
-		buf->flags = 0;
-	}
-
-	if (go->bufs[index].mapped)
-		buf->flags |= V4L2_BUF_FLAG_MAPPED;
-	buf->memory = V4L2_MEMORY_MMAP;
-	buf->m.offset = index * GO7007_BUF_SIZE;
-	buf->length = GO7007_BUF_SIZE;
-
-	return 0;
-
-unlock_and_return:
-	return retval;
-}
-
-static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct go7007 *go = video_drvdata(file);
-	struct go7007_buffer *gobuf;
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct go7007 *go = vb2_get_drv_priv(vq);
+	struct go7007_buffer *go7007_vb =
+		container_of(vb, struct go7007_buffer, vb);
 	unsigned long flags;
-	int retval = -EINVAL;
-	int ret;
-
-	if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-			buf->memory != V4L2_MEMORY_MMAP)
-		return retval;
-
-	if (buf->index >= go->buf_count)
-		goto unlock_and_return;
 
-	gobuf = &go->bufs[buf->index];
-	if (!gobuf->mapped)
-		goto unlock_and_return;
-
-	retval = -EBUSY;
-	if (gobuf->state != BUF_STATE_IDLE)
-		goto unlock_and_return;
-
-	/* offset will be 0 until we really support USERPTR streaming */
-	gobuf->offset = gobuf->user_addr & ~PAGE_MASK;
-	gobuf->bytesused = 0;
-	gobuf->frame_offset = 0;
-	gobuf->modet_active = 0;
-	if (gobuf->offset > 0)
-		gobuf->page_count = GO7007_BUF_PAGES + 1;
-	else
-		gobuf->page_count = GO7007_BUF_PAGES;
-
-	retval = -ENOMEM;
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm,
-			gobuf->user_addr & PAGE_MASK, gobuf->page_count,
-			1, 1, gobuf->pages, NULL);
-	up_read(&current->mm->mmap_sem);
-
-	if (ret != gobuf->page_count) {
-		int i;
-		for (i = 0; i < ret; ++i)
-			page_cache_release(gobuf->pages[i]);
-		gobuf->page_count = 0;
-		goto unlock_and_return;
-	}
-
-	gobuf->state = BUF_STATE_QUEUED;
 	spin_lock_irqsave(&go->spinlock, flags);
-	list_add_tail(&gobuf->stream, &go->stream);
+	list_add_tail(&go7007_vb->list, &go->vidq_active);
 	spin_unlock_irqrestore(&go->spinlock, flags);
+}
 
-	return 0;
+static int go7007_buf_prepare(struct vb2_buffer *vb)
+{
+	struct go7007_buffer *go7007_vb =
+		container_of(vb, struct go7007_buffer, vb);
 
-unlock_and_return:
-	return retval;
+	go7007_vb->modet_active = 0;
+	go7007_vb->frame_offset = 0;
+	vb->v4l2_planes[0].bytesused = 0;
+	return 0;
 }
 
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+static int go7007_buf_finish(struct vb2_buffer *vb)
 {
-	struct go7007 *go = video_drvdata(file);
-	struct go7007_buffer *gobuf;
-	int retval = -EINVAL;
-	unsigned long flags;
-	u32 frame_type_flag;
-	DEFINE_WAIT(wait);
-
-	if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return retval;
-	if (buf->memory != V4L2_MEMORY_MMAP)
-		return retval;
-
-	if (list_empty(&go->stream))
-		goto unlock_and_return;
-	gobuf = list_entry(go->stream.next,
-			struct go7007_buffer, stream);
-
-	retval = -EAGAIN;
-	if (gobuf->state != BUF_STATE_DONE &&
-			!(file->f_flags & O_NONBLOCK)) {
-		for (;;) {
-			prepare_to_wait(&go->frame_waitq, &wait,
-					TASK_INTERRUPTIBLE);
-			if (gobuf->state == BUF_STATE_DONE)
-				break;
-			if (signal_pending(current)) {
-				retval = -ERESTARTSYS;
-				break;
-			}
-			schedule();
-		}
-		finish_wait(&go->frame_waitq, &wait);
-	}
-	if (gobuf->state != BUF_STATE_DONE)
-		goto unlock_and_return;
-
-	spin_lock_irqsave(&go->spinlock, flags);
-	deactivate_buffer(gobuf);
-	spin_unlock_irqrestore(&go->spinlock, flags);
-	frame_type_flag = get_frame_type_flag(gobuf, go->format);
-	gobuf->state = BUF_STATE_IDLE;
-
-	memset(buf, 0, sizeof(*buf));
-	buf->index = gobuf->index;
-	buf->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	buf->bytesused = gobuf->bytesused;
-	buf->flags = V4L2_BUF_FLAG_MAPPED | frame_type_flag;
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct go7007 *go = vb2_get_drv_priv(vq);
+	struct go7007_buffer *go7007_vb =
+		container_of(vb, struct go7007_buffer, vb);
+	u32 frame_type_flag = get_frame_type_flag(go7007_vb, go->format);
+	struct v4l2_buffer *buf = &vb->v4l2_buf;
+
+	buf->flags &= ~(V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_BFRAME |
+			V4L2_BUF_FLAG_PFRAME);
+	buf->flags |= frame_type_flag;
 	buf->field = V4L2_FIELD_NONE;
-	buf->timestamp = gobuf->timestamp;
-	buf->sequence = gobuf->seq;
-	buf->memory = V4L2_MEMORY_MMAP;
-	buf->m.offset = gobuf->index * GO7007_BUF_SIZE;
-	buf->length = GO7007_BUF_SIZE;
-	buf->reserved = gobuf->modet_active;
-
 	return 0;
-
-unlock_and_return:
-	return retval;
 }
 
-static int vidioc_streamon(struct file *file, void *priv,
-					enum v4l2_buf_type type)
+static int go7007_start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	struct go7007 *go = video_drvdata(file);
-	int retval = 0;
-
-	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
+	struct go7007 *go = vb2_get_drv_priv(q);
+	int ret;
 
+	set_formatting(go);
 	mutex_lock(&go->hw_lock);
-
-	if (!go->streaming) {
-		go->streaming = 1;
-		go->next_seq = 0;
-		go->active_buf = NULL;
-		if (go7007_start_encoder(go) < 0)
-			retval = -EIO;
-		else
-			retval = 0;
-	}
+	go->next_seq = 0;
+	go->active_buf = NULL;
+	q->streaming = 1;
+	if (go7007_start_encoder(go) < 0)
+		ret = -EIO;
+	else
+		ret = 0;
 	mutex_unlock(&go->hw_lock);
+	if (ret) {
+		q->streaming = 0;
+		return ret;
+	}
 	call_all(&go->v4l2_dev, video, s_stream, 1);
 	v4l2_ctrl_grab(go->mpeg_video_gop_size, true);
 	v4l2_ctrl_grab(go->mpeg_video_gop_closure, true);
 	v4l2_ctrl_grab(go->mpeg_video_bitrate, true);
 	v4l2_ctrl_grab(go->mpeg_video_aspect_ratio, true);
-
-	return retval;
+	return ret;
 }
 
-static int vidioc_streamoff(struct file *file, void *priv,
-					enum v4l2_buf_type type)
+static int go7007_stop_streaming(struct vb2_queue *q)
 {
-	struct go7007 *go = video_drvdata(file);
+	struct go7007 *go = vb2_get_drv_priv(q);
+	unsigned long flags;
 
-	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	go7007_streamoff(go);
+	q->streaming = 0;
+	go7007_stream_stop(go);
+	mutex_lock(&go->hw_lock);
+	go7007_reset_encoder(go);
+	mutex_unlock(&go->hw_lock);
 	call_all(&go->v4l2_dev, video, s_stream, 0);
 
+	spin_lock_irqsave(&go->spinlock, flags);
+	INIT_LIST_HEAD(&go->vidq_active);
+	spin_unlock_irqrestore(&go->spinlock, flags);
+	v4l2_ctrl_grab(go->mpeg_video_gop_size, false);
+	v4l2_ctrl_grab(go->mpeg_video_gop_closure, false);
+	v4l2_ctrl_grab(go->mpeg_video_bitrate, false);
+	v4l2_ctrl_grab(go->mpeg_video_aspect_ratio, false);
 	return 0;
 }
 
+static struct vb2_ops go7007_video_qops = {
+	.queue_setup    = go7007_queue_setup,
+	.buf_queue      = go7007_buf_queue,
+	.buf_prepare    = go7007_buf_prepare,
+	.buf_finish     = go7007_buf_finish,
+	.start_streaming = go7007_start_streaming,
+	.stop_streaming = go7007_stop_streaming,
+	.wait_prepare   = vb2_ops_wait_prepare,
+	.wait_finish    = vb2_ops_wait_finish,
+};
+
 static int vidioc_g_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parm)
 {
@@ -895,7 +669,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct go7007 *go = video_drvdata(file);
 
-	if (go->streaming)
+	if (vb2_is_busy(&go->vidq))
 		return -EBUSY;
 
 	go->std = *std;
@@ -1006,7 +780,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
 
 	if (input >= go->board_info->num_inputs)
 		return -EINVAL;
-	if (go->streaming)
+	if (vb2_is_busy(&go->vidq))
 		return -EBUSY;
 
 	go->input = input;
@@ -1193,95 +967,6 @@ static int vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *
 	}
 #endif
 
-static ssize_t go7007_read(struct file *file, char __user *data,
-		size_t count, loff_t *ppos)
-{
-	return -EINVAL;
-}
-
-static void go7007_vm_open(struct vm_area_struct *vma)
-{
-	struct go7007_buffer *gobuf = vma->vm_private_data;
-
-	++gobuf->mapped;
-}
-
-static void go7007_vm_close(struct vm_area_struct *vma)
-{
-	struct go7007_buffer *gobuf = vma->vm_private_data;
-	unsigned long flags;
-
-	if (--gobuf->mapped == 0) {
-		spin_lock_irqsave(&gobuf->go->spinlock, flags);
-		deactivate_buffer(gobuf);
-		spin_unlock_irqrestore(&gobuf->go->spinlock, flags);
-	}
-}
-
-/* Copied from videobuf-dma-sg.c */
-static int go7007_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct page *page;
-
-	page = alloc_page(GFP_USER | __GFP_DMA32);
-	if (!page)
-		return VM_FAULT_OOM;
-	clear_user_highpage(page, (unsigned long)vmf->virtual_address);
-	vmf->page = page;
-	return 0;
-}
-
-static struct vm_operations_struct go7007_vm_ops = {
-	.open	= go7007_vm_open,
-	.close	= go7007_vm_close,
-	.fault	= go7007_vm_fault,
-};
-
-static int go7007_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct go7007 *go = video_drvdata(file);
-	unsigned int index;
-
-	if (go->status != STATUS_ONLINE)
-		return -EIO;
-	if (!(vma->vm_flags & VM_SHARED))
-		return -EINVAL; /* only support VM_SHARED mapping */
-	if (vma->vm_end - vma->vm_start != GO7007_BUF_SIZE)
-		return -EINVAL; /* must map exactly one full buffer */
-	index = vma->vm_pgoff / GO7007_BUF_PAGES;
-	if (index >= go->buf_count)
-		return -EINVAL; /* trying to map beyond requested buffers */
-	if (index * GO7007_BUF_PAGES != vma->vm_pgoff)
-		return -EINVAL; /* offset is not aligned on buffer boundary */
-	if (go->bufs[index].mapped > 0)
-		return -EBUSY;
-	go->bufs[index].mapped = 1;
-	go->bufs[index].user_addr = vma->vm_start;
-	vma->vm_ops = &go7007_vm_ops;
-	vma->vm_flags |= VM_DONTEXPAND;
-	vma->vm_flags &= ~VM_IO;
-	vma->vm_private_data = &go->bufs[index];
-	return 0;
-}
-
-static unsigned int go7007_poll(struct file *file, poll_table *wait)
-{
-	unsigned long req_events = poll_requested_events(wait);
-	struct go7007 *go = video_drvdata(file);
-	struct go7007_buffer *gobuf;
-	unsigned int res = v4l2_ctrl_poll(file, wait);
-
-	if (!(req_events & (POLLIN | POLLRDNORM)))
-		return res;
-	if (list_empty(&go->stream))
-		return POLLERR;
-	gobuf = list_entry(go->stream.next, struct go7007_buffer, stream);
-	poll_wait(file, &go->frame_waitq, wait);
-	if (gobuf->state == BUF_STATE_DONE)
-		return res | POLLIN | POLLRDNORM;
-	return res;
-}
-
 static void go7007_vfl_release(struct video_device *vfd)
 {
 	video_device_release(vfd);
@@ -1290,11 +975,11 @@ static void go7007_vfl_release(struct video_device *vfd)
 static struct v4l2_file_operations go7007_fops = {
 	.owner		= THIS_MODULE,
 	.open		= v4l2_fh_open,
-	.release	= go7007_release,
-	.ioctl		= video_ioctl2,
-	.read		= go7007_read,
-	.mmap		= go7007_mmap,
-	.poll		= go7007_poll,
+	.release	= vb2_fop_release,
+	.unlocked_ioctl	= video_ioctl2,
+	.read		= vb2_fop_read,
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1303,10 +988,10 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
-	.vidioc_reqbufs           = vidioc_reqbufs,
-	.vidioc_querybuf          = vidioc_querybuf,
-	.vidioc_qbuf              = vidioc_qbuf,
-	.vidioc_dqbuf             = vidioc_dqbuf,
+	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
+	.vidioc_querybuf          = vb2_ioctl_querybuf,
+	.vidioc_qbuf              = vb2_ioctl_qbuf,
+	.vidioc_dqbuf             = vb2_ioctl_dqbuf,
 	.vidioc_g_std             = vidioc_g_std,
 	.vidioc_s_std             = vidioc_s_std,
 	.vidioc_querystd          = vidioc_querystd,
@@ -1316,8 +1001,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enumaudio         = vidioc_enumaudio,
 	.vidioc_g_audio           = vidioc_g_audio,
 	.vidioc_s_audio           = vidioc_s_audio,
-	.vidioc_streamon          = vidioc_streamon,
-	.vidioc_streamoff         = vidioc_streamoff,
+	.vidioc_streamon          = vb2_ioctl_streamon,
+	.vidioc_streamoff         = vb2_ioctl_streamoff,
 	.vidioc_g_tuner           = vidioc_g_tuner,
 	.vidioc_s_tuner           = vidioc_s_tuner,
 	.vidioc_g_frequency       = vidioc_g_frequency,
@@ -1379,10 +1064,27 @@ int go7007_v4l2_init(struct go7007 *go)
 {
 	int rv;
 
+	mutex_init(&go->serialize_lock);
+	mutex_init(&go->queue_lock);
+
+	INIT_LIST_HEAD(&go->vidq_active);
+	go->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	go->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	go->vidq.ops = &go7007_video_qops;
+	go->vidq.mem_ops = &vb2_vmalloc_memops;
+	go->vidq.drv_priv = go;
+	go->vidq.buf_struct_size = sizeof(struct go7007_buffer);
+	go->vidq.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	go->vidq.lock = &go->queue_lock;
+	rv = vb2_queue_init(&go->vidq);
+	if (rv)
+		return rv;
 	go->video_dev = video_device_alloc();
 	if (go->video_dev == NULL)
 		return -ENOMEM;
 	*go->video_dev = go7007_template;
+	go->video_dev->lock = &go->serialize_lock;
+	go->video_dev->queue = &go->vidq;
 	set_bit(V4L2_FL_USE_FH_PRIO, &go->video_dev->flags);
 	video_set_drvdata(go->video_dev, go);
 	go->video_dev->v4l2_dev = &go->v4l2_dev;
@@ -1436,16 +1138,5 @@ int go7007_v4l2_init(struct go7007 *go)
 
 void go7007_v4l2_remove(struct go7007 *go)
 {
-	unsigned long flags;
-
-	mutex_lock(&go->hw_lock);
-	if (go->streaming) {
-		go->streaming = 0;
-		go7007_stream_stop(go);
-		spin_lock_irqsave(&go->spinlock, flags);
-		abort_queued(go);
-		spin_unlock_irqrestore(&go->spinlock, flags);
-	}
-	mutex_unlock(&go->hw_lock);
 	v4l2_ctrl_handler_free(&go->hdl);
 }
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index 4c73945..fa9de3c 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -236,7 +236,7 @@ static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
 	struct go7007 *go = video_get_drvdata(dev->empress_dev);
 	struct saa7134_go7007 *saa = go->hpi_context;
 
-	if (!go->streaming)
+	if (!vb2_is_streaming(&go->vidq))
 		return;
 	if (0 != (status & 0x000f0000))
 		printk(KERN_DEBUG "saa7134-go7007: irq: lost %ld\n",
-- 
1.7.10.4

