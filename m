Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1HDHOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:23 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/21] [staging] tm6000: Miscellaneous cleanups.
Date: Thu,  4 Aug 2011 09:14:01 +0200
Message-Id: <1312442059-23935-4-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit fixes a number of coding style issues as well as some issues
reported by checkpatch and sparse.
---
 drivers/staging/tm6000/tm6000-alsa.c  |    4 +-
 drivers/staging/tm6000/tm6000-cards.c |   18 ++---
 drivers/staging/tm6000/tm6000-core.c  |   17 ++---
 drivers/staging/tm6000/tm6000-dvb.c   |   14 ++--
 drivers/staging/tm6000/tm6000-input.c |    2 +-
 drivers/staging/tm6000/tm6000-stds.c  |    3 +-
 drivers/staging/tm6000/tm6000-video.c |  125 +++++++++++++++------------------
 drivers/staging/tm6000/tm6000.h       |    4 -
 8 files changed, 83 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 2b96047..768d713 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -401,7 +401,7 @@ static struct snd_pcm_ops snd_tm6000_pcm_ops = {
 /*
  * Alsa Constructor - Component probe
  */
-int tm6000_audio_init(struct tm6000_core *dev)
+static int tm6000_audio_init(struct tm6000_core *dev)
 {
 	struct snd_card		*card;
 	struct snd_tm6000_card	*chip;
@@ -494,7 +494,7 @@ static int tm6000_audio_fini(struct tm6000_core *dev)
 	return 0;
 }
 
-struct tm6000_ops audio_ops = {
+static struct tm6000_ops audio_ops = {
 	.type	= TM6000_AUDIO,
 	.name	= "TM6000 Audio Extension",
 	.init	= tm6000_audio_init,
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index a69c82e..202f454 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -88,7 +88,7 @@ struct tm6000_board {
 	char		*ir_codes;
 };
 
-struct tm6000_board tm6000_boards[] = {
+static struct tm6000_board tm6000_boards[] = {
 	[TM6000_BOARD_UNKNOWN] = {
 		.name         = "Unknown tm6000 video grabber",
 		.caps = {
@@ -395,7 +395,7 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353    = 1,
 			.has_eeprom     = 1,
 			.has_remote     = 1,
-			.has_radio	= 1.
+			.has_radio	= 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
@@ -612,7 +612,7 @@ struct tm6000_board tm6000_boards[] = {
 };
 
 /* table of devices that work with this driver */
-struct usb_device_id tm6000_id_table[] = {
+static struct usb_device_id tm6000_id_table[] = {
 	{ USB_DEVICE(0x6000, 0x0001), .driver_info = TM5600_BOARD_GENERIC },
 	{ USB_DEVICE(0x6000, 0x0002), .driver_info = TM6010_BOARD_GENERIC },
 	{ USB_DEVICE(0x06e1, 0xf332), .driver_info = TM6000_BOARD_ADSTECH_DUAL_TV },
@@ -633,7 +633,7 @@ struct usb_device_id tm6000_id_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3264), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
 	{ USB_DEVICE(0x6000, 0xdec2), .driver_info = TM6010_BOARD_BEHOLD_WANDER_LITE },
 	{ USB_DEVICE(0x6000, 0xdec3), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER_LITE },
-	{ },
+	{ }
 };
 
 /* Control power led for show some activity */
@@ -788,8 +788,6 @@ EXPORT_SYMBOL_GPL(tm6000_tuner_callback);
 
 int tm6000_cards_setup(struct tm6000_core *dev)
 {
-	int i, rc;
-
 	/*
 	 * Board-specific initialization sequence. Handles all GPIO
 	 * initialization sequences that are board-specific.
@@ -861,6 +859,9 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 	 */
 
 	if (dev->gpio.tuner_reset) {
+		int rc;
+		int i;
+
 		for (i = 0; i < 2; i++) {
 			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 						dev->gpio.tuner_reset, 0x00);
@@ -1173,7 +1174,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	snprintf(dev->name, 29, "tm6000 #%d", nr);
 
 	dev->model = id->driver_info;
-	if ((card[nr] >= 0) && (card[nr] < ARRAY_SIZE(tm6000_boards)))
+	if (card[nr] < ARRAY_SIZE(tm6000_boards))
 		dev->model = card[nr];
 
 	dev->udev = usbdev;
@@ -1194,8 +1195,6 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-
-
 	/* Get endpoints */
 	for (i = 0; i < interface->num_altsetting; i++) {
 		int ep;
@@ -1279,7 +1278,6 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	printk(KERN_INFO "tm6000: Found %s\n", tm6000_boards[dev->model].name);
 
 	rc = tm6000_init_dev(dev);
-
 	if (rc < 0)
 		goto err;
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index d7eb2e2..e14bd3d 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -42,7 +42,6 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	if (len)
 		data = kzalloc(len, GFP_KERNEL);
 
-
 	if (req_type & USB_DIR_IN)
 		pipe = usb_rcvctrlpipe(dev->udev, 0);
 	else {
@@ -62,7 +61,7 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 			printk(">>> ");
 			for (i = 0; i < len; i++)
 				printk(" %02x", buf[i]);
-		printk("\n");
+			printk("\n");
 		}
 	}
 
@@ -308,7 +307,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 	 * FIXME: This is a hack! xc3028 "sleeps" when no channel is detected
 	 * for more than a few seconds. Not sure why, as this behavior does
 	 * not happen on other devices with xc3028. So, I suspect that it
-	 * is yet another bug at tm6000. After start sleeping, decoding 
+	 * is yet another bug at tm6000. After start sleeping, decoding
 	 * doesn't start automatically. Instead, it requires some
 	 * I2C commands to wake it up. As we want to have image at the
 	 * beginning, we needed to add this hack. The better would be to
@@ -390,7 +389,7 @@ struct reg_init {
 };
 
 /* The meaning of those initializations are unknown */
-struct reg_init tm6000_init_tab[] = {
+static struct reg_init tm6000_init_tab[] = {
 	/* REG  VALUE */
 	{ TM6000_REQ07_RDF_PWDOWN_ACLK, 0x1f },
 	{ TM6010_REQ07_RFF_SOFT_RESET, 0x08 },
@@ -458,7 +457,7 @@ struct reg_init tm6000_init_tab[] = {
 	{ TM6010_REQ05_R18_IMASK7, 0x00 },
 };
 
-struct reg_init tm6010_init_tab[] = {
+static struct reg_init tm6010_init_tab[] = {
 	{ TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x00 },
 	{ TM6010_REQ07_RC4_HSTART0, 0xa0 },
 	{ TM6010_REQ07_RC6_HEND0, 0x40 },
@@ -687,7 +686,7 @@ int tm6000_set_audio_rinput(struct tm6000_core *dev)
 	return 0;
 }
 
-void tm6010_set_mute_sif(struct tm6000_core *dev, u8 mute)
+static void tm6010_set_mute_sif(struct tm6000_core *dev, u8 mute)
 {
 	u8 mute_reg = 0;
 
@@ -697,7 +696,7 @@ void tm6010_set_mute_sif(struct tm6000_core *dev, u8 mute)
 	tm6000_set_reg_mask(dev, TM6010_REQ08_R0A_A_I2S_MOD, mute_reg, 0x08);
 }
 
-void tm6010_set_mute_adc(struct tm6000_core *dev, u8 mute)
+static void tm6010_set_mute_adc(struct tm6000_core *dev, u8 mute)
 {
 	u8 mute_reg = 0;
 
@@ -749,7 +748,7 @@ int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
 	return 0;
 }
 
-void tm6010_set_volume_sif(struct tm6000_core *dev, int vol)
+static void tm6010_set_volume_sif(struct tm6000_core *dev, int vol)
 {
 	u8 vol_reg;
 
@@ -762,7 +761,7 @@ void tm6010_set_volume_sif(struct tm6000_core *dev, int vol)
 	tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, vol_reg);
 }
 
-void tm6010_set_volume_adc(struct tm6000_core *dev, int vol)
+static void tm6010_set_volume_adc(struct tm6000_core *dev, int vol)
 {
 	u8 vol_reg;
 
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index ff04c89..6e5ce25 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -105,7 +105,7 @@ static void tm6000_urb_received(struct urb *urb)
 	}
 }
 
-int tm6000_start_stream(struct tm6000_core *dev)
+static int tm6000_start_stream(struct tm6000_core *dev)
 {
 	int ret;
 	unsigned int pipe, size;
@@ -166,7 +166,7 @@ int tm6000_start_stream(struct tm6000_core *dev)
 	return 0;
 }
 
-void tm6000_stop_stream(struct tm6000_core *dev)
+static void tm6000_stop_stream(struct tm6000_core *dev)
 {
 	struct tm6000_dvb *dvb = dev->dvb;
 
@@ -180,7 +180,7 @@ void tm6000_stop_stream(struct tm6000_core *dev)
 	}
 }
 
-int tm6000_start_feed(struct dvb_demux_feed *feed)
+static int tm6000_start_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
 	struct tm6000_core *dev = demux->priv;
@@ -199,7 +199,7 @@ int tm6000_start_feed(struct dvb_demux_feed *feed)
 	return 0;
 }
 
-int tm6000_stop_feed(struct dvb_demux_feed *feed)
+static int tm6000_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
 	struct tm6000_core *dev = demux->priv;
@@ -222,7 +222,7 @@ int tm6000_stop_feed(struct dvb_demux_feed *feed)
 	return 0;
 }
 
-int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
+static int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
 {
 	struct tm6000_dvb *dvb = dev->dvb;
 
@@ -247,7 +247,7 @@ int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-int register_dvb(struct tm6000_core *dev)
+static int register_dvb(struct tm6000_core *dev)
 {
 	int ret = -1;
 	struct tm6000_dvb *dvb = dev->dvb;
@@ -359,7 +359,7 @@ err:
 	return ret;
 }
 
-void unregister_dvb(struct tm6000_core *dev)
+static void unregister_dvb(struct tm6000_core *dev)
 {
 	struct tm6000_dvb *dvb = dev->dvb;
 
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index dae2f1f..15ac727 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -284,7 +284,7 @@ static void tm6000_ir_stop(struct rc_dev *rc)
 	cancel_delayed_work_sync(&ir->work);
 }
 
-int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
+static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 {
 	struct tm6000_IR *ir = rc->priv;
 
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index 8b29d73..bebf1f3 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -22,7 +22,7 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 
-static unsigned int tm6010_a_mode = 0;
+static unsigned int tm6010_a_mode;
 module_param(tm6010_a_mode, int, 0644);
 MODULE_PARM_DESC(tm6010_a_mode, "set tm6010 sif audio mode");
 
@@ -674,6 +674,5 @@ ret:
 
 	msleep(40);
 
-
 	return 0;
 }
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 4264064..e0cd512 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -19,6 +19,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -206,17 +207,6 @@ static inline void buffer_filled(struct tm6000_core *dev,
 	wake_up(&buf->vb.done);
 }
 
-const char *tm6000_msg_type[] = {
-	"unknown(0)",   /* 0 */
-	"video",        /* 1 */
-	"audio",        /* 2 */
-	"vbi",          /* 3 */
-	"pts",          /* 4 */
-	"err",          /* 5 */
-	"unknown(6)",   /* 6 */
-	"unknown(7)",   /* 7 */
-};
-
 /*
  * Identify the tm5600/6000 buffer header type and properly handles
  */
@@ -290,17 +280,18 @@ static int copy_streams(u8 *data, unsigned long len,
 			if (size > TM6000_URB_MSG_LEN)
 				size = TM6000_URB_MSG_LEN;
 			pktsize = TM6000_URB_MSG_LEN;
-			/* calculate position in buffer
-			 * and change the buffer
+			/*
+			 * calculate position in buffer and change the buffer
 			 */
 			switch (cmd) {
 			case TM6000_URB_MSG_VIDEO:
 				if (!dev->radio) {
 					if ((dev->isoc_ctl.vfield != field) &&
 						(field == 1)) {
-					/* Announces that a new buffer
-					 * were filled
-					 */
+						/*
+						 * Announces that a new buffer
+						 * were filled
+						 */
 						buffer_filled(dev, dma_q, vbuf);
 						dprintk(dev, V4L2_DEBUG_ISOC,
 							"new buffer filled\n");
@@ -325,7 +316,7 @@ static int copy_streams(u8 *data, unsigned long len,
 				break;
 			case TM6000_URB_MSG_AUDIO:
 			case TM6000_URB_MSG_PTS:
-				size = pktsize;		/* Size is always 180 bytes */
+				size = pktsize; /* Size is always 180 bytes */
 				break;
 			}
 		} else {
@@ -367,7 +358,8 @@ static int copy_streams(u8 *data, unsigned long len,
 			}
 		}
 		if (ptr + pktsize > endp) {
-			/* End of URB packet, but cmd processing is not
+			/*
+			 * End of URB packet, but cmd processing is not
 			 * complete. Preserve the state for a next packet
 			 */
 			dev->isoc_ctl.pos = pos + cpysize;
@@ -777,7 +769,8 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	}
 
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		if (0 != (rc = videobuf_iolock(vq, &buf->vb, NULL)))
+		rc = videobuf_iolock(vq, &buf->vb, NULL);
+		if (rc != 0)
 			goto fail;
 		urb_init = 1;
 	}
@@ -1038,8 +1031,8 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct tm6000_fh  *fh = priv;
-	struct tm6000_core *dev    = fh->dev;
+	struct tm6000_fh *fh = priv;
+	struct tm6000_core *dev = fh->dev;
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1048,29 +1041,30 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 
 	if (!res_get(dev, fh, false))
 		return -EBUSY;
-	return (videobuf_streamon(&fh->vb_vidq));
+	return videobuf_streamon(&fh->vb_vidq);
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct tm6000_fh  *fh=priv;
-	struct tm6000_core *dev    = fh->dev;
+	struct tm6000_fh *fh = priv;
+	struct tm6000_core *dev = fh->dev;
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
+
 	if (i != fh->type)
 		return -EINVAL;
 
 	videobuf_streamoff(&fh->vb_vidq);
-	res_free(dev,fh);
+	res_free(dev, fh);
 
-	return (0);
+	return 0;
 }
 
-static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
-	int rc=0;
-	struct tm6000_fh   *fh=priv;
+	int rc = 0;
+	struct tm6000_fh *fh = priv;
 	struct tm6000_core *dev = fh->dev;
 
 	dev->norm = *norm;
@@ -1079,7 +1073,7 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	fh->width  = dev->width;
 	fh->height = dev->height;
 
-	if (rc<0)
+	if (rc < 0)
 		return rc;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
@@ -1087,7 +1081,7 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	return 0;
 }
 
-static const char *iname [] = {
+static const char * const iname[] = {
 	[TM6000_INPUT_TV] = "Television",
 	[TM6000_INPUT_COMPOSITE1] = "Composite 1",
 	[TM6000_INPUT_COMPOSITE2] = "Composite 2",
@@ -1394,10 +1388,10 @@ static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
 	struct tm6000_fh *fh = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	if (dev->input !=5)
+	if (dev->input != 5)
 		return -EINVAL;
 
-	*i = dev->input -5;
+	*i = dev->input - 5;
 
 	return 0;
 }
@@ -1467,9 +1461,6 @@ static int tm6000_open(struct file *file)
 	int i, rc;
 	int radio = 0;
 
-	printk(KERN_INFO "tm6000: open called (dev=%s)\n",
-		video_device_node_name(vdev));
-
 	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: open called (dev=%s)\n",
 		video_device_node_name(vdev));
 
@@ -1499,27 +1490,27 @@ static int tm6000_open(struct file *file)
 		return -ENOMEM;
 	}
 
-	file->private_data = fh;
-	fh->dev      = dev;
-	fh->radio    = radio;
-	dev->radio   = radio;
-	fh->type     = type;
-	dev->fourcc  = format[0].fourcc;
-
-	fh->fmt      = format_by_fourcc(dev->fourcc);
-
-	tm6000_get_std_res (dev);
+	dev->radio = radio;
+	dev->fourcc = format[0].fourcc;
+	tm6000_get_std_res(dev);
 
-	fh->width    = dev->width;
-	fh->height   = dev->height;
+	file->private_data = fh;
+	fh->vdev = vdev;
+	fh->dev = dev;
+	fh->radio = radio;
+	fh->type = type;
+	fh->fmt = format_by_fourcc(dev->fourcc);
+	fh->width = dev->width;
+	fh->height = dev->height;
 
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: fh=0x%08lx, dev=0x%08lx, "
 						"dev->vidq=0x%08lx\n",
-		(unsigned long)fh,(unsigned long)dev,(unsigned long)&dev->vidq);
+			(unsigned long)fh, (unsigned long)dev,
+			(unsigned long)&dev->vidq);
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"queued=%d\n",list_empty(&dev->vidq.queued));
+				"queued=%d\n", list_empty(&dev->vidq.queued));
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"active=%d\n",list_empty(&dev->vidq.active));
+				"active=%d\n", list_empty(&dev->vidq.active));
 
 	/* initialize hardware on analog mode */
 	rc = tm6000_init_analog_mode(dev);
@@ -1557,7 +1548,7 @@ tm6000_read(struct file *file, char __user *data, size_t count, loff_t *pos)
 {
 	struct tm6000_fh        *fh = file->private_data;
 
-	if (fh->type==V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		if (!res_get(fh->dev, fh, true))
 			return -EBUSY;
 
@@ -1583,11 +1574,10 @@ tm6000_poll(struct file *file, struct poll_table_struct *wait)
 		/* streaming capture */
 		if (list_empty(&fh->vb_vidq.stream))
 			return POLLERR;
-		buf = list_entry(fh->vb_vidq.stream.next,struct tm6000_buffer,vb.stream);
+		buf = list_entry(fh->vb_vidq.stream.next, struct tm6000_buffer, vb.stream);
 	} else {
 		/* read() capture */
-		return videobuf_poll_stream(file, &fh->vb_vidq,
-					    wait);
+		return videobuf_poll_stream(file, &fh->vb_vidq, wait);
 	}
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
@@ -1620,22 +1610,19 @@ static int tm6000_release(struct file *file)
 
 static int tm6000_mmap(struct file *file, struct vm_area_struct * vma)
 {
-	struct tm6000_fh        *fh = file->private_data;
-	int ret;
-
-	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
+	struct tm6000_fh *fh = file->private_data;
 
-	return ret;
+	return videobuf_mmap_mapper(&fh->vb_vidq, vma);
 }
 
 static struct v4l2_file_operations tm6000_fops = {
-	.owner		= THIS_MODULE,
-	.open           = tm6000_open,
-	.release        = tm6000_release,
-	.unlocked_ioctl	= video_ioctl2, /* V4L2 ioctl handler */
-	.read           = tm6000_read,
-	.poll		= tm6000_poll,
-	.mmap		= tm6000_mmap,
+	.owner = THIS_MODULE,
+	.open = tm6000_open,
+	.release = tm6000_release,
+	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
+	.read = tm6000_read,
+	.poll = tm6000_poll,
+	.mmap = tm6000_mmap,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1696,10 +1683,10 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_frequency	= vidioc_s_frequency,
 };
 
-struct video_device tm6000_radio_template = {
+static struct video_device tm6000_radio_template = {
 	.name			= "tm6000",
 	.fops			= &radio_fops,
-	.ioctl_ops 		= &radio_ioctl_ops,
+	.ioctl_ops		= &radio_ioctl_ops,
 };
 
 /* -----------------------------------------------------------------
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index ae6369b..4323fc2 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -20,9 +20,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-/* Use the tm6000-hack, instead of the proper initialization code i*/
-/* #define HACK 1 */
-
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/videobuf-vmalloc.h>
@@ -31,7 +28,6 @@
 #include <linux/mutex.h>
 #include <media/v4l2-device.h>
 
-
 #include <linux/dvb/frontend.h>
 #include "dvb_demux.h"
 #include "dvb_frontend.h"
-- 
1.7.6

