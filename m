Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaK1Lee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 06:34:34 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx: checkpatch cleanup: whitespaces/new lines cleanups
Date: Fri, 28 Nov 2014 09:34:15 -0200
Message-Id: <c197afc375d1d5ecfa59f3485bf33521c871e503.1417174453.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is basically produced while testing a tool that
Joe Perches sent upstream sometime ago:
	https://lkml.org/lkml/2014/7/11/794

I used it with those arguments:
	scripts/reformat_with_checkpatch.sh drivers/media/usb/em28xx/em28xx*.[ch]

It actually produced 24 patches, with is too much, and showed
interesting things: gcc produced different codes on most of the
patches, even with just linespace changes. The total code data
remained the same on all cases I checked though.

Anyway, provided that we fold the resulting patches, this tool
seems useful.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 957c7ae30efe..44ae1e0661e6 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -56,7 +56,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
 #define dprintk(fmt, arg...) do {					\
 	    if (debug)							\
 		printk(KERN_INFO "em28xx-audio %s: " fmt,		\
-				  __func__, ##arg); 		\
+				  __func__, ##arg);		\
 	} while (0)
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
@@ -232,7 +232,6 @@ static struct snd_pcm_hardware snd_em28xx_hw_capture = {
 	.channels_max = 2,
 	.buffer_bytes_max = 62720 * 8,	/* just about the value in usbaudio.c */
 
-
 	/*
 	 * The period is 12.288 bytes. Allow a 10% of variation along its
 	 * value, in order to avoid overruns/underruns due to some clock
@@ -361,7 +360,7 @@ static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
 	dprintk("Setting capture parameters\n");
 
 	ret = snd_pcm_alloc_vmalloc_buffer(substream,
-				params_buffer_bytes(hw_params));
+					   params_buffer_bytes(hw_params));
 	if (ret < 0)
 		return ret;
 #if 0
@@ -478,7 +477,7 @@ static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
  * AC97 volume control support
  */
 static int em28xx_vol_info(struct snd_kcontrol *kcontrol,
-				struct snd_ctl_elem_info *info)
+			   struct snd_ctl_elem_info *info)
 {
 	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
 
@@ -494,7 +493,7 @@ static int em28xx_vol_info(struct snd_kcontrol *kcontrol,
 }
 
 static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
-			       struct snd_ctl_elem_value *value)
+			  struct snd_ctl_elem_value *value)
 {
 	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
 	struct snd_pcm_substream *substream = dev->adev.capture_pcm_substream;
@@ -534,7 +533,7 @@ err:
 }
 
 static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
-			       struct snd_ctl_elem_value *value)
+			  struct snd_ctl_elem_value *value)
 {
 	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
 	struct snd_pcm_substream *substream = dev->adev.capture_pcm_substream;
@@ -655,7 +654,7 @@ static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 	struct snd_kcontrol *kctl;
 	struct snd_kcontrol_new tmp;
 
-	memset (&tmp, 0, sizeof(tmp));
+	memset(&tmp, 0, sizeof(tmp));
 	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	tmp.private_value = id,
 	tmp.name  = ctl_name,
@@ -672,7 +671,7 @@ static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 	dprintk("Added control %s for ac97 volume control 0x%04x\n",
 		ctl_name, id);
 
-	memset (&tmp, 0, sizeof(tmp));
+	memset(&tmp, 0, sizeof(tmp));
 	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	tmp.private_value = id,
 	tmp.name  = ctl_name,
@@ -731,7 +730,7 @@ static void em28xx_audio_free_urb(struct em28xx *dev)
 
 /* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
 static int em28xx_audio_ep_packet_size(struct usb_device *udev,
-					struct usb_endpoint_descriptor *e)
+				       struct usb_endpoint_descriptor *e)
 {
 	int size = le16_to_cpu(e->wMaxPacketSize);
 
@@ -781,7 +780,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	interval = 1 << (ep->bInterval - 1);
 
 	em28xx_info("Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
-		     EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
+		    EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
 		     dev->ifnum, alt,
 		     interval,
 		     ep_size);
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 38cf6c8491a4..7be661f73930 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -27,7 +27,6 @@
 
 #include "em28xx.h"
 
-
 /* Possible i2c addresses of Micron sensors */
 static unsigned short micron_sensor_addrs[] = {
 	0xb8 >> 1,   /* MT9V111, MT9V403 */
@@ -43,7 +42,6 @@ static unsigned short omnivision_sensor_addrs[] = {
 	I2C_CLIENT_END
 };
 
-
 static struct soc_camera_link camlink = {
 	.bus_id = 0,
 	.flags = 0,
@@ -51,7 +49,6 @@ static struct soc_camera_link camlink = {
 	.unbalanced_power = true,
 };
 
-
 /* FIXME: Should be replaced by a proper mt9m111 driver */
 static int em28xx_initialize_mt9m111(struct em28xx *dev)
 {
@@ -70,7 +67,6 @@ static int em28xx_initialize_mt9m111(struct em28xx *dev)
 	return 0;
 }
 
-
 /* FIXME: Should be replaced by a proper mt9m001 driver */
 static int em28xx_initialize_mt9m001(struct em28xx *dev)
 {
@@ -98,7 +94,6 @@ static int em28xx_initialize_mt9m001(struct em28xx *dev)
 	return 0;
 }
 
-
 /*
  * Probes Micron sensors with 8 bit address and 16 bit register width
  */
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 5f747a5e2463..d9704e66b8c9 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -64,7 +64,6 @@ module_param(usb_xfer_mode, int, 0444);
 MODULE_PARM_DESC(usb_xfer_mode,
 		 "USB transfer mode for frame data (-1 = auto, 0 = prefer isoc, 1 = prefer bulk)");
 
-
 /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
 static DECLARE_BITMAP(em28xx_devused, EM28XX_MAXBOARDS);
 
@@ -190,8 +189,8 @@ static struct em28xx_reg_seq kworld_a340_digital[] = {
 };
 
 static struct em28xx_reg_seq kworld_ub435q_v3_digital[] = {
-	{EM2874_R80_GPIO_P0_CTRL,	0xff, 	0xff,	100},
-	{EM2874_R80_GPIO_P0_CTRL,	0xfe, 	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfe,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xbe,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xfe,	0xff,	100},
 	{	-1,			-1,	-1,	-1},
@@ -301,7 +300,6 @@ static struct em28xx_reg_seq dikom_dk300_digital[] = {
 	{	-1,		-1,	-1,		-1},
 };
 
-
 /* Reset for the most [digital] boards */
 static struct em28xx_reg_seq leadership_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x70,	0xff,	10},
@@ -562,7 +560,6 @@ static struct em28xx_led pctv_80e_leds[] = {
 	{-1, 0, 0, 0},
 };
 
-
 /*
  *  Board definitions
  */
@@ -1528,7 +1525,7 @@ struct em28xx_board em28xx_boards[] = {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
-			.aout     = EM28XX_AOUT_MONO | 	/* I2S */
+			.aout     = EM28XX_AOUT_MONO |	/* I2S */
 				    EM28XX_AOUT_MASTER,	/* Line out pin */
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
@@ -1550,7 +1547,7 @@ struct em28xx_board em28xx_boards[] = {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
-			.aout     = EM28XX_AOUT_MONO | 	/* I2S */
+			.aout     = EM28XX_AOUT_MONO |	/* I2S */
 				    EM28XX_AOUT_MASTER,	/* Line out pin */
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
@@ -2496,6 +2493,7 @@ static struct em28xx_hash_table em28xx_i2c_hash[] = {
 	{0x4ba50080, EM2861_BOARD_GADMEI_UTV330PLUS, TUNER_TNF_5335MF},
 	{0x6b800080, EM2874_BOARD_LEADERSHIP_ISDBT, TUNER_ABSENT},
 };
+
 /* NOTE: introduce a separate hash table for devices with 16 bit eeproms */
 
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg)
@@ -2738,7 +2736,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 		      " insmod option:\n");
 	for (i = 0; i < em28xx_bcount; i++) {
 		em28xx_errdev("    card=%d -> %s\n",
-				i, em28xx_boards[i].name);
+			      i, em28xx_boards[i].name);
 	}
 	return -1;
 }
@@ -3094,6 +3092,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			if (le16_to_cpu(dev->udev->descriptor.idVendor)
 								    == 0xeb1a) {
 				__le16 idProd = dev->udev->descriptor.idProduct;
+
 				if (le16_to_cpu(idProd) == 0x2710)
 					chip_name = "em2710";
 				else if (le16_to_cpu(idProd) == 0x2820)
@@ -3182,7 +3181,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
 	if (retval < 0) {
 		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
-			__func__, retval);
+			      __func__, retval);
 		return retval;
 	}
 
@@ -3190,13 +3189,13 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	if (dev->def_i2c_bus) {
 		if (dev->is_em25xx)
 			retval = em28xx_i2c_register(dev, 1,
-						  EM28XX_I2C_ALGO_EM25XX_BUS_B);
+						     EM28XX_I2C_ALGO_EM25XX_BUS_B);
 		else
 			retval = em28xx_i2c_register(dev, 1,
-							EM28XX_I2C_ALGO_EM28XX);
+						     EM28XX_I2C_ALGO_EM28XX);
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
-				__func__, retval);
+				      __func__, retval);
 
 			em28xx_i2c_unregister(dev, 0);
 
@@ -3236,7 +3235,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		if (nr >= EM28XX_MAXBOARDS) {
 			/* No free device slots */
 			printk(DRIVER_NAME ": Supports only %i em28xx boards.\n",
-					EM28XX_MAXBOARDS);
+			       EM28XX_MAXBOARDS);
 			retval = -ENOMEM;
 			goto err_no_slot;
 		}
@@ -3420,6 +3419,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* Checks if audio is provided by a USB Audio Class interface */
 	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
 		struct usb_interface *uif = udev->config->interface[i];
+
 		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
 			if (has_vendor_audio)
 				em28xx_err("em28xx: device seems to have vendor AND usb audio class interfaces !\n"
@@ -3530,7 +3530,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 }
 
 static int em28xx_usb_suspend(struct usb_interface *interface,
-				pm_message_t message)
+			      pm_message_t message)
 {
 	struct em28xx *dev;
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 901cf2b952d7..324eb54299bc 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -75,7 +75,7 @@ MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
  * reads data from the usb device specifying bRequest
  */
 int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
-				   char *buf, int len)
+			    char *buf, int len)
 {
 	int ret;
 	int pipe = usb_rcvctrlpipe(dev->udev, 0);
@@ -151,7 +151,7 @@ EXPORT_SYMBOL_GPL(em28xx_read_reg);
  * sends data to the usb device, specifying bRequest
  */
 int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
-				 int len)
+			  int len)
 {
 	int ret;
 	int pipe = usb_sndctrlpipe(dev->udev, 0);
@@ -213,7 +213,7 @@ EXPORT_SYMBOL_GPL(em28xx_write_reg);
  * the actual value
  */
 int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
-				 u8 bitmask)
+			  u8 bitmask)
 {
 	int oldval;
 	u8 newval;
@@ -222,7 +222,7 @@ int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
 	if (oldval < 0)
 		return oldval;
 
-	newval = (((u8) oldval) & ~bitmask) | (val & bitmask);
+	newval = (((u8)oldval) & ~bitmask) | (val & bitmask);
 
 	return em28xx_write_regs(dev, reg, &newval, 1);
 }
@@ -314,7 +314,7 @@ int em28xx_write_ac97(struct em28xx *dev, u8 reg, u16 val)
 	if (ret < 0)
 		return ret;
 
-	ret = em28xx_write_regs(dev, EM28XX_R40_AC97LSB, (u8 *) &value, 2);
+	ret = em28xx_write_regs(dev, EM28XX_R40_AC97LSB, (u8 *)&value, 2);
 	if (ret < 0)
 		return ret;
 
@@ -361,7 +361,7 @@ static int set_ac97_input(struct em28xx *dev)
 
 		if (ret < 0)
 			em28xx_warn("couldn't setup AC97 register %d\n",
-				     inputs[i].reg);
+				    inputs[i].reg);
 	}
 	return 0;
 }
@@ -445,7 +445,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 			ret = em28xx_write_ac97(dev, outputs[i].reg, 0x8000);
 			if (ret < 0)
 				em28xx_warn("couldn't setup AC97 register %d\n",
-				     outputs[i].reg);
+					    outputs[i].reg);
 		}
 	}
 
@@ -483,7 +483,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 							vol);
 			if (ret < 0)
 				em28xx_warn("couldn't setup AC97 register %d\n",
-				     outputs[i].reg);
+					    outputs[i].reg);
 		}
 
 		if (dev->ctl_aoutput & EM28XX_AOUT_PCM_IN) {
@@ -531,7 +531,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) != EM28XX_CHIPCFG_AC97) {
 		dev->int_audio_type = EM28XX_INT_AUDIO_I2S;
 		if (dev->chip_id < CHIP_ID_EM2860 &&
-	            (cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
+		    (cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
 		    EM2820_CHIPCFG_I2S_1_SAMPRATE)
 			i2s_samplerates = 1;
 		else if (dev->chip_id >= CHIP_ID_EM2860 &&
@@ -541,7 +541,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 		else
 			i2s_samplerates = 3;
 		em28xx_info("I2S Audio (%d sample rate(s))\n",
-					       i2s_samplerates);
+			    i2s_samplerates);
 		/* Skip the code that does AC97 vendor detection */
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		goto init_audio;
@@ -614,8 +614,9 @@ const struct em28xx_led *em28xx_find_led(struct em28xx *dev,
 {
 	if (dev->board.leds) {
 		u8 k = 0;
+
 		while (dev->board.leds[k].role >= 0 &&
-			       dev->board.leds[k].role < EM28XX_NUM_LED_ROLES) {
+		       dev->board.leds[k].role < EM28XX_NUM_LED_ROLES) {
 			if (dev->board.leds[k].role == role)
 				return &dev->board.leds[k];
 			k++;
@@ -658,10 +659,10 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 
 			if (dev->mode == EM28XX_ANALOG_MODE)
 				rc = em28xx_write_reg(dev,
-						    EM28XX_R12_VINENABLE, 0x67);
+						      EM28XX_R12_VINENABLE, 0x67);
 			else
 				rc = em28xx_write_reg(dev,
-						    EM28XX_R12_VINENABLE, 0x37);
+						      EM28XX_R12_VINENABLE, 0x37);
 			if (rc < 0)
 				return rc;
 
@@ -815,7 +816,7 @@ void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode)
 
 			if (usb_bufs->transfer_buffer[i]) {
 				usb_free_coherent(dev->udev,
-					urb->transfer_buffer_length,
+						  urb->transfer_buffer_length,
 					usb_bufs->transfer_buffer[i],
 					urb->transfer_dma);
 			}
@@ -889,7 +890,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		if ((xfer_bulk && !dev->analog_ep_bulk) ||
 		    (!xfer_bulk && !dev->analog_ep_isoc)) {
 			em28xx_errdev("no endpoint for analog mode and transfer type %d\n",
-				       xfer_bulk > 0);
+				      xfer_bulk > 0);
 			return -EINVAL;
 		}
 		usb_bufs = &dev->usb_ctl.analog_bufs;
@@ -988,9 +989,9 @@ EXPORT_SYMBOL_GPL(em28xx_alloc_urbs);
  * Allocate URBs and start IRQ
  */
 int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
-		    int xfer_bulk, int num_bufs, int max_pkt_size,
+			 int xfer_bulk, int num_bufs, int max_pkt_size,
 		    int packet_multiplier,
-		    int (*urb_data_copy) (struct em28xx *dev, struct urb *urb))
+		    int (*urb_data_copy)(struct em28xx *dev, struct urb *urb))
 {
 	struct em28xx_dmaqueue *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue *vbi_dma_q = &dev->vbiq;
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 0b8823d7f7ec..c0d862abb80f 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -63,7 +63,6 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(DRIVER_DESC " - digital TV interface");
 MODULE_VERSION(EM28XX_VERSION);
 
-
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages [dvb]");
@@ -71,7 +70,7 @@ MODULE_PARM_DESC(debug, "enable debug messages [dvb]");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk(level, fmt, arg...) do {			\
-if (debug >= level) 						\
+if (debug >= level)						\
 	printk(KERN_DEBUG "%s/2-dvb: " fmt, dev->name, ## arg);	\
 } while (0)
 
@@ -99,9 +98,8 @@ struct em28xx_dvb {
 	struct i2c_client	*i2c_client_tuner;
 };
 
-
 static inline void print_err_status(struct em28xx *dev,
-				     int packet, int status)
+				    int packet, int status)
 {
 	char *errmsg = "Unknown";
 
@@ -169,7 +167,7 @@ static inline int em28xx_dvb_urb_data_copy(struct em28xx *dev, struct urb *urb)
 			if (!urb->actual_length)
 				continue;
 			dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer,
-					urb->actual_length);
+					 urb->actual_length);
 		} else {
 			if (urb->iso_frame_desc[i].status < 0) {
 				print_err_status(dev, i,
@@ -280,7 +278,6 @@ static int em28xx_stop_feed(struct dvb_demux_feed *feed)
 }
 
 
-
 /* ------------------------------------------------------------------ */
 static int em28xx_dvb_bus_ctrl(struct dvb_frontend *fe, int acquire)
 {
@@ -740,7 +737,7 @@ static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 	return ret;
 #else
 	dev_warn(&dev->udev->dev, "%s: LNA control is disabled (lna=%u)\n",
-			KBUILD_MODNAME, c->lna);
+		 KBUILD_MODNAME, c->lna);
 	return 0;
 #endif
 }
@@ -830,6 +827,7 @@ static struct zl10353_config em28xx_zl10353_no_i2c_gate_dev = {
 	.no_tuner = 1,
 	.parallel_ts = 1,
 };
+
 static struct qt1010_config em28xx_qt1010_config = {
 	.i2c_address = 0x62
 };
@@ -861,7 +859,6 @@ static const struct m88ds3103_config pctv_461e_m88ds3103_config = {
 	.agc = 0x99,
 };
 
-
 static struct tda18271_std_map drx_j_std_map = {
 	.atsc_6   = { .if_freq = 5000, .agc_mode = 3, .std = 0, .if_lvl = 1,
 		      .rfagc_top = 0x37, },
@@ -948,7 +945,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 		result = dvb_register_frontend(&dvb->adapter, dvb->fe[1]);
 		if (result < 0) {
 			printk(KERN_WARNING "%s: 2nd dvb_register_frontend failed (errno = %d)\n",
-				dev->name, result);
+			       dev->name, result);
 			goto fail_frontend1;
 		}
 	}
@@ -1182,7 +1179,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (dvb->fe[0] != NULL) {
 			if (!dvb_attach(simple_tuner_attach, dvb->fe[0],
-				&dev->i2c_adap[dev->def_i2c_bus], 0x61, TUNER_THOMSON_DTT761X)) {
+					&dev->i2c_adap[dev->def_i2c_bus], 0x61, TUNER_THOMSON_DTT761X)) {
 				result = -EINVAL;
 				goto out_free;
 			}
@@ -1204,7 +1201,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			&dev->i2c_adap[dev->def_i2c_bus], 0x48);
 		if (dvb->fe[0]) {
 			if (!dvb_attach(simple_tuner_attach, dvb->fe[0],
-				&dev->i2c_adap[dev->def_i2c_bus], 0x60, TUNER_PHILIPS_CU1216L)) {
+					&dev->i2c_adap[dev->def_i2c_bus], 0x60, TUNER_PHILIPS_CU1216L)) {
 				result = -EINVAL;
 				goto out_free;
 			}
@@ -1219,7 +1216,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-			&dev->i2c_adap[dev->def_i2c_bus],
+				&dev->i2c_adap[dev->def_i2c_bus],
 			&kworld_a340_config)) {
 				dvb_frontend_detach(dvb->fe[0]);
 				result = -EINVAL;
@@ -1250,10 +1247,10 @@ static int em28xx_dvb_init(struct em28xx *dev)
 #ifdef CONFIG_GPIOLIB
 			/* enable LNA for DVB-T, DVB-T2 and DVB-C */
 			result = gpio_request_one(dvb->lna_gpio,
-					GPIOF_OUT_INIT_LOW, NULL);
+						  GPIOF_OUT_INIT_LOW, NULL);
 			if (result)
 				em28xx_errdev("gpio request failed %d\n",
-						result);
+					      result);
 			else
 				gpio_free(dvb->lna_gpio);
 
@@ -1266,6 +1263,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
 	{
 		struct xc5000_config cfg;
+
 		hauppauge_hvr930c_init(dev);
 
 		dvb->fe[0] = dvb_attach(drxk_attach,
@@ -1339,7 +1337,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		/* attach SEC */
 		if (dvb->fe[0])
 			dvb_attach(a8293_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
-				&em28xx_a8293_config);
+				   &em28xx_a8293_config);
 		break;
 	case EM2874_BOARD_DELOCK_61959:
 	case EM2874_BOARD_MAXMEDIA_UB425_TC:
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index d22986dcd865..a19b5c8b56ff 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -593,6 +593,7 @@ static inline unsigned long em28xx_hash_mem(char *buf, int length, int bits)
 	unsigned long l = 0;
 	int len = 0;
 	unsigned char c;
+
 	do {
 		if (len == length) {
 			c = (char)len;
@@ -950,7 +951,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
 	if (retval < 0) {
 		em28xx_errdev("%s: i2c_add_adapter failed! retval [%d]\n",
-			__func__, retval);
+			      __func__, retval);
 		return retval;
 	}
 
@@ -962,7 +963,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 		retval = em28xx_i2c_eeprom(dev, bus, &dev->eedata, &dev->eedata_len);
 		if ((retval < 0) && (retval != -ENODEV)) {
 			em28xx_errdev("%s: em28xx_i2_eeprom failed! retval [%d]\n",
-				__func__, retval);
+				      __func__, retval);
 
 			return retval;
 		}
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 85ac7dd15700..d8dc03aadfbd 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -459,7 +459,7 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 		return em2874_ir_change_protocol(rc_dev, rc_type);
 	default:
 		printk("Unrecognized em28xx chip id 0x%02x: IR not supported\n",
-			dev->chip_id);
+		       dev->chip_id);
 		return -EINVAL;
 	}
 }
@@ -505,7 +505,7 @@ static void em28xx_query_buttons(struct work_struct *work)
 		/* Check states of the buttons and act */
 		j = 0;
 		while (dev->board.buttons[j].role >= 0 &&
-			 dev->board.buttons[j].role < EM28XX_NUM_BUTTON_ROLES) {
+		       dev->board.buttons[j].role < EM28XX_NUM_BUTTON_ROLES) {
 			struct em28xx_button *button = &dev->board.buttons[j];
 			/* Check if button uses the current address */
 			if (button->reg_r != dev->button_polling_addresses[i]) {
@@ -607,7 +607,7 @@ static void em28xx_init_buttons(struct em28xx *dev)
 
 	dev->button_polling_interval = EM28XX_BUTTONS_DEBOUNCED_QUERY_INTERVAL;
 	while (dev->board.buttons[i].role >= 0 &&
-			 dev->board.buttons[i].role < EM28XX_NUM_BUTTON_ROLES) {
+	       dev->board.buttons[i].role < EM28XX_NUM_BUTTON_ROLES) {
 		struct em28xx_button *button = &dev->board.buttons[i];
 		/* Check if polling address is already on the list */
 		addr_new = true;
@@ -653,11 +653,11 @@ next_button:
 	/* Start polling */
 	if (dev->num_button_polling_addresses) {
 		memset(dev->button_polling_last_values, 0,
-					       EM28XX_NUM_BUTTON_ADDRESSES_MAX);
+		       EM28XX_NUM_BUTTON_ADDRESSES_MAX);
 		INIT_DELAYED_WORK(&dev->buttons_query_work,
-							  em28xx_query_buttons);
+				  em28xx_query_buttons);
 		schedule_delayed_work(&dev->buttons_query_work,
-			       msecs_to_jiffies(dev->button_polling_interval));
+				      msecs_to_jiffies(dev->button_polling_interval));
 	}
 }
 
@@ -886,7 +886,7 @@ static int em28xx_ir_resume(struct em28xx *dev)
 		schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 	if (dev->num_button_polling_addresses)
 		schedule_delayed_work(&dev->buttons_query_work,
-			       msecs_to_jiffies(dev->button_polling_interval));
+				      msecs_to_jiffies(dev->button_polling_interval));
 	return 0;
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 311fb349dafa..13cbb7f3ea10 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -49,7 +49,6 @@
 #define EM28XX_CHIPCFG2_TS_PACKETSIZE_564	0x02
 #define EM28XX_CHIPCFG2_TS_PACKETSIZE_752	0x03
 
-
 /* GPIO/GPO registers */
 #define EM2880_R04_GPO		0x04    /* em2880-em2883 only */
 #define EM2820_R08_GPIO_CTRL	0x08	/* em2820-em2873/83 only */
@@ -68,7 +67,6 @@
 #define EM28XX_I2C_FREQ_400_KHZ		0x01
 #define EM28XX_I2C_FREQ_100_KHZ		0x00
 
-
 #define EM28XX_R0A_CHIPID	0x0a
 #define EM28XX_R0C_USBSUSP	0x0c
 #define   EM28XX_R0C_USBSUSP_SNAPSHOT	0x20 /* 1=button pressed, needs reset */
@@ -157,7 +155,6 @@
 #define EM28XX_OUTFMT_YUV422_Y1UY0V	0x15
 #define EM28XX_OUTFMT_YUV411		0x18
 
-
 #define EM28XX_R28_XMIN	0x28
 #define EM28XX_R29_XMAX	0x29
 #define EM28XX_R2A_YMIN	0x2a
diff --git a/drivers/media/usb/em28xx/em28xx-v4l.h b/drivers/media/usb/em28xx/em28xx-v4l.h
index 432862c20bbf..8dfcb56bf4b3 100644
--- a/drivers/media/usb/em28xx/em28xx-v4l.h
+++ b/drivers/media/usb/em28xx/em28xx-v4l.h
@@ -14,7 +14,6 @@
    GNU General Public License for more details.
  */
 
-
 int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
 void em28xx_stop_vbi_streaming(struct vb2_queue *vq);
 extern struct vb2_ops em28xx_vbi_qops;
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 34ee1e03a732..744e7ed743e1 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -92,7 +92,6 @@ vbi_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-
 struct vb2_ops em28xx_vbi_qops = {
 	.queue_setup    = vbi_queue_setup,
 	.buf_prepare    = vbi_buffer_prepare,
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 03d5ece0319c..4c34e587c565 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -81,7 +81,6 @@ MODULE_DESCRIPTION(DRIVER_DESC " - v4l2 interface");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EM28XX_VERSION);
 
-
 #define EM25XX_FRMDATAHDR_BYTE1			0x02
 #define EM25XX_FRMDATAHDR_BYTE2_STILL_IMAGE	0x20
 #define EM25XX_FRMDATAHDR_BYTE2_FRAME_END	0x02
@@ -90,7 +89,6 @@ MODULE_VERSION(EM28XX_VERSION);
 					 EM25XX_FRMDATAHDR_BYTE2_FRAME_END |   \
 					 EM25XX_FRMDATAHDR_BYTE2_FRAME_ID)
 
-
 static unsigned int video_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
 static unsigned int vbi_nr[]   = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
 static unsigned int radio_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
@@ -194,9 +192,10 @@ static int em28xx_vbi_supported(struct em28xx *dev)
 static void em28xx_wake_i2c(struct em28xx *dev)
 {
 	struct v4l2_device *v4l2_dev = &dev->v4l2->v4l2_dev;
+
 	v4l2_device_call_all(v4l2_dev, 0, core,  reset, 0);
 	v4l2_device_call_all(v4l2_dev, 0, video, s_routing,
-			INPUT(dev->ctl_input)->vmux, 0, 0);
+			     INPUT(dev->ctl_input)->vmux, 0, 0);
 	v4l2_device_call_all(v4l2_dev, 0, video, s_stream, 0);
 }
 
@@ -275,7 +274,7 @@ static int em28xx_accumulator_set(struct em28xx *dev, u8 xmin, u8 xmax,
 }
 
 static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
-				   u16 width, u16 height)
+				    u16 width, u16 height)
 {
 	u8 cwidth = width >> 2;
 	u8 cheight = height >> 2;
@@ -283,7 +282,7 @@ static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
 	/* NOTE: size limit: 2047x1023 = 2MPix */
 
 	em28xx_videodbg("capture area set to (%d,%d): %dx%d\n",
-		       hstart, vstart,
+			hstart, vstart,
 		       ((overflow & 2) << 9 | cwidth << 2),
 		       ((overflow & 1) << 10 | cheight << 2));
 
@@ -406,13 +405,13 @@ set_alt:
 		dev->packet_multiplier = EM28XX_BULK_PACKET_MULTIPLIER;
 	} else { /* isoc */
 		em28xx_videodbg("minimum isoc packet size: %u (alt=%d)\n",
-			       min_pkt_size, dev->alt);
+				min_pkt_size, dev->alt);
 		dev->max_pkt_size =
 				  dev->alt_max_pkt_size_isoc[dev->alt];
 		dev->packet_multiplier = EM28XX_NUM_ISOC_PACKETS;
 	}
 	em28xx_videodbg("setting alternate %d with wMaxPacketSize=%u\n",
-		       dev->alt, dev->max_pkt_size);
+			dev->alt, dev->max_pkt_size);
 	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
 	if (errCode < 0) {
 		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
@@ -482,7 +481,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 
 	if ((char *)startwrite + lencopy > (char *)buf->vb_buf + buf->length) {
 		em28xx_isocdbg("Overflow of %zu bytes past buffer end (1)\n",
-			      ((char *)startwrite + lencopy) -
+			       ((char *)startwrite + lencopy) -
 			      ((char *)buf->vb_buf + buf->length));
 		remain = (char *)buf->vb_buf + buf->length -
 			 (char *)startwrite;
@@ -548,7 +547,7 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 }
 
 static inline void print_err_status(struct em28xx *dev,
-				     int packet, int status)
+				    int packet, int status)
 {
 	char *errmsg = "Unknown";
 
@@ -831,7 +830,6 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 	return 1;
 }
 
-
 static int get_ressource(enum v4l2_buf_type f_type)
 {
 	switch (f_type) {
@@ -1003,6 +1001,7 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 	}
 	while (!list_empty(&vidq->active)) {
 		struct em28xx_buffer *buf;
+
 		buf = list_entry(vidq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
@@ -1033,6 +1032,7 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 	}
 	while (!list_empty(&vbiq->active)) {
 		struct em28xx_buffer *buf;
+
 		buf = list_entry(vbiq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
@@ -1109,6 +1109,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 static void video_mux(struct em28xx *dev, int index)
 {
 	struct v4l2_device *v4l2_dev = &dev->v4l2->v4l2_dev;
+
 	dev->ctl_input = index;
 	dev->ctl_ainput = INPUT(index)->amux;
 	dev->ctl_aoutput = INPUT(index)->aout;
@@ -1117,21 +1118,21 @@ static void video_mux(struct em28xx *dev, int index)
 		dev->ctl_aoutput = EM28XX_AOUT_MASTER;
 
 	v4l2_device_call_all(v4l2_dev, 0, video, s_routing,
-			INPUT(index)->vmux, 0, 0);
+			     INPUT(index)->vmux, 0, 0);
 
 	if (dev->board.has_msp34xx) {
 		if (dev->i2s_speed) {
 			v4l2_device_call_all(v4l2_dev, 0, audio,
-				s_i2s_clock_freq, dev->i2s_speed);
+					     s_i2s_clock_freq, dev->i2s_speed);
 		}
 		/* Note: this is msp3400 specific */
 		v4l2_device_call_all(v4l2_dev, 0, audio, s_routing,
-			 dev->ctl_ainput, MSP_OUTPUT(MSP_SC_IN_DSP_SCART1), 0);
+				     dev->ctl_ainput, MSP_OUTPUT(MSP_SC_IN_DSP_SCART1), 0);
 	}
 
 	if (dev->board.adecoder != EM28XX_NOADECODER) {
 		v4l2_device_call_all(v4l2_dev, 0, audio, s_routing,
-			dev->ctl_ainput, dev->ctl_aoutput, 0);
+				     dev->ctl_ainput, dev->ctl_aoutput, 0);
 	}
 
 	em28xx_audio_analog_set(dev);
@@ -1203,7 +1204,7 @@ static const struct v4l2_ctrl_ops em28xx_ctrl_ops = {
 };
 
 static void size_to_scale(struct em28xx *dev,
-			unsigned int width, unsigned int height,
+			  unsigned int width, unsigned int height,
 			unsigned int *hscale, unsigned int *vscale)
 {
 	unsigned int          maxw = norm_maxw(dev);
@@ -1234,7 +1235,7 @@ static void scale_to_size(struct em28xx *dev,
    ------------------------------------------------------------------*/
 
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-					struct v4l2_format *f)
+				struct v4l2_format *f)
 {
 	struct em28xx         *dev = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
@@ -1267,7 +1268,7 @@ static struct em28xx_fmt *format_by_fourcc(unsigned int fourcc)
 }
 
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-			struct v4l2_format *f)
+				  struct v4l2_format *f)
 {
 	struct em28xx         *dev   = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2  = dev->v4l2;
@@ -1338,7 +1339,7 @@ static int em28xx_set_video_format(struct em28xx *dev, unsigned int fourcc,
 
 	/* set new image size */
 	size_to_scale(dev, v4l2->width, v4l2->height,
-			   &v4l2->hscale, &v4l2->vscale);
+		      &v4l2->hscale, &v4l2->vscale);
 
 	em28xx_resolution_set(dev);
 
@@ -1346,7 +1347,7 @@ static int em28xx_set_video_format(struct em28xx *dev, unsigned int fourcc,
 }
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-			struct v4l2_format *f)
+				struct v4l2_format *f)
 {
 	struct em28xx *dev = video_drvdata(file);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
@@ -1401,7 +1402,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	v4l2->width = f.fmt.pix.width;
 	v4l2->height = f.fmt.pix.height;
 	size_to_scale(dev, v4l2->width, v4l2->height,
-			   &v4l2->hscale, &v4l2->vscale);
+		      &v4l2->hscale, &v4l2->vscale);
 
 	em28xx_resolution_set(dev);
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, video, s_std, v4l2->norm);
@@ -1422,7 +1423,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 						video, g_parm, p);
 	else
 		v4l2_video_std_frame_period(v4l2->norm,
-						 &p->parm.capture.timeperframe);
+					    &p->parm.capture.timeperframe);
 
 	return rc;
 }
@@ -1450,7 +1451,7 @@ static const char *iname[] = {
 };
 
 static int vidioc_enum_input(struct file *file, void *priv,
-				struct v4l2_input *i)
+			     struct v4l2_input *i)
 {
 	struct em28xx *dev = video_drvdata(file);
 	unsigned int       n;
@@ -1467,7 +1468,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	strcpy(i->name, iname[INPUT(n)->type]);
 
 	if ((EM28XX_VMUX_TELEVISION == INPUT(n)->type) ||
-		(EM28XX_VMUX_CABLE == INPUT(n)->type))
+	    (EM28XX_VMUX_CABLE == INPUT(n)->type))
 		i->type = V4L2_INPUT_TYPE_TUNER;
 
 	i->std = dev->v4l2->vdev->tvnorms;
@@ -1558,7 +1559,7 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 }
 
 static int vidioc_g_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+			  struct v4l2_tuner *t)
 {
 	struct em28xx *dev = video_drvdata(file);
 
@@ -1572,7 +1573,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				const struct v4l2_tuner *t)
+			  const struct v4l2_tuner *t)
 {
 	struct em28xx *dev = video_drvdata(file);
 
@@ -1584,7 +1585,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_g_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+			      struct v4l2_frequency *f)
 {
 	struct em28xx         *dev = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
@@ -1597,7 +1598,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				const struct v4l2_frequency *f)
+			      const struct v4l2_frequency *f)
 {
 	struct v4l2_frequency  new_freq = *f;
 	struct em28xx             *dev  = video_drvdata(file);
@@ -1615,7 +1616,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_chip_info(struct file *file, void *priv,
-	       struct v4l2_dbg_chip_info *chip)
+			      struct v4l2_dbg_chip_info *chip)
 {
 	struct em28xx *dev = video_drvdata(file);
 
@@ -1670,6 +1671,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 		reg->val = ret;
 	} else {
 		__le16 val = 0;
+
 		ret = dev->em28xx_read_reg_req_len(dev, USB_REQ_GET_STATUS,
 						   reg->reg, (char *)&val, 2);
 		if (ret < 0)
@@ -1700,9 +1702,8 @@ static int vidioc_s_register(struct file *file, void *priv,
 }
 #endif
 
-
 static int vidioc_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *cap)
+			   struct v4l2_capability *cap)
 {
 	struct video_device   *vdev = video_devdata(file);
 	struct em28xx         *dev  = video_drvdata(file);
@@ -1736,7 +1737,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 }
 
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
-					struct v4l2_fmtdesc *f)
+				   struct v4l2_fmtdesc *f)
 {
 	if (unlikely(f->index >= ARRAY_SIZE(format)))
 		return -EINVAL;
@@ -2178,7 +2179,7 @@ static unsigned short msp3400_addrs[] = {
 /******************************** usb interface ******************************/
 
 static struct video_device *em28xx_vdev_init(struct em28xx *dev,
-					const struct video_device *template,
+					     const struct video_device *template,
 					const char *type_name)
 {
 	struct video_device *vfd;
@@ -2344,12 +2345,12 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 		if (dev->board.radio.type)
 			v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
-					  &dev->i2c_adap[dev->def_i2c_bus],
+					    &dev->i2c_adap[dev->def_i2c_bus],
 					  "tuner", dev->board.radio_addr, NULL);
 
 		if (has_demod)
 			v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
-				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
+					    &dev->i2c_adap[dev->def_i2c_bus], "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (tuner_addr == 0) {
 			enum v4l2_i2c_tuner_type type =
@@ -2357,7 +2358,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 			struct v4l2_subdev *sd;
 
 			sd = v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
-				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
+						 &dev->i2c_adap[dev->def_i2c_bus], "tuner",
 				0, v4l2_i2c_tuner_addrs(type));
 
 			if (sd)
@@ -2378,20 +2379,20 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	ret = em28xx_audio_setup(dev);
 	if (ret < 0) {
 		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
-			__func__, ret);
+			      __func__, ret);
 		goto unregister_dev;
 	}
 	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
-			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+				  V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
-			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
+				  V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
 	} else {
 		/* install the em28xx notify callback */
 		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
-				em28xx_ctrl_notify, dev);
+				 em28xx_ctrl_notify, dev);
 		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
-				em28xx_ctrl_notify, dev);
+				 em28xx_ctrl_notify, dev);
 	}
 
 	/* wake i2c devices */
@@ -2518,7 +2519,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	/* register v4l2 video video_device */
 	ret = video_register_device(v4l2->vdev, VFL_TYPE_GRABBER,
-				       video_nr[dev->devno]);
+				    video_nr[dev->devno]);
 	if (ret) {
 		em28xx_errdev("unable to register video device (error=%i).\n",
 			      ret);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 8c970be8ad33..9c7075344109 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -217,7 +217,6 @@ enum em28xx_mode {
 	EM28XX_DIGITAL_MODE,
 };
 
-
 struct em28xx;
 
 struct em28xx_usb_bufs {
@@ -245,11 +244,11 @@ struct em28xx_usb_ctl {
 	struct em28xx_usb_bufs		digital_bufs;
 
 		/* Stores already requested buffers */
-	struct em28xx_buffer    	*vid_buf;
-	struct em28xx_buffer    	*vbi_buf;
+	struct em28xx_buffer	*vid_buf;
+	struct em28xx_buffer	*vbi_buf;
 
 		/* copy data from URB */
-	int (*urb_data_copy) (struct em28xx *dev, struct urb *urb);
+	int (*urb_data_copy)(struct em28xx *dev, struct urb *urb);
 
 };
 
@@ -697,14 +696,14 @@ struct em28xx {
 	char urb_buf[URB_MAX_CTRL_SIZE];	/* urb control msg buffer */
 
 	/* helper funcs that call usb_control_msg */
-	int (*em28xx_write_regs) (struct em28xx *dev, u16 reg,
-					char *buf, int len);
-	int (*em28xx_read_reg) (struct em28xx *dev, u16 reg);
-	int (*em28xx_read_reg_req_len) (struct em28xx *dev, u8 req, u16 reg,
-					char *buf, int len);
-	int (*em28xx_write_regs_req) (struct em28xx *dev, u8 req, u16 reg,
-				      char *buf, int len);
-	int (*em28xx_read_reg_req) (struct em28xx *dev, u8 req, u16 reg);
+	int (*em28xx_write_regs)(struct em28xx *dev, u16 reg,
+				 char *buf, int len);
+	int (*em28xx_read_reg)(struct em28xx *dev, u16 reg);
+	int (*em28xx_read_reg_req_len)(struct em28xx *dev, u8 req, u16 reg,
+				       char *buf, int len);
+	int (*em28xx_write_regs_req)(struct em28xx *dev, u8 req, u16 reg,
+				     char *buf, int len);
+	int (*em28xx_read_reg_req)(struct em28xx *dev, u8 req, u16 reg);
 
 	enum em28xx_mode mode;
 
@@ -747,7 +746,7 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len);
 int em28xx_write_reg(struct em28xx *dev, u16 reg, u8 val);
 int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
-				 u8 bitmask);
+			  u8 bitmask);
 int em28xx_toggle_reg_bits(struct em28xx *dev, u16 reg, u8 bitmask);
 
 int em28xx_read_ac97(struct em28xx *dev, u8 reg);
-- 
1.9.3

