Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48591 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbcJNRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 03/25] [media] em28xx: don't break long lines
Date: Fri, 14 Oct 2016 14:45:41 -0300
Message-Id: <ef6c345183c982d3313f8487e600ff99178d908c.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 10 +++----
 drivers/media/usb/em28xx/em28xx-cards.c | 51 ++++++++++++---------------------
 drivers/media/usb/em28xx/em28xx-core.c  | 11 ++++---
 drivers/media/usb/em28xx/em28xx-dvb.c   |  6 ++--
 drivers/media/usb/em28xx/em28xx-input.c |  3 +-
 drivers/media/usb/em28xx/em28xx-video.c |  6 ++--
 6 files changed, 33 insertions(+), 54 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index e11fe46a547c..2a3975b1aea5 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2006 Markus Rechberger <mrechberger@gmail.com>
  *
- *  Copyright (C) 2007-2014 Mauro Carvalho Chehab
+ *  Copyright (C) 2007-2016 Mauro Carvalho Chehab
  *	- Port to work with the in-kernel driver
  *	- Cleanups, fixes, alsa-controls, etc.
  *
@@ -254,8 +254,7 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	int nonblock, ret = 0;
 
 	if (!dev) {
-		em28xx_err("BUG: em28xx can't find device struct."
-				" Can't proceed with open\n");
+		em28xx_err("BUG: em28xx can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
@@ -902,10 +901,9 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	kref_get(&dev->ref);
 
-	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
-			 "Rechberger\n");
+	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus Rechberger\n");
 	printk(KERN_INFO
-	       "em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho Chehab\n");
+	       "em28xx-audio.c: Copyright (C) 2007-2016 Mauro Carvalho Chehab\n");
 
 	err = snd_card_new(&dev->udev->dev, index[devnr], "Em28xx Audio",
 			   THIS_MODULE, 0, &card);
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index e397f544f108..bed41c1b4817 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2832,13 +2832,10 @@ static int em28xx_hint_board(struct em28xx *dev)
 			dev->tuner_type = em28xx_eeprom_hash[i].tuner;
 
 			em28xx_errdev("Your board has no unique USB ID.\n");
-			em28xx_errdev("A hint were successfully done, "
-				      "based on eeprom hash.\n");
+			em28xx_errdev("A hint were successfully done, based on eeprom hash.\n");
 			em28xx_errdev("This method is not 100%% failproof.\n");
-			em28xx_errdev("If the board were missdetected, "
-				      "please email this log to:\n");
-			em28xx_errdev("\tV4L Mailing List "
-				      " <linux-media@vger.kernel.org>\n");
+			em28xx_errdev("If the board were missdetected, please email this log to:\n");
+			em28xx_errdev("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
 			em28xx_errdev("Board detected as %s\n",
 				      em28xx_boards[dev->model].name);
 
@@ -2864,13 +2861,10 @@ static int em28xx_hint_board(struct em28xx *dev)
 			dev->model = em28xx_i2c_hash[i].model;
 			dev->tuner_type = em28xx_i2c_hash[i].tuner;
 			em28xx_errdev("Your board has no unique USB ID.\n");
-			em28xx_errdev("A hint were successfully done, "
-				      "based on i2c devicelist hash.\n");
+			em28xx_errdev("A hint were successfully done, based on i2c devicelist hash.\n");
 			em28xx_errdev("This method is not 100%% failproof.\n");
-			em28xx_errdev("If the board were missdetected, "
-				      "please email this log to:\n");
-			em28xx_errdev("\tV4L Mailing List "
-				      " <linux-media@vger.kernel.org>\n");
+			em28xx_errdev("If the board were missdetected, please email this log to:\n");
+			em28xx_errdev("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
 			em28xx_errdev("Board detected as %s\n",
 				      em28xx_boards[dev->model].name);
 
@@ -2878,17 +2872,14 @@ static int em28xx_hint_board(struct em28xx *dev)
 		}
 	}
 
-	em28xx_errdev("Your board has no unique USB ID and thus need a "
-		      "hint to be detected.\n");
-	em28xx_errdev("You may try to use card=<n> insmod option to "
-		      "workaround that.\n");
+	em28xx_errdev("Your board has no unique USB ID and thus need a hint to be detected.\n");
+	em28xx_errdev("You may try to use card=<n> insmod option to workaround that.\n");
 	em28xx_errdev("Please send an email with this log to:\n");
 	em28xx_errdev("\tV4L Mailing List <linux-media@vger.kernel.org>\n");
 	em28xx_errdev("Board eeprom hash is 0x%08lx\n", dev->hash);
 	em28xx_errdev("Board i2c devicelist hash is 0x%08lx\n", dev->i2c_hash);
 
-	em28xx_errdev("Here is a list of valid choices for the card=<n>"
-		      " insmod option:\n");
+	em28xx_errdev("Here is a list of valid choices for the card=<n> insmod option:\n");
 	for (i = 0; i < em28xx_bcount; i++) {
 		em28xx_errdev("    card=%d -> %s\n",
 			      i, em28xx_boards[i].name);
@@ -3035,11 +3026,9 @@ static void em28xx_card_setup(struct em28xx *dev)
 
 	if (dev->board.valid == EM28XX_BOARD_NOT_VALIDATED) {
 		em28xx_errdev("\n\n");
-		em28xx_errdev("The support for this board weren't "
-			      "valid yet.\n");
+		em28xx_errdev("The support for this board weren't valid yet.\n");
 		em28xx_errdev("Please send a report of having this working\n");
-		em28xx_errdev("not to V4L mailing list (and/or to other "
-				"addresses)\n\n");
+		em28xx_errdev("not to V4L mailing list (and/or to other addresses)\n\n");
 	}
 
 	/* Free eeprom data memory */
@@ -3360,8 +3349,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		/* Resets I2C speed */
 		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
 		if (retval < 0) {
-			em28xx_errdev("%s: em28xx_write_reg failed!"
-				      " retval [%d]\n",
+			em28xx_errdev("%s: em28xx_write_reg failed! retval [%d]\n",
 				      __func__, retval);
 			return retval;
 		}
@@ -3429,7 +3417,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		nr = find_first_zero_bit(em28xx_devused, EM28XX_MAXBOARDS);
 		if (nr >= EM28XX_MAXBOARDS) {
 			/* No free device slots */
-			printk(DRIVER_NAME ": Supports only %i em28xx boards.\n",
+			printk(DRIVER_NAME
+			       ": Supports only %i em28xx boards.\n",
 			       EM28XX_MAXBOARDS);
 			retval = -ENOMEM;
 			goto err_no_slot;
@@ -3438,8 +3427,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	/* Don't register audio interfaces */
 	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
-		em28xx_err(DRIVER_NAME " audio device (%04x:%04x): "
-			"interface %i, class %i\n",
+		em28xx_err(DRIVER_NAME
+			" audio device (%04x:%04x): interface %i, class %i\n",
 			le16_to_cpu(udev->descriptor.idVendor),
 			le16_to_cpu(udev->descriptor.idProduct),
 			ifnum,
@@ -3502,7 +3491,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 						has_vendor_audio = true;
 					} else {
 						printk(KERN_INFO DRIVER_NAME
-						": error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
+						       ": error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
 					}
 					break;
 				case 0x84:
@@ -3576,8 +3565,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	printk(KERN_INFO DRIVER_NAME
-		": New device %s %s @ %s Mbps "
-		"(%04x:%04x, interface %d, class %d)\n",
+		": New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
 		udev->manufacturer ? udev->manufacturer : "",
 		udev->product ? udev->product : "",
 		speed,
@@ -3593,8 +3581,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	 */
 	if (udev->speed != USB_SPEED_HIGH && disable_usb_speed_check == 0) {
 		printk(DRIVER_NAME ": Device initialization failed.\n");
-		printk(DRIVER_NAME ": Device must be connected to a high-speed"
-		       " USB 2.0 port.\n");
+		printk(DRIVER_NAME ": Device must be connected to a high-speed USB 2.0 port.\n");
 		retval = -ENODEV;
 		goto err_free;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index eebd5d7088d0..a73e853e876e 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -87,8 +87,8 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 		return -EINVAL;
 
 	if (reg_debug) {
-		printk(KERN_DEBUG "(pipe 0x%08x): "
-			"IN:  %02x %02x %02x %02x %02x %02x %02x %02x ",
+		printk(KERN_DEBUG
+			"(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x ",
 			pipe,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			req, 0, 0,
@@ -165,8 +165,8 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 	if (reg_debug) {
 		int byte;
 
-		printk(KERN_DEBUG "(pipe 0x%08x): "
-			"OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>>",
+		printk(KERN_DEBUG
+			"(pipe 0x%08x): OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>>",
 			pipe,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			req, 0, 0,
@@ -942,8 +942,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		usb_bufs->transfer_buffer[i] = usb_alloc_coherent(dev->udev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!usb_bufs->transfer_buffer[i]) {
-			em28xx_err("unable to allocate %i bytes for transfer"
-					" buffer %i%s\n",
+			em28xx_err("unable to allocate %i bytes for transfer buffer %i%s\n",
 					sb_size, i,
 					in_interrupt() ? " while in int" : "");
 			em28xx_uninit_usb_xfer(dev, mode);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 8cedef0daae4..488c70e5ebde 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -934,8 +934,7 @@ static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
 	cfg.ctrl  = &ctl;
 
 	if (!dev->dvb->fe[0]) {
-		em28xx_errdev("/2: dvb frontend not attached. "
-				"Can't attach xc3028\n");
+		em28xx_errdev("/2: dvb frontend not attached. Can't attach xc3028\n");
 		return -EINVAL;
 	}
 
@@ -1937,8 +1936,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	default:
-		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
-				" isn't supported yet\n");
+		em28xx_errdev("/2: The frontend of your DVB/ATSC card isn't supported yet\n");
 		break;
 	}
 	if (NULL == dvb->fe[0]) {
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 4007356d991d..580f3853505d 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -703,8 +703,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 
 	if (dev->board.ir_codes == NULL && !dev->board.has_ir_i2c) {
 		/* No remote control support */
-		em28xx_warn("Remote control support is not available for "
-				"this card.\n");
+		em28xx_warn("Remote control support is not available for this card.\n");
 		return 0;
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 1f7fa059eb34..119877bb8a1e 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -505,8 +505,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 
 		if ((char *)startwrite + lencopy > (char *)buf->vb_buf +
 		    buf->length) {
-			em28xx_isocdbg("Overflow of %zu bytes past buffer end"
-				       "(2)\n",
+			em28xx_isocdbg("Overflow of %zu bytes past buffer end(2)\n",
 				       ((char *)startwrite + lencopy) -
 				       ((char *)buf->vb_buf + buf->length));
 			lencopy = remain = (char *)buf->vb_buf + buf->length -
@@ -2204,8 +2203,7 @@ static int em28xx_v4l2_close(struct file *filp)
 		em28xx_videodbg("setting alternate 0\n");
 		errCode = usb_set_interface(dev->udev, 0, 0);
 		if (errCode < 0) {
-			em28xx_errdev("cannot change alternate number to "
-					"0 (error=%i)\n", errCode);
+			em28xx_errdev("cannot change alternate number to 0 (error=%i)\n", errCode);
 		}
 	}
 
-- 
2.7.4


