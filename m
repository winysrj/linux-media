Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:37268 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbZBIQuq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 11:50:46 -0500
Received: from ozzy.localnet (dhpc-2-47.sissa.it [147.122.2.227])
	by smtp.sissa.it (Postfix) with ESMTP id 7388F1B48064
	for <linux-media@vger.kernel.org>; Mon,  9 Feb 2009 17:50:43 +0100 (CET)
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx: Codign style fixes and a typo correction
Date: Mon, 9 Feb 2009 17:50:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902091750.45091.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lots of codign style fixes and a typo correction for em28xx.

Priority: low

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>

---
diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c	Mon Feb 02 10:33:31 2009 
+0100
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c	Mon Feb 09 12:47:13 2009 
+0100
@@ -264,8 +264,7 @@
 }
 
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 16)
-static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
-					size_t size)
+static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs, size_t 
size)
 #else
 static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 					size_t size)
@@ -277,7 +276,7 @@
 	struct snd_pcm_runtime *runtime = subs->runtime;
 #endif
 
-	dprintk("Alocating vbuffer\n");
+	dprintk("Allocating vbuffer\n");
 	if (runtime->dma_area) {
 		if (runtime->dma_bytes > size)
 			return 0;
@@ -454,8 +453,8 @@
 {
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
 
-	dprintk("Should %s capture\n", (cmd == SNDRV_PCM_TRIGGER_START)?
-				       "start": "stop");
+	dprintk("Should %s capture\n", (cmd == SNDRV_PCM_TRIGGER_START) ?
+				       "start" : "stop");
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 		em28xx_cmd(dev, EM28XX_CAPTURE_STREAM_EN, 1);
@@ -476,8 +475,7 @@
 						    *substream)
 #endif
 {
-       unsigned long flags;
-
+	unsigned long flags;
 	struct em28xx *dev;
 	snd_pcm_uframes_t hwptr_done;
 
diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Mon Feb 02 10:33:31 2009 
+0100
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Mon Feb 09 12:47:13 2009 
+0100
@@ -534,7 +534,7 @@
 	},
 	[EM2861_BOARD_YAKUMO_MOVIE_MIXER] = {
 		.name          = "Yakumo MovieMixer",
-		.tuner_type   = TUNER_ABSENT,	/* Capture only device */
+		.tuner_type    = TUNER_ABSENT,	/* Capture only device */
 		.decoder       = EM28XX_TVP5150,
 		.input         = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -902,11 +902,11 @@
 		} },
 	},
 	[EM2800_BOARD_GRABBEEX_USB2800] = {
-		.name         = "eMPIA Technology, Inc. GrabBeeX+ Video Encoder",
-		.is_em2800    = 1,
-		.decoder      = EM28XX_SAA711X,
-		.tuner_type   = TUNER_ABSENT, /* capture only board */
-		.input        = { {
+		.name       = "eMPIA Technology, Inc. GrabBeeX+ Video Encoder",
+		.is_em2800  = 1,
+		.decoder    = EM28XX_SAA711X,
+		.tuner_type = TUNER_ABSENT, /* capture only board */
+		.input      = { {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
@@ -1282,7 +1282,9 @@
 		.has_dvb      = 1,
 		.dvb_gpio     = kworld_330u_digital,
 		.xclk             = EM28XX_XCLK_FREQUENCY_12MHZ,
-		.i2c_speed        = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_EEPROM_ON_BOARD 
| EM28XX_I2C_EEPROM_KEY_VALID,
+		.i2c_speed        = EM28XX_I2C_CLK_WAIT_ENABLE |
+					EM28XX_I2C_EEPROM_ON_BOARD |
+					EM28XX_I2C_EEPROM_KEY_VALID,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1321,7 +1323,7 @@
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
 /* table of devices that work with this driver */
-struct usb_device_id em28xx_id_table [] = {
+struct usb_device_id em28xx_id_table[] = {
 	{ USB_DEVICE(0xeb1a, 0x2750),
 			.driver_info = EM2750_BOARD_UNKNOWN },
 	{ USB_DEVICE(0xeb1a, 0x2751),
@@ -1391,7 +1393,8 @@
 	{ USB_DEVICE(0x2040, 0x6500),
 			.driver_info = EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900 },
 	{ USB_DEVICE(0x2040, 0x6502),
-			.driver_info = EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2 },
+			.driver_info =
+				EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2 },
 	{ USB_DEVICE(0x2040, 0x6513), /* HCW HVR-980 */
 			.driver_info = EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950 },
 	{ USB_DEVICE(0x2040, 0x6517), /* HP  HVR-950 */
@@ -1425,10 +1428,11 @@
 /*
  * EEPROM hash table for devices with generic USB IDs
  */
-static struct em28xx_hash_table em28xx_eeprom_hash [] = {
+static struct em28xx_hash_table em28xx_eeprom_hash[] = {
 	/* P/N: SA 60002070465 Tuner: TVF7533-MF */
 	{0x6ce05a8f, EM2820_BOARD_PROLINK_PLAYTV_USB2, TUNER_YMEC_TVF_5533MF},
-	{0x72cc5a8b, EM2820_BOARD_PROLINK_PLAYTV_BOX4_USB2, TUNER_YMEC_TVF_5533MF},
+	{0x72cc5a8b, EM2820_BOARD_PROLINK_PLAYTV_BOX4_USB2,
+							TUNER_YMEC_TVF_5533MF},
 	{0x966a0441, EM2880_BOARD_KWORLD_DVB_310U, TUNER_XC2028},
 };
 
@@ -1457,7 +1461,7 @@
 }
 EXPORT_SYMBOL_GPL(em28xx_tuner_callback);
 
-static void inline em28xx_set_model(struct em28xx *dev)
+static inline void em28xx_set_model(struct em28xx *dev)
 {
 	memcpy(&dev->board, &em28xx_boards[dev->model], sizeof(dev->board));
 
@@ -2193,7 +2197,8 @@
 	/* Checks if audio is provided by some interface */
 	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
 		uif = udev->config->interface[i];
-		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
+		if (uif->altsetting[0].desc.bInterfaceClass ==
+							USB_CLASS_AUDIO) {
 			dev->has_audio_class = 1;
 			break;
 		}
diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx-core.c
--- a/linux/drivers/media/video/em28xx/em28xx-core.c	Mon Feb 02 10:33:31 2009 
+0100
+++ b/linux/drivers/media/video/em28xx/em28xx-core.c	Mon Feb 09 12:47:13 2009 
+0100
@@ -33,8 +33,8 @@
 /* #define ENABLE_DEBUG_ISOC_FRAMES */
 
 static unsigned int core_debug;
-module_param(core_debug,int,0644);
-MODULE_PARM_DESC(core_debug,"enable debug messages [core]");
+module_param(core_debug, int, 0644);
+MODULE_PARM_DESC(core_debug, "enable debug messages [core]");
 
 #define em28xx_coredbg(fmt, arg...) do {\
 	if (core_debug) \
@@ -42,8 +42,8 @@
 			 dev->name, __func__ , ##arg); } while (0)
 
 static unsigned int reg_debug;
-module_param(reg_debug,int,0644);
-MODULE_PARM_DESC(reg_debug,"enable debug messages [URB reg]");
+module_param(reg_debug, int, 0644);
+MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
 
 #define em28xx_regdbg(fmt, arg...) do {\
 	if (reg_debug) \
@@ -77,7 +77,7 @@
 		return -EINVAL;
 
 	if (reg_debug) {
-		printk( KERN_DEBUG "(pipe 0x%08x): "
+		printk(KERN_DEBUG "(pipe 0x%08x): "
 			"IN:  %02x %02x %02x %02x %02x %02x %02x %02x ",
 			pipe,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -154,7 +154,7 @@
 	if (reg_debug) {
 		int byte;
 
-		printk( KERN_DEBUG "(pipe 0x%08x): "
+		printk(KERN_DEBUG "(pipe 0x%08x): "
 			"OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>>",
 			pipe,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -462,7 +462,8 @@
 		if (dev->ctl_aoutput & EM28XX_AOUT_PCM_IN) {
 			int sel = ac97_return_record_select(dev->ctl_aoutput);
 
-			/* Use the same input for both left and right channels */
+			/* Use the same input for both left and right
+			   channels */
 			sel |= (sel << 8);
 
 			em28xx_write_ac97(dev, AC97_RECORD_SELECT, sel);
@@ -698,7 +699,7 @@
 		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
 		/* it seems that both H and V scalers must be active
 		   to work correctly */
-		mode = (h || v)? 0x30: 0x00;
+		mode = (h || v) ? 0x30 : 0x00;
 	}
 	return em28xx_write_reg_bits(dev, EM28XX_R26_COMPR, mode, 0x30);
 }
@@ -954,7 +955,7 @@
 			em28xx_err("unable to allocate %i bytes for transfer"
 					" buffer %i%s\n",
 					sb_size, i,
-					in_interrupt()?" while in int":"");
+					in_interrupt() ? " while in int" : "");
 			em28xx_uninit_isoc(dev);
 			return -ENOMEM;
 		}
diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx-i2c.c
--- a/linux/drivers/media/video/em28xx/em28xx-i2c.c	Mon Feb 02 10:33:31 2009 
+0100
+++ b/linux/drivers/media/video/em28xx/em28xx-i2c.c	Mon Feb 09 12:47:13 2009 
+0100
@@ -399,13 +399,15 @@
 		break;
 	case 1:
 		printk(KERN_INFO "%s:\tAC97 audio (5 sample rates)\n",
-				 dev->name);
+								dev->name);
 		break;
 	case 2:
-		printk(KERN_INFO "%s:\tI2S audio, sample rate=32k\n", dev->name);
+		printk(KERN_INFO "%s:\tI2S audio, sample rate=32k\n",
+								dev->name);
 		break;
 	case 3:
-		printk(KERN_INFO "%s:\tI2S audio, 3 sample rates\n", dev->name);
+		printk(KERN_INFO "%s:\tI2S audio, 3 sample rates\n",
+								dev->name);
 		break;
 	}
 
diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx-video.c
--- a/linux/drivers/media/video/em28xx/em28xx-video.c	Mon Feb 02 10:33:31 2009 
+0100
+++ b/linux/drivers/media/video/em28xx/em28xx-video.c	Mon Feb 09 12:47:13 2009 
+0100
@@ -186,7 +186,8 @@
 		em28xx_isocdbg("Overflow of %zi bytes past buffer end (1)\n",
 			       ((char *)startwrite + lencopy) -
 			       ((char *)outp + buf->vb.size));
-		lencopy = remain = (char *)outp + buf->vb.size - (char *)startwrite;
+		lencopy = remain = (char *)outp + buf->vb.size -
+							(char *)startwrite;
 	}
 	if (lencopy <= 0)
 		return;
@@ -202,7 +203,8 @@
 		else
 			lencopy = bytesperline;
 
-		if ((char *)startwrite + lencopy > (char *)outp + buf->vb.size) {
+		if ((char *)startwrite + lencopy > (char *)outp +
+								buf->vb.size) {
 			em28xx_isocdbg("Overflow of %zi bytes past buffer end (2)\n",
 				       ((char *)startwrite + lencopy) -
 				       ((char *)outp + buf->vb.size));
@@ -351,7 +353,7 @@
 		}
 		if (p[0] == 0x22 && p[1] == 0x5a) {
 			em28xx_isocdbg("Video frame %d, length=%i, %s\n", p[2],
-				       len, (p[2] & 1)? "odd" : "even");
+				       len, (p[2] & 1) ? "odd" : "even");
 
 			if (!(p[2] & 1)) {
 				if (buf != NULL)
@@ -389,7 +391,8 @@
 	struct em28xx        *dev = fh->dev;
 	struct v4l2_frequency f;
 
-	*size = (fh->dev->width * fh->dev->height * dev->format->depth + 7) >> 3;
+	*size = (fh->dev->width * fh->dev->height * dev->format->depth + 7) >>
+									 3;
 
 	if (0 == *count)
 		*count = EM28XX_DEF_BUF;
@@ -443,7 +446,8 @@
 	struct em28xx        *dev = fh->dev;
 	int                  rc = 0, urb_init = 0;
 
-	buf->vb.size = (fh->dev->width * fh->dev->height * dev->format->depth + 7) 
>> 3;
+	buf->vb.size = (fh->dev->width * fh->dev->height * dev->format->depth +
+								 7) >> 3;
 
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
 		return -EINVAL;
@@ -480,7 +484,8 @@
 static void
 buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
-	struct em28xx_buffer    *buf     = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer    *buf     = container_of(vb,
+						struct em28xx_buffer, vb);
 	struct em28xx_fh        *fh      = vq->priv_data;
 	struct em28xx           *dev     = fh->dev;
 	struct em28xx_dmaqueue  *vidq    = &dev->vidq;
@@ -493,7 +498,8 @@
 static void buffer_release(struct videobuf_queue *vq,
 				struct videobuf_buffer *vb)
 {
-	struct em28xx_buffer   *buf  = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer   *buf  = container_of(vb,
+						struct em28xx_buffer, vb);
 	struct em28xx_fh       *fh   = vq->priv_data;
 	struct em28xx          *dev  = (struct em28xx *)fh->dev;
 
@@ -561,7 +567,7 @@
 
 static int res_check(struct em28xx_fh *fh)
 {
-	return (fh->stream_on);
+	return fh->stream_on;
 }
 
 static void res_free(struct em28xx_fh *fh)
@@ -795,7 +801,7 @@
 	return rc;
 }
 
-static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
@@ -1483,7 +1489,7 @@
 	if (rc < 0)
 		return rc;
 
-	return (videobuf_reqbufs(&fh->vb_vidq, rb));
+	return videobuf_reqbufs(&fh->vb_vidq, rb);
 }
 
 static int vidioc_querybuf(struct file *file, void *priv,
@@ -1497,7 +1503,7 @@
 	if (rc < 0)
 		return rc;
 
-	return (videobuf_querybuf(&fh->vb_vidq, b));
+	return videobuf_querybuf(&fh->vb_vidq, b);
 }
 
 static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
@@ -1510,7 +1516,7 @@
 	if (rc < 0)
 		return rc;
 
-	return (videobuf_qbuf(&fh->vb_vidq, b));
+	return videobuf_qbuf(&fh->vb_vidq, b);
 }
 
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
@@ -1523,8 +1529,7 @@
 	if (rc < 0)
 		return rc;
 
-	return (videobuf_dqbuf(&fh->vb_vidq, b,
-				file->f_flags & O_NONBLOCK));
+	return videobuf_dqbuf(&fh->vb_vidq, b, file->f_flags & O_NONBLOCK);
 }
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
@@ -1848,7 +1853,7 @@
  * em28xx_v4l2_poll()
  * will allocate buffers when called for the first time
  */
-static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table * wait)
+static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table *wait)
 {
 	struct em28xx_fh *fh = filp->private_data;
 	struct em28xx *dev = fh->dev;
@@ -2006,8 +2011,8 @@
 
 
 static struct video_device *em28xx_vdev_init(struct em28xx *dev,
-					     const struct video_device *template,
-					     const char *type_name)
+					const struct video_device *template,
+					const char *type_name)
 {
 	struct video_device *vfd;
 
@@ -2057,8 +2062,9 @@
 	/* enable vbi capturing */
 
 /*	em28xx_write_reg(dev, EM28XX_R0E_AUDIOSRC, 0xc0); audio register */
-       val = (u8)em28xx_read_reg(dev, EM28XX_R0F_XCLK);
-       em28xx_write_reg(dev, EM28XX_R0F_XCLK, (EM28XX_XCLK_AUDIO_UNMUTE | 
val));
+	val = (u8)em28xx_read_reg(dev, EM28XX_R0F_XCLK);
+	em28xx_write_reg(dev, EM28XX_R0F_XCLK, (EM28XX_XCLK_AUDIO_UNMUTE |
+									val));
 	em28xx_write_reg(dev, EM28XX_R11_VINCTRL, 0x51);
 #endif
 
@@ -2094,7 +2100,8 @@
 	}
 
 	if (em28xx_boards[dev->model].radio.type == EM28XX_RADIO) {
-		dev->radio_dev = em28xx_vdev_init(dev, &em28xx_radio_template, "radio");
+		dev->radio_dev = em28xx_vdev_init(dev, &em28xx_radio_template,
+								"radio");
 		if (!dev->radio_dev) {
 			em28xx_errdev("cannot allocate video_device.\n");
 			return -ENODEV;
diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h	Mon Feb 02 10:33:31 2009 +0100
+++ b/linux/drivers/media/video/em28xx/em28xx.h	Mon Feb 09 12:47:13 2009 +0100
@@ -156,7 +156,8 @@
 */
 
 /* time to wait when stopping the isoc transfer */
-#define EM28XX_URB_TIMEOUT       msecs_to_jiffies(EM28XX_NUM_BUFS * 
EM28XX_NUM_PACKETS)
+#define EM28XX_URB_TIMEOUT \
+			msecs_to_jiffies(EM28XX_NUM_BUFS * EM28XX_NUM_PACKETS)
 
 /* time in msecs to wait for i2c writes to finish */
 #define EM2800_I2C_WRITE_TIMEOUT 20
@@ -533,7 +534,8 @@
 	int num_alt;		/* Number of alternative settings */
 	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
 	struct urb *urb[EM28XX_NUM_BUFS];	/* urb for isoc transfers */
-	char *transfer_buffer[EM28XX_NUM_BUFS];	/* transfer buffers for isoc transfer 
*/
+	char *transfer_buffer[EM28XX_NUM_BUFS];	/* transfer buffers for isoc
+						   transfer */
 	char urb_buf[URB_MAX_CTRL_SIZE];	/* urb control msg buffer */
 
 	/* helper funcs that call usb_control_msg */
