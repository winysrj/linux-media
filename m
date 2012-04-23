Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:13045 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2DWLs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:48:59 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: [RFC PATCH 6/8] v4l: fix compiler warnings.
Date: Mon, 23 Apr 2012 13:38:24 +0200
Message-Id: <a3e409c1e5a1609cf4266fc1b402666cf6dcc068.1335180844.git.hans.verkuil@cisco.com>
In-Reply-To: <1335181106-19342-1-git-send-email-hans.verkuil@cisco.com>
References: <1335181106-19342-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335180844.git.hans.verkuil@cisco.com>
References: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335180844.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_build/v4l/adv7343.c: In function 'adv7343_setstd':
media_build/v4l/adv7343.c:133:6: warning: variable 'output_idx' set but not used [-Wunused-but-set-variable]
media_build/v4l/tvp5150.c: In function 'tvp5150_mbus_fmt':
media_build/v4l/tvp5150.c:833:14: warning: variable 'std' set but not used [-Wunused-but-set-variable]
media_build/v4l/tvp7002.c: In function 'tvp7002_query_dv_preset':
media_build/v4l/tvp7002.c:673:18: warning: variable 'device' set but not used [-Wunused-but-set-variable]
media_build/v4l/c-qcam.c: In function 'qc_capture':
media_build/v4l/c-qcam.c:381:33: warning: variable 'bitsperxfer' set but not used [-Wunused-but-set-variable]
media_build/v4l/pms.c: In function 'pms_s_std':
media_build/v4l/pms.c:738:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/pms.c: In function 'init_mediavision':
media_build/v4l/pms.c:959:6: warning: variable 'id' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-alsa.c: In function 'cx25821_irq':
media_build/v4l/cx25821-alsa.c:294:6: warning: variable 'audint_count' set but not used [-Wunused-but-set-variable]
media_build/v4l/zr364xx.c: In function 'zr364xx_fillbuff':
media_build/v4l/zr364xx.c:510:25: warning: variable 'frm' set but not used [-Wunused-but-set-variable]
media_build/v4l/s2255drv.c: In function 's2255_fillbuff':
media_build/v4l/s2255drv.c:637:23: warning: variable 'frm' set but not used [-Wunused-but-set-variable]
media_build/v4l/s2255drv.c: In function 'vidioc_s_fmt_vid_cap':
media_build/v4l/s2255drv.c:990:6: warning: variable 'norm' set but not used [-Wunused-but-set-variable]
media_build/v4l/tm6000-stds.c: In function 'tm6000_set_audio_std':
media_build/v4l/tm6000-stds.c:341:10: warning: variable 'nicam_flag' set but not used [-Wunused-but-set-variable]
media_build/v4l/tm6000-video.c: In function 'get_next_buf':
media_build/v4l/tm6000-video.c:172:8: warning: variable 'outp' set but not used [-Wunused-but-set-variable]
media_build/v4l/tm6000-video.c: In function 'copy_streams':
media_build/v4l/tm6000-video.c:214:36: warning: variable 'c' set but not used [-Wunused-but-set-variable]
media_build/v4l/tm6000-input.c: In function 'tm6000_ir_urb_received':
media_build/v4l/tm6000-input.c:171:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
media_build/v4l/usbvision-core.c: In function 'usbvision_decompress':
media_build/v4l/usbvision-core.c:604:23: warning: variable 'max_pos' set but not used [-Wunused-but-set-variable]
media_build/v4l/usbvision-core.c: In function 'usbvision_parse_compress':
media_build/v4l/usbvision-core.c:705:39: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
media_build/v4l/usbvision-core.c:705:22: warning: variable 'bytes_per_pixel' set but not used [-Wunused-but-set-variable]
media_build/v4l/zoran_device.c: In function 'write_overlay_mask':
media_build/v4l/zoran_device.c:545:6: warning: variable 'reg' set but not used [-Wunused-but-set-variable]
media_build/v4l/go7007-v4l2.c: In function 'go7007_streamoff':
media_build/v4l/go7007-v4l2.c:79:6: warning: variable 'retval' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/adv7343.c                  |    4 +---
 drivers/media/video/c-qcam.c                   |    3 +--
 drivers/media/video/cx25821/cx25821-alsa.c     |    2 --
 drivers/media/video/pms.c                      |    4 +---
 drivers/media/video/s2255drv.c                 |    4 ----
 drivers/media/video/tm6000/tm6000-input.c      |    3 +--
 drivers/media/video/tm6000/tm6000-stds.c       |    2 --
 drivers/media/video/tm6000/tm6000-video.c      |    9 +--------
 drivers/media/video/tvp5150.c                  |    7 -------
 drivers/media/video/tvp7002.c                  |    3 ---
 drivers/media/video/usbvision/usbvision-core.c |   12 +++++-------
 drivers/media/video/zoran/zoran_device.c       |    2 --
 drivers/media/video/zr364xx.c                  |    2 --
 drivers/staging/media/go7007/go7007-v4l2.c     |    2 --
 14 files changed, 10 insertions(+), 49 deletions(-)

diff --git a/drivers/media/video/adv7343.c b/drivers/media/video/adv7343.c
index 119b604..2b5aa67 100644
--- a/drivers/media/video/adv7343.c
+++ b/drivers/media/video/adv7343.c
@@ -130,14 +130,12 @@ static int adv7343_setstd(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct adv7343_state *state = to_state(sd);
 	struct adv7343_std_info *std_info;
-	int output_idx, num_std;
+	int num_std;
 	char *fsc_ptr;
 	u8 reg, val;
 	int err = 0;
 	int i = 0;
 
-	output_idx = state->output;
-
 	std_info = (struct adv7343_std_info *)stdinfo;
 	num_std = ARRAY_SIZE(stdinfo);
 
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
index fda32f5..73c65c2 100644
--- a/drivers/media/video/c-qcam.c
+++ b/drivers/media/video/c-qcam.c
@@ -378,7 +378,7 @@ get_fragment:
 static long qc_capture(struct qcam *qcam, char __user *buf, unsigned long len)
 {
 	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
-	unsigned lines, pixelsperline, bitsperxfer;
+	unsigned lines, pixelsperline;
 	unsigned int is_bi_dir = qcam->bidirectional;
 	size_t wantlen, outptr = 0;
 	char tmpbuf[BUFSZ];
@@ -404,7 +404,6 @@ static long qc_capture(struct qcam *qcam, char __user *buf, unsigned long len)
 
 	lines = qcam->height;
 	pixelsperline = qcam->width;
-	bitsperxfer = (is_bi_dir) ? 24 : 8;
 
 	if (is_bi_dir) {
 		/* Turn the port around */
diff --git a/drivers/media/video/cx25821/cx25821-alsa.c b/drivers/media/video/cx25821/cx25821-alsa.c
index 03cfac4..1858a45 100644
--- a/drivers/media/video/cx25821/cx25821-alsa.c
+++ b/drivers/media/video/cx25821/cx25821-alsa.c
@@ -290,11 +290,9 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)
 	u32 status, pci_status;
 	u32 audint_status, audint_mask;
 	int loop, handled = 0;
-	int audint_count = 0;
 
 	audint_status = cx_read(AUD_A_INT_STAT);
 	audint_mask = cx_read(AUD_A_INT_MSK);
-	audint_count = cx_read(AUD_A_GPCNT);
 	status = cx_read(PCI_INT_STAT);
 
 	for (loop = 0; loop < 1; loop++) {
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index e753b5e..2402da7 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -763,7 +763,7 @@ static int pms_s_std(struct file *file, void *fh, v4l2_std_id *std)
 		break;
 	}*/
 	mutex_unlock(&dev->lock);
-	return 0;
+	return ret;
 }
 
 static int pms_queryctrl(struct file *file, void *priv,
@@ -956,7 +956,6 @@ static const struct v4l2_ioctl_ops pms_ioctl_ops = {
 
 static int init_mediavision(struct pms *dev)
 {
-	int id;
 	int idec, decst;
 	int i;
 	static const unsigned char i2c_defs[] = {
@@ -988,7 +987,6 @@ static int init_mediavision(struct pms *dev)
 	outb(dev->io >> 4, 0x9a01);	/* Set IO port */
 
 
-	id = mvv_read(dev, 3);
 	decst = pms_i2c_stat(dev, 0x43);
 
 	if (decst != -1)
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 37845de..21eaa87 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -634,13 +634,11 @@ static void s2255_fillbuff(struct s2255_channel *channel,
 	const char *tmpbuf;
 	char *vbuf = videobuf_to_vmalloc(&buf->vb);
 	unsigned long last_frame;
-	struct s2255_framei *frm;
 
 	if (!vbuf)
 		return;
 	last_frame = channel->last_frame;
 	if (last_frame != -1) {
-		frm = &channel->buffer.frame[last_frame];
 		tmpbuf =
 		    (const char *)channel->buffer.frame[last_frame].lpvbits;
 		switch (buf->fmt->fourcc) {
@@ -987,7 +985,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	struct videobuf_queue *q = &fh->vb_vidq;
 	struct s2255_mode mode;
 	int ret;
-	int norm;
 
 	ret = vidioc_try_fmt_vid_cap(file, fh, f);
 
@@ -1018,7 +1015,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	channel->height = f->fmt.pix.height;
 	fh->vb_vidq.field = f->fmt.pix.field;
 	fh->type = f->type;
-	norm = norm_minw(&channel->vdev);
 	if (channel->width > norm_minw(&channel->vdev)) {
 		if (channel->height > norm_minh(&channel->vdev)) {
 			if (channel->cap_parm.capturemode &
diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index 859eb90..e80b7e1 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -168,7 +168,6 @@ static void tm6000_ir_urb_received(struct urb *urb)
 	struct tm6000_IR *ir = dev->ir;
 	struct tm6000_ir_poll_result poll_result;
 	char *buf;
-	int rc;
 
 	dprintk(2, "%s\n",__func__);
 	if (urb->status < 0 || urb->actual_length <= 0) {
@@ -192,7 +191,7 @@ static void tm6000_ir_urb_received(struct urb *urb)
 	dprintk(1, "%s, scancode: 0x%04x\n",__func__, poll_result.rc_data);
 	rc_keydown(ir->rc, poll_result.rc_data, 0);
 
-	rc = usb_submit_urb(urb, GFP_ATOMIC);
+	usb_submit_urb(urb, GFP_ATOMIC);
 	/*
 	 * Flash the led. We can't do it here, as it is running on IRQ context.
 	 * So, use the scheduler to do it, in a few ms.
diff --git a/drivers/media/video/tm6000/tm6000-stds.c b/drivers/media/video/tm6000/tm6000-stds.c
index 9dc0831..5e28d6a 100644
--- a/drivers/media/video/tm6000/tm6000-stds.c
+++ b/drivers/media/video/tm6000/tm6000-stds.c
@@ -338,7 +338,6 @@ static int tm6000_set_audio_std(struct tm6000_core *dev)
 	uint8_t areg_02 = 0x04; /* GC1 Fixed gain 0dB */
 	uint8_t areg_05 = 0x01; /* Auto 4.5 = M Japan, Auto 6.5 = DK */
 	uint8_t areg_06 = 0x02; /* Auto de-emphasis, mannual channel mode */
-	uint8_t nicam_flag = 0; /* No NICAM */
 
 	if (dev->radio) {
 		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
@@ -398,7 +397,6 @@ static int tm6000_set_audio_std(struct tm6000_core *dev)
 		} else {
 			areg_05 = 0x07;
 		}
-		nicam_flag = 1;
 		break;
 	/* other */
 	case 3:
diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/video/tm6000/tm6000-video.c
index 1ba26d5..011265e 100644
--- a/drivers/media/video/tm6000/tm6000-video.c
+++ b/drivers/media/video/tm6000/tm6000-video.c
@@ -169,7 +169,6 @@ static inline void get_next_buf(struct tm6000_dmaqueue *dma_q,
 			       struct tm6000_buffer   **buf)
 {
 	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
-	char *outp;
 
 	if (list_empty(&dma_q->active)) {
 		dprintk(dev, V4L2_DEBUG_QUEUE, "No active queue to serve\n");
@@ -179,11 +178,6 @@ static inline void get_next_buf(struct tm6000_dmaqueue *dma_q,
 
 	*buf = list_entry(dma_q->active.next,
 			struct tm6000_buffer, vb.queue);
-
-	/* Cleans up buffer - Useful for testing for frame/URB loss */
-	outp = videobuf_to_vmalloc(&(*buf)->vb);
-
-	return;
 }
 
 /*
@@ -211,7 +205,7 @@ static int copy_streams(u8 *data, unsigned long len,
 {
 	struct tm6000_dmaqueue  *dma_q = urb->context;
 	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
-	u8 *ptr = data, *endp = data+len, c;
+	u8 *ptr = data, *endp = data+len;
 	unsigned long header = 0;
 	int rc = 0;
 	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
@@ -264,7 +258,6 @@ static int copy_streams(u8 *data, unsigned long len,
 			}
 
 			/* split the header fields */
-			c = (header >> 24) & 0xff;
 			size = ((header & 0x7e) << 1);
 			if (size > 0)
 				size -= 4;
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 1326e11..476a6a0 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -830,19 +830,12 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 			    struct v4l2_mbus_framefmt *f)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-	v4l2_std_id std;
 
 	if (f == NULL)
 		return -EINVAL;
 
 	tvp5150_reset(sd, 0);
 
-	/* Calculate height and width based on current standard */
-	if (decoder->norm == V4L2_STD_ALL)
-		std = tvp5150_read_std(sd);
-	else
-		std = decoder->norm;
-
 	f->width = decoder->rect.width;
 	f->height = decoder->rect.height;
 
diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index d7676d8..408b65e 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -670,7 +670,6 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
 						struct v4l2_dv_preset *qpreset)
 {
 	const struct tvp7002_preset_definition *presets = tvp7002_presets;
-	struct tvp7002 *device;
 	u8 progressive;
 	u32 lpfr;
 	u32 cpln;
@@ -684,8 +683,6 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
 	/* Return invalid preset if no active input is detected */
 	qpreset->preset = V4L2_DV_INVALID;
 
-	device = to_tvp7002(sd);
-
 	/* Read standards from device registers */
 	tvp7002_read_err(sd, TVP7002_L_FRAME_STAT_LSBS, &lpf_lsb, &error);
 	tvp7002_read_err(sd, TVP7002_L_FRAME_STAT_MSBS, &lpf_msb, &error);
diff --git a/drivers/media/video/usbvision/usbvision-core.c b/drivers/media/video/usbvision/usbvision-core.c
index f344411..c9b2042 100644
--- a/drivers/media/video/usbvision/usbvision-core.c
+++ b/drivers/media/video/usbvision/usbvision-core.c
@@ -601,13 +601,12 @@ static int usbvision_decompress(struct usb_usbvision *usbvision, unsigned char *
 								unsigned char *decompressed, int *start_pos,
 								int *block_typestart_pos, int len)
 {
-	int rest_pixel, idx, max_pos, pos, extra_pos, block_len, block_type_pos, block_type_len;
+	int rest_pixel, idx, pos, extra_pos, block_len, block_type_pos, block_type_len;
 	unsigned char block_byte, block_code, block_type, block_type_byte, integrator;
 
 	integrator = 0;
 	pos = *start_pos;
 	block_type_pos = *block_typestart_pos;
-	max_pos = 396; /* pos + len; */
 	extra_pos = pos;
 	block_len = 0;
 	block_byte = 0;
@@ -702,7 +701,7 @@ static enum parse_state usbvision_parse_compress(struct usb_usbvision *usbvision
 	unsigned char strip_data[USBVISION_STRIP_LEN_MAX];
 	unsigned char strip_header[USBVISION_STRIP_HEADER_LEN];
 	int idx, idx_end, strip_len, strip_ptr, startblock_pos, block_pos, block_type_pos;
-	int clipmask_index, bytes_per_pixel, rc;
+	int clipmask_index;
 	int image_size;
 	unsigned char rv, gv, bv;
 	static unsigned char *Y, *U, *V;
@@ -769,7 +768,6 @@ static enum parse_state usbvision_parse_compress(struct usb_usbvision *usbvision
 		return parse_state_next_frame;
 	}
 
-	bytes_per_pixel = frame->v4l2_format.bytes_per_pixel;
 	clipmask_index = frame->curline * MAX_FRAME_WIDTH;
 
 	scratch_get(usbvision, strip_data, strip_len);
@@ -781,14 +779,14 @@ static enum parse_state usbvision_parse_compress(struct usb_usbvision *usbvision
 
 	usbvision->block_pos = block_pos;
 
-	rc = usbvision_decompress(usbvision, strip_data, Y, &block_pos, &block_type_pos, idx_end);
+	usbvision_decompress(usbvision, strip_data, Y, &block_pos, &block_type_pos, idx_end);
 	if (strip_len > usbvision->max_strip_len)
 		usbvision->max_strip_len = strip_len;
 
 	if (frame->curline % 2)
-		rc = usbvision_decompress(usbvision, strip_data, V, &block_pos, &block_type_pos, idx_end / 2);
+		usbvision_decompress(usbvision, strip_data, V, &block_pos, &block_type_pos, idx_end / 2);
 	else
-		rc = usbvision_decompress(usbvision, strip_data, U, &block_pos, &block_type_pos, idx_end / 2);
+		usbvision_decompress(usbvision, strip_data, U, &block_pos, &block_type_pos, idx_end / 2);
 
 	if (block_pos > usbvision->comprblock_pos)
 		usbvision->comprblock_pos = block_pos;
diff --git a/drivers/media/video/zoran/zoran_device.c b/drivers/media/video/zoran/zoran_device.c
index e86173b..a4cd504 100644
--- a/drivers/media/video/zoran/zoran_device.c
+++ b/drivers/media/video/zoran/zoran_device.c
@@ -542,11 +542,9 @@ void write_overlay_mask(struct zoran_fh *fh, struct v4l2_clip *vp, int count)
 	u32 *mask;
 	int x, y, width, height;
 	unsigned i, j, k;
-	u32 reg;
 
 	/* fill mask with one bits */
 	memset(fh->overlay_mask, ~0, mask_line_size * 4 * BUZ_MAX_HEIGHT);
-	reg = 0;
 
 	for (i = 0; i < count; ++i) {
 		/* pick up local copy of clip */
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index cd2e39f..e44cb33 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -507,14 +507,12 @@ static void zr364xx_fillbuff(struct zr364xx_camera *cam,
 	const char *tmpbuf;
 	char *vbuf = videobuf_to_vmalloc(&buf->vb);
 	unsigned long last_frame;
-	struct zr364xx_framei *frm;
 
 	if (!vbuf)
 		return;
 
 	last_frame = cam->last_frame;
 	if (last_frame != -1) {
-		frm = &cam->buffer.frame[last_frame];
 		tmpbuf = (const char *)cam->buffer.frame[last_frame].lpvbits;
 		switch (buf->fmt->fourcc) {
 		case V4L2_PIX_FMT_JPEG:
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 3ef4cd8..c184ad3 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -76,7 +76,6 @@ static void abort_queued(struct go7007 *go)
 
 static int go7007_streamoff(struct go7007 *go)
 {
-	int retval = -EINVAL;
 	unsigned long flags;
 
 	mutex_lock(&go->hw_lock);
@@ -87,7 +86,6 @@ static int go7007_streamoff(struct go7007 *go)
 		abort_queued(go);
 		spin_unlock_irqrestore(&go->spinlock, flags);
 		go7007_reset_encoder(go);
-		retval = 0;
 	}
 	mutex_unlock(&go->hw_lock);
 	return 0;
-- 
1.7.9.5

