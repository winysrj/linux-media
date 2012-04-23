Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1244 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2DWLvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:51:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/8] v4l: fix compiler warnings.
Date: Mon, 23 Apr 2012 13:51:25 +0200
Message-Id: <c21418a68a0851986513afbb4dc5fa92c004b1ba.1335181658.git.hans.verkuil@cisco.com>
In-Reply-To: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
References: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
References: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

media_build/v4l/au0828-video.c: In function 'au0828_irq_callback':
media_build/v4l/au0828-video.c:123:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx23888-ir.c: In function 'pulse_clocks_to_clock_divider':
media_build/v4l/cx23888-ir.c:334:6: warning: variable 'rem' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25840-ir.c: In function 'pulse_clocks_to_clock_divider':
media_build/v4l/cx25840-ir.c:319:6: warning: variable 'rem' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25840-ir.c: In function 'cx25840_ir_tx_write':
media_build/v4l/cx25840-ir.c:863:21: warning: variable 'c' set but not used [-Wunused-but-set-variable]
media_build/v4l/em28xx-audio.c: In function 'snd_em28xx_hw_capture_params':
media_build/v4l/em28xx-audio.c:346:31: warning: variable 'format' set but not used [-Wunused-but-set-variable]
media_build/v4l/em28xx-audio.c:346:25: warning: variable 'rate' set but not used [-Wunused-but-set-variable]
media_build/v4l/em28xx-audio.c:346:15: warning: variable 'channels' set but not used [-Wunused-but-set-variable]
media_build/v4l/et61x251_core.c: In function 'et61x251_urb_complete':
media_build/v4l/et61x251_core.c:370:16: warning: variable 'len' set but not used [-Wunused-but-set-variable]
media_build/v4l/et61x251_core.c: In function 'et61x251_stream_interrupt':
media_build/v4l/et61x251_core.c:581:7: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]
media_build/v4l/hdpvr-control.c: In function 'get_input_lines_info':
media_build/v4l/hdpvr-control.c:98:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/hdpvr-video.c: In function 'hdpvr_try_ctrl':
media_build/v4l/hdpvr-video.c:955:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/saa7134-video.c: In function 'saa7134_s_tuner':
media_build/v4l/saa7134-video.c:2030:6: warning: variable 'rx' set but not used [-Wunused-but-set-variable]
media_build/v4l/sn9c102_core.c: In function 'sn9c102_stream_interrupt':
media_build/v4l/sn9c102_core.c:998:7: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/au0828/au0828-video.c    |    4 ++--
 drivers/media/video/cx23885/cx23888-ir.c     |    4 +---
 drivers/media/video/cx25840/cx25840-ir.c     |    6 +-----
 drivers/media/video/em28xx/em28xx-audio.c    |    9 +++++----
 drivers/media/video/et61x251/et61x251_core.c |   11 ++++-------
 drivers/media/video/hdpvr/hdpvr-control.c    |    2 ++
 drivers/media/video/hdpvr/hdpvr-video.c      |    2 +-
 drivers/media/video/saa7134/saa7134-video.c  |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c   |    4 +---
 9 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 0b3e481..3023727 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -120,7 +120,7 @@ static void au0828_irq_callback(struct urb *urb)
 	struct au0828_dmaqueue  *dma_q = urb->context;
 	struct au0828_dev *dev = container_of(dma_q, struct au0828_dev, vidq);
 	unsigned long flags = 0;
-	int rc, i;
+	int i;
 
 	switch (urb->status) {
 	case 0:             /* success */
@@ -138,7 +138,7 @@ static void au0828_irq_callback(struct urb *urb)
 
 	/* Copy data from URB */
 	spin_lock_irqsave(&dev->slock, flags);
-	rc = dev->isoc_ctl.isoc_copy(dev, urb);
+	dev->isoc_ctl.isoc_copy(dev, urb);
 	spin_unlock_irqrestore(&dev->slock, flags);
 
 	/* Reset urb buffers */
diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/video/cx23885/cx23888-ir.c
index bb1ce34..c2bc39c 100644
--- a/drivers/media/video/cx23885/cx23888-ir.c
+++ b/drivers/media/video/cx23885/cx23888-ir.c
@@ -331,9 +331,7 @@ static u64 ns_to_pulse_clocks(u32 ns)
 
 static u16 pulse_clocks_to_clock_divider(u64 count)
 {
-	u32 rem;
-
-	rem = do_div(count, (FIFO_RXTX << 2) | 0x3);
+	do_div(count, (FIFO_RXTX << 2) | 0x3);
 
 	/* net result needs to be rounded down and decremented by 1 */
 	if (count > RXCLK_RCD + 1)
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/video/cx25840/cx25840-ir.c
index 13c380e..38ce76e 100644
--- a/drivers/media/video/cx25840/cx25840-ir.c
+++ b/drivers/media/video/cx25840/cx25840-ir.c
@@ -316,9 +316,7 @@ static u64 ns_to_pulse_clocks(u32 ns)
 
 static u16 pulse_clocks_to_clock_divider(u64 count)
 {
-	u32 rem;
-
-	rem = do_div(count, (FIFO_RXTX << 2) | 0x3);
+	do_div(count, (FIFO_RXTX << 2) | 0x3);
 
 	/* net result needs to be rounded down and decremented by 1 */
 	if (count > RXCLK_RCD + 1)
@@ -860,12 +858,10 @@ static int cx25840_ir_tx_write(struct v4l2_subdev *sd, u8 *buf, size_t count,
 			       ssize_t *num)
 {
 	struct cx25840_ir_state *ir_state = to_ir_state(sd);
-	struct i2c_client *c;
 
 	if (ir_state == NULL)
 		return -ENODEV;
 
-	c = ir_state->c;
 #if 0
 	/*
 	 * FIXME - the code below is an incomplete and untested sketch of what
diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index e2a7b77..e7e6143 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -343,7 +343,7 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
 static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
 					struct snd_pcm_hw_params *hw_params)
 {
-	unsigned int channels, rate, format;
+	/* unsigned int channels, rate, format; */
 	int ret;
 
 	dprintk("Setting capture parameters\n");
@@ -352,13 +352,14 @@ static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
 				params_buffer_bytes(hw_params));
 	if (ret < 0)
 		return ret;
+	/* TODO: set up em28xx audio chip to deliver the correct audio format,
+	   current default is 48000hz multiplexed => 96000hz mono
+	   which shouldn't matter since analogue TV only supports mono
 	format = params_format(hw_params);
 	rate = params_rate(hw_params);
 	channels = params_channels(hw_params);
+	*/
 
-	/* TODO: set up em28xx audio chip to deliver the correct audio format,
-	   current default is 48000hz multiplexed => 96000hz mono
-	   which shouldn't matter since analogue TV only supports mono */
 	return 0;
 }
 
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index 5539f09..a62fa1e 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -366,13 +366,12 @@ static void et61x251_urb_complete(struct urb *urb)
 		     cam->sensor.pix_format.priv) / 8;
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		unsigned int len, status;
+		unsigned int status;
 		void *pos;
 		u8* b1, * b2, sof;
 		const u8 VOID_BYTES = 6;
 		size_t imglen;
 
-		len = urb->iso_frame_desc[i].actual_length;
 		status = urb->iso_frame_desc[i].status;
 		pos = urb->iso_frame_desc[i].offset + urb->transfer_buffer;
 
@@ -387,8 +386,8 @@ static void et61x251_urb_complete(struct urb *urb)
 		sof = ((*b1 & 0x3f) == 63);
 		imglen = ((*b1 & 0xc0) << 2) | *b2;
 
-		PDBGG("Isochrnous frame: length %u, #%u i, image length %zu",
-		      len, i, imglen);
+		PDBGG("Isochronous frame: length %u, #%u i, image length %zu",
+		      urb->iso_frame_desc[i].actual_length, i, imglen);
 
 		if ((*f)->state == F_QUEUED || (*f)->state == F_ERROR)
 start_of_frame:
@@ -577,10 +576,8 @@ static int et61x251_stop_transfer(struct et61x251_device* cam)
 
 static int et61x251_stream_interrupt(struct et61x251_device* cam)
 {
-	long timeout;
-
 	cam->stream = STREAM_INTERRUPT;
-	timeout = wait_event_timeout(cam->wait_stream,
+	wait_event_timeout(cam->wait_stream,
 				     (cam->stream == STREAM_OFF) ||
 				     (cam->state & DEV_DISCONNECTED),
 				     ET61X251_URB_TIMEOUT);
diff --git a/drivers/media/video/hdpvr/hdpvr-control.c b/drivers/media/video/hdpvr/hdpvr-control.c
index 068df4b..ae8f229 100644
--- a/drivers/media/video/hdpvr/hdpvr-control.c
+++ b/drivers/media/video/hdpvr/hdpvr-control.c
@@ -113,6 +113,8 @@ int get_input_lines_info(struct hdpvr_device *dev)
 			 "get input lines info returned: %d, %s\n", ret,
 			 print_buf);
 	}
+#else
+	(void)ret;	/* suppress compiler warning */
 #endif
 	lines = dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
 	mutex_unlock(&dev->usbc_mutex);
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 11ffe9c..0e9e156 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -994,7 +994,7 @@ static int hdpvr_try_ctrl(struct v4l2_ext_control *ctrl, int ac3)
 	default:
 		return -EINVAL;
 	}
-	return 0;
+	return ret;
 }
 
 static int vidioc_try_ext_ctrls(struct file *file, void *priv,
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 417034e..6de10b1 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -2036,7 +2036,7 @@ static int saa7134_s_tuner(struct file *file, void *priv,
 	mode = dev->thread.mode;
 	if (UNSET == mode) {
 		rx   = saa7134_tvaudio_getstereo(dev);
-		mode = saa7134_tvaudio_rx2mode(t->rxsubchans);
+		mode = saa7134_tvaudio_rx2mode(rx);
 	}
 	if (mode != t->audmode)
 		dev->thread.mode = t->audmode;
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index c2882fa..19ea780 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -995,10 +995,8 @@ static int sn9c102_stop_transfer(struct sn9c102_device* cam)
 
 static int sn9c102_stream_interrupt(struct sn9c102_device* cam)
 {
-	long timeout;
-
 	cam->stream = STREAM_INTERRUPT;
-	timeout = wait_event_timeout(cam->wait_stream,
+	wait_event_timeout(cam->wait_stream,
 				     (cam->stream == STREAM_OFF) ||
 				     (cam->state & DEV_DISCONNECTED),
 				     SN9C102_URB_TIMEOUT);
-- 
1.7.10

