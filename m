Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48599 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755361AbcJNRrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 06/25] [media] em28xx: convert the remaining printks to pr_foo
Date: Fri, 14 Oct 2016 14:45:44 -0300
Message-Id: <65d7fd29f5121101bf2911f5588bf914a627dc6c.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are still several places with printk's called directly.

Convert them to pr_foo() macros, except for the debug printk's,
as those are enabled via modprobe vars.

While here, realign the pr_foo() arguments to match the
recommended CodingStyle.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c  | 10 ++---
 drivers/media/usb/em28xx/em28xx-camera.c | 21 +++++----
 drivers/media/usb/em28xx/em28xx-cards.c  | 67 ++++++++++++-----------------
 drivers/media/usb/em28xx/em28xx-core.c   | 47 ++++++++++----------
 drivers/media/usb/em28xx/em28xx-dvb.c    | 39 ++++++++---------
 drivers/media/usb/em28xx/em28xx-i2c.c    | 74 ++++++++++++++++----------------
 drivers/media/usb/em28xx/em28xx-input.c  |  2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c    |  7 +--
 drivers/media/usb/em28xx/em28xx-video.c  | 46 +++++++++-----------
 9 files changed, 146 insertions(+), 167 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index b5f35a25d870..06e495615296 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -56,9 +56,8 @@ MODULE_PARM_DESC(debug, "activates debug info");
 
 #define dprintk(fmt, arg...) do {					\
 	    if (debug)							\
-		printk(KERN_INFO "em28xx-audio %s: " fmt,		\
-				  __func__, ##arg);		\
-	} while (0)
+		printk(KERN_DEBUG pr_fmt("audio: %s: " fmt),		\
+			 __func__, ##arg); } while (0)
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 
@@ -902,9 +901,8 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	kref_get(&dev->ref);
 
-	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus Rechberger\n");
-	printk(KERN_INFO
-	       "em28xx-audio.c: Copyright (C) 2007-2016 Mauro Carvalho Chehab\n");
+	pr_info("em28xx-audio.c: Copyright (C) 2006 Markus Rechberger\n");
+	pr_info("em28xx-audio.c: Copyright (C) 2007-2016 Mauro Carvalho Chehab\n");
 
 	err = snd_card_new(&dev->udev->dev, index[devnr], "Em28xx Audio",
 			   THIS_MODULE, 0, &card);
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index bc07166e7df0..a24695474212 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -121,13 +121,13 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 		if (ret < 0) {
 			if (ret != -ENXIO)
 				pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-					      client.addr << 1, ret);
+				       client.addr << 1, ret);
 			continue;
 		}
 		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
 		if (ret < 0) {
 			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-				      client.addr << 1, ret);
+			       client.addr << 1, ret);
 			continue;
 		}
 		id = be16_to_cpu(id_be);
@@ -136,13 +136,13 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 		ret = i2c_master_send(&client, &reg, 1);
 		if (ret < 0) {
 			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-				      client.addr << 1, ret);
+			       client.addr << 1, ret);
 			continue;
 		}
 		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
 		if (ret < 0) {
 			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-				      client.addr << 1, ret);
+			       client.addr << 1, ret);
 			continue;
 		}
 		/* Validate chip ID to be sure we have a Micron device */
@@ -180,8 +180,7 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 			dev->em28xx_sensor = EM28XX_MT9M001;
 			break;
 		default:
-			pr_info("unknown Micron sensor detected: 0x%04x\n",
-				    id);
+			pr_info("unknown Micron sensor detected: 0x%04x\n", id);
 			return 0;
 		}
 
@@ -219,7 +218,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		if (ret < 0) {
 			if (ret != -ENXIO)
 				pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-					      client.addr << 1, ret);
+				       client.addr << 1, ret);
 			continue;
 		}
 		id = ret << 8;
@@ -227,7 +226,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
 			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-				      client.addr << 1, ret);
+			       client.addr << 1, ret);
 			continue;
 		}
 		id += ret;
@@ -239,7 +238,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
 			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-				      client.addr << 1, ret);
+			       client.addr << 1, ret);
 			continue;
 		}
 		id = ret << 8;
@@ -247,7 +246,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
 			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-				      client.addr << 1, ret);
+			       client.addr << 1, ret);
 			continue;
 		}
 		id += ret;
@@ -286,7 +285,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 			break;
 		default:
 			pr_info("unknown OmniVision sensor detected: 0x%04x\n",
-				    id);
+				id);
 			return 0;
 		}
 
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index c73cf2012bf5..bcd6ac61d9f8 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2838,7 +2838,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 			pr_err("If the board were missdetected, please email this log to:\n");
 			pr_err("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
 			pr_err("Board detected as %s\n",
-				      em28xx_boards[dev->model].name);
+			       em28xx_boards[dev->model].name);
 
 			return 0;
 		}
@@ -2867,7 +2867,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 			pr_err("If the board were missdetected, please email this log to:\n");
 			pr_err("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
 			pr_err("Board detected as %s\n",
-				      em28xx_boards[dev->model].name);
+			       em28xx_boards[dev->model].name);
 
 			return 0;
 		}
@@ -2882,8 +2882,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 
 	pr_err("Here is a list of valid choices for the card=<n> insmod option:\n");
 	for (i = 0; i < em28xx_bcount; i++) {
-		pr_err("    card=%d -> %s\n",
-			      i, em28xx_boards[i].name);
+		pr_err("    card=%d -> %s\n", i, em28xx_boards[i].name);
 	}
 	return -1;
 }
@@ -2928,7 +2927,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 	}
 
 	pr_info("Identified as %s (card=%d)\n",
-		    dev->board.name, dev->model);
+		dev->board.name, dev->model);
 
 	dev->tuner_type = em28xx_boards[dev->model].tuner_type;
 
@@ -3318,14 +3317,12 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
 		default:
-			printk(KERN_INFO DRIVER_NAME
-			       ": unknown em28xx chip ID (%d)\n", dev->chip_id);
+			pr_info("unknown em28xx chip ID (%d)\n", dev->chip_id);
 		}
 	}
 
 	if (chip_name != default_chip_name)
-		printk(KERN_INFO DRIVER_NAME
-		       ": chip ID is %s\n", chip_name);
+		pr_info("chip ID is %s\n", chip_name);
 
 	/*
 	 * For em2820/em2710, the name may change latter, after checking
@@ -3351,7 +3348,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
 		if (retval < 0) {
 			pr_err("%s: em28xx_write_reg failed! retval [%d]\n",
-				      __func__, retval);
+			       __func__, retval);
 			return retval;
 		}
 	}
@@ -3365,7 +3362,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
 	if (retval < 0) {
 		pr_err("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
-			      __func__, retval);
+		       __func__, retval);
 		return retval;
 	}
 
@@ -3379,7 +3376,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 						     EM28XX_I2C_ALGO_EM28XX);
 		if (retval < 0) {
 			pr_err("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
-				      __func__, retval);
+			       __func__, retval);
 
 			em28xx_i2c_unregister(dev, 0);
 
@@ -3418,8 +3415,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		nr = find_first_zero_bit(em28xx_devused, EM28XX_MAXBOARDS);
 		if (nr >= EM28XX_MAXBOARDS) {
 			/* No free device slots */
-			printk(DRIVER_NAME
-			       ": Supports only %i em28xx boards.\n",
+			pr_err("Driver supports up to %i em28xx boards.\n",
 			       EM28XX_MAXBOARDS);
 			retval = -ENOMEM;
 			goto err_no_slot;
@@ -3428,8 +3424,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	/* Don't register audio interfaces */
 	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
-		pr_err(DRIVER_NAME
-			" audio device (%04x:%04x): interface %i, class %i\n",
+		pr_err("audio device (%04x:%04x): interface %i, class %i\n",
 			le16_to_cpu(udev->descriptor.idVendor),
 			le16_to_cpu(udev->descriptor.idProduct),
 			ifnum,
@@ -3489,8 +3484,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 					if (usb_endpoint_xfer_isoc(e)) {
 						has_vendor_audio = true;
 					} else {
-						printk(KERN_INFO DRIVER_NAME
-						       ": error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
+						pr_err("error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
 					}
 					break;
 				case 0x84:
@@ -3563,8 +3557,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-	printk(KERN_INFO DRIVER_NAME
-		": New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
+	pr_info("New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
 		udev->manufacturer ? udev->manufacturer : "",
 		udev->product ? udev->product : "",
 		speed,
@@ -3579,8 +3572,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	 * not enough even for most Digital TV streams.
 	 */
 	if (udev->speed != USB_SPEED_HIGH && disable_usb_speed_check == 0) {
-		printk(DRIVER_NAME ": Device initialization failed.\n");
-		printk(DRIVER_NAME ": Device must be connected to a high-speed USB 2.0 port.\n");
+		pr_err("Device initialization failed.\n");
+		pr_err("Device must be connected to a high-speed USB 2.0 port.\n");
 		retval = -ENODEV;
 		goto err_free;
 	}
@@ -3593,8 +3586,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->ifnum = ifnum;
 
 	if (has_vendor_audio) {
-		printk(KERN_INFO DRIVER_NAME ": Audio interface %i found %s\n",
-		       ifnum, "(Vendor Class)");
+		pr_info("Audio interface %i found (Vendor Class)\n", ifnum);
 		dev->usb_audio_type = EM28XX_USB_AUDIO_VENDOR;
 	}
 	/* Checks if audio is provided by a USB Audio Class interface */
@@ -3604,24 +3596,22 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
 			if (has_vendor_audio)
 				pr_err("em28xx: device seems to have vendor AND usb audio class interfaces !\n"
-					   "\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
+				       "\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
 			dev->usb_audio_type = EM28XX_USB_AUDIO_CLASS;
 			break;
 		}
 	}
 
 	if (has_video)
-		printk(KERN_INFO DRIVER_NAME
-		       ": Video interface %i found:%s%s\n",
-		       ifnum,
-		       dev->analog_ep_bulk ? " bulk" : "",
-		       dev->analog_ep_isoc ? " isoc" : "");
+		pr_info("Video interface %i found:%s%s\n",
+			ifnum,
+			dev->analog_ep_bulk ? " bulk" : "",
+			dev->analog_ep_isoc ? " isoc" : "");
 	if (has_dvb)
-		printk(KERN_INFO DRIVER_NAME
-		       ": DVB interface %i found:%s%s\n",
-		       ifnum,
-		       dev->dvb_ep_bulk ? " bulk" : "",
-		       dev->dvb_ep_isoc ? " isoc" : "");
+		pr_info("DVB interface %i found:%s%s\n",
+			ifnum,
+			dev->dvb_ep_bulk ? " bulk" : "",
+			dev->dvb_ep_isoc ? " isoc" : "");
 
 	dev->num_alt = interface->num_altsetting;
 
@@ -3650,8 +3640,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* Disable V4L2 if the device doesn't have a decoder */
 	if (has_video &&
 	    dev->board.decoder == EM28XX_NODECODER && !dev->board.is_webcam) {
-		printk(DRIVER_NAME
-		       ": Currently, V4L2 is not supported on this model\n");
+		pr_err("Currently, V4L2 is not supported on this model\n");
 		has_video = false;
 		dev->has_video = false;
 	}
@@ -3661,13 +3650,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
 			dev->analog_xfer_bulk = 1;
 		pr_info("analog set to %s mode.\n",
-			    dev->analog_xfer_bulk ? "bulk" : "isoc");
+			dev->analog_xfer_bulk ? "bulk" : "isoc");
 	}
 	if (has_dvb) {
 		if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
 			dev->dvb_xfer_bulk = 1;
 		pr_info("dvb set to %s mode.\n",
-			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
+			dev->dvb_xfer_bulk ? "bulk" : "isoc");
 	}
 
 	kref_init(&dev->ref);
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 8897cde9894b..a413ff7c30d7 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -48,12 +48,12 @@ MODULE_VERSION(EM28XX_VERSION);
 
 static unsigned int core_debug;
 module_param(core_debug, int, 0644);
-MODULE_PARM_DESC(core_debug, "enable debug messages [core]");
+MODULE_PARM_DESC(core_debug, "enable debug messages [core and isoc]");
 
 #define em28xx_coredbg(fmt, arg...) do {\
 	if (core_debug) \
-		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __func__ , ##arg); } while (0)
+		printk(KERN_DEBUG pr_fmt("core: %s: " fmt), \
+			 __func__, ##arg); } while (0)
 
 static unsigned int reg_debug;
 module_param(reg_debug, int, 0644);
@@ -61,14 +61,14 @@ MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
 
 #define em28xx_regdbg(fmt, arg...) do {\
 	if (reg_debug) \
-		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __func__ , ##arg); } while (0)
+		printk(KERN_DEBUG pr_fmt("reg: %s: " fmt), \
+		       __func__, ##arg); } while (0)
 
 /* FIXME */
 #define em28xx_isocdbg(fmt, arg...) do {\
 	if (core_debug) \
-		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __func__ , ##arg); } while (0)
+		printk(KERN_DEBUG pr_fmt("isoc: %s: " fmt), \
+		       __func__, ##arg); } while (0)
 
 /*
  * em28xx_read_reg_req()
@@ -102,7 +102,7 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	if (ret < 0) {
 		if (reg_debug)
-			printk(KERN_CONT " failed!\n");
+			pr_cont(" failed!\n");
 		mutex_unlock(&dev->ctrl_urb_lock);
 		return usb_translate_errors(ret);
 	}
@@ -115,10 +115,10 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 	if (reg_debug) {
 		int byte;
 
-		printk(KERN_CONT "<<<");
+		pr_cont("<<<");
 		for (byte = 0; byte < len; byte++)
-			printk(KERN_CONT " %02x", (unsigned char)buf[byte]);
-		printk(KERN_CONT "\n");
+			pr_cont(" %02x", (unsigned char)buf[byte]);
+		pr_cont("\n");
 	}
 
 	return ret;
@@ -174,8 +174,8 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 			len & 0xff, len >> 8);
 
 		for (byte = 0; byte < len; byte++)
-			printk(KERN_CONT " %02x", (unsigned char)buf[byte]);
-		printk(KERN_CONT "\n");
+			pr_cont(" %02x", (unsigned char)buf[byte]);
+		pr_cont("\n");
 	}
 
 	mutex_lock(&dev->ctrl_urb_lock);
@@ -541,7 +541,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 		else
 			i2s_samplerates = 3;
 		pr_info("I2S Audio (%d sample rate(s))\n",
-			    i2s_samplerates);
+			i2s_samplerates);
 		/* Skip the code that does AC97 vendor detection */
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		goto init_audio;
@@ -596,7 +596,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 		break;
 	case EM28XX_AC97_SIGMATEL:
 		pr_info("Sigmatel audio processor detected (stac 97%02x)\n",
-			    vid & 0xff);
+			vid & 0xff);
 		break;
 	case EM28XX_AC97_OTHER:
 		pr_warn("Unknown AC97 audio processor detected!\n");
@@ -884,7 +884,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		if ((xfer_bulk && !dev->dvb_ep_bulk) ||
 		    (!xfer_bulk && !dev->dvb_ep_isoc)) {
 			pr_err("no endpoint for DVB mode and transfer type %d\n",
-				      xfer_bulk > 0);
+			       xfer_bulk > 0);
 			return -EINVAL;
 		}
 		usb_bufs = &dev->usb_ctl.digital_bufs;
@@ -892,7 +892,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		if ((xfer_bulk && !dev->analog_ep_bulk) ||
 		    (!xfer_bulk && !dev->analog_ep_isoc)) {
 			pr_err("no endpoint for analog mode and transfer type %d\n",
-				      xfer_bulk > 0);
+			       xfer_bulk > 0);
 			return -EINVAL;
 		}
 		usb_bufs = &dev->usb_ctl.analog_bufs;
@@ -940,8 +940,8 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!usb_bufs->transfer_buffer[i]) {
 			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
-					sb_size, i,
-					in_interrupt() ? " while in int" : "");
+			       sb_size, i,
+			       in_interrupt() ? " while in int" : "");
 			em28xx_uninit_usb_xfer(dev, mode);
 			return -ENOMEM;
 		}
@@ -1022,7 +1022,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 		rc = usb_clear_halt(dev->udev, usb_bufs->urb[0]->pipe);
 		if (rc < 0) {
 			pr_err("failed to clear USB bulk endpoint stall/halt condition (error=%i)\n",
-				   rc);
+			       rc);
 			em28xx_uninit_usb_xfer(dev, mode);
 			return rc;
 		}
@@ -1037,8 +1037,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 	for (i = 0; i < usb_bufs->num_bufs; i++) {
 		rc = usb_submit_urb(usb_bufs->urb[i], GFP_ATOMIC);
 		if (rc) {
-			pr_err("submit of urb %i failed (error=%i)\n", i,
-				   rc);
+			pr_err("submit of urb %i failed (error=%i)\n", i, rc);
 			em28xx_uninit_usb_xfer(dev, mode);
 			return rc;
 		}
@@ -1071,7 +1070,7 @@ int em28xx_register_extension(struct em28xx_ops *ops)
 		ops->init(dev);
 	}
 	mutex_unlock(&em28xx_devlist_mutex);
-	printk(KERN_INFO "em28xx: Registered (%s) extension\n", ops->name);
+	pr_info("em28xx: Registered (%s) extension\n", ops->name);
 	return 0;
 }
 EXPORT_SYMBOL(em28xx_register_extension);
@@ -1086,7 +1085,7 @@ void em28xx_unregister_extension(struct em28xx_ops *ops)
 	}
 	list_del(&ops->next);
 	mutex_unlock(&em28xx_devlist_mutex);
-	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
+	pr_info("Em28xx: Removed (%s) extension\n", ops->name);
 }
 EXPORT_SYMBOL(em28xx_unregister_extension);
 
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index cbece65899b5..6feb0e416eac 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -935,19 +935,19 @@ static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
 	cfg.ctrl  = &ctl;
 
 	if (!dev->dvb->fe[0]) {
-		pr_err("/2: dvb frontend not attached. Can't attach xc3028\n");
+		pr_err("dvb frontend not attached. Can't attach xc3028\n");
 		return -EINVAL;
 	}
 
 	fe = dvb_attach(xc2028_attach, dev->dvb->fe[0], &cfg);
 	if (!fe) {
-		pr_err("/2: xc3028 attach failed\n");
+		pr_err("xc3028 attach failed\n");
 		dvb_frontend_detach(dev->dvb->fe[0]);
 		dev->dvb->fe[0] = NULL;
 		return -EINVAL;
 	}
 
-	pr_info("%s/2: xc3028 attached\n", dev->name);
+	pr_info("xc3028 attached\n");
 
 	return 0;
 }
@@ -966,8 +966,8 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	result = dvb_register_adapter(&dvb->adapter, dev->name, module, device,
 				      adapter_nr);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_register_adapter failed (errno = %d)\n",
-		       dev->name, result);
+		pr_warn("dvb_register_adapter failed (errno = %d)\n",
+			result);
 		goto fail_adapter;
 	}
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
@@ -984,8 +984,8 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->fe[0]);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_register_frontend failed (errno = %d)\n",
-		       dev->name, result);
+		pr_warn("dvb_register_frontend failed (errno = %d)\n",
+			result);
 		goto fail_frontend0;
 	}
 
@@ -993,8 +993,8 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	if (dvb->fe[1]) {
 		result = dvb_register_frontend(&dvb->adapter, dvb->fe[1]);
 		if (result < 0) {
-			printk(KERN_WARNING "%s: 2nd dvb_register_frontend failed (errno = %d)\n",
-			       dev->name, result);
+			pr_warn("2nd dvb_register_frontend failed (errno = %d)\n",
+				result);
 			goto fail_frontend1;
 		}
 	}
@@ -1011,8 +1011,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 
 	result = dvb_dmx_init(&dvb->demux);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_dmx_init failed (errno = %d)\n",
-		       dev->name, result);
+		pr_warn("dvb_dmx_init failed (errno = %d)\n", result);
 		goto fail_dmx;
 	}
 
@@ -1021,31 +1020,29 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	dvb->dmxdev.capabilities = 0;
 	result = dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_dmxdev_init failed (errno = %d)\n",
-		       dev->name, result);
+		pr_warn("dvb_dmxdev_init failed (errno = %d)\n", result);
 		goto fail_dmxdev;
 	}
 
 	dvb->fe_hw.source = DMX_FRONTEND_0;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
-		       dev->name, result);
+		pr_warn("add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
+			result);
 		goto fail_fe_hw;
 	}
 
 	dvb->fe_mem.source = DMX_MEMORY_FE;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
-		       dev->name, result);
+		pr_warn("add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
+			result);
 		goto fail_fe_mem;
 	}
 
 	result = dvb->demux.dmx.connect_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: connect_frontend failed (errno = %d)\n",
-		       dev->name, result);
+		pr_warn("connect_frontend failed (errno = %d)\n", result);
 		goto fail_fe_conn;
 	}
 
@@ -1936,11 +1933,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	default:
-		pr_err("/2: The frontend of your DVB/ATSC card isn't supported yet\n");
+		pr_err("The frontend of your DVB/ATSC card isn't supported yet\n");
 		break;
 	}
 	if (NULL == dvb->fe[0]) {
-		pr_err("/2: frontend initialization failed\n");
+		pr_err("frontend initialization failed\n");
 		result = -EINVAL;
 		goto out_free;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 5185fed9fbf0..b7a5b4c5ceff 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -83,12 +83,12 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x94 + len - 1) {
 			if (i2c_debug == 1)
 				pr_warn("R05 returned 0x%02x: I2C ACK error\n",
-					    ret);
+					ret);
 			return -ENXIO;
 		}
 		if (ret < 0) {
 			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-				    ret);
+				ret);
 			return ret;
 		}
 		msleep(5);
@@ -118,7 +118,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	ret = dev->em28xx_write_regs(dev, 0x04, buf2, 2);
 	if (ret != 2) {
 		pr_warn("failed to trigger read from i2c address 0x%x (error=%i)\n",
-			    addr, ret);
+			addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
 
@@ -130,12 +130,12 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x94 + len - 1) {
 			if (i2c_debug == 1)
 				pr_warn("R05 returned 0x%02x: I2C ACK error\n",
-					    ret);
+					ret);
 			return -ENXIO;
 		}
 		if (ret < 0) {
 			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-				    ret);
+				ret);
 			return ret;
 		}
 		msleep(5);
@@ -143,14 +143,14 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	if (ret != 0x84 + len - 1) {
 		if (i2c_debug)
 			pr_warn("read from i2c device at 0x%x timed out\n",
-				    addr);
+				addr);
 	}
 
 	/* get the received message */
 	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
 	if (ret != len) {
 		pr_warn("reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
-			    addr, ret);
+			addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
 	for (i = 0; i < len; i++)
@@ -195,11 +195,11 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	if (ret != len) {
 		if (ret < 0) {
 			pr_warn("writing to i2c device at 0x%x failed (error=%i)\n",
-				    addr, ret);
+				addr, ret);
 			return ret;
 		} else {
 			pr_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
-				    len, addr, ret);
+				len, addr, ret);
 			return -EIO;
 		}
 	}
@@ -212,12 +212,12 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		if (ret == 0x10) {
 			if (i2c_debug == 1)
 				pr_warn("I2C ACK error on writing to addr 0x%02x\n",
-					    addr);
+					addr);
 			return -ENXIO;
 		}
 		if (ret < 0) {
 			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-				    ret);
+				ret);
 			return ret;
 		}
 		msleep(5);
@@ -232,12 +232,12 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		/* NOTE: these errors seem to be related to clock stretching */
 		if (i2c_debug)
 			pr_warn("write to i2c device at 0x%x timed out (status=%i)\n",
-				    addr, ret);
+				addr, ret);
 		return -ETIMEDOUT;
 	}
 
 	pr_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
-		    addr, ret);
+		addr, ret);
 	return -EIO;
 }
 
@@ -260,7 +260,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
 	if (ret < 0) {
 		pr_warn("reading from i2c device at 0x%x failed (error=%i)\n",
-			    addr, ret);
+			addr, ret);
 		return ret;
 	}
 	/*
@@ -278,13 +278,13 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 		return len;
 	if (ret < 0) {
 		pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-			    ret);
+			ret);
 		return ret;
 	}
 	if (ret == 0x10) {
 		if (i2c_debug == 1)
 			pr_warn("I2C ACK error on writing to addr 0x%02x\n",
-				    addr);
+				addr);
 		return -ENXIO;
 	}
 
@@ -292,12 +292,12 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 		/* NOTE: these errors seem to be related to clock stretching */
 		if (i2c_debug)
 			pr_warn("write to i2c device at 0x%x timed out (status=%i)\n",
-				    addr, ret);
+				addr, ret);
 		return -ETIMEDOUT;
 	}
 
 	pr_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
-		    addr, ret);
+		addr, ret);
 	return -EIO;
 }
 
@@ -337,11 +337,11 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	if (ret != len) {
 		if (ret < 0) {
 			pr_warn("writing to i2c device at 0x%x failed (error=%i)\n",
-				    addr, ret);
+				addr, ret);
 			return ret;
 		} else {
 			pr_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
-				    len, addr, ret);
+				len, addr, ret);
 			return -EIO;
 		}
 	}
@@ -356,7 +356,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	else if (ret > 0) {
 		if (i2c_debug == 1)
 			pr_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
-				    ret);
+				ret);
 		return -ENXIO;
 	}
 
@@ -388,7 +388,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	ret = dev->em28xx_read_reg_req_len(dev, 0x06, addr, buf, len);
 	if (ret < 0) {
 		pr_warn("reading from i2c device at 0x%x failed (error=%i)\n",
-			    addr, ret);
+			addr, ret);
 		return ret;
 	}
 	/*
@@ -411,7 +411,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	else if (ret > 0) {
 		if (i2c_debug == 1)
 			pr_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
-				    ret);
+				ret);
 		return -ENXIO;
 	}
 
@@ -544,11 +544,11 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			if (rc < 0) {
 				if (rc == -ENXIO) {
 					if (i2c_debug > 1)
-						printk(KERN_CONT " no device\n");
+						pr_cont(" no device\n");
 					rc = -ENODEV;
 				} else {
 					if (i2c_debug > 1)
-						printk(KERN_CONT " ERROR: %i\n", rc);
+						pr_cont(" ERROR: %i\n", rc);
 				}
 				rt_mutex_unlock(&dev->i2c_bus_lock);
 				return rc;
@@ -558,11 +558,11 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			rc = i2c_recv_bytes(i2c_bus, msgs[i]);
 
 			if (i2c_debug > 1 && rc >= 0)
-				printk(KERN_CONT " %*ph",
+				pr_cont(" %*ph",
 				       msgs[i].len, msgs[i].buf);
 		} else {
 			if (i2c_debug > 1)
-				printk(KERN_CONT " %*ph",
+				pr_cont(" %*ph",
 				       msgs[i].len, msgs[i].buf);
 
 			/* write bytes */
@@ -570,12 +570,12 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 		}
 		if (rc < 0) {
 			if (i2c_debug > 1)
-				printk(KERN_CONT " ERROR: %i\n", rc);
+				pr_cont(" ERROR: %i\n", rc);
 			rt_mutex_unlock(&dev->i2c_bus_lock);
 			return rc;
 		}
 		if (i2c_debug > 1)
-			printk(KERN_CONT "\n");
+			pr_cont("\n");
 	}
 
 	rt_mutex_unlock(&dev->i2c_bus_lock);
@@ -709,10 +709,10 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		mc_start = (data[1] << 8) + 4;	/* usually 0x0004 */
 
 		pr_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
-			    data[0], data[1], data[2], data[3], dev->hash);
+			data[0], data[1], data[2], data[3], dev->hash);
 		pr_info("EEPROM info:\n");
 		pr_info("\tmicrocode start address = 0x%04x, boot configuration = 0x%02x\n",
-			    mc_start, data[2]);
+			mc_start, data[2]);
 		/*
 		 * boot configuration (address 0x0002):
 		 * [0]   microcode download speed: 1 = 400 kHz; 0 = 100 kHz
@@ -731,7 +731,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 					    data);
 		if (err != 2) {
 			pr_err("failed to read hardware configuration data from eeprom (err=%d)\n",
-				      err);
+			       err);
 			goto error;
 		}
 
@@ -749,7 +749,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 					    data);
 		if (err != len) {
 			pr_err("failed to read hardware configuration data from eeprom (err=%d)\n",
-				      err);
+			       err);
 			goto error;
 		}
 
@@ -769,7 +769,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		   data[2] == 0x67 && data[3] == 0x95) {
 		dev->hash = em28xx_hash_mem(data, len, 32);
 		pr_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
-			    data[0], data[1], data[2], data[3], dev->hash);
+			data[0], data[1], data[2], data[3], dev->hash);
 		pr_info("EEPROM info:\n");
 	} else {
 		pr_info("unknown eeprom format or eeprom corrupted !\n");
@@ -916,7 +916,7 @@ void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus)
 			continue;
 		i2c_devicelist[i] = i;
 		pr_info("found i2c device @ 0x%x on bus %d [%s]\n",
-			    i << 1, bus, i2c_devs[i] ? i2c_devs[i] : "???");
+			i << 1, bus, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 
 	if (bus == dev->def_i2c_bus)
@@ -951,7 +951,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
 	if (retval < 0) {
 		pr_err("%s: i2c_add_adapter failed! retval [%d]\n",
-			      __func__, retval);
+		       __func__, retval);
 		return retval;
 	}
 
@@ -963,7 +963,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 		retval = em28xx_i2c_eeprom(dev, bus, &dev->eedata, &dev->eedata_len);
 		if ((retval < 0) && (retval != -ENODEV)) {
 			pr_err("%s: em28xx_i2_eeprom failed! retval [%d]\n",
-				      __func__, retval);
+			       __func__, retval);
 
 			return retval;
 		}
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index e8e1f768d45e..0e23e65eff15 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -458,7 +458,7 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 	case CHIP_ID_EM28178:
 		return em2874_ir_change_protocol(rc_dev, rc_type);
 	default:
-		printk("Unrecognized em28xx chip id 0x%02x: IR not supported\n",
+		pr_err("Unrecognized em28xx chip id 0x%02x: IR not supported\n",
 		       dev->chip_id);
 		return -EINVAL;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 836c6b53b16c..744b3300b153 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -21,12 +21,13 @@
    02110-1301, USA.
  */
 
+#include "em28xx.h"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
 #include <linux/init.h>
 
-#include "em28xx.h"
 #include "em28xx-v4l.h"
 
 /* ------------------------------------------------------------------ */
@@ -63,8 +64,8 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 	size = v4l2->vbi_width * v4l2->vbi_height * 2;
 
 	if (vb2_plane_size(vb, 0) < size) {
-		printk(KERN_INFO "%s data will not fit into plane (%lu < %lu)\n",
-		       __func__, vb2_plane_size(vb, 0), size);
+		pr_info("%s data will not fit into plane (%lu < %lu)\n",
+			__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
 	vb2_set_plane_payload(vb, 0, size);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3efabc19bfe9..8b5e13bbfb07 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -66,16 +66,13 @@ MODULE_PARM_DESC(alt, "alternate setting to use for video endpoint");
 
 #define em28xx_videodbg(fmt, arg...) do {\
 	if (video_debug) \
-		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __func__ , ##arg); } while (0)
+		printk(KERN_DEBUG pr_fmt("video: %s: " fmt), \
+			 __func__, ##arg); } while (0)
 
-#define em28xx_isocdbg(fmt, arg...) \
-do {\
-	if (isoc_debug) { \
-		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __func__ , ##arg); \
-	} \
-  } while (0)
+#define em28xx_isocdbg(fmt, arg...) do {\
+	if (isoc_debug) \
+		printk(KERN_DEBUG pr_fmt("isoc: %s: " fmt), \
+			 __func__, ##arg); } while (0)
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC " - v4l2 interface");
@@ -415,7 +412,7 @@ static int em28xx_set_alternate(struct em28xx *dev)
 	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
 	if (errCode < 0) {
 		pr_err("cannot change alternate number to %d (error=%i)\n",
-			      dev->alt, errCode);
+		       dev->alt, errCode);
 		return errCode;
 	}
 	return 0;
@@ -2049,7 +2046,7 @@ static int em28xx_v4l2_open(struct file *filp)
 	ret = v4l2_fh_open(filp);
 	if (ret) {
 		pr_err("%s: v4l2_fh_open() returned error %d\n",
-			      __func__, ret);
+		       __func__, ret);
 		mutex_unlock(&dev->lock);
 		return ret;
 	}
@@ -2115,17 +2112,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 
 	if (video_is_registered(&v4l2->radio_dev)) {
 		pr_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(&v4l2->radio_dev));
+			video_device_node_name(&v4l2->radio_dev));
 		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		pr_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(&v4l2->vbi_dev));
+			video_device_node_name(&v4l2->vbi_dev));
 		video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		pr_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(&v4l2->vdev));
+			video_device_node_name(&v4l2->vdev));
 		video_unregister_device(&v4l2->vdev);
 	}
 
@@ -2525,7 +2522,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	ret = em28xx_audio_setup(dev);
 	if (ret < 0) {
 		pr_err("%s: Error while setting audio - error [%d]!\n",
-			      __func__, ret);
+		       __func__, ret);
 		goto unregister_dev;
 	}
 	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
@@ -2553,7 +2550,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
 		if (ret < 0) {
 			pr_err("%s: em28xx_write_reg - msp34xx(1) failed! error [%d]\n",
-				      __func__, ret);
+			       __func__, ret);
 			goto unregister_dev;
 		}
 		msleep(3);
@@ -2561,7 +2558,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
 		if (ret < 0) {
 			pr_err("%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
-				      __func__, ret);
+			       __func__, ret);
 			goto unregister_dev;
 		}
 		msleep(3);
@@ -2662,8 +2659,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	ret = video_register_device(&v4l2->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
 	if (ret) {
-		pr_err("unable to register video device (error=%i).\n",
-			      ret);
+		pr_err("unable to register video device (error=%i).\n", ret);
 		goto unregister_dev;
 	}
 
@@ -2707,7 +2703,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 			goto unregister_dev;
 		}
 		pr_info("Registered radio device as %s\n",
-			    video_device_node_name(&v4l2->radio_dev));
+			video_device_node_name(&v4l2->radio_dev));
 	}
 
 	/* Init entities at the Media Controller */
@@ -2723,11 +2719,11 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 #endif
 
 	pr_info("V4L2 video device registered as %s\n",
-		    video_device_node_name(&v4l2->vdev));
+		video_device_node_name(&v4l2->vdev));
 
 	if (video_is_registered(&v4l2->vbi_dev))
 		pr_info("V4L2 VBI device registered as %s\n",
-			    video_device_node_name(&v4l2->vbi_dev));
+			video_device_node_name(&v4l2->vbi_dev));
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
@@ -2745,17 +2741,17 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 unregister_dev:
 	if (video_is_registered(&v4l2->radio_dev)) {
 		pr_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(&v4l2->radio_dev));
+			video_device_node_name(&v4l2->radio_dev));
 		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		pr_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(&v4l2->vbi_dev));
+			video_device_node_name(&v4l2->vbi_dev));
 		video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		pr_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(&v4l2->vdev));
+			video_device_node_name(&v4l2->vdev));
 		video_unregister_device(&v4l2->vdev);
 	}
 
-- 
2.7.4


