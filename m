Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe12.tele2.it ([212.247.155.109]:59448 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754017AbZBJX6W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 18:58:22 -0500
Received: from [93.145.236.208] (account cxu-8be-dgf@tele2.it HELO ozzy.localnet)
  by mailfe12.swip.net (CommuniGate Pro SMTP 5.2.6)
  with ESMTPA id 1021518221 for linux-media@vger.kernel.org; Wed, 11 Feb 2009 00:58:18 +0100
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: linux-media@vger.kernel.org
Subject: [PATCH v2] em28xx: Coding style fixes and a typo correction
Date: Wed, 11 Feb 2009 00:58:20 +0100
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200902110058.21520.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lots of coding style fixes and a typo correction for em28xx.

Priority: low

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>
---
v2: Addressed review comments from Mauro Carvalho Chehab

diff -r 9cb19f080660 linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c	Tue Feb 10 20:33:23 2009 +0100
@@ -264,8 +264,7 @@ static int em28xx_cmd(struct em28xx *dev
 }
 
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 16)
-static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
-					size_t size)
+static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs, size_t size)
 #else
 static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 					size_t size)
@@ -277,7 +276,7 @@ static int snd_pcm_alloc_vmalloc_buffer(
 	struct snd_pcm_runtime *runtime = subs->runtime;
 #endif
 
-	dprintk("Alocating vbuffer\n");
+	dprintk("Allocating vbuffer\n");
 	if (runtime->dma_area) {
 		if (runtime->dma_bytes > size)
 			return 0;
@@ -454,8 +453,8 @@ static int snd_em28xx_capture_trigger(st
 {
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
 
-	dprintk("Should %s capture\n", (cmd == SNDRV_PCM_TRIGGER_START)?
-				       "start": "stop");
+	dprintk("Should %s capture\n", (cmd == SNDRV_PCM_TRIGGER_START) ?
+				       "start" : "stop");
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 		em28xx_cmd(dev, EM28XX_CAPTURE_STREAM_EN, 1);
@@ -476,8 +475,7 @@ static snd_pcm_uframes_t snd_em28xx_capt
 						    *substream)
 #endif
 {
-       unsigned long flags;
-
+	unsigned long flags;
 	struct em28xx *dev;
 	snd_pcm_uframes_t hwptr_done;
 
diff -r 9cb19f080660 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Tue Feb 10 20:33:23 2009 +0100
@@ -257,7 +257,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Hauppauge WinTV USB 2",
 		.tuner_type   = TUNER_PHILIPS_FM1236_MK3,
 		.tda9887_conf = TDA9887_PRESENT |
-				TDA9887_PORT1_ACTIVE|
+				TDA9887_PORT1_ACTIVE |
 				TDA9887_PORT2_ACTIVE,
 		.decoder      = EM28XX_TVP5150,
 		.has_msp34xx  = 1,
@@ -534,7 +534,7 @@ struct em28xx_board em28xx_boards[] = {
 	},
 	[EM2861_BOARD_YAKUMO_MOVIE_MIXER] = {
 		.name          = "Yakumo MovieMixer",
-		.tuner_type   = TUNER_ABSENT,	/* Capture only device */
+		.tuner_type    = TUNER_ABSENT,	/* Capture only device */
 		.decoder       = EM28XX_TVP5150,
 		.input         = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -902,11 +902,11 @@ struct em28xx_board em28xx_boards[] = {
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
@@ -1282,7 +1282,9 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb      = 1,
 		.dvb_gpio     = kworld_330u_digital,
 		.xclk             = EM28XX_XCLK_FREQUENCY_12MHZ,
-		.i2c_speed        = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_EEPROM_ON_BOARD | EM28XX_I2C_EEPROM_KEY_VALID,
+		.i2c_speed        = EM28XX_I2C_CLK_WAIT_ENABLE |
+				    EM28XX_I2C_EEPROM_ON_BOARD |
+				    EM28XX_I2C_EEPROM_KEY_VALID,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1321,7 +1323,7 @@ struct em28xx_board em28xx_boards[] = {
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
 /* table of devices that work with this driver */
-struct usb_device_id em28xx_id_table [] = {
+struct usb_device_id em28xx_id_table[] = {
 	{ USB_DEVICE(0xeb1a, 0x2750),
 			.driver_info = EM2750_BOARD_UNKNOWN },
 	{ USB_DEVICE(0xeb1a, 0x2751),
@@ -1425,7 +1427,7 @@ MODULE_DEVICE_TABLE(usb, em28xx_id_table
 /*
  * EEPROM hash table for devices with generic USB IDs
  */
-static struct em28xx_hash_table em28xx_eeprom_hash [] = {
+static struct em28xx_hash_table em28xx_eeprom_hash[] = {
 	/* P/N: SA 60002070465 Tuner: TVF7533-MF */
 	{0x6ce05a8f, EM2820_BOARD_PROLINK_PLAYTV_USB2, TUNER_YMEC_TVF_5533MF},
 	{0x72cc5a8b, EM2820_BOARD_PROLINK_PLAYTV_BOX4_USB2, TUNER_YMEC_TVF_5533MF},
@@ -1457,7 +1459,7 @@ int em28xx_tuner_callback(void *ptr, int
 }
 EXPORT_SYMBOL_GPL(em28xx_tuner_callback);
 
-static void inline em28xx_set_model(struct em28xx *dev)
+static inline void em28xx_set_model(struct em28xx *dev)
 {
 	memcpy(&dev->board, &em28xx_boards[dev->model], sizeof(dev->board));
 
diff -r 9cb19f080660 linux/drivers/media/video/em28xx/em28xx-core.c
--- a/linux/drivers/media/video/em28xx/em28xx-core.c	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-core.c	Tue Feb 10 20:33:23 2009 +0100
@@ -33,8 +33,8 @@
 /* #define ENABLE_DEBUG_ISOC_FRAMES */
 
 static unsigned int core_debug;
-module_param(core_debug,int,0644);
-MODULE_PARM_DESC(core_debug,"enable debug messages [core]");
+module_param(core_debug, int, 0644);
+MODULE_PARM_DESC(core_debug, "enable debug messages [core]");
 
 #define em28xx_coredbg(fmt, arg...) do {\
 	if (core_debug) \
@@ -42,8 +42,8 @@ MODULE_PARM_DESC(core_debug,"enable debu
 			 dev->name, __func__ , ##arg); } while (0)
 
 static unsigned int reg_debug;
-module_param(reg_debug,int,0644);
-MODULE_PARM_DESC(reg_debug,"enable debug messages [URB reg]");
+module_param(reg_debug, int, 0644);
+MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
 
 #define em28xx_regdbg(fmt, arg...) do {\
 	if (reg_debug) \
@@ -77,7 +77,7 @@ int em28xx_read_reg_req_len(struct em28x
 		return -EINVAL;
 
 	if (reg_debug) {
-		printk( KERN_DEBUG "(pipe 0x%08x): "
+		printk(KERN_DEBUG "(pipe 0x%08x): "
 			"IN:  %02x %02x %02x %02x %02x %02x %02x %02x ",
 			pipe,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -154,7 +154,7 @@ int em28xx_write_regs_req(struct em28xx 
 	if (reg_debug) {
 		int byte;
 
-		printk( KERN_DEBUG "(pipe 0x%08x): "
+		printk(KERN_DEBUG "(pipe 0x%08x): "
 			"OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>>",
 			pipe,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -462,7 +462,8 @@ int em28xx_audio_analog_set(struct em28x
 		if (dev->ctl_aoutput & EM28XX_AOUT_PCM_IN) {
 			int sel = ac97_return_record_select(dev->ctl_aoutput);
 
-			/* Use the same input for both left and right channels */
+			/* Use the same input for both left and right
+			   channels */
 			sel |= (sel << 8);
 
 			em28xx_write_ac97(dev, AC97_RECORD_SELECT, sel);
@@ -698,7 +699,7 @@ static int em28xx_scaler_set(struct em28
 		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
 		/* it seems that both H and V scalers must be active
 		   to work correctly */
-		mode = (h || v)? 0x30: 0x00;
+		mode = (h || v) ? 0x30 : 0x00;
 	}
 	return em28xx_write_reg_bits(dev, EM28XX_R26_COMPR, mode, 0x30);
 }
@@ -954,7 +955,7 @@ int em28xx_init_isoc(struct em28xx *dev,
 			em28xx_err("unable to allocate %i bytes for transfer"
 					" buffer %i%s\n",
 					sb_size, i,
-					in_interrupt()?" while in int":"");
+					in_interrupt() ? " while in int" : "");
 			em28xx_uninit_isoc(dev);
 			return -ENOMEM;
 		}
diff -r 9cb19f080660 linux/drivers/media/video/em28xx/em28xx-i2c.c
--- a/linux/drivers/media/video/em28xx/em28xx-i2c.c	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-i2c.c	Tue Feb 10 20:33:23 2009 +0100
@@ -402,10 +402,12 @@ static int em28xx_i2c_eeprom(struct em28
 				 dev->name);
 		break;
 	case 2:
-		printk(KERN_INFO "%s:\tI2S audio, sample rate=32k\n", dev->name);
+		printk(KERN_INFO "%s:\tI2S audio, sample rate=32k\n",
+				 dev->name);
 		break;
 	case 3:
-		printk(KERN_INFO "%s:\tI2S audio, 3 sample rates\n", dev->name);
+		printk(KERN_INFO "%s:\tI2S audio, 3 sample rates\n",
+				 dev->name);
 		break;
 	}
 
diff -r 9cb19f080660 linux/drivers/media/video/em28xx/em28xx-video.c
--- a/linux/drivers/media/video/em28xx/em28xx-video.c	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-video.c	Tue Feb 10 20:33:23 2009 +0100
@@ -186,7 +186,8 @@ static void em28xx_copy_video(struct em2
 		em28xx_isocdbg("Overflow of %zi bytes past buffer end (1)\n",
 			       ((char *)startwrite + lencopy) -
 			       ((char *)outp + buf->vb.size));
-		lencopy = remain = (char *)outp + buf->vb.size - (char *)startwrite;
+		remain = (char *)outp + buf->vb.size - (char *)startwrite;
+		lencopy = remain;
 	}
 	if (lencopy <= 0)
 		return;
@@ -202,7 +203,8 @@ static void em28xx_copy_video(struct em2
 		else
 			lencopy = bytesperline;
 
-		if ((char *)startwrite + lencopy > (char *)outp + buf->vb.size) {
+		if ((char *)startwrite + lencopy > (char *)outp +
+		    buf->vb.size) {
 			em28xx_isocdbg("Overflow of %zi bytes past buffer end (2)\n",
 				       ((char *)startwrite + lencopy) -
 				       ((char *)outp + buf->vb.size));
@@ -351,7 +353,7 @@ static inline int em28xx_isoc_copy(struc
 		}
 		if (p[0] == 0x22 && p[1] == 0x5a) {
 			em28xx_isocdbg("Video frame %d, length=%i, %s\n", p[2],
-				       len, (p[2] & 1)? "odd" : "even");
+				       len, (p[2] & 1) ? "odd" : "even");
 
 			if (!(p[2] & 1)) {
 				if (buf != NULL)
@@ -480,7 +482,9 @@ fail:
 static void
 buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
-	struct em28xx_buffer    *buf     = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer    *buf     = container_of(vb,
+							struct em28xx_buffer,
+							vb);
 	struct em28xx_fh        *fh      = vq->priv_data;
 	struct em28xx           *dev     = fh->dev;
 	struct em28xx_dmaqueue  *vidq    = &dev->vidq;
@@ -493,7 +497,9 @@ buffer_queue(struct videobuf_queue *vq, 
 static void buffer_release(struct videobuf_queue *vq,
 				struct videobuf_buffer *vb)
 {
-	struct em28xx_buffer   *buf  = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer   *buf  = container_of(vb,
+						    struct em28xx_buffer,
+						    vb);
 	struct em28xx_fh       *fh   = vq->priv_data;
 	struct em28xx          *dev  = (struct em28xx *)fh->dev;
 
@@ -561,7 +567,7 @@ static int res_get(struct em28xx_fh *fh)
 
 static int res_check(struct em28xx_fh *fh)
 {
-	return (fh->stream_on);
+	return fh->stream_on;
 }
 
 static void res_free(struct em28xx_fh *fh)
@@ -795,7 +801,7 @@ out:
 	return rc;
 }
 
-static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
@@ -1483,7 +1489,7 @@ static int vidioc_reqbufs(struct file *f
 	if (rc < 0)
 		return rc;
 
-	return (videobuf_reqbufs(&fh->vb_vidq, rb));
+	return videobuf_reqbufs(&fh->vb_vidq, rb);
 }
 
 static int vidioc_querybuf(struct file *file, void *priv,
@@ -1497,7 +1503,7 @@ static int vidioc_querybuf(struct file *
 	if (rc < 0)
 		return rc;
 
-	return (videobuf_querybuf(&fh->vb_vidq, b));
+	return videobuf_querybuf(&fh->vb_vidq, b);
 }
 
 static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
@@ -1510,7 +1516,7 @@ static int vidioc_qbuf(struct file *file
 	if (rc < 0)
 		return rc;
 
-	return (videobuf_qbuf(&fh->vb_vidq, b));
+	return videobuf_qbuf(&fh->vb_vidq, b);
 }
 
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
@@ -1523,8 +1529,7 @@ static int vidioc_dqbuf(struct file *fil
 	if (rc < 0)
 		return rc;
 
-	return (videobuf_dqbuf(&fh->vb_vidq, b,
-				file->f_flags & O_NONBLOCK));
+	return videobuf_dqbuf(&fh->vb_vidq, b, file->f_flags & O_NONBLOCK);
 }
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
@@ -1848,7 +1853,7 @@ em28xx_v4l2_read(struct file *filp, char
  * em28xx_v4l2_poll()
  * will allocate buffers when called for the first time
  */
-static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table * wait)
+static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table *wait)
 {
 	struct em28xx_fh *fh = filp->private_data;
 	struct em28xx *dev = fh->dev;
@@ -2006,8 +2011,8 @@ static struct video_device em28xx_radio_
 
 
 static struct video_device *em28xx_vdev_init(struct em28xx *dev,
-					     const struct video_device *template,
-					     const char *type_name)
+					const struct video_device *template,
+					const char *type_name)
 {
 	struct video_device *vfd;
 
@@ -2057,8 +2062,9 @@ int em28xx_register_analog_devices(struc
 	/* enable vbi capturing */
 
 /*	em28xx_write_reg(dev, EM28XX_R0E_AUDIOSRC, 0xc0); audio register */
-       val = (u8)em28xx_read_reg(dev, EM28XX_R0F_XCLK);
-       em28xx_write_reg(dev, EM28XX_R0F_XCLK, (EM28XX_XCLK_AUDIO_UNMUTE | val));
+	val = (u8)em28xx_read_reg(dev, EM28XX_R0F_XCLK);
+	em28xx_write_reg(dev, EM28XX_R0F_XCLK,
+			 (EM28XX_XCLK_AUDIO_UNMUTE | val));
 	em28xx_write_reg(dev, EM28XX_R11_VINCTRL, 0x51);
 #endif
 
@@ -2094,7 +2100,8 @@ int em28xx_register_analog_devices(struc
 	}
 
 	if (em28xx_boards[dev->model].radio.type == EM28XX_RADIO) {
-		dev->radio_dev = em28xx_vdev_init(dev, &em28xx_radio_template, "radio");
+		dev->radio_dev = em28xx_vdev_init(dev, &em28xx_radio_template,
+						  "radio");
 		if (!dev->radio_dev) {
 			em28xx_errdev("cannot allocate video_device.\n");
 			return -ENODEV;
diff -r 9cb19f080660 linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx.h	Tue Feb 10 20:33:23 2009 +0100
@@ -156,7 +156,8 @@
 */
 
 /* time to wait when stopping the isoc transfer */
-#define EM28XX_URB_TIMEOUT       msecs_to_jiffies(EM28XX_NUM_BUFS * EM28XX_NUM_PACKETS)
+#define EM28XX_URB_TIMEOUT \
+			msecs_to_jiffies(EM28XX_NUM_BUFS * EM28XX_NUM_PACKETS)
 
 /* time in msecs to wait for i2c writes to finish */
 #define EM2800_I2C_WRITE_TIMEOUT 20
@@ -533,7 +534,8 @@ struct em28xx {
 	int num_alt;		/* Number of alternative settings */
 	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
 	struct urb *urb[EM28XX_NUM_BUFS];	/* urb for isoc transfers */
-	char *transfer_buffer[EM28XX_NUM_BUFS];	/* transfer buffers for isoc transfer */
+	char *transfer_buffer[EM28XX_NUM_BUFS];	/* transfer buffers for isoc
+						   transfer */
 	char urb_buf[URB_MAX_CTRL_SIZE];	/* urb control msg buffer */
 
 	/* helper funcs that call usb_control_msg */


