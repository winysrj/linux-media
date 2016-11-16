Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49667 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbcKPQnP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:15 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 30/35] [media] em28xx: convert it from pr_foo() to dev_foo()
Date: Wed, 16 Nov 2016 14:43:02 -0200
Message-Id: <5aad8d6e438cf7ec3af1f7bdf9803e0c05405671.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using pr_foo(), use dev_foo(), with provides a
better output. As this device is a multi-interface one,
we'll set the device name to show the chipset and the driver
used.

While here, get rid of printk continuation messages.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c  |  64 ++++---
 drivers/media/usb/em28xx/em28xx-camera.c |  60 ++++---
 drivers/media/usb/em28xx/em28xx-cards.c  | 129 ++++++++------
 drivers/media/usb/em28xx/em28xx-core.c   | 154 +++++++++--------
 drivers/media/usb/em28xx/em28xx-dvb.c    |  89 ++++++----
 drivers/media/usb/em28xx/em28xx-i2c.c    | 284 ++++++++++++++++---------------
 drivers/media/usb/em28xx/em28xx-input.c  |  42 +++--
 drivers/media/usb/em28xx/em28xx-vbi.c    |   6 +-
 drivers/media/usb/em28xx/em28xx-video.c  | 127 ++++++++------
 drivers/media/usb/em28xx/em28xx.h        |   3 -
 10 files changed, 535 insertions(+), 423 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 06e495615296..cd2545ca5e39 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -55,9 +55,10 @@ MODULE_PARM_DESC(debug, "activates debug info");
 #define EM28XX_MIN_AUDIO_PACKETS	64
 
 #define dprintk(fmt, arg...) do {					\
-	    if (debug)							\
-		printk(KERN_DEBUG pr_fmt("audio: %s: " fmt),		\
-			 __func__, ##arg); } while (0)
+	if (debug)						\
+		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
+			   "video: %s: " fmt, __func__, ## arg);	\
+} while (0)
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 
@@ -91,7 +92,8 @@ static void em28xx_audio_isocirq(struct urb *urb)
 	struct snd_pcm_runtime   *runtime;
 
 	if (dev->disconnected) {
-		dprintk("device disconnected while streaming. URB status=%d.\n", urb->status);
+		dprintk("device disconnected while streaming. URB status=%d.\n",
+			urb->status);
 		atomic_set(&dev->adev.stream_started, 0);
 		return;
 	}
@@ -164,8 +166,9 @@ static void em28xx_audio_isocirq(struct urb *urb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status < 0)
-		pr_err("resubmit of audio urb failed (error=%i)\n",
-			      status);
+		dev_err(&dev->udev->dev,
+			"resubmit of audio urb failed (error=%i)\n",
+			status);
 	return;
 }
 
@@ -182,8 +185,9 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 
 		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
 		if (errCode) {
-			pr_err("submit of audio urb failed (error=%i)\n",
-				      errCode);
+			dev_err(&dev->udev->dev,
+				"submit of audio urb failed (error=%i)\n",
+				errCode);
 			em28xx_deinit_isoc_audio(dev);
 			atomic_set(&dev->adev.stream_started, 0);
 			return errCode;
@@ -197,6 +201,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 					size_t size)
 {
+	struct em28xx *dev = snd_pcm_substream_chip(subs);
 	struct snd_pcm_runtime *runtime = subs->runtime;
 
 	dprintk("Allocating vbuffer\n");
@@ -254,7 +259,8 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	int nonblock, ret = 0;
 
 	if (!dev) {
-		pr_err("BUG: em28xx can't find device struct. Can't proceed with open\n");
+		dev_err(&dev->udev->dev,
+			"BUG: em28xx can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
@@ -317,7 +323,8 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 err:
 	mutex_unlock(&dev->lock);
 
-	pr_err("Error while configuring em28xx mixer\n");
+	dev_err(&dev->udev->dev,
+		"Error while configuring em28xx mixer\n");
 	return ret;
 }
 
@@ -755,7 +762,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	intf = usb_ifnum_to_if(dev->udev, dev->ifnum);
 
 	if (intf->num_altsetting <= alt) {
-		pr_err("alt %d doesn't exist on interface %d\n",
+		dev_err(&dev->udev->dev, "alt %d doesn't exist on interface %d\n",
 			      dev->ifnum, alt);
 		return -ENODEV;
 	}
@@ -771,18 +778,17 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	}
 
 	if (!ep) {
-		pr_err("Couldn't find an audio endpoint");
+		dev_err(&dev->udev->dev, "Couldn't find an audio endpoint");
 		return -ENODEV;
 	}
 
 	ep_size = em28xx_audio_ep_packet_size(dev->udev, ep);
 	interval = 1 << (ep->bInterval - 1);
 
-	pr_info("Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
-		    EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
-		     dev->ifnum, alt,
-		     interval,
-		     ep_size);
+	dev_info(&dev->udev->dev,
+		 "Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
+		 EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
+		 dev->ifnum, alt, interval, ep_size);
 
 	/* Calculate the number and size of URBs to better fit the audio samples */
 
@@ -819,8 +825,9 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	if (urb_size > ep_size * npackets)
 		npackets = DIV_ROUND_UP(urb_size, ep_size);
 
-	pr_info("Number of URBs: %d, with %d packets and %d size\n",
-		    num_urb, npackets, urb_size);
+	dev_info(&dev->udev->dev,
+		 "Number of URBs: %d, with %d packets and %d size\n",
+		 num_urb, npackets, urb_size);
 
 	/* Estimate the bytes per period */
 	dev->adev.period = urb_size * npackets;
@@ -857,7 +864,8 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 		buf = usb_alloc_coherent(dev->udev, npackets * ep_size, GFP_ATOMIC,
 					 &urb->transfer_dma);
 		if (!buf) {
-			pr_err("usb_alloc_coherent failed!\n");
+			dev_err(&dev->udev->dev,
+				"usb_alloc_coherent failed!\n");
 			em28xx_audio_free_urb(dev);
 			return -ENOMEM;
 		}
@@ -897,12 +905,14 @@ static int em28xx_audio_init(struct em28xx *dev)
 		return 0;
 	}
 
-	pr_info("Binding audio extension\n");
+	dev_info(&dev->udev->dev, "Binding audio extension\n");
 
 	kref_get(&dev->ref);
 
-	pr_info("em28xx-audio.c: Copyright (C) 2006 Markus Rechberger\n");
-	pr_info("em28xx-audio.c: Copyright (C) 2007-2016 Mauro Carvalho Chehab\n");
+	dev_info(&dev->udev->dev,
+		 "em28xx-audio.c: Copyright (C) 2006 Markus Rechberger\n");
+	dev_info(&dev->udev->dev,
+		 "em28xx-audio.c: Copyright (C) 2007-2016 Mauro Carvalho Chehab\n");
 
 	err = snd_card_new(&dev->udev->dev, index[devnr], "Em28xx Audio",
 			   THIS_MODULE, 0, &card);
@@ -952,7 +962,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 	if (err < 0)
 		goto urb_free;
 
-	pr_info("Audio extension successfully initialized\n");
+	dev_info(&dev->udev->dev, "Audio extension successfully initialized\n");
 	return 0;
 
 urb_free:
@@ -977,7 +987,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
 		return 0;
 	}
 
-	pr_info("Closing audio extension\n");
+	dev_info(&dev->udev->dev, "Closing audio extension\n");
 
 	if (dev->adev.sndcard) {
 		snd_card_disconnect(dev->adev.sndcard);
@@ -1001,7 +1011,7 @@ static int em28xx_audio_suspend(struct em28xx *dev)
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
 		return 0;
 
-	pr_info("Suspending audio extension\n");
+	dev_info(&dev->udev->dev, "Suspending audio extension\n");
 	em28xx_deinit_isoc_audio(dev);
 	atomic_set(&dev->adev.stream_started, 0);
 	return 0;
@@ -1015,7 +1025,7 @@ static int em28xx_audio_resume(struct em28xx *dev)
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
 		return 0;
 
-	pr_info("Resuming audio extension\n");
+	dev_info(&dev->udev->dev, "Resuming audio extension\n");
 	/* Nothing to do other than schedule_work() ?? */
 	schedule_work(&dev->adev.wq_trigger);
 	return 0;
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index a24695474212..2e24b65901ec 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -22,6 +22,7 @@
 #include "em28xx.h"
 
 #include <linux/i2c.h>
+#include <linux/usb.h>
 #include <media/soc_camera.h>
 #include <media/i2c/mt9v011.h>
 #include <media/v4l2-clk.h>
@@ -120,14 +121,16 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 		ret = i2c_master_send(&client, &reg, 1);
 		if (ret < 0) {
 			if (ret != -ENXIO)
-				pr_err("couldn't read from i2c device 0x%02x: error %i\n",
+				dev_err(&dev->udev->dev,
+					"couldn't read from i2c device 0x%02x: error %i\n",
 				       client.addr << 1, ret);
 			continue;
 		}
 		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
 		if (ret < 0) {
-			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-			       client.addr << 1, ret);
+			dev_err(&dev->udev->dev,
+				"couldn't read from i2c device 0x%02x: error %i\n",
+				client.addr << 1, ret);
 			continue;
 		}
 		id = be16_to_cpu(id_be);
@@ -135,14 +138,16 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 		reg = 0xff;
 		ret = i2c_master_send(&client, &reg, 1);
 		if (ret < 0) {
-			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-			       client.addr << 1, ret);
+			dev_err(&dev->udev->dev,
+				"couldn't read from i2c device 0x%02x: error %i\n",
+				client.addr << 1, ret);
 			continue;
 		}
 		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
 		if (ret < 0) {
-			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-			       client.addr << 1, ret);
+			dev_err(&dev->udev->dev,
+				"couldn't read from i2c device 0x%02x: error %i\n",
+				client.addr << 1, ret);
 			continue;
 		}
 		/* Validate chip ID to be sure we have a Micron device */
@@ -180,14 +185,17 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 			dev->em28xx_sensor = EM28XX_MT9M001;
 			break;
 		default:
-			pr_info("unknown Micron sensor detected: 0x%04x\n", id);
+			dev_info(&dev->udev->dev,
+				 "unknown Micron sensor detected: 0x%04x\n", id);
 			return 0;
 		}
 
 		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
-			pr_info("unsupported sensor detected: %s\n", name);
+			dev_info(&dev->udev->dev,
+				 "unsupported sensor detected: %s\n", name);
 		else
-			pr_info("sensor %s detected\n", name);
+			dev_info(&dev->udev->dev,
+				 "sensor %s detected\n", name);
 
 		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
 		return 0;
@@ -217,16 +225,18 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
 			if (ret != -ENXIO)
-				pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-				       client.addr << 1, ret);
+				dev_err(&dev->udev->dev,
+					"couldn't read from i2c device 0x%02x: error %i\n",
+					client.addr << 1, ret);
 			continue;
 		}
 		id = ret << 8;
 		reg = 0x1d;
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
-			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-			       client.addr << 1, ret);
+			dev_err(&dev->udev->dev,
+				"couldn't read from i2c device 0x%02x: error %i\n",
+				client.addr << 1, ret);
 			continue;
 		}
 		id += ret;
@@ -237,16 +247,18 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		reg = 0x0a;
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
-			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-			       client.addr << 1, ret);
+			dev_err(&dev->udev->dev,
+				"couldn't read from i2c device 0x%02x: error %i\n",
+				client.addr << 1, ret);
 			continue;
 		}
 		id = ret << 8;
 		reg = 0x0b;
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
-			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
-			       client.addr << 1, ret);
+			dev_err(&dev->udev->dev,
+				"couldn't read from i2c device 0x%02x: error %i\n",
+				client.addr << 1, ret);
 			continue;
 		}
 		id += ret;
@@ -284,15 +296,18 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 			name = "OV9655";
 			break;
 		default:
-			pr_info("unknown OmniVision sensor detected: 0x%04x\n",
+			dev_info(&dev->udev->dev,
+				 "unknown OmniVision sensor detected: 0x%04x\n",
 				id);
 			return 0;
 		}
 
 		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
-			pr_info("unsupported sensor detected: %s\n", name);
+			dev_info(&dev->udev->dev,
+				 "unsupported sensor detected: %s\n", name);
 		else
-			pr_info("sensor %s detected\n", name);
+			dev_info(&dev->udev->dev,
+				 "sensor %s detected\n", name);
 
 		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
 		return 0;
@@ -316,7 +331,8 @@ int em28xx_detect_sensor(struct em28xx *dev)
 	 */
 
 	if (dev->em28xx_sensor == EM28XX_NOSENSOR && ret < 0) {
-		pr_info("No sensor detected\n");
+		dev_info(&dev->udev->dev,
+			 "No sensor detected\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 898fab136534..b516c691b9eb 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2677,7 +2677,7 @@ static int em28xx_wait_until_ac97_features_equals(struct em28xx *dev,
 		msleep(50);
 	}
 
-	pr_warn("AC97 registers access is not reliable !\n");
+	dev_warn(&dev->udev->dev, "AC97 registers access is not reliable !\n");
 	return -ETIMEDOUT;
 }
 
@@ -2831,12 +2831,13 @@ static int em28xx_hint_board(struct em28xx *dev)
 			dev->model = em28xx_eeprom_hash[i].model;
 			dev->tuner_type = em28xx_eeprom_hash[i].tuner;
 
-			pr_err("Your board has no unique USB ID.\n");
-			pr_err("A hint were successfully done, based on eeprom hash.\n");
-			pr_err("This method is not 100%% failproof.\n");
-			pr_err("If the board were missdetected, please email this log to:\n");
-			pr_err("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
-			pr_err("Board detected as %s\n",
+			dev_err(&dev->udev->dev,
+				"Your board has no unique USB ID.\n"
+				"A hint were successfully done, based on eeprom hash.\n"
+				"This method is not 100%% failproof.\n"
+				"If the board were missdetected, please email this log to:\n"
+				"\tV4L Mailing List  <linux-media@vger.kernel.org>\n"
+				"Board detected as %s\n",
 			       em28xx_boards[dev->model].name);
 
 			return 0;
@@ -2860,28 +2861,33 @@ static int em28xx_hint_board(struct em28xx *dev)
 		if (dev->i2c_hash == em28xx_i2c_hash[i].hash) {
 			dev->model = em28xx_i2c_hash[i].model;
 			dev->tuner_type = em28xx_i2c_hash[i].tuner;
-			pr_err("Your board has no unique USB ID.\n");
-			pr_err("A hint were successfully done, based on i2c devicelist hash.\n");
-			pr_err("This method is not 100%% failproof.\n");
-			pr_err("If the board were missdetected, please email this log to:\n");
-			pr_err("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
-			pr_err("Board detected as %s\n",
-			       em28xx_boards[dev->model].name);
+			dev_err(&dev->udev->dev,
+				"Your board has no unique USB ID.\n"
+				"A hint were successfully done, based on i2c devicelist hash.\n"
+				"This method is not 100%% failproof.\n"
+				"If the board were missdetected, please email this log to:\n"
+				"\tV4L Mailing List  <linux-media@vger.kernel.org>\n"
+				"Board detected as %s\n",
+				em28xx_boards[dev->model].name);
 
 			return 0;
 		}
 	}
 
-	pr_err("Your board has no unique USB ID and thus need a hint to be detected.\n");
-	pr_err("You may try to use card=<n> insmod option to workaround that.\n");
-	pr_err("Please send an email with this log to:\n");
-	pr_err("\tV4L Mailing List <linux-media@vger.kernel.org>\n");
-	pr_err("Board eeprom hash is 0x%08lx\n", dev->hash);
-	pr_err("Board i2c devicelist hash is 0x%08lx\n", dev->i2c_hash);
+	dev_err(&dev->udev->dev,
+		"Your board has no unique USB ID and thus need a hint to be detected.\n"
+		"You may try to use card=<n> insmod option to workaround that.\n"
+		"Please send an email with this log to:\n"
+		"\tV4L Mailing List <linux-media@vger.kernel.org>\n"
+		"Board eeprom hash is 0x%08lx\n"
+		"Board i2c devicelist hash is 0x%08lx\n",
+		dev->hash, dev->i2c_hash);
 
-	pr_err("Here is a list of valid choices for the card=<n> insmod option:\n");
+	dev_err(&dev->udev->dev,
+		"Here is a list of valid choices for the card=<n> insmod option:\n");
 	for (i = 0; i < em28xx_bcount; i++) {
-		pr_err("    card=%d -> %s\n", i, em28xx_boards[i].name);
+		dev_err(&dev->udev->dev,
+			"    card=%d -> %s\n", i, em28xx_boards[i].name);
 	}
 	return -1;
 }
@@ -2915,7 +2921,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 		 * hash identities which has not been determined as yet.
 		 */
 		if (em28xx_hint_board(dev) < 0)
-			pr_err("Board not discovered\n");
+			dev_err(&dev->udev->dev, "Board not discovered\n");
 		else {
 			em28xx_set_model(dev);
 			em28xx_pre_card_setup(dev);
@@ -2925,7 +2931,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 		em28xx_set_model(dev);
 	}
 
-	pr_info("Identified as %s (card=%d)\n",
+	dev_info(&dev->udev->dev, "Identified as %s (card=%d)\n",
 		dev->board.name, dev->model);
 
 	dev->tuner_type = em28xx_boards[dev->model].tuner_type;
@@ -3024,10 +3030,11 @@ static void em28xx_card_setup(struct em28xx *dev)
 	}
 
 	if (dev->board.valid == EM28XX_BOARD_NOT_VALIDATED) {
-		pr_err("\n\n");
-		pr_err("The support for this board weren't valid yet.\n");
-		pr_err("Please send a report of having this working\n");
-		pr_err("not to V4L mailing list (and/or to other addresses)\n\n");
+		dev_err(&dev->udev->dev,
+			"\n\n"
+			"The support for this board weren't valid yet.\n"
+			"Please send a report of having this working\n"
+			"not to V4L mailing list (and/or to other addresses)\n\n");
 	}
 
 	/* Free eeprom data memory */
@@ -3154,7 +3161,7 @@ static int em28xx_media_device_init(struct em28xx *dev,
 	else if (udev->manufacturer)
 		media_device_usb_init(mdev, udev, udev->manufacturer);
 	else
-		media_device_usb_init(mdev, udev, dev->name);
+		media_device_usb_init(mdev, udev, dev_name(&dev->udev->dev));
 
 	dev->media_dev = mdev;
 #endif
@@ -3210,7 +3217,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	pr_info("Freeing device\n");
+	dev_info(&dev->udev->dev, "Freeing device\n");
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
@@ -3315,19 +3322,18 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
-		default:
-			pr_info("unknown em28xx chip ID (%d)\n", dev->chip_id);
 		}
 	}
 
-	if (chip_name != default_chip_name)
-		pr_info("chip ID is %s\n", chip_name);
+	dev_set_name(&dev->udev->dev, "%d-%s: %s#%d",
+		     dev->udev->bus->busnum, dev->udev->devpath,
+		     chip_name, dev->devno);
 
-	/*
-	 * For em2820/em2710, the name may change latter, after checking
-	 * if the device has a sensor (so, it is em2710) or not.
-	 */
-	snprintf(dev->name, sizeof(dev->name), "%s #%d", chip_name, dev->devno);
+	if (chip_name == default_chip_name)
+			dev_info(&dev->udev->dev,
+				 "unknown em28xx chip ID (%d)\n", dev->chip_id);
+	else
+		dev_info(&dev->udev->dev, "chip ID is %s\n", chip_name);
 
 	em28xx_media_device_init(dev, udev);
 
@@ -3346,7 +3352,8 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		/* Resets I2C speed */
 		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
 		if (retval < 0) {
-			pr_err("%s: em28xx_write_reg failed! retval [%d]\n",
+			dev_err(&dev->udev->dev,
+			       "%s: em28xx_write_reg failed! retval [%d]\n",
 			       __func__, retval);
 			return retval;
 		}
@@ -3360,7 +3367,8 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	else
 		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
 	if (retval < 0) {
-		pr_err("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
+		dev_err(&dev->udev->dev,
+			"%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 		       __func__, retval);
 		return retval;
 	}
@@ -3374,7 +3382,8 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			retval = em28xx_i2c_register(dev, 1,
 						     EM28XX_I2C_ALGO_EM28XX);
 		if (retval < 0) {
-			pr_err("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
+			dev_err(&dev->udev->dev,
+			       "%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 			       __func__, retval);
 
 			em28xx_i2c_unregister(dev, 0);
@@ -3414,7 +3423,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		nr = find_first_zero_bit(em28xx_devused, EM28XX_MAXBOARDS);
 		if (nr >= EM28XX_MAXBOARDS) {
 			/* No free device slots */
-			pr_err("Driver supports up to %i em28xx boards.\n",
+			dev_err(&udev->dev,
+				"Driver supports up to %i em28xx boards.\n",
 			       EM28XX_MAXBOARDS);
 			retval = -ENOMEM;
 			goto err_no_slot;
@@ -3423,7 +3433,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	/* Don't register audio interfaces */
 	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
-		pr_err("audio device (%04x:%04x): interface %i, class %i\n",
+		dev_err(&udev->dev,
+			"audio device (%04x:%04x): interface %i, class %i\n",
 			le16_to_cpu(udev->descriptor.idVendor),
 			le16_to_cpu(udev->descriptor.idProduct),
 			ifnum,
@@ -3483,7 +3494,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 					if (usb_endpoint_xfer_isoc(e)) {
 						has_vendor_audio = true;
 					} else {
-						pr_err("error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
+						dev_err(&udev->dev,
+							"error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
 					}
 					break;
 				case 0x84:
@@ -3556,7 +3568,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-	pr_info("New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
+	dev_err(&udev->dev,
+		"New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
 		udev->manufacturer ? udev->manufacturer : "",
 		udev->product ? udev->product : "",
 		speed,
@@ -3571,8 +3584,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	 * not enough even for most Digital TV streams.
 	 */
 	if (udev->speed != USB_SPEED_HIGH && disable_usb_speed_check == 0) {
-		pr_err("Device initialization failed.\n");
-		pr_err("Device must be connected to a high-speed USB 2.0 port.\n");
+		dev_err(&udev->dev, "Device initialization failed.\n");
+		dev_err(&udev->dev,
+			"Device must be connected to a high-speed USB 2.0 port.\n");
 		retval = -ENODEV;
 		goto err_free;
 	}
@@ -3585,7 +3599,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->ifnum = ifnum;
 
 	if (has_vendor_audio) {
-		pr_info("Audio interface %i found (Vendor Class)\n", ifnum);
+		dev_err(&udev->dev,
+			"Audio interface %i found (Vendor Class)\n", ifnum);
 		dev->usb_audio_type = EM28XX_USB_AUDIO_VENDOR;
 	}
 	/* Checks if audio is provided by a USB Audio Class interface */
@@ -3594,7 +3609,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
 			if (has_vendor_audio)
-				pr_err("em28xx: device seems to have vendor AND usb audio class interfaces !\n"
+				dev_err(&udev->dev,
+					"em28xx: device seems to have vendor AND usb audio class interfaces !\n"
 				       "\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
 			dev->usb_audio_type = EM28XX_USB_AUDIO_CLASS;
 			break;
@@ -3602,12 +3618,12 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	if (has_video)
-		pr_info("Video interface %i found:%s%s\n",
+		dev_err(&udev->dev, "Video interface %i found:%s%s\n",
 			ifnum,
 			dev->analog_ep_bulk ? " bulk" : "",
 			dev->analog_ep_isoc ? " isoc" : "");
 	if (has_dvb)
-		pr_info("DVB interface %i found:%s%s\n",
+		dev_err(&udev->dev, "DVB interface %i found:%s%s\n",
 			ifnum,
 			dev->dvb_ep_bulk ? " bulk" : "",
 			dev->dvb_ep_isoc ? " isoc" : "");
@@ -3639,7 +3655,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* Disable V4L2 if the device doesn't have a decoder */
 	if (has_video &&
 	    dev->board.decoder == EM28XX_NODECODER && !dev->board.is_webcam) {
-		pr_err("Currently, V4L2 is not supported on this model\n");
+		dev_err(&udev->dev,
+			"Currently, V4L2 is not supported on this model\n");
 		has_video = false;
 		dev->has_video = false;
 	}
@@ -3648,13 +3665,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (has_video) {
 		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
 			dev->analog_xfer_bulk = 1;
-		pr_info("analog set to %s mode.\n",
+		dev_err(&udev->dev, "analog set to %s mode.\n",
 			dev->analog_xfer_bulk ? "bulk" : "isoc");
 	}
 	if (has_dvb) {
 		if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
 			dev->dvb_xfer_bulk = 1;
-		pr_info("dvb set to %s mode.\n",
+		dev_err(&udev->dev, "dvb set to %s mode.\n",
 			dev->dvb_xfer_bulk ? "bulk" : "isoc");
 	}
 
@@ -3702,7 +3719,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 
 	dev->disconnected = 1;
 
-	pr_info("Disconnecting %s\n", dev->name);
+	dev_err(&dev->udev->dev, "Disconnecting\n");
 
 	flush_request_modules(dev);
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index a413ff7c30d7..7f1fe5d9d685 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -50,25 +50,29 @@ static unsigned int core_debug;
 module_param(core_debug, int, 0644);
 MODULE_PARM_DESC(core_debug, "enable debug messages [core and isoc]");
 
-#define em28xx_coredbg(fmt, arg...) do {\
-	if (core_debug) \
-		printk(KERN_DEBUG pr_fmt("core: %s: " fmt), \
-			 __func__, ##arg); } while (0)
+#define em28xx_coredbg(fmt, arg...) do {				\
+	if (core_debug)							\
+		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
+			   "core: %s: " fmt, __func__, ## arg);		\
+} while (0)
 
 static unsigned int reg_debug;
 module_param(reg_debug, int, 0644);
 MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
 
-#define em28xx_regdbg(fmt, arg...) do {\
-	if (reg_debug) \
-		printk(KERN_DEBUG pr_fmt("reg: %s: " fmt), \
-		       __func__, ##arg); } while (0)
 
-/* FIXME */
-#define em28xx_isocdbg(fmt, arg...) do {\
-	if (core_debug) \
-		printk(KERN_DEBUG pr_fmt("isoc: %s: " fmt), \
-		       __func__, ##arg); } while (0)
+#define em28xx_regdbg(fmt, arg...) do {				\
+	if (reg_debug)							\
+		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
+			   "reg: %s: " fmt, __func__, ## arg);		\
+} while (0)
+
+/* FIXME: don't abuse core_debug */
+#define em28xx_isocdbg(fmt, arg...) do {				\
+	if (core_debug)							\
+		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
+			   "core: %s: " fmt, __func__, ## arg);		\
+} while (0)
 
 /*
  * em28xx_read_reg_req()
@@ -86,23 +90,22 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 	if (len > URB_MAX_CTRL_SIZE)
 		return -EINVAL;
 
-	if (reg_debug) {
-		printk(KERN_DEBUG
-			"(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x ",
-			pipe,
-			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			req, 0, 0,
-			reg & 0xff, reg >> 8,
-			len & 0xff, len >> 8);
-	}
+	em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x ",
+		     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		     req, 0, 0,
+		     reg & 0xff, reg >> 8,
+		     len & 0xff, len >> 8);
 
 	mutex_lock(&dev->ctrl_urb_lock);
 	ret = usb_control_msg(dev->udev, pipe, req,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	if (ret < 0) {
-		if (reg_debug)
-			pr_cont(" failed!\n");
+		em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed\n",
+			     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			     req, 0, 0,
+			     reg & 0xff, reg >> 8,
+			     len & 0xff, len >> 8);
 		mutex_unlock(&dev->ctrl_urb_lock);
 		return usb_translate_errors(ret);
 	}
@@ -112,14 +115,11 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 
 	mutex_unlock(&dev->ctrl_urb_lock);
 
-	if (reg_debug) {
-		int byte;
-
-		pr_cont("<<<");
-		for (byte = 0; byte < len; byte++)
-			pr_cont(" %02x", (unsigned char)buf[byte]);
-		pr_cont("\n");
-	}
+	em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed <<< %*ph\n",
+		     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		     req, 0, 0,
+		     reg & 0xff, reg >> 8,
+		     len & 0xff, len >> 8, len, buf);
 
 	return ret;
 }
@@ -162,21 +162,12 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 	if ((len < 1) || (len > URB_MAX_CTRL_SIZE))
 		return -EINVAL;
 
-	if (reg_debug) {
-		int byte;
-
-		printk(KERN_DEBUG
-			"(pipe 0x%08x): OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>>",
-			pipe,
-			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			req, 0, 0,
-			reg & 0xff, reg >> 8,
-			len & 0xff, len >> 8);
-
-		for (byte = 0; byte < len; byte++)
-			pr_cont(" %02x", (unsigned char)buf[byte]);
-		pr_cont("\n");
-	}
+	em28xx_regdbg("(pipe 0x%08x): OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>> %*ph\n",
+		      pipe,
+		      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		      req, 0, 0,
+		      reg & 0xff, reg >> 8,
+		      len & 0xff, len >> 8, len, buf);
 
 	mutex_lock(&dev->ctrl_urb_lock);
 	memcpy(dev->urb_buf, buf, len);
@@ -267,7 +258,8 @@ static int em28xx_is_ac97_ready(struct em28xx *dev)
 		msleep(5);
 	}
 
-	pr_warn("AC97 command still being executed: not handled properly!\n");
+	dev_warn(&dev->udev->dev,
+		 "AC97 command still being executed: not handled properly!\n");
 	return -EBUSY;
 }
 
@@ -360,8 +352,9 @@ static int set_ac97_input(struct em28xx *dev)
 			ret = em28xx_write_ac97(dev, inputs[i].reg, 0x8000);
 
 		if (ret < 0)
-			pr_warn("couldn't setup AC97 register %d\n",
-				    inputs[i].reg);
+			dev_warn(&dev->udev->dev,
+				 "couldn't setup AC97 register %d\n",
+				 inputs[i].reg);
 	}
 	return 0;
 }
@@ -444,8 +437,9 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 		for (i = 0; i < ARRAY_SIZE(outputs); i++) {
 			ret = em28xx_write_ac97(dev, outputs[i].reg, 0x8000);
 			if (ret < 0)
-				pr_warn("couldn't setup AC97 register %d\n",
-					    outputs[i].reg);
+				dev_warn(&dev->udev->dev,
+					 "couldn't setup AC97 register %d\n",
+					 outputs[i].reg);
 		}
 	}
 
@@ -482,8 +476,9 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 				ret = em28xx_write_ac97(dev, outputs[i].reg,
 							vol);
 			if (ret < 0)
-				pr_warn("couldn't setup AC97 register %d\n",
-					    outputs[i].reg);
+				dev_warn(&dev->udev->dev,
+					 "couldn't setup AC97 register %d\n",
+					 outputs[i].reg);
 		}
 
 		if (dev->ctl_aoutput & EM28XX_AOUT_PCM_IN) {
@@ -519,7 +514,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 
 	/* See how this device is configured */
 	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
-	pr_info("Config register raw data: 0x%02x\n", cfg);
+	dev_info(&dev->udev->dev, "Config register raw data: 0x%02x\n", cfg);
 	if (cfg < 0) { /* Register read error */
 		/* Be conservative */
 		dev->int_audio_type = EM28XX_INT_AUDIO_AC97;
@@ -540,7 +535,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 			i2s_samplerates = 5;
 		else
 			i2s_samplerates = 3;
-		pr_info("I2S Audio (%d sample rate(s))\n",
+		dev_info(&dev->udev->dev, "I2S Audio (%d sample rate(s))\n",
 			i2s_samplerates);
 		/* Skip the code that does AC97 vendor detection */
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
@@ -558,7 +553,8 @@ int em28xx_audio_setup(struct em28xx *dev)
 		 * Note: (some) em2800 devices without eeprom reports 0x91 on
 		 *	 CHIPCFG register, even not having an AC97 chip
 		 */
-		pr_warn("AC97 chip type couldn't be determined\n");
+		dev_warn(&dev->udev->dev,
+			 "AC97 chip type couldn't be determined\n");
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		if (dev->usb_audio_type == EM28XX_USB_AUDIO_VENDOR)
 			dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
@@ -571,13 +567,13 @@ int em28xx_audio_setup(struct em28xx *dev)
 		goto init_audio;
 
 	vid = vid1 << 16 | vid2;
-	pr_warn("AC97 vendor ID = 0x%08x\n", vid);
+	dev_warn(&dev->udev->dev, "AC97 vendor ID = 0x%08x\n", vid);
 
 	feat = em28xx_read_ac97(dev, AC97_RESET);
 	if (feat < 0)
 		goto init_audio;
 
-	pr_warn("AC97 features = 0x%04x\n", feat);
+	dev_warn(&dev->udev->dev, "AC97 features = 0x%04x\n", feat);
 
 	/* Try to identify what audio processor we have */
 	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat == 0x6a90))
@@ -589,17 +585,20 @@ int em28xx_audio_setup(struct em28xx *dev)
 	/* Reports detected AC97 processor */
 	switch (dev->audio_mode.ac97) {
 	case EM28XX_NO_AC97:
-		pr_info("No AC97 audio processor\n");
+		dev_info(&dev->udev->dev, "No AC97 audio processor\n");
 		break;
 	case EM28XX_AC97_EM202:
-		pr_info("Empia 202 AC97 audio processor detected\n");
+		dev_info(&dev->udev->dev,
+			 "Empia 202 AC97 audio processor detected\n");
 		break;
 	case EM28XX_AC97_SIGMATEL:
-		pr_info("Sigmatel audio processor detected (stac 97%02x)\n",
-			vid & 0xff);
+		dev_info(&dev->udev->dev,
+			 "Sigmatel audio processor detected (stac 97%02x)\n",
+			 vid & 0xff);
 		break;
 	case EM28XX_AC97_OTHER:
-		pr_warn("Unknown AC97 audio processor detected!\n");
+		dev_warn(&dev->udev->dev,
+			 "Unknown AC97 audio processor detected!\n");
 		break;
 	default:
 		break;
@@ -883,21 +882,23 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 	if (mode == EM28XX_DIGITAL_MODE) {
 		if ((xfer_bulk && !dev->dvb_ep_bulk) ||
 		    (!xfer_bulk && !dev->dvb_ep_isoc)) {
-			pr_err("no endpoint for DVB mode and transfer type %d\n",
-			       xfer_bulk > 0);
+			dev_err(&dev->udev->dev,
+				"no endpoint for DVB mode and transfer type %d\n",
+				xfer_bulk > 0);
 			return -EINVAL;
 		}
 		usb_bufs = &dev->usb_ctl.digital_bufs;
 	} else if (mode == EM28XX_ANALOG_MODE) {
 		if ((xfer_bulk && !dev->analog_ep_bulk) ||
 		    (!xfer_bulk && !dev->analog_ep_isoc)) {
-			pr_err("no endpoint for analog mode and transfer type %d\n",
-			       xfer_bulk > 0);
+			dev_err(&dev->udev->dev,
+				"no endpoint for analog mode and transfer type %d\n",
+				xfer_bulk > 0);
 			return -EINVAL;
 		}
 		usb_bufs = &dev->usb_ctl.analog_bufs;
 	} else {
-		pr_err("invalid mode selected\n");
+		dev_err(&dev->udev->dev, "invalid mode selected\n");
 		return -EINVAL;
 	}
 
@@ -939,7 +940,8 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		usb_bufs->transfer_buffer[i] = usb_alloc_coherent(dev->udev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!usb_bufs->transfer_buffer[i]) {
-			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
+			dev_err(&dev->udev->dev,
+				"unable to allocate %i bytes for transfer buffer %i%s\n",
 			       sb_size, i,
 			       in_interrupt() ? " while in int" : "");
 			em28xx_uninit_usb_xfer(dev, mode);
@@ -1021,7 +1023,8 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 	if (xfer_bulk) {
 		rc = usb_clear_halt(dev->udev, usb_bufs->urb[0]->pipe);
 		if (rc < 0) {
-			pr_err("failed to clear USB bulk endpoint stall/halt condition (error=%i)\n",
+			dev_err(&dev->udev->dev,
+				"failed to clear USB bulk endpoint stall/halt condition (error=%i)\n",
 			       rc);
 			em28xx_uninit_usb_xfer(dev, mode);
 			return rc;
@@ -1037,7 +1040,8 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 	for (i = 0; i < usb_bufs->num_bufs; i++) {
 		rc = usb_submit_urb(usb_bufs->urb[i], GFP_ATOMIC);
 		if (rc) {
-			pr_err("submit of urb %i failed (error=%i)\n", i, rc);
+			dev_err(&dev->udev->dev,
+				"submit of urb %i failed (error=%i)\n", i, rc);
 			em28xx_uninit_usb_xfer(dev, mode);
 			return rc;
 		}
@@ -1085,7 +1089,7 @@ void em28xx_unregister_extension(struct em28xx_ops *ops)
 	}
 	list_del(&ops->next);
 	mutex_unlock(&em28xx_devlist_mutex);
-	pr_info("Em28xx: Removed (%s) extension\n", ops->name);
+	pr_info("em28xx: Removed (%s) extension\n", ops->name);
 }
 EXPORT_SYMBOL(em28xx_unregister_extension);
 
@@ -1119,7 +1123,7 @@ int em28xx_suspend_extension(struct em28xx *dev)
 {
 	const struct em28xx_ops *ops = NULL;
 
-	pr_info("Suspending extensions\n");
+	dev_info(&dev->udev->dev, "Suspending extensions\n");
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
 		if (ops->suspend)
@@ -1133,7 +1137,7 @@ int em28xx_resume_extension(struct em28xx *dev)
 {
 	const struct em28xx_ops *ops = NULL;
 
-	pr_info("Resuming extensions\n");
+	dev_info(&dev->udev->dev, "Resuming extensions\n");
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
 		if (ops->resume)
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 6feb0e416eac..445e51db636f 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -73,9 +73,10 @@ MODULE_PARM_DESC(debug, "enable debug messages [dvb]");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define dprintk(level, fmt, arg...) do {			\
-if (debug >= level)						\
-	printk(KERN_DEBUG "%s/2-dvb: " fmt, dev->name, ## arg);	\
+#define dprintk(level, fmt, arg...) do {				\
+	if (debug >= level)						\
+		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
+			   "dvb: " fmt, ## arg);			\
 } while (0)
 
 struct em28xx_dvb {
@@ -735,7 +736,7 @@ static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 
 	ret = gpio_request_one(dvb->lna_gpio, flags, NULL);
 	if (ret)
-		pr_err("gpio request failed %d\n", ret);
+		dev_err(&dev->udev->dev, "gpio request failed %d\n", ret);
 	else
 		gpio_free(dvb->lna_gpio);
 
@@ -935,19 +936,20 @@ static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
 	cfg.ctrl  = &ctl;
 
 	if (!dev->dvb->fe[0]) {
-		pr_err("dvb frontend not attached. Can't attach xc3028\n");
+		dev_err(&dev->udev->dev,
+			"dvb frontend not attached. Can't attach xc3028\n");
 		return -EINVAL;
 	}
 
 	fe = dvb_attach(xc2028_attach, dev->dvb->fe[0], &cfg);
 	if (!fe) {
-		pr_err("xc3028 attach failed\n");
+		dev_err(&dev->udev->dev, "xc3028 attach failed\n");
 		dvb_frontend_detach(dev->dvb->fe[0]);
 		dev->dvb->fe[0] = NULL;
 		return -EINVAL;
 	}
 
-	pr_info("xc3028 attached\n");
+	dev_info(&dev->udev->dev, "xc3028 attached\n");
 
 	return 0;
 }
@@ -963,11 +965,13 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	mutex_init(&dvb->lock);
 
 	/* register adapter */
-	result = dvb_register_adapter(&dvb->adapter, dev->name, module, device,
-				      adapter_nr);
+	result = dvb_register_adapter(&dvb->adapter,
+				      dev_name(&dev->udev->dev), module,
+				      device, adapter_nr);
 	if (result < 0) {
-		pr_warn("dvb_register_adapter failed (errno = %d)\n",
-			result);
+		dev_warn(&dev->udev->dev,
+			 "dvb_register_adapter failed (errno = %d)\n",
+			 result);
 		goto fail_adapter;
 	}
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
@@ -984,8 +988,9 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->fe[0]);
 	if (result < 0) {
-		pr_warn("dvb_register_frontend failed (errno = %d)\n",
-			result);
+		dev_warn(&dev->udev->dev,
+			 "dvb_register_frontend failed (errno = %d)\n",
+			 result);
 		goto fail_frontend0;
 	}
 
@@ -993,8 +998,9 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	if (dvb->fe[1]) {
 		result = dvb_register_frontend(&dvb->adapter, dvb->fe[1]);
 		if (result < 0) {
-			pr_warn("2nd dvb_register_frontend failed (errno = %d)\n",
-				result);
+			dev_warn(&dev->udev->dev,
+				 "2nd dvb_register_frontend failed (errno = %d)\n",
+				 result);
 			goto fail_frontend1;
 		}
 	}
@@ -1011,7 +1017,9 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 
 	result = dvb_dmx_init(&dvb->demux);
 	if (result < 0) {
-		pr_warn("dvb_dmx_init failed (errno = %d)\n", result);
+		dev_warn(&dev->udev->dev,
+			 "dvb_dmx_init failed (errno = %d)\n",
+			 result);
 		goto fail_dmx;
 	}
 
@@ -1020,29 +1028,35 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	dvb->dmxdev.capabilities = 0;
 	result = dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
 	if (result < 0) {
-		pr_warn("dvb_dmxdev_init failed (errno = %d)\n", result);
+		dev_warn(&dev->udev->dev,
+			 "dvb_dmxdev_init failed (errno = %d)\n",
+			 result);
 		goto fail_dmxdev;
 	}
 
 	dvb->fe_hw.source = DMX_FRONTEND_0;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		pr_warn("add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
-			result);
+		dev_warn(&dev->udev->dev,
+			 "add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
+			 result);
 		goto fail_fe_hw;
 	}
 
 	dvb->fe_mem.source = DMX_MEMORY_FE;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	if (result < 0) {
-		pr_warn("add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
-			result);
+		dev_warn(&dev->udev->dev,
+			 "add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
+			 result);
 		goto fail_fe_mem;
 	}
 
 	result = dvb->demux.dmx.connect_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		pr_warn("connect_frontend failed (errno = %d)\n", result);
+		dev_warn(&dev->udev->dev,
+			 "connect_frontend failed (errno = %d)\n",
+			 result);
 		goto fail_fe_conn;
 	}
 
@@ -1114,7 +1128,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		return 0;
 	}
 
-	pr_info("Binding DVB extension\n");
+	dev_info(&dev->udev->dev, "Binding DVB extension\n");
 
 	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
 	if (!dvb)
@@ -1138,7 +1152,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 					   EM28XX_DVB_NUM_ISOC_PACKETS);
 	}
 	if (result) {
-		pr_err("em28xx_dvb: failed to pre-allocate USB transfer buffers for DVB.\n");
+		dev_err(&dev->udev->dev,
+			"failed to pre-allocate USB transfer buffers for DVB.\n");
 		kfree(dvb);
 		dev->dvb = NULL;
 		return result;
@@ -1317,8 +1332,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			result = gpio_request_one(dvb->lna_gpio,
 						  GPIOF_OUT_INIT_LOW, NULL);
 			if (result)
-				pr_err("gpio request failed %d\n",
-					      result);
+				dev_err(&dev->udev->dev,
+					"gpio request failed %d\n",
+					result);
 			else
 				gpio_free(dvb->lna_gpio);
 
@@ -1933,11 +1949,12 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	default:
-		pr_err("The frontend of your DVB/ATSC card isn't supported yet\n");
+		dev_err(&dev->udev->dev,
+			"The frontend of your DVB/ATSC card isn't supported yet\n");
 		break;
 	}
 	if (NULL == dvb->fe[0]) {
-		pr_err("frontend initialization failed\n");
+		dev_err(&dev->udev->dev, "frontend initialization failed\n");
 		result = -EINVAL;
 		goto out_free;
 	}
@@ -1952,7 +1969,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	if (result < 0)
 		goto out_free;
 
-	pr_info("DVB extension successfully initialized\n");
+	dev_info(&dev->udev->dev, "DVB extension successfully initialized\n");
 
 	kref_get(&dev->ref);
 
@@ -1992,7 +2009,7 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	if (!dev->dvb)
 		return 0;
 
-	pr_info("Closing DVB extension\n");
+	dev_info(&dev->udev->dev, "Closing DVB extension\n");
 
 	dvb = dev->dvb;
 
@@ -2050,17 +2067,17 @@ static int em28xx_dvb_suspend(struct em28xx *dev)
 	if (!dev->board.has_dvb)
 		return 0;
 
-	pr_info("Suspending DVB extension\n");
+	dev_info(&dev->udev->dev, "Suspending DVB extension\n");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_suspend(dvb->fe[0]);
-			pr_info("fe0 suspend %d\n", ret);
+			dev_info(&dev->udev->dev, "fe0 suspend %d\n", ret);
 		}
 		if (dvb->fe[1]) {
 			dvb_frontend_suspend(dvb->fe[1]);
-			pr_info("fe1 suspend %d\n", ret);
+			dev_info(&dev->udev->dev, "fe1 suspend %d\n", ret);
 		}
 	}
 
@@ -2077,18 +2094,18 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 	if (!dev->board.has_dvb)
 		return 0;
 
-	pr_info("Resuming DVB extension\n");
+	dev_info(&dev->udev->dev, "Resuming DVB extension\n");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_resume(dvb->fe[0]);
-			pr_info("fe0 resume %d\n", ret);
+			dev_info(&dev->udev->dev, "fe0 resume %d\n", ret);
 		}
 
 		if (dvb->fe[1]) {
 			ret = dvb_frontend_resume(dvb->fe[1]);
-			pr_info("fe1 resume %d\n", ret);
+			dev_info(&dev->udev->dev, "fe1 resume %d\n", ret);
 		}
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index b7a5b4c5ceff..00e39edc0837 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -44,6 +44,13 @@ static unsigned int i2c_debug;
 module_param(i2c_debug, int, 0644);
 MODULE_PARM_DESC(i2c_debug, "i2c debug message level (1: normal debug, 2: show I2C transfers)");
 
+#define dprintk(level, fmt, arg...) do {				\
+	if (i2c_debug > level)						\
+		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
+			   "i2c: %s: " fmt, __func__, ## arg);		\
+} while (0)
+
+
 /*
  * em2800_i2c_send_bytes()
  * send up to 4 bytes to the em2800 i2c device
@@ -71,7 +78,8 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	/* trigger write */
 	ret = dev->em28xx_write_regs(dev, 4 - len, &b2[4 - len], 2 + len);
 	if (ret != 2 + len) {
-		pr_warn("failed to trigger write to i2c address 0x%x (error=%i)\n",
+		dev_warn(&dev->udev->dev,
+			 "failed to trigger write to i2c address 0x%x (error=%i)\n",
 			    addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
@@ -81,20 +89,18 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x80 + len - 1)
 			return len;
 		if (ret == 0x94 + len - 1) {
-			if (i2c_debug == 1)
-				pr_warn("R05 returned 0x%02x: I2C ACK error\n",
-					ret);
+			dprintk(1, "R05 returned 0x%02x: I2C ACK error\n", ret);
 			return -ENXIO;
 		}
 		if (ret < 0) {
-			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
+			dev_warn(&dev->udev->dev,
+				 "failed to get i2c transfer status from bridge register (error=%i)\n",
 				ret);
 			return ret;
 		}
 		msleep(5);
 	}
-	if (i2c_debug)
-		pr_warn("write to i2c device at 0x%x timed out\n", addr);
+	dprintk(0, "write to i2c device at 0x%x timed out\n", addr);
 	return -ETIMEDOUT;
 }
 
@@ -117,8 +123,9 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	buf2[0] = addr;
 	ret = dev->em28xx_write_regs(dev, 0x04, buf2, 2);
 	if (ret != 2) {
-		pr_warn("failed to trigger read from i2c address 0x%x (error=%i)\n",
-			addr, ret);
+		dev_warn(&dev->udev->dev,
+			 "failed to trigger read from i2c address 0x%x (error=%i)\n",
+			 addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
 
@@ -128,29 +135,28 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x84 + len - 1)
 			break;
 		if (ret == 0x94 + len - 1) {
-			if (i2c_debug == 1)
-				pr_warn("R05 returned 0x%02x: I2C ACK error\n",
-					ret);
+			dprintk(1, "R05 returned 0x%02x: I2C ACK error\n",
+				ret);
 			return -ENXIO;
 		}
 		if (ret < 0) {
-			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-				ret);
+			dev_warn(&dev->udev->dev,
+				 "failed to get i2c transfer status from bridge register (error=%i)\n",
+				 ret);
 			return ret;
 		}
 		msleep(5);
 	}
 	if (ret != 0x84 + len - 1) {
-		if (i2c_debug)
-			pr_warn("read from i2c device at 0x%x timed out\n",
-				addr);
+		dprintk(0, "read from i2c device at 0x%x timed out\n", addr);
 	}
 
 	/* get the received message */
 	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
 	if (ret != len) {
-		pr_warn("reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
-			addr, ret);
+		dev_warn(&dev->udev->dev,
+			 "reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
+			 addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
 	for (i = 0; i < len; i++)
@@ -194,12 +200,14 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
 	if (ret != len) {
 		if (ret < 0) {
-			pr_warn("writing to i2c device at 0x%x failed (error=%i)\n",
-				addr, ret);
+			dev_warn(&dev->udev->dev,
+				 "writing to i2c device at 0x%x failed (error=%i)\n",
+				 addr, ret);
 			return ret;
 		} else {
-			pr_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
-				len, addr, ret);
+			dev_warn(&dev->udev->dev,
+				 "%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
+				 len, addr, ret);
 			return -EIO;
 		}
 	}
@@ -210,14 +218,14 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		if (ret == 0) /* success */
 			return len;
 		if (ret == 0x10) {
-			if (i2c_debug == 1)
-				pr_warn("I2C ACK error on writing to addr 0x%02x\n",
-					addr);
+			dprintk(1, "I2C ACK error on writing to addr 0x%02x\n",
+				addr);
 			return -ENXIO;
 		}
 		if (ret < 0) {
-			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-				ret);
+			dev_warn(&dev->udev->dev,
+				 "failed to get i2c transfer status from bridge register (error=%i)\n",
+				 ret);
 			return ret;
 		}
 		msleep(5);
@@ -230,14 +238,15 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 
 	if (ret == 0x02 || ret == 0x04) {
 		/* NOTE: these errors seem to be related to clock stretching */
-		if (i2c_debug)
-			pr_warn("write to i2c device at 0x%x timed out (status=%i)\n",
-				addr, ret);
+		dprintk(0,
+			"write to i2c device at 0x%x timed out (status=%i)\n",
+			addr, ret);
 		return -ETIMEDOUT;
 	}
 
-	pr_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
-		addr, ret);
+	dev_warn(&dev->udev->dev,
+		 "write to i2c device at 0x%x failed with unknown error (status=%i)\n",
+		 addr, ret);
 	return -EIO;
 }
 
@@ -259,8 +268,9 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	/* Read data from i2c device */
 	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
 	if (ret < 0) {
-		pr_warn("reading from i2c device at 0x%x failed (error=%i)\n",
-			addr, ret);
+		dev_warn(&dev->udev->dev,
+			 "reading from i2c device at 0x%x failed (error=%i)\n",
+			 addr, ret);
 		return ret;
 	}
 	/*
@@ -277,27 +287,28 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	if (ret == 0) /* success */
 		return len;
 	if (ret < 0) {
-		pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
-			ret);
+		dev_warn(&dev->udev->dev,
+			 "failed to get i2c transfer status from bridge register (error=%i)\n",
+			 ret);
 		return ret;
 	}
 	if (ret == 0x10) {
-		if (i2c_debug == 1)
-			pr_warn("I2C ACK error on writing to addr 0x%02x\n",
-				addr);
+		dprintk(1, "I2C ACK error on writing to addr 0x%02x\n",
+			addr);
 		return -ENXIO;
 	}
 
 	if (ret == 0x02 || ret == 0x04) {
 		/* NOTE: these errors seem to be related to clock stretching */
-		if (i2c_debug)
-			pr_warn("write to i2c device at 0x%x timed out (status=%i)\n",
-				addr, ret);
+		dprintk(0,
+			"write to i2c device at 0x%x timed out (status=%i)\n",
+			addr, ret);
 		return -ETIMEDOUT;
 	}
 
-	pr_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
-		addr, ret);
+	dev_warn(&dev->udev->dev,
+		 "write to i2c device at 0x%x failed with unknown error (status=%i)\n",
+		 addr, ret);
 	return -EIO;
 }
 
@@ -336,12 +347,14 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	ret = dev->em28xx_write_regs_req(dev, 0x06, addr, buf, len);
 	if (ret != len) {
 		if (ret < 0) {
-			pr_warn("writing to i2c device at 0x%x failed (error=%i)\n",
-				addr, ret);
+			dev_warn(&dev->udev->dev,
+				 "writing to i2c device at 0x%x failed (error=%i)\n",
+				 addr, ret);
 			return ret;
 		} else {
-			pr_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
-				len, addr, ret);
+			dev_warn(&dev->udev->dev,
+				 "%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
+				 len, addr, ret);
 			return -EIO;
 		}
 	}
@@ -354,9 +367,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	if (!ret)
 		return len;
 	else if (ret > 0) {
-		if (i2c_debug == 1)
-			pr_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
-				ret);
+		dprintk(1, "Bus B R08 returned 0x%02x: I2C ACK error\n", ret);
 		return -ENXIO;
 	}
 
@@ -387,8 +398,9 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	/* Read value */
 	ret = dev->em28xx_read_reg_req_len(dev, 0x06, addr, buf, len);
 	if (ret < 0) {
-		pr_warn("reading from i2c device at 0x%x failed (error=%i)\n",
-			addr, ret);
+		dev_warn(&dev->udev->dev,
+			 "reading from i2c device at 0x%x failed (error=%i)\n",
+			 addr, ret);
 		return ret;
 	}
 	/*
@@ -409,9 +421,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	if (!ret)
 		return len;
 	else if (ret > 0) {
-		if (i2c_debug == 1)
-			pr_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
-				ret);
+		dprintk(1, "Bus B R08 returned 0x%02x: I2C ACK error\n", ret);
 		return -ENXIO;
 	}
 
@@ -529,57 +539,46 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	}
 	for (i = 0; i < num; i++) {
 		addr = msgs[i].addr << 1;
-		if (i2c_debug > 1)
-			printk(KERN_DEBUG "%s at %s: %s %s addr=%02x len=%d:",
-			       dev->name, __func__ ,
-			       (msgs[i].flags & I2C_M_RD) ? "read" : "write",
-			       i == num - 1 ? "stop" : "nonstop",
-			       addr, msgs[i].len);
 		if (!msgs[i].len) {
 			/*
 			 * no len: check only for device presence
 			 * This code is only called during device probe.
 			 */
 			rc = i2c_check_for_device(i2c_bus, addr);
-			if (rc < 0) {
-				if (rc == -ENXIO) {
-					if (i2c_debug > 1)
-						pr_cont(" no device\n");
-					rc = -ENODEV;
-				} else {
-					if (i2c_debug > 1)
-						pr_cont(" ERROR: %i\n", rc);
-				}
-				rt_mutex_unlock(&dev->i2c_bus_lock);
-				return rc;
-			}
+
+			if (rc == -ENXIO)
+				rc = -ENODEV;
 		} else if (msgs[i].flags & I2C_M_RD) {
 			/* read bytes */
 			rc = i2c_recv_bytes(i2c_bus, msgs[i]);
-
-			if (i2c_debug > 1 && rc >= 0)
-				pr_cont(" %*ph",
-				       msgs[i].len, msgs[i].buf);
 		} else {
-			if (i2c_debug > 1)
-				pr_cont(" %*ph",
-				       msgs[i].len, msgs[i].buf);
-
 			/* write bytes */
 			rc = i2c_send_bytes(i2c_bus, msgs[i], i == num - 1);
 		}
-		if (rc < 0) {
-			if (i2c_debug > 1)
-				pr_cont(" ERROR: %i\n", rc);
-			rt_mutex_unlock(&dev->i2c_bus_lock);
-			return rc;
-		}
-		if (i2c_debug > 1)
-			pr_cont("\n");
+
+		if (rc < 0)
+			goto error;
+
+		dprintk(2, "%s %s addr=%02x len=%d: %*ph\n",
+			(msgs[i].flags & I2C_M_RD) ? "read" : "write",
+			i == num - 1 ? "stop" : "nonstop",
+			addr, msgs[i].len,
+			msgs[i].len, msgs[i].buf);
 	}
 
 	rt_mutex_unlock(&dev->i2c_bus_lock);
 	return num;
+
+error:
+	dprintk(2, "%s %s addr=%02x len=%d: %sERROR: %i\n",
+		(msgs[i].flags & I2C_M_RD) ? "read" : "write",
+		i == num - 1 ? "stop" : "nonstop",
+		addr, msgs[i].len,
+		(rc == -ENODEV) ? "no device " : "",
+		rc);
+
+	rt_mutex_unlock(&dev->i2c_bus_lock);
+	return rc;
 }
 
 /*
@@ -673,7 +672,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 	/* Check if board has eeprom */
 	err = i2c_master_recv(&dev->i2c_client[bus], &buf, 0);
 	if (err < 0) {
-		pr_info("board has no eeprom\n");
+		dev_info(&dev->udev->dev, "board has no eeprom\n");
 		return -ENODEV;
 	}
 
@@ -686,17 +685,19 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 				    dev->eeprom_addrwidth_16bit,
 				    len, data);
 	if (err != len) {
-		pr_err("failed to read eeprom (err=%d)\n", err);
+		dev_err(&dev->udev->dev,
+			"failed to read eeprom (err=%d)\n", err);
 		goto error;
 	}
 
 	if (i2c_debug) {
 		/* Display eeprom content */
-		print_hex_dump(KERN_INFO, "eeprom ", DUMP_PREFIX_OFFSET,
+		print_hex_dump(KERN_DEBUG, "em28xx eeprom ", DUMP_PREFIX_OFFSET,
 			       16, 1, data, len, true);
 
 		if (dev->eeprom_addrwidth_16bit)
-			pr_info("eeprom %06x: ... (skipped)\n", 256);
+			dev_info(&dev->udev->dev,
+				 "eeprom %06x: ... (skipped)\n", 256);
 	}
 
 	if (dev->eeprom_addrwidth_16bit &&
@@ -708,11 +709,14 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		dev->hash = em28xx_hash_mem(data, len, 32);
 		mc_start = (data[1] << 8) + 4;	/* usually 0x0004 */
 
-		pr_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
-			data[0], data[1], data[2], data[3], dev->hash);
-		pr_info("EEPROM info:\n");
-		pr_info("\tmicrocode start address = 0x%04x, boot configuration = 0x%02x\n",
-			mc_start, data[2]);
+		dev_info(&dev->udev->dev,
+			 "EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
+			 data[0], data[1], data[2], data[3], dev->hash);
+		dev_info(&dev->udev->dev,
+			 "EEPROM info:\n");
+		dev_info(&dev->udev->dev,
+			 "\tmicrocode start address = 0x%04x, boot configuration = 0x%02x\n",
+			 mc_start, data[2]);
 		/*
 		 * boot configuration (address 0x0002):
 		 * [0]   microcode download speed: 1 = 400 kHz; 0 = 100 kHz
@@ -730,8 +734,9 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		err = em28xx_i2c_read_block(dev, bus, mc_start + 46, 1, 2,
 					    data);
 		if (err != 2) {
-			pr_err("failed to read hardware configuration data from eeprom (err=%d)\n",
-			       err);
+			dev_err(&dev->udev->dev,
+				"failed to read hardware configuration data from eeprom (err=%d)\n",
+				err);
 			goto error;
 		}
 
@@ -748,8 +753,9 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		err = em28xx_i2c_read_block(dev, bus, hwconf_offset, 1, len,
 					    data);
 		if (err != len) {
-			pr_err("failed to read hardware configuration data from eeprom (err=%d)\n",
-			       err);
+			dev_err(&dev->udev->dev,
+				"failed to read hardware configuration data from eeprom (err=%d)\n",
+				err);
 			goto error;
 		}
 
@@ -757,7 +763,8 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		/* NOTE: not all devices provide this type of dataset */
 		if (data[0] != 0x1a || data[1] != 0xeb ||
 		    data[2] != 0x67 || data[3] != 0x95) {
-			pr_info("\tno hardware configuration dataset found in eeprom\n");
+			dev_info(&dev->udev->dev,
+				 "\tno hardware configuration dataset found in eeprom\n");
 			kfree(data);
 			return 0;
 		}
@@ -768,11 +775,14 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		   data[0] == 0x1a && data[1] == 0xeb &&
 		   data[2] == 0x67 && data[3] == 0x95) {
 		dev->hash = em28xx_hash_mem(data, len, 32);
-		pr_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
-			data[0], data[1], data[2], data[3], dev->hash);
-		pr_info("EEPROM info:\n");
+		dev_info(&dev->udev->dev,
+			 "EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
+			 data[0], data[1], data[2], data[3], dev->hash);
+		dev_info(&dev->udev->dev,
+			 "EEPROM info:\n");
 	} else {
-		pr_info("unknown eeprom format or eeprom corrupted !\n");
+		dev_info(&dev->udev->dev,
+			 "unknown eeprom format or eeprom corrupted !\n");
 		err = -ENODEV;
 		goto error;
 	}
@@ -783,50 +793,55 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 
 	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
 	case 0:
-		pr_info("\tNo audio on board.\n");
+		dev_info(&dev->udev->dev, "\tNo audio on board.\n");
 		break;
 	case 1:
-		pr_info("\tAC97 audio (5 sample rates)\n");
+		dev_info(&dev->udev->dev, "\tAC97 audio (5 sample rates)\n");
 		break;
 	case 2:
 		if (dev->chip_id < CHIP_ID_EM2860)
-			pr_info("\tI2S audio, sample rate=32k\n");
+			dev_info(&dev->udev->dev,
+				 "\tI2S audio, sample rate=32k\n");
 		else
-			pr_info("\tI2S audio, 3 sample rates\n");
+			dev_info(&dev->udev->dev,
+				 "\tI2S audio, 3 sample rates\n");
 		break;
 	case 3:
 		if (dev->chip_id < CHIP_ID_EM2860)
-			pr_info("\tI2S audio, 3 sample rates\n");
+			dev_info(&dev->udev->dev,
+				 "\tI2S audio, 3 sample rates\n");
 		else
-			pr_info("\tI2S audio, 5 sample rates\n");
+			dev_info(&dev->udev->dev,
+				 "\tI2S audio, 5 sample rates\n");
 		break;
 	}
 
 	if (le16_to_cpu(dev_config->chip_conf) & 1 << 3)
-		pr_info("\tUSB Remote wakeup capable\n");
+		dev_info(&dev->udev->dev, "\tUSB Remote wakeup capable\n");
 
 	if (le16_to_cpu(dev_config->chip_conf) & 1 << 2)
-		pr_info("\tUSB Self power capable\n");
+		dev_info(&dev->udev->dev, "\tUSB Self power capable\n");
 
 	switch (le16_to_cpu(dev_config->chip_conf) & 0x3) {
 	case 0:
-		pr_info("\t500mA max power\n");
+		dev_info(&dev->udev->dev, "\t500mA max power\n");
 		break;
 	case 1:
-		pr_info("\t400mA max power\n");
+		dev_info(&dev->udev->dev, "\t400mA max power\n");
 		break;
 	case 2:
-		pr_info("\t300mA max power\n");
+		dev_info(&dev->udev->dev, "\t300mA max power\n");
 		break;
 	case 3:
-		pr_info("\t200mA max power\n");
+		dev_info(&dev->udev->dev, "\t200mA max power\n");
 		break;
 	}
-	pr_info("\tTable at offset 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
-		    dev_config->string_idx_table,
-		    le16_to_cpu(dev_config->string1),
-		    le16_to_cpu(dev_config->string2),
-		    le16_to_cpu(dev_config->string3));
+	dev_info(&dev->udev->dev,
+		 "\tTable at offset 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
+		 dev_config->string_idx_table,
+		 le16_to_cpu(dev_config->string1),
+		 le16_to_cpu(dev_config->string2),
+		 le16_to_cpu(dev_config->string3));
 
 	return 0;
 
@@ -915,8 +930,9 @@ void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus)
 		if (rc < 0)
 			continue;
 		i2c_devicelist[i] = i;
-		pr_info("found i2c device @ 0x%x on bus %d [%s]\n",
-			i << 1, bus, i2c_devs[i] ? i2c_devs[i] : "???");
+		dev_info(&dev->udev->dev,
+			 "found i2c device @ 0x%x on bus %d [%s]\n",
+			 i << 1, bus, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 
 	if (bus == dev->def_i2c_bus)
@@ -941,7 +957,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 
 	dev->i2c_adap[bus] = em28xx_adap_template;
 	dev->i2c_adap[bus].dev.parent = &dev->udev->dev;
-	strcpy(dev->i2c_adap[bus].name, dev->name);
+	strcpy(dev->i2c_adap[bus].name, dev_name(&dev->udev->dev));
 
 	dev->i2c_bus[bus].bus = bus;
 	dev->i2c_bus[bus].algo_type = algo_type;
@@ -950,8 +966,9 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 
 	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
 	if (retval < 0) {
-		pr_err("%s: i2c_add_adapter failed! retval [%d]\n",
-		       __func__, retval);
+		dev_err(&dev->udev->dev,
+			"%s: i2c_add_adapter failed! retval [%d]\n",
+			__func__, retval);
 		return retval;
 	}
 
@@ -962,8 +979,9 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 	if (!bus) {
 		retval = em28xx_i2c_eeprom(dev, bus, &dev->eedata, &dev->eedata_len);
 		if ((retval < 0) && (retval != -ENODEV)) {
-			pr_err("%s: em28xx_i2_eeprom failed! retval [%d]\n",
-			       __func__, retval);
+			dev_err(&dev->udev->dev,
+				"%s: em28xx_i2_eeprom failed! retval [%d]\n",
+				__func__, retval);
 
 			return retval;
 		}
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 0e23e65eff15..a1904e2230ea 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -41,10 +41,11 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
 #define MODULE_NAME "em28xx"
 
-#define dprintk(fmt, arg...) \
-	if (ir_debug) { \
-		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
-	}
+#define dprintk( fmt, arg...) do {					\
+	if (ir_debug)							\
+		dev_printk(KERN_DEBUG, &ir->dev->udev->dev,		\
+			   "input: %s: " fmt, __func__, ## arg);	\
+} while (0)
 
 /**********************************************************
  Polling structure used by em28xx IR's
@@ -458,8 +459,9 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 	case CHIP_ID_EM28178:
 		return em2874_ir_change_protocol(rc_dev, rc_type);
 	default:
-		pr_err("Unrecognized em28xx chip id 0x%02x: IR not supported\n",
-		       dev->chip_id);
+		dev_err(&ir->dev->udev->dev,
+			"Unrecognized em28xx chip id 0x%02x: IR not supported\n",
+			dev->chip_id);
 		return -EINVAL;
 	}
 }
@@ -567,7 +569,7 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
 	struct input_dev *input_dev;
 	int err;
 
-	pr_info("Registering snapshot button...\n");
+	dev_info(&dev->udev->dev, "Registering snapshot button...\n");
 	input_dev = input_allocate_device();
 	if (!input_dev)
 		return -ENOMEM;
@@ -591,7 +593,7 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
 
 	err = input_register_device(input_dev);
 	if (err) {
-		pr_err("input_register_device failed\n");
+		dev_err(&dev->udev->dev, "input_register_device failed\n");
 		input_free_device(input_dev);
 		return err;
 	}
@@ -631,7 +633,8 @@ static void em28xx_init_buttons(struct em28xx *dev)
 		} else if (button->role == EM28XX_BUTTON_ILLUMINATION) {
 			/* Check sanity */
 			if (!em28xx_find_led(dev, EM28XX_LED_ILLUMINATION)) {
-				pr_err("BUG: illumination button defined, but no illumination LED.\n");
+				dev_err(&dev->udev->dev,
+					"BUG: illumination button defined, but no illumination LED.\n");
 				goto next_button;
 			}
 		}
@@ -667,7 +670,7 @@ static void em28xx_shutdown_buttons(struct em28xx *dev)
 	dev->num_button_polling_addresses = 0;
 	/* Deregister input devices */
 	if (dev->sbutton_input_dev != NULL) {
-		pr_info("Deregistering snapshot button\n");
+		dev_info(&dev->udev->dev, "Deregistering snapshot button\n");
 		input_unregister_device(dev->sbutton_input_dev);
 		dev->sbutton_input_dev = NULL;
 	}
@@ -696,18 +699,20 @@ static int em28xx_ir_init(struct em28xx *dev)
 		i2c_rc_dev_addr = em28xx_probe_i2c_ir(dev);
 		if (!i2c_rc_dev_addr) {
 			dev->board.has_ir_i2c = 0;
-			pr_warn("No i2c IR remote control device found.\n");
+			dev_warn(&dev->udev->dev,
+				 "No i2c IR remote control device found.\n");
 			return -ENODEV;
 		}
 	}
 
 	if (dev->board.ir_codes == NULL && !dev->board.has_ir_i2c) {
 		/* No remote control support */
-		pr_warn("Remote control support is not available for this card.\n");
+		dev_warn(&dev->udev->dev,
+			 "Remote control support is not available for this card.\n");
 		return 0;
 	}
 
-	pr_info("Registering input extension\n");
+	dev_info(&dev->udev->dev, "Registering input extension\n");
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	if (!ir)
@@ -791,7 +796,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 	ir->polling = 100; /* ms */
 
 	/* init input device */
-	snprintf(ir->name, sizeof(ir->name), "em28xx IR (%s)", dev->name);
+	snprintf(ir->name, sizeof(ir->name), "%s IR",
+		 dev_name(&dev->udev->dev));
 
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
@@ -810,7 +816,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	if (err)
 		goto error;
 
-	pr_info("Input extension successfully initalized\n");
+	dev_info(&dev->udev->dev, "Input extension successfully initalized\n");
 
 	return 0;
 
@@ -831,7 +837,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
 		return 0;
 	}
 
-	pr_info("Closing input extension\n");
+	dev_info(&dev->udev->dev, "Closing input extension\n");
 
 	em28xx_shutdown_buttons(dev);
 
@@ -860,7 +866,7 @@ static int em28xx_ir_suspend(struct em28xx *dev)
 	if (dev->is_audio_only)
 		return 0;
 
-	pr_info("Suspending input extension\n");
+	dev_info(&dev->udev->dev, "Suspending input extension\n");
 	if (ir)
 		cancel_delayed_work_sync(&ir->work);
 	cancel_delayed_work_sync(&dev->buttons_query_work);
@@ -877,7 +883,7 @@ static int em28xx_ir_resume(struct em28xx *dev)
 	if (dev->is_audio_only)
 		return 0;
 
-	pr_info("Resuming input extension\n");
+	dev_info(&dev->udev->dev, "Resuming input extension\n");
 	/* if suspend calls ir_raw_event_unregister(), the should call
 	   ir_raw_event_register() */
 	if (ir)
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 744b3300b153..1b21d001cc7e 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/hardirq.h>
 #include <linux/init.h>
+#include <linux/usb.h>
 
 #include "em28xx-v4l.h"
 
@@ -64,8 +65,9 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 	size = v4l2->vbi_width * v4l2->vbi_height * 2;
 
 	if (vb2_plane_size(vb, 0) < size) {
-		pr_info("%s data will not fit into plane (%lu < %lu)\n",
-			__func__, vb2_plane_size(vb, 0), size);
+		dev_info(&dev->udev->dev,
+			 "%s data will not fit into plane (%lu < %lu)\n",
+			 __func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
 	vb2_set_plane_payload(vb, 0, size);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8b5e13bbfb07..2d282ed9aac0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -64,15 +64,17 @@ static int alt;
 module_param(alt, int, 0644);
 MODULE_PARM_DESC(alt, "alternate setting to use for video endpoint");
 
-#define em28xx_videodbg(fmt, arg...) do {\
-	if (video_debug) \
-		printk(KERN_DEBUG pr_fmt("video: %s: " fmt), \
-			 __func__, ##arg); } while (0)
+#define em28xx_videodbg(fmt, arg...) do {				\
+	if (video_debug)						\
+		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
+			   "video: %s: " fmt, __func__, ## arg);	\
+} while (0)
 
 #define em28xx_isocdbg(fmt, arg...) do {\
 	if (isoc_debug) \
-		printk(KERN_DEBUG pr_fmt("isoc: %s: " fmt), \
-			 __func__, ##arg); } while (0)
+		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
+			   "isoc: %s: " fmt, __func__, ## arg);		\
+} while (0)
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC " - v4l2 interface");
@@ -411,8 +413,9 @@ static int em28xx_set_alternate(struct em28xx *dev)
 			dev->alt, dev->max_pkt_size);
 	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
 	if (errCode < 0) {
-		pr_err("cannot change alternate number to %d (error=%i)\n",
-		       dev->alt, errCode);
+		dev_err(&dev->udev->dev,
+			"cannot change alternate number to %d (error=%i)\n",
+			dev->alt, errCode);
 		return errCode;
 	}
 	return 0;
@@ -923,10 +926,11 @@ static int em28xx_enable_analog_tuner(struct em28xx *dev)
 
 		ret = media_entity_setup_link(link, flags);
 		if (ret) {
-			pr_err("Couldn't change link %s->%s to %s. Error %d\n",
-			       source->name, sink->name,
-			       flags ? "enabled" : "disabled",
-			       ret);
+			dev_err(&dev->udev->dev,
+				"Couldn't change link %s->%s to %s. Error %d\n",
+				source->name, sink->name,
+				flags ? "enabled" : "disabled",
+				ret);
 			return ret;
 		} else
 			em28xx_videodbg("link %s->%s was %s\n",
@@ -954,14 +958,16 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
 	v4l2->video_pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_pads_init(&v4l2->vdev.entity, 1, &v4l2->video_pad);
 	if (ret < 0)
-		pr_err("failed to initialize video media entity!\n");
+		dev_err(&dev->udev->dev,
+			"failed to initialize video media entity!\n");
 
 	if (em28xx_vbi_supported(dev)) {
 		v4l2->vbi_pad.flags = MEDIA_PAD_FL_SINK;
 		ret = media_entity_pads_init(&v4l2->vbi_dev.entity, 1,
 					     &v4l2->vbi_pad);
 		if (ret < 0)
-			pr_err("failed to initialize vbi media entity!\n");
+			dev_err(&dev->udev->dev,
+				"failed to initialize vbi media entity!\n");
 	}
 
 	/* Webcams don't have input connectors */
@@ -994,11 +1000,13 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
 
 		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
 		if (ret < 0)
-			pr_err("failed to initialize input pad[%d]!\n", i);
+			dev_err(&dev->udev->dev,
+				"failed to initialize input pad[%d]!\n", i);
 
 		ret = media_device_register_entity(dev->media_dev, ent);
 		if (ret < 0)
-			pr_err("failed to register input entity %d!\n", i);
+			dev_err(&dev->udev->dev,
+				"failed to register input entity %d!\n", i);
 	}
 #endif
 }
@@ -2045,7 +2053,8 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	ret = v4l2_fh_open(filp);
 	if (ret) {
-		pr_err("%s: v4l2_fh_open() returned error %d\n",
+		dev_err(&dev->udev->dev,
+			"%s: v4l2_fh_open() returned error %d\n",
 		       __func__, ret);
 		mutex_unlock(&dev->lock);
 		return ret;
@@ -2100,7 +2109,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (v4l2 == NULL)
 		return 0;
 
-	pr_info("Closing video extension\n");
+	dev_info(&dev->udev->dev, "Closing video extension\n");
 
 	mutex_lock(&dev->lock);
 
@@ -2111,17 +2120,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	em28xx_v4l2_media_release(dev);
 
 	if (video_is_registered(&v4l2->radio_dev)) {
-		pr_info("V4L2 device %s deregistered\n",
+		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
 			video_device_node_name(&v4l2->radio_dev));
 		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
-		pr_info("V4L2 device %s deregistered\n",
+		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
 			video_device_node_name(&v4l2->vbi_dev));
 		video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
-		pr_info("V4L2 device %s deregistered\n",
+		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
 			video_device_node_name(&v4l2->vdev));
 		video_unregister_device(&v4l2->vdev);
 	}
@@ -2151,7 +2160,7 @@ static int em28xx_v4l2_suspend(struct em28xx *dev)
 	if (!dev->has_video)
 		return 0;
 
-	pr_info("Suspending video extension\n");
+	dev_info(&dev->udev->dev, "Suspending video extension\n");
 	em28xx_stop_urbs(dev);
 	return 0;
 }
@@ -2164,7 +2173,7 @@ static int em28xx_v4l2_resume(struct em28xx *dev)
 	if (!dev->has_video)
 		return 0;
 
-	pr_info("Resuming video extension\n");
+	dev_info(&dev->udev->dev, "Resuming video extension\n");
 	/* what do we do here */
 	return 0;
 }
@@ -2201,8 +2210,9 @@ static int em28xx_v4l2_close(struct file *filp)
 		em28xx_videodbg("setting alternate 0\n");
 		errCode = usb_set_interface(dev->udev, 0, 0);
 		if (errCode < 0) {
-			pr_err("cannot change alternate number to 0 (error=%i)\n",
-			       errCode);
+			dev_err(&dev->udev->dev,
+				"cannot change alternate number to 0 (error=%i)\n",
+				errCode);
 		}
 	}
 
@@ -2335,7 +2345,7 @@ static void em28xx_vdev_init(struct em28xx *dev,
 		vfd->tvnorms = 0;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s",
-		 dev->name, type_name);
+		 dev_name(&dev->udev->dev), type_name);
 
 	video_set_drvdata(vfd, dev);
 }
@@ -2419,7 +2429,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		return 0;
 	}
 
-	pr_info("Registering V4L2 extension\n");
+	dev_info(&dev->udev->dev, "Registering V4L2 extension\n");
 
 	mutex_lock(&dev->lock);
 
@@ -2437,7 +2447,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 #endif
 	ret = v4l2_device_register(&dev->udev->dev, &v4l2->v4l2_dev);
 	if (ret < 0) {
-		pr_err("Call to v4l2_device_register() failed!\n");
+		dev_err(&dev->udev->dev,
+			"Call to v4l2_device_register() failed!\n");
 		goto err;
 	}
 
@@ -2521,8 +2532,9 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Configure audio */
 	ret = em28xx_audio_setup(dev);
 	if (ret < 0) {
-		pr_err("%s: Error while setting audio - error [%d]!\n",
-		       __func__, ret);
+		dev_err(&dev->udev->dev,
+			"%s: Error while setting audio - error [%d]!\n",
+			__func__, ret);
 		goto unregister_dev;
 	}
 	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
@@ -2549,16 +2561,18 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		/* Send a reset to other chips via gpio */
 		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
 		if (ret < 0) {
-			pr_err("%s: em28xx_write_reg - msp34xx(1) failed! error [%d]\n",
-			       __func__, ret);
+			dev_err(&dev->udev->dev,
+				"%s: em28xx_write_reg - msp34xx(1) failed! error [%d]\n",
+				__func__, ret);
 			goto unregister_dev;
 		}
 		msleep(3);
 
 		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
 		if (ret < 0) {
-			pr_err("%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
-			       __func__, ret);
+			dev_err(&dev->udev->dev,
+				"%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
+				__func__, ret);
 			goto unregister_dev;
 		}
 		msleep(3);
@@ -2659,7 +2673,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	ret = video_register_device(&v4l2->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
 	if (ret) {
-		pr_err("unable to register video device (error=%i).\n", ret);
+		dev_err(&dev->udev->dev,
+			"unable to register video device (error=%i).\n", ret);
 		goto unregister_dev;
 	}
 
@@ -2688,7 +2703,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		ret = video_register_device(&v4l2->vbi_dev, VFL_TYPE_VBI,
 					    vbi_nr[dev->devno]);
 		if (ret < 0) {
-			pr_err("unable to register vbi device\n");
+			dev_err(&dev->udev->dev,
+				"unable to register vbi device\n");
 			goto unregister_dev;
 		}
 	}
@@ -2699,11 +2715,13 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		ret = video_register_device(&v4l2->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
-			pr_err("can't register radio device\n");
+			dev_err(&dev->udev->dev,
+				"can't register radio device\n");
 			goto unregister_dev;
 		}
-		pr_info("Registered radio device as %s\n",
-			video_device_node_name(&v4l2->radio_dev));
+		dev_info(&dev->udev->dev,
+			 "Registered radio device as %s\n",
+			 video_device_node_name(&v4l2->radio_dev));
 	}
 
 	/* Init entities at the Media Controller */
@@ -2712,18 +2730,21 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_mc_create_media_graph(dev->media_dev);
 	if (ret) {
-		pr_err("failed to create media graph\n");
+		dev_err(&dev->udev->dev,
+			"failed to create media graph\n");
 		em28xx_v4l2_media_release(dev);
 		goto unregister_dev;
 	}
 #endif
 
-	pr_info("V4L2 video device registered as %s\n",
-		video_device_node_name(&v4l2->vdev));
+	dev_info(&dev->udev->dev,
+		 "V4L2 video device registered as %s\n",
+		 video_device_node_name(&v4l2->vdev));
 
 	if (video_is_registered(&v4l2->vbi_dev))
-		pr_info("V4L2 VBI device registered as %s\n",
-			video_device_node_name(&v4l2->vbi_dev));
+		dev_info(&dev->udev->dev,
+			 "V4L2 VBI device registered as %s\n",
+			 video_device_node_name(&v4l2->vbi_dev));
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
@@ -2731,7 +2752,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* initialize videobuf2 stuff */
 	em28xx_vb2_setup(dev);
 
-	pr_info("V4L2 extension successfully initialized\n");
+	dev_info(&dev->udev->dev,
+		 "V4L2 extension successfully initialized\n");
 
 	kref_get(&dev->ref);
 
@@ -2740,18 +2762,21 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 unregister_dev:
 	if (video_is_registered(&v4l2->radio_dev)) {
-		pr_info("V4L2 device %s deregistered\n",
-			video_device_node_name(&v4l2->radio_dev));
+		dev_info(&dev->udev->dev,
+			 "V4L2 device %s deregistered\n",
+			 video_device_node_name(&v4l2->radio_dev));
 		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
-		pr_info("V4L2 device %s deregistered\n",
-			video_device_node_name(&v4l2->vbi_dev));
+		dev_info(&dev->udev->dev,
+			 "V4L2 device %s deregistered\n",
+			 video_device_node_name(&v4l2->vbi_dev));
 		video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
-		pr_info("V4L2 device %s deregistered\n",
-			video_device_node_name(&v4l2->vdev));
+		dev_info(&dev->udev->dev,
+			 "V4L2 device %s deregistered\n",
+			 video_device_node_name(&v4l2->vdev));
 		video_unregister_device(&v4l2->vdev);
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 0f6830f5078b..3e5ace497a4e 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -29,8 +29,6 @@
 #define EM28XX_VERSION "0.2.2"
 #define DRIVER_DESC    "Empia em28xx device driver"
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/workqueue.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
@@ -612,7 +610,6 @@ struct em28xx {
 	struct em28xx_IR *ir;
 
 	/* generic device properties */
-	char name[30];		/* name (including minor) of the device */
 	int model;		/* index in the device_data struct */
 	int devno;		/* marks the number of this device */
 	enum em28xx_chip_id chip_id;
-- 
2.7.4


