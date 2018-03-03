Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44591 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752318AbeCCUvU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:20 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/11] media: em28xx-core: fix most coding style issues
Date: Sat,  3 Mar 2018 17:51:09 -0300
Message-Id: <e5870c851a7e2ac35900710b71698fd5b204b291.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of coding style issues at em28xx-core.
Fix most of them, by using checkpatch in strict mode to point
for it.

Automatic fixes were made with --fix-inplace, but those
were complemented by manual work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 84 +++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 2b1e7e35de20..8961368d8ec1 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -56,7 +56,6 @@ static unsigned int reg_debug;
 module_param(reg_debug, int, 0644);
 MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
 
-
 #define em28xx_regdbg(fmt, arg...) do {				\
 	if (reg_debug)							\
 		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
@@ -93,10 +92,10 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	if (ret < 0) {
 		em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed with error %i\n",
-			     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			     req, 0, 0,
-			     reg & 0xff, reg >> 8,
-			     len & 0xff, len >> 8, ret);
+			      pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      req, 0, 0,
+			      reg & 0xff, reg >> 8,
+			      len & 0xff, len >> 8, ret);
 		mutex_unlock(&dev->ctrl_urb_lock);
 		return usb_translate_errors(ret);
 	}
@@ -107,10 +106,10 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 	mutex_unlock(&dev->ctrl_urb_lock);
 
 	em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x <<< %*ph\n",
-		     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		     req, 0, 0,
-		     reg & 0xff, reg >> 8,
-		     len & 0xff, len >> 8, len, buf);
+		      pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		      req, 0, 0,
+		      reg & 0xff, reg >> 8,
+		      len & 0xff, len >> 8, len, buf);
 
 	return ret;
 }
@@ -151,7 +150,7 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 	if (dev->disconnected)
 		return -ENODEV;
 
-	if ((len < 1) || (len > URB_MAX_CTRL_SIZE))
+	if (len < 1 || len > URB_MAX_CTRL_SIZE)
 		return -EINVAL;
 
 	mutex_lock(&dev->ctrl_urb_lock);
@@ -337,8 +336,9 @@ static int set_ac97_input(struct em28xx *dev)
 	int ret, i;
 	enum em28xx_amux amux = dev->ctl_ainput;
 
-	/* EM28XX_AMUX_VIDEO2 is a special case used to indicate that
-	   em28xx should point to LINE IN, while AC97 should use VIDEO
+	/*
+	 * EM28XX_AMUX_VIDEO2 is a special case used to indicate that
+	 * em28xx should point to LINE IN, while AC97 should use VIDEO
 	 */
 	if (amux == EM28XX_AMUX_VIDEO2)
 		amux = EM28XX_AMUX_VIDEO;
@@ -374,9 +374,9 @@ static int em28xx_set_audio_source(struct em28xx *dev)
 			return ret;
 	}
 
-	if (dev->has_msp34xx)
+	if (dev->has_msp34xx) {
 		input = EM28XX_AUDIO_SRC_TUNER;
-	else {
+	} else {
 		switch (dev->ctl_ainput) {
 		case EM28XX_AMUX_VIDEO:
 			input = EM28XX_AUDIO_SRC_TUNER;
@@ -395,7 +395,7 @@ static int em28xx_set_audio_source(struct em28xx *dev)
 	ret = em28xx_write_reg_bits(dev, EM28XX_R0E_AUDIOSRC, input, 0xc0);
 	if (ret < 0)
 		return ret;
-	msleep(5);
+	usleep_range(10000, 11000);
 
 	switch (dev->audio_mode.ac97) {
 	case EM28XX_NO_AC97:
@@ -428,8 +428,9 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 	if (dev->int_audio_type == EM28XX_INT_AUDIO_NONE)
 		return 0;
 
-	/* It is assumed that all devices use master volume for output.
-	   It would be possible to use also line output.
+	/*
+	 * It is assumed that all devices use master volume for output.
+	 * It would be possible to use also line output.
 	 */
 	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
 		/* Mute all outputs */
@@ -449,7 +450,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 	ret = em28xx_write_reg(dev, EM28XX_R0F_XCLK, xclk);
 	if (ret < 0)
 		return ret;
-	msleep(10);
+	usleep_range(10000, 11000);
 
 	/* Selects the proper audio input */
 	ret = em28xx_set_audio_source(dev);
@@ -483,8 +484,10 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 		if (dev->ctl_aoutput & EM28XX_AOUT_PCM_IN) {
 			int sel = ac97_return_record_select(dev->ctl_aoutput);
 
-			/* Use the same input for both left and right
-			   channels */
+			/*
+			 * Use the same input for both left and right
+			 * channels
+			 */
 			sel |= (sel << 8);
 
 			em28xx_write_ac97(dev, AC97_REC_SEL, sel);
@@ -535,7 +538,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 		else
 			i2s_samplerates = 3;
 		dev_info(&dev->intf->dev, "I2S Audio (%d sample rate(s))\n",
-			i2s_samplerates);
+			 i2s_samplerates);
 		/* Skip the code that does AC97 vendor detection */
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		goto init_audio;
@@ -575,7 +578,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 	dev_warn(&dev->intf->dev, "AC97 features = 0x%04x\n", feat);
 
 	/* Try to identify what audio processor we have */
-	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat == 0x6a90))
+	if ((vid == 0xffffffff || vid == 0x83847650) && feat == 0x6a90)
 		dev->audio_mode.ac97 = EM28XX_AC97_EM202;
 	else if ((vid >> 8) == 0x838476)
 		dev->audio_mode.ac97 = EM28XX_AC97_SIGMATEL;
@@ -666,7 +669,7 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 			if (rc < 0)
 				return rc;
 
-			msleep(6);
+			usleep_range(10000, 11000);
 		} else {
 			/* disable video capture */
 			rc = em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x27);
@@ -700,7 +703,7 @@ int em28xx_gpio_set(struct em28xx *dev, const struct em28xx_reg_seq *gpio)
 			em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x67);
 		else
 			em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x37);
-		msleep(6);
+		usleep_range(10000, 11000);
 	}
 
 	/* Send GPIO reset sequences specified at board entry */
@@ -744,9 +747,9 @@ int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode)
 }
 EXPORT_SYMBOL_GPL(em28xx_set_mode);
 
-/* ------------------------------------------------------------------
-	URB control
-   ------------------------------------------------------------------*/
+/*
+ *URB control
+ */
 
 /*
  * URB completion handler for isoc/bulk transfers
@@ -765,7 +768,7 @@ static void em28xx_irq_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:            /* error */
-		em28xx_isocdbg("urb completition error %d.\n", urb->status);
+		em28xx_isocdbg("urb completion error %d.\n", urb->status);
 		break;
 	}
 
@@ -798,8 +801,7 @@ void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode)
 	struct em28xx_usb_bufs *usb_bufs;
 	int i;
 
-	em28xx_isocdbg("em28xx: called em28xx_uninit_usb_xfer in mode %d\n",
-		       mode);
+	em28xx_isocdbg("called %s in mode %d\n", __func__, mode);
 
 	if (mode == EM28XX_DIGITAL_MODE)
 		usb_bufs = &dev->usb_ctl.digital_bufs;
@@ -839,7 +841,7 @@ void em28xx_stop_urbs(struct em28xx *dev)
 	struct urb *urb;
 	struct em28xx_usb_bufs *isoc_bufs = &dev->usb_ctl.digital_bufs;
 
-	em28xx_isocdbg("em28xx: called em28xx_stop_urbs\n");
+	em28xx_isocdbg("called %s\n", __func__);
 
 	for (i = 0; i < isoc_bufs->num_bufs; i++) {
 		urb = isoc_bufs->urb[i];
@@ -868,10 +870,12 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 	int sb_size, pipe;
 	int j, k;
 
-	em28xx_isocdbg("em28xx: called em28xx_alloc_isoc in mode %d\n", mode);
+	em28xx_isocdbg("em28xx: called %s in mode %d\n", __func__, mode);
 
-	/* Check mode and if we have an endpoint for the selected
-	   transfer type, select buffer				 */
+	/*
+	 * Check mode and if we have an endpoint for the selected
+	 * transfer type, select buffer
+	 */
 	if (mode == EM28XX_DIGITAL_MODE) {
 		if ((xfer_bulk && !dev->dvb_ep_bulk) ||
 		    (!xfer_bulk && !dev->dvb_ep_isoc)) {
@@ -900,11 +904,11 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 
 	usb_bufs->num_bufs = num_bufs;
 
-	usb_bufs->urb = kcalloc(sizeof(void *), num_bufs,  GFP_KERNEL);
+	usb_bufs->urb = kcalloc(num_bufs, sizeof(void *), GFP_KERNEL);
 	if (!usb_bufs->urb)
 		return -ENOMEM;
 
-	usb_bufs->buf = kcalloc(sizeof(void *), num_bufs, GFP_KERNEL);
+	usb_bufs->buf = kcalloc(num_bufs, sizeof(void *), GFP_KERNEL);
 	if (!usb_bufs->buf) {
 		kfree(usb_bufs->buf);
 		return -ENOMEM;
@@ -931,11 +935,6 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 
 		usb_bufs->buf[i] = kzalloc(sb_size, GFP_KERNEL);
 		if (!usb_bufs->buf[i]) {
-			dev_err(&dev->intf->dev,
-				"unable to allocate %i bytes for transfer buffer %i%s\n",
-			       sb_size, i,
-			       in_interrupt() ? " while in int" : "");
-
 			em28xx_uninit_usb_xfer(dev, mode);
 
 			for (i--; i >= 0; i--)
@@ -996,8 +995,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 	int rc;
 	int alloc;
 
-	em28xx_isocdbg("em28xx: called em28xx_init_usb_xfer in mode %d\n",
-		       mode);
+	em28xx_isocdbg("em28xx: called %s in mode %d\n", __func__, mode);
 
 	dev->usb_ctl.urb_data_copy = urb_data_copy;
 
-- 
2.14.3
