Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754290AbcJNRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 05/25] [media] em28xx: use pr_foo instead of em28xx-specific printk macros
Date: Fri, 14 Oct 2016 14:45:43 -0300
Message-Id: <4d813af4f751127b7eeb690ef8319abf32c5fb5f.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason to keep using em28xx-specific printk macros
here. Just use pr_foo().

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c  |  31 ++++-----
 drivers/media/usb/em28xx/em28xx-camera.c |  34 +++++-----
 drivers/media/usb/em28xx/em28xx-cards.c  |  77 +++++++++++-----------
 drivers/media/usb/em28xx/em28xx-core.c   |  51 +++++++--------
 drivers/media/usb/em28xx/em28xx-dvb.c    |  42 ++++++------
 drivers/media/usb/em28xx/em28xx-i2c.c    | 109 ++++++++++++++++---------------
 drivers/media/usb/em28xx/em28xx-input.c  |  26 ++++----
 drivers/media/usb/em28xx/em28xx-video.c  |  57 ++++++++--------
 drivers/media/usb/em28xx/em28xx.h        |  18 +----
 9 files changed, 215 insertions(+), 230 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 2a3975b1aea5..b5f35a25d870 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -25,6 +25,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "em28xx.h"
+
 #include <linux/kernel.h>
 #include <linux/usb.h>
 #include <linux/init.h>
@@ -44,7 +46,6 @@
 #include <sound/tlv.h>
 #include <sound/ac97_codec.h>
 #include <media/v4l2-common.h>
-#include "em28xx.h"
 
 static int debug;
 module_param(debug, int, 0644);
@@ -164,7 +165,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status < 0)
-		em28xx_errdev("resubmit of audio urb failed (error=%i)\n",
+		pr_err("resubmit of audio urb failed (error=%i)\n",
 			      status);
 	return;
 }
@@ -182,7 +183,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 
 		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
 		if (errCode) {
-			em28xx_errdev("submit of audio urb failed (error=%i)\n",
+			pr_err("submit of audio urb failed (error=%i)\n",
 				      errCode);
 			em28xx_deinit_isoc_audio(dev);
 			atomic_set(&dev->adev.stream_started, 0);
@@ -254,7 +255,7 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	int nonblock, ret = 0;
 
 	if (!dev) {
-		em28xx_err("BUG: em28xx can't find device struct. Can't proceed with open\n");
+		pr_err("BUG: em28xx can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
@@ -317,7 +318,7 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 err:
 	mutex_unlock(&dev->lock);
 
-	em28xx_err("Error while configuring em28xx mixer\n");
+	pr_err("Error while configuring em28xx mixer\n");
 	return ret;
 }
 
@@ -755,7 +756,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	intf = usb_ifnum_to_if(dev->udev, dev->ifnum);
 
 	if (intf->num_altsetting <= alt) {
-		em28xx_errdev("alt %d doesn't exist on interface %d\n",
+		pr_err("alt %d doesn't exist on interface %d\n",
 			      dev->ifnum, alt);
 		return -ENODEV;
 	}
@@ -771,14 +772,14 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	}
 
 	if (!ep) {
-		em28xx_errdev("Couldn't find an audio endpoint");
+		pr_err("Couldn't find an audio endpoint");
 		return -ENODEV;
 	}
 
 	ep_size = em28xx_audio_ep_packet_size(dev->udev, ep);
 	interval = 1 << (ep->bInterval - 1);
 
-	em28xx_info("Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
+	pr_info("Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
 		    EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
 		     dev->ifnum, alt,
 		     interval,
@@ -819,7 +820,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	if (urb_size > ep_size * npackets)
 		npackets = DIV_ROUND_UP(urb_size, ep_size);
 
-	em28xx_info("Number of URBs: %d, with %d packets and %d size\n",
+	pr_info("Number of URBs: %d, with %d packets and %d size\n",
 		    num_urb, npackets, urb_size);
 
 	/* Estimate the bytes per period */
@@ -857,7 +858,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 		buf = usb_alloc_coherent(dev->udev, npackets * ep_size, GFP_ATOMIC,
 					 &urb->transfer_dma);
 		if (!buf) {
-			em28xx_errdev("usb_alloc_coherent failed!\n");
+			pr_err("usb_alloc_coherent failed!\n");
 			em28xx_audio_free_urb(dev);
 			return -ENOMEM;
 		}
@@ -897,7 +898,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 		return 0;
 	}
 
-	em28xx_info("Binding audio extension\n");
+	pr_info("Binding audio extension\n");
 
 	kref_get(&dev->ref);
 
@@ -953,7 +954,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 	if (err < 0)
 		goto urb_free;
 
-	em28xx_info("Audio extension successfully initialized\n");
+	pr_info("Audio extension successfully initialized\n");
 	return 0;
 
 urb_free:
@@ -978,7 +979,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
 		return 0;
 	}
 
-	em28xx_info("Closing audio extension\n");
+	pr_info("Closing audio extension\n");
 
 	if (dev->adev.sndcard) {
 		snd_card_disconnect(dev->adev.sndcard);
@@ -1002,7 +1003,7 @@ static int em28xx_audio_suspend(struct em28xx *dev)
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
 		return 0;
 
-	em28xx_info("Suspending audio extension\n");
+	pr_info("Suspending audio extension\n");
 	em28xx_deinit_isoc_audio(dev);
 	atomic_set(&dev->adev.stream_started, 0);
 	return 0;
@@ -1016,7 +1017,7 @@ static int em28xx_audio_resume(struct em28xx *dev)
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
 		return 0;
 
-	em28xx_info("Resuming audio extension\n");
+	pr_info("Resuming audio extension\n");
 	/* Nothing to do other than schedule_work() ?? */
 	schedule_work(&dev->adev.wq_trigger);
 	return 0;
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 72f3f4d50253..bc07166e7df0 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -19,14 +19,14 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#include "em28xx.h"
+
 #include <linux/i2c.h>
 #include <media/soc_camera.h>
 #include <media/i2c/mt9v011.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 
-#include "em28xx.h"
-
 /* Possible i2c addresses of Micron sensors */
 static unsigned short micron_sensor_addrs[] = {
 	0xb8 >> 1,   /* MT9V111, MT9V403 */
@@ -120,13 +120,13 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 		ret = i2c_master_send(&client, &reg, 1);
 		if (ret < 0) {
 			if (ret != -ENXIO)
-				em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+				pr_err("couldn't read from i2c device 0x%02x: error %i\n",
 					      client.addr << 1, ret);
 			continue;
 		}
 		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
 		if (ret < 0) {
-			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
 				      client.addr << 1, ret);
 			continue;
 		}
@@ -135,13 +135,13 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 		reg = 0xff;
 		ret = i2c_master_send(&client, &reg, 1);
 		if (ret < 0) {
-			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
 				      client.addr << 1, ret);
 			continue;
 		}
 		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
 		if (ret < 0) {
-			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
 				      client.addr << 1, ret);
 			continue;
 		}
@@ -180,15 +180,15 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 			dev->em28xx_sensor = EM28XX_MT9M001;
 			break;
 		default:
-			em28xx_info("unknown Micron sensor detected: 0x%04x\n",
+			pr_info("unknown Micron sensor detected: 0x%04x\n",
 				    id);
 			return 0;
 		}
 
 		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
-			em28xx_info("unsupported sensor detected: %s\n", name);
+			pr_info("unsupported sensor detected: %s\n", name);
 		else
-			em28xx_info("sensor %s detected\n", name);
+			pr_info("sensor %s detected\n", name);
 
 		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
 		return 0;
@@ -218,7 +218,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
 			if (ret != -ENXIO)
-				em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+				pr_err("couldn't read from i2c device 0x%02x: error %i\n",
 					      client.addr << 1, ret);
 			continue;
 		}
@@ -226,7 +226,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		reg = 0x1d;
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
-			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
 				      client.addr << 1, ret);
 			continue;
 		}
@@ -238,7 +238,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		reg = 0x0a;
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
-			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
 				      client.addr << 1, ret);
 			continue;
 		}
@@ -246,7 +246,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		reg = 0x0b;
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
-			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+			pr_err("couldn't read from i2c device 0x%02x: error %i\n",
 				      client.addr << 1, ret);
 			continue;
 		}
@@ -285,15 +285,15 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 			name = "OV9655";
 			break;
 		default:
-			em28xx_info("unknown OmniVision sensor detected: 0x%04x\n",
+			pr_info("unknown OmniVision sensor detected: 0x%04x\n",
 				    id);
 			return 0;
 		}
 
 		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
-			em28xx_info("unsupported sensor detected: %s\n", name);
+			pr_info("unsupported sensor detected: %s\n", name);
 		else
-			em28xx_info("sensor %s detected\n", name);
+			pr_info("sensor %s detected\n", name);
 
 		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
 		return 0;
@@ -317,7 +317,7 @@ int em28xx_detect_sensor(struct em28xx *dev)
 	 */
 
 	if (dev->em28xx_sensor == EM28XX_NOSENSOR && ret < 0) {
-		em28xx_info("No sensor detected\n");
+		pr_info("No sensor detected\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index bed41c1b4817..c73cf2012bf5 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -23,6 +23,8 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "em28xx.h"
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -39,7 +41,6 @@
 #include <media/v4l2-common.h>
 #include <sound/ac97_codec.h>
 
-#include "em28xx.h"
 
 #define DRIVER_NAME         "em28xx"
 
@@ -2677,7 +2678,7 @@ static int em28xx_wait_until_ac97_features_equals(struct em28xx *dev,
 		msleep(50);
 	}
 
-	em28xx_warn("AC97 registers access is not reliable !\n");
+	pr_warn("AC97 registers access is not reliable !\n");
 	return -ETIMEDOUT;
 }
 
@@ -2831,12 +2832,12 @@ static int em28xx_hint_board(struct em28xx *dev)
 			dev->model = em28xx_eeprom_hash[i].model;
 			dev->tuner_type = em28xx_eeprom_hash[i].tuner;
 
-			em28xx_errdev("Your board has no unique USB ID.\n");
-			em28xx_errdev("A hint were successfully done, based on eeprom hash.\n");
-			em28xx_errdev("This method is not 100%% failproof.\n");
-			em28xx_errdev("If the board were missdetected, please email this log to:\n");
-			em28xx_errdev("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
-			em28xx_errdev("Board detected as %s\n",
+			pr_err("Your board has no unique USB ID.\n");
+			pr_err("A hint were successfully done, based on eeprom hash.\n");
+			pr_err("This method is not 100%% failproof.\n");
+			pr_err("If the board were missdetected, please email this log to:\n");
+			pr_err("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
+			pr_err("Board detected as %s\n",
 				      em28xx_boards[dev->model].name);
 
 			return 0;
@@ -2860,28 +2861,28 @@ static int em28xx_hint_board(struct em28xx *dev)
 		if (dev->i2c_hash == em28xx_i2c_hash[i].hash) {
 			dev->model = em28xx_i2c_hash[i].model;
 			dev->tuner_type = em28xx_i2c_hash[i].tuner;
-			em28xx_errdev("Your board has no unique USB ID.\n");
-			em28xx_errdev("A hint were successfully done, based on i2c devicelist hash.\n");
-			em28xx_errdev("This method is not 100%% failproof.\n");
-			em28xx_errdev("If the board were missdetected, please email this log to:\n");
-			em28xx_errdev("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
-			em28xx_errdev("Board detected as %s\n",
+			pr_err("Your board has no unique USB ID.\n");
+			pr_err("A hint were successfully done, based on i2c devicelist hash.\n");
+			pr_err("This method is not 100%% failproof.\n");
+			pr_err("If the board were missdetected, please email this log to:\n");
+			pr_err("\tV4L Mailing List  <linux-media@vger.kernel.org>\n");
+			pr_err("Board detected as %s\n",
 				      em28xx_boards[dev->model].name);
 
 			return 0;
 		}
 	}
 
-	em28xx_errdev("Your board has no unique USB ID and thus need a hint to be detected.\n");
-	em28xx_errdev("You may try to use card=<n> insmod option to workaround that.\n");
-	em28xx_errdev("Please send an email with this log to:\n");
-	em28xx_errdev("\tV4L Mailing List <linux-media@vger.kernel.org>\n");
-	em28xx_errdev("Board eeprom hash is 0x%08lx\n", dev->hash);
-	em28xx_errdev("Board i2c devicelist hash is 0x%08lx\n", dev->i2c_hash);
+	pr_err("Your board has no unique USB ID and thus need a hint to be detected.\n");
+	pr_err("You may try to use card=<n> insmod option to workaround that.\n");
+	pr_err("Please send an email with this log to:\n");
+	pr_err("\tV4L Mailing List <linux-media@vger.kernel.org>\n");
+	pr_err("Board eeprom hash is 0x%08lx\n", dev->hash);
+	pr_err("Board i2c devicelist hash is 0x%08lx\n", dev->i2c_hash);
 
-	em28xx_errdev("Here is a list of valid choices for the card=<n> insmod option:\n");
+	pr_err("Here is a list of valid choices for the card=<n> insmod option:\n");
 	for (i = 0; i < em28xx_bcount; i++) {
-		em28xx_errdev("    card=%d -> %s\n",
+		pr_err("    card=%d -> %s\n",
 			      i, em28xx_boards[i].name);
 	}
 	return -1;
@@ -2916,7 +2917,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 		 * hash identities which has not been determined as yet.
 		 */
 		if (em28xx_hint_board(dev) < 0)
-			em28xx_errdev("Board not discovered\n");
+			pr_err("Board not discovered\n");
 		else {
 			em28xx_set_model(dev);
 			em28xx_pre_card_setup(dev);
@@ -2926,7 +2927,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 		em28xx_set_model(dev);
 	}
 
-	em28xx_info("Identified as %s (card=%d)\n",
+	pr_info("Identified as %s (card=%d)\n",
 		    dev->board.name, dev->model);
 
 	dev->tuner_type = em28xx_boards[dev->model].tuner_type;
@@ -3025,10 +3026,10 @@ static void em28xx_card_setup(struct em28xx *dev)
 	}
 
 	if (dev->board.valid == EM28XX_BOARD_NOT_VALIDATED) {
-		em28xx_errdev("\n\n");
-		em28xx_errdev("The support for this board weren't valid yet.\n");
-		em28xx_errdev("Please send a report of having this working\n");
-		em28xx_errdev("not to V4L mailing list (and/or to other addresses)\n\n");
+		pr_err("\n\n");
+		pr_err("The support for this board weren't valid yet.\n");
+		pr_err("Please send a report of having this working\n");
+		pr_err("not to V4L mailing list (and/or to other addresses)\n\n");
 	}
 
 	/* Free eeprom data memory */
@@ -3211,7 +3212,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	em28xx_info("Freeing device\n");
+	pr_info("Freeing device\n");
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
@@ -3349,7 +3350,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		/* Resets I2C speed */
 		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
 		if (retval < 0) {
-			em28xx_errdev("%s: em28xx_write_reg failed! retval [%d]\n",
+			pr_err("%s: em28xx_write_reg failed! retval [%d]\n",
 				      __func__, retval);
 			return retval;
 		}
@@ -3363,7 +3364,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	else
 		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
 	if (retval < 0) {
-		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
+		pr_err("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 			      __func__, retval);
 		return retval;
 	}
@@ -3377,7 +3378,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			retval = em28xx_i2c_register(dev, 1,
 						     EM28XX_I2C_ALGO_EM28XX);
 		if (retval < 0) {
-			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
+			pr_err("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				      __func__, retval);
 
 			em28xx_i2c_unregister(dev, 0);
@@ -3427,7 +3428,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	/* Don't register audio interfaces */
 	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
-		em28xx_err(DRIVER_NAME
+		pr_err(DRIVER_NAME
 			" audio device (%04x:%04x): interface %i, class %i\n",
 			le16_to_cpu(udev->descriptor.idVendor),
 			le16_to_cpu(udev->descriptor.idProduct),
@@ -3441,7 +3442,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
-		em28xx_err(DRIVER_NAME ": out of memory!\n");
 		retval = -ENOMEM;
 		goto err;
 	}
@@ -3451,7 +3451,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 				kmalloc(sizeof(dev->alt_max_pkt_size_isoc[0]) *
 					interface->num_altsetting, GFP_KERNEL);
 	if (dev->alt_max_pkt_size_isoc == NULL) {
-		em28xx_errdev("out of memory!\n");
 		kfree(dev);
 		retval = -ENOMEM;
 		goto err;
@@ -3604,7 +3603,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
 			if (has_vendor_audio)
-				em28xx_err("em28xx: device seems to have vendor AND usb audio class interfaces !\n"
+				pr_err("em28xx: device seems to have vendor AND usb audio class interfaces !\n"
 					   "\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
 			dev->usb_audio_type = EM28XX_USB_AUDIO_CLASS;
 			break;
@@ -3661,13 +3660,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (has_video) {
 		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
 			dev->analog_xfer_bulk = 1;
-		em28xx_info("analog set to %s mode.\n",
+		pr_info("analog set to %s mode.\n",
 			    dev->analog_xfer_bulk ? "bulk" : "isoc");
 	}
 	if (has_dvb) {
 		if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
 			dev->dvb_xfer_bulk = 1;
-		em28xx_info("dvb set to %s mode.\n",
+		pr_info("dvb set to %s mode.\n",
 			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
 	}
 
@@ -3715,7 +3714,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 
 	dev->disconnected = 1;
 
-	em28xx_info("Disconnecting %s\n", dev->name);
+	pr_info("Disconnecting %s\n", dev->name);
 
 	flush_request_modules(dev);
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 06bee2d67273..8897cde9894b 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -22,6 +22,8 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "em28xx.h"
+
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/list.h>
@@ -32,8 +34,6 @@
 #include <sound/ac97_codec.h>
 #include <media/v4l2-common.h>
 
-#include "em28xx.h"
-
 #define DRIVER_AUTHOR "Ludovico Cavedon <cavedon@sssup.it>, " \
 		      "Markus Rechberger <mrechberger@gmail.com>, " \
 		      "Mauro Carvalho Chehab <mchehab@infradead.org>, " \
@@ -267,7 +267,7 @@ static int em28xx_is_ac97_ready(struct em28xx *dev)
 		msleep(5);
 	}
 
-	em28xx_warn("AC97 command still being executed: not handled properly!\n");
+	pr_warn("AC97 command still being executed: not handled properly!\n");
 	return -EBUSY;
 }
 
@@ -360,7 +360,7 @@ static int set_ac97_input(struct em28xx *dev)
 			ret = em28xx_write_ac97(dev, inputs[i].reg, 0x8000);
 
 		if (ret < 0)
-			em28xx_warn("couldn't setup AC97 register %d\n",
+			pr_warn("couldn't setup AC97 register %d\n",
 				    inputs[i].reg);
 	}
 	return 0;
@@ -444,7 +444,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 		for (i = 0; i < ARRAY_SIZE(outputs); i++) {
 			ret = em28xx_write_ac97(dev, outputs[i].reg, 0x8000);
 			if (ret < 0)
-				em28xx_warn("couldn't setup AC97 register %d\n",
+				pr_warn("couldn't setup AC97 register %d\n",
 					    outputs[i].reg);
 		}
 	}
@@ -482,7 +482,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 				ret = em28xx_write_ac97(dev, outputs[i].reg,
 							vol);
 			if (ret < 0)
-				em28xx_warn("couldn't setup AC97 register %d\n",
+				pr_warn("couldn't setup AC97 register %d\n",
 					    outputs[i].reg);
 		}
 
@@ -519,7 +519,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 
 	/* See how this device is configured */
 	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
-	em28xx_info("Config register raw data: 0x%02x\n", cfg);
+	pr_info("Config register raw data: 0x%02x\n", cfg);
 	if (cfg < 0) { /* Register read error */
 		/* Be conservative */
 		dev->int_audio_type = EM28XX_INT_AUDIO_AC97;
@@ -540,7 +540,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 			i2s_samplerates = 5;
 		else
 			i2s_samplerates = 3;
-		em28xx_info("I2S Audio (%d sample rate(s))\n",
+		pr_info("I2S Audio (%d sample rate(s))\n",
 			    i2s_samplerates);
 		/* Skip the code that does AC97 vendor detection */
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
@@ -558,7 +558,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 		 * Note: (some) em2800 devices without eeprom reports 0x91 on
 		 *	 CHIPCFG register, even not having an AC97 chip
 		 */
-		em28xx_warn("AC97 chip type couldn't be determined\n");
+		pr_warn("AC97 chip type couldn't be determined\n");
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		if (dev->usb_audio_type == EM28XX_USB_AUDIO_VENDOR)
 			dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
@@ -571,13 +571,13 @@ int em28xx_audio_setup(struct em28xx *dev)
 		goto init_audio;
 
 	vid = vid1 << 16 | vid2;
-	em28xx_warn("AC97 vendor ID = 0x%08x\n", vid);
+	pr_warn("AC97 vendor ID = 0x%08x\n", vid);
 
 	feat = em28xx_read_ac97(dev, AC97_RESET);
 	if (feat < 0)
 		goto init_audio;
 
-	em28xx_warn("AC97 features = 0x%04x\n", feat);
+	pr_warn("AC97 features = 0x%04x\n", feat);
 
 	/* Try to identify what audio processor we have */
 	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat == 0x6a90))
@@ -589,17 +589,17 @@ int em28xx_audio_setup(struct em28xx *dev)
 	/* Reports detected AC97 processor */
 	switch (dev->audio_mode.ac97) {
 	case EM28XX_NO_AC97:
-		em28xx_info("No AC97 audio processor\n");
+		pr_info("No AC97 audio processor\n");
 		break;
 	case EM28XX_AC97_EM202:
-		em28xx_info("Empia 202 AC97 audio processor detected\n");
+		pr_info("Empia 202 AC97 audio processor detected\n");
 		break;
 	case EM28XX_AC97_SIGMATEL:
-		em28xx_info("Sigmatel audio processor detected (stac 97%02x)\n",
+		pr_info("Sigmatel audio processor detected (stac 97%02x)\n",
 			    vid & 0xff);
 		break;
 	case EM28XX_AC97_OTHER:
-		em28xx_warn("Unknown AC97 audio processor detected!\n");
+		pr_warn("Unknown AC97 audio processor detected!\n");
 		break;
 	default:
 		break;
@@ -883,7 +883,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 	if (mode == EM28XX_DIGITAL_MODE) {
 		if ((xfer_bulk && !dev->dvb_ep_bulk) ||
 		    (!xfer_bulk && !dev->dvb_ep_isoc)) {
-			em28xx_errdev("no endpoint for DVB mode and transfer type %d\n",
+			pr_err("no endpoint for DVB mode and transfer type %d\n",
 				      xfer_bulk > 0);
 			return -EINVAL;
 		}
@@ -891,13 +891,13 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 	} else if (mode == EM28XX_ANALOG_MODE) {
 		if ((xfer_bulk && !dev->analog_ep_bulk) ||
 		    (!xfer_bulk && !dev->analog_ep_isoc)) {
-			em28xx_errdev("no endpoint for analog mode and transfer type %d\n",
+			pr_err("no endpoint for analog mode and transfer type %d\n",
 				      xfer_bulk > 0);
 			return -EINVAL;
 		}
 		usb_bufs = &dev->usb_ctl.analog_bufs;
 	} else {
-		em28xx_errdev("invalid mode selected\n");
+		pr_err("invalid mode selected\n");
 		return -EINVAL;
 	}
 
@@ -907,15 +907,12 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 	usb_bufs->num_bufs = num_bufs;
 
 	usb_bufs->urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
-	if (!usb_bufs->urb) {
-		em28xx_errdev("cannot alloc memory for usb buffers\n");
+	if (!usb_bufs->urb)
 		return -ENOMEM;
-	}
 
 	usb_bufs->transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
 					     GFP_KERNEL);
 	if (!usb_bufs->transfer_buffer) {
-		em28xx_errdev("cannot allocate memory for usb transfer\n");
 		kfree(usb_bufs->urb);
 		return -ENOMEM;
 	}
@@ -942,7 +939,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		usb_bufs->transfer_buffer[i] = usb_alloc_coherent(dev->udev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!usb_bufs->transfer_buffer[i]) {
-			em28xx_err("unable to allocate %i bytes for transfer buffer %i%s\n",
+			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
 					sb_size, i,
 					in_interrupt() ? " while in int" : "");
 			em28xx_uninit_usb_xfer(dev, mode);
@@ -1024,7 +1021,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 	if (xfer_bulk) {
 		rc = usb_clear_halt(dev->udev, usb_bufs->urb[0]->pipe);
 		if (rc < 0) {
-			em28xx_err("failed to clear USB bulk endpoint stall/halt condition (error=%i)\n",
+			pr_err("failed to clear USB bulk endpoint stall/halt condition (error=%i)\n",
 				   rc);
 			em28xx_uninit_usb_xfer(dev, mode);
 			return rc;
@@ -1040,7 +1037,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 	for (i = 0; i < usb_bufs->num_bufs; i++) {
 		rc = usb_submit_urb(usb_bufs->urb[i], GFP_ATOMIC);
 		if (rc) {
-			em28xx_err("submit of urb %i failed (error=%i)\n", i,
+			pr_err("submit of urb %i failed (error=%i)\n", i,
 				   rc);
 			em28xx_uninit_usb_xfer(dev, mode);
 			return rc;
@@ -1123,7 +1120,7 @@ int em28xx_suspend_extension(struct em28xx *dev)
 {
 	const struct em28xx_ops *ops = NULL;
 
-	em28xx_info("Suspending extensions\n");
+	pr_info("Suspending extensions\n");
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
 		if (ops->suspend)
@@ -1137,7 +1134,7 @@ int em28xx_resume_extension(struct em28xx *dev)
 {
 	const struct em28xx_ops *ops = NULL;
 
-	em28xx_info("Resuming extensions\n");
+	pr_info("Resuming extensions\n");
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
 		if (ops->resume)
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 488c70e5ebde..cbece65899b5 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -21,11 +21,12 @@
  the Free Software Foundation; either version 2 of the License.
  */
 
+#include "em28xx.h"
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
 
-#include "em28xx.h"
 #include <media/v4l2-common.h>
 #include <dvb_demux.h>
 #include <dvb_net.h>
@@ -734,7 +735,7 @@ static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 
 	ret = gpio_request_one(dvb->lna_gpio, flags, NULL);
 	if (ret)
-		em28xx_errdev("gpio request failed %d\n", ret);
+		pr_err("gpio request failed %d\n", ret);
 	else
 		gpio_free(dvb->lna_gpio);
 
@@ -934,19 +935,19 @@ static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
 	cfg.ctrl  = &ctl;
 
 	if (!dev->dvb->fe[0]) {
-		em28xx_errdev("/2: dvb frontend not attached. Can't attach xc3028\n");
+		pr_err("/2: dvb frontend not attached. Can't attach xc3028\n");
 		return -EINVAL;
 	}
 
 	fe = dvb_attach(xc2028_attach, dev->dvb->fe[0], &cfg);
 	if (!fe) {
-		em28xx_errdev("/2: xc3028 attach failed\n");
+		pr_err("/2: xc3028 attach failed\n");
 		dvb_frontend_detach(dev->dvb->fe[0]);
 		dev->dvb->fe[0] = NULL;
 		return -EINVAL;
 	}
 
-	em28xx_info("%s/2: xc3028 attached\n", dev->name);
+	pr_info("%s/2: xc3028 attached\n", dev->name);
 
 	return 0;
 }
@@ -1116,13 +1117,12 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		return 0;
 	}
 
-	em28xx_info("Binding DVB extension\n");
+	pr_info("Binding DVB extension\n");
 
 	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
-	if (dvb == NULL) {
-		em28xx_info("em28xx_dvb: memory allocation failed\n");
+	if (!dvb)
 		return -ENOMEM;
-	}
+
 	dev->dvb = dvb;
 	dvb->fe[0] = dvb->fe[1] = NULL;
 
@@ -1141,7 +1141,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 					   EM28XX_DVB_NUM_ISOC_PACKETS);
 	}
 	if (result) {
-		em28xx_errdev("em28xx_dvb: failed to pre-allocate USB transfer buffers for DVB.\n");
+		pr_err("em28xx_dvb: failed to pre-allocate USB transfer buffers for DVB.\n");
 		kfree(dvb);
 		dev->dvb = NULL;
 		return result;
@@ -1320,7 +1320,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			result = gpio_request_one(dvb->lna_gpio,
 						  GPIOF_OUT_INIT_LOW, NULL);
 			if (result)
-				em28xx_errdev("gpio request failed %d\n",
+				pr_err("gpio request failed %d\n",
 					      result);
 			else
 				gpio_free(dvb->lna_gpio);
@@ -1936,11 +1936,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	default:
-		em28xx_errdev("/2: The frontend of your DVB/ATSC card isn't supported yet\n");
+		pr_err("/2: The frontend of your DVB/ATSC card isn't supported yet\n");
 		break;
 	}
 	if (NULL == dvb->fe[0]) {
-		em28xx_errdev("/2: frontend initialization failed\n");
+		pr_err("/2: frontend initialization failed\n");
 		result = -EINVAL;
 		goto out_free;
 	}
@@ -1955,7 +1955,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	if (result < 0)
 		goto out_free;
 
-	em28xx_info("DVB extension successfully initialized\n");
+	pr_info("DVB extension successfully initialized\n");
 
 	kref_get(&dev->ref);
 
@@ -1995,7 +1995,7 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	if (!dev->dvb)
 		return 0;
 
-	em28xx_info("Closing DVB extension\n");
+	pr_info("Closing DVB extension\n");
 
 	dvb = dev->dvb;
 
@@ -2053,17 +2053,17 @@ static int em28xx_dvb_suspend(struct em28xx *dev)
 	if (!dev->board.has_dvb)
 		return 0;
 
-	em28xx_info("Suspending DVB extension\n");
+	pr_info("Suspending DVB extension\n");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_suspend(dvb->fe[0]);
-			em28xx_info("fe0 suspend %d\n", ret);
+			pr_info("fe0 suspend %d\n", ret);
 		}
 		if (dvb->fe[1]) {
 			dvb_frontend_suspend(dvb->fe[1]);
-			em28xx_info("fe1 suspend %d\n", ret);
+			pr_info("fe1 suspend %d\n", ret);
 		}
 	}
 
@@ -2080,18 +2080,18 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 	if (!dev->board.has_dvb)
 		return 0;
 
-	em28xx_info("Resuming DVB extension\n");
+	pr_info("Resuming DVB extension\n");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_resume(dvb->fe[0]);
-			em28xx_info("fe0 resume %d\n", ret);
+			pr_info("fe0 resume %d\n", ret);
 		}
 
 		if (dvb->fe[1]) {
 			ret = dvb_frontend_resume(dvb->fe[1]);
-			em28xx_info("fe1 resume %d\n", ret);
+			pr_info("fe1 resume %d\n", ret);
 		}
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 8b690ac908a4..5185fed9fbf0 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -22,13 +22,14 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "em28xx.h"
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include <linux/jiffies.h>
 
-#include "em28xx.h"
 #include "tuner-xc2028.h"
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
@@ -70,7 +71,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	/* trigger write */
 	ret = dev->em28xx_write_regs(dev, 4 - len, &b2[4 - len], 2 + len);
 	if (ret != 2 + len) {
-		em28xx_warn("failed to trigger write to i2c address 0x%x (error=%i)\n",
+		pr_warn("failed to trigger write to i2c address 0x%x (error=%i)\n",
 			    addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
@@ -81,19 +82,19 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 			return len;
 		if (ret == 0x94 + len - 1) {
 			if (i2c_debug == 1)
-				em28xx_warn("R05 returned 0x%02x: I2C ACK error\n",
+				pr_warn("R05 returned 0x%02x: I2C ACK error\n",
 					    ret);
 			return -ENXIO;
 		}
 		if (ret < 0) {
-			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
+			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
 		}
 		msleep(5);
 	}
 	if (i2c_debug)
-		em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
+		pr_warn("write to i2c device at 0x%x timed out\n", addr);
 	return -ETIMEDOUT;
 }
 
@@ -116,7 +117,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	buf2[0] = addr;
 	ret = dev->em28xx_write_regs(dev, 0x04, buf2, 2);
 	if (ret != 2) {
-		em28xx_warn("failed to trigger read from i2c address 0x%x (error=%i)\n",
+		pr_warn("failed to trigger read from i2c address 0x%x (error=%i)\n",
 			    addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
@@ -128,12 +129,12 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 			break;
 		if (ret == 0x94 + len - 1) {
 			if (i2c_debug == 1)
-				em28xx_warn("R05 returned 0x%02x: I2C ACK error\n",
+				pr_warn("R05 returned 0x%02x: I2C ACK error\n",
 					    ret);
 			return -ENXIO;
 		}
 		if (ret < 0) {
-			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
+			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
 		}
@@ -141,14 +142,14 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	}
 	if (ret != 0x84 + len - 1) {
 		if (i2c_debug)
-			em28xx_warn("read from i2c device at 0x%x timed out\n",
+			pr_warn("read from i2c device at 0x%x timed out\n",
 				    addr);
 	}
 
 	/* get the received message */
 	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
 	if (ret != len) {
-		em28xx_warn("reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
+		pr_warn("reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
 			    addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
@@ -193,11 +194,11 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
 	if (ret != len) {
 		if (ret < 0) {
-			em28xx_warn("writing to i2c device at 0x%x failed (error=%i)\n",
+			pr_warn("writing to i2c device at 0x%x failed (error=%i)\n",
 				    addr, ret);
 			return ret;
 		} else {
-			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
+			pr_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
 				    len, addr, ret);
 			return -EIO;
 		}
@@ -210,12 +211,12 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 			return len;
 		if (ret == 0x10) {
 			if (i2c_debug == 1)
-				em28xx_warn("I2C ACK error on writing to addr 0x%02x\n",
+				pr_warn("I2C ACK error on writing to addr 0x%02x\n",
 					    addr);
 			return -ENXIO;
 		}
 		if (ret < 0) {
-			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
+			pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 				    ret);
 			return ret;
 		}
@@ -230,12 +231,12 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	if (ret == 0x02 || ret == 0x04) {
 		/* NOTE: these errors seem to be related to clock stretching */
 		if (i2c_debug)
-			em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n",
+			pr_warn("write to i2c device at 0x%x timed out (status=%i)\n",
 				    addr, ret);
 		return -ETIMEDOUT;
 	}
 
-	em28xx_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
+	pr_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
 		    addr, ret);
 	return -EIO;
 }
@@ -258,7 +259,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	/* Read data from i2c device */
 	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
 	if (ret < 0) {
-		em28xx_warn("reading from i2c device at 0x%x failed (error=%i)\n",
+		pr_warn("reading from i2c device at 0x%x failed (error=%i)\n",
 			    addr, ret);
 		return ret;
 	}
@@ -276,13 +277,13 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	if (ret == 0) /* success */
 		return len;
 	if (ret < 0) {
-		em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
+		pr_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
 			    ret);
 		return ret;
 	}
 	if (ret == 0x10) {
 		if (i2c_debug == 1)
-			em28xx_warn("I2C ACK error on writing to addr 0x%02x\n",
+			pr_warn("I2C ACK error on writing to addr 0x%02x\n",
 				    addr);
 		return -ENXIO;
 	}
@@ -290,12 +291,12 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	if (ret == 0x02 || ret == 0x04) {
 		/* NOTE: these errors seem to be related to clock stretching */
 		if (i2c_debug)
-			em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n",
+			pr_warn("write to i2c device at 0x%x timed out (status=%i)\n",
 				    addr, ret);
 		return -ETIMEDOUT;
 	}
 
-	em28xx_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
+	pr_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
 		    addr, ret);
 	return -EIO;
 }
@@ -335,11 +336,11 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	ret = dev->em28xx_write_regs_req(dev, 0x06, addr, buf, len);
 	if (ret != len) {
 		if (ret < 0) {
-			em28xx_warn("writing to i2c device at 0x%x failed (error=%i)\n",
+			pr_warn("writing to i2c device at 0x%x failed (error=%i)\n",
 				    addr, ret);
 			return ret;
 		} else {
-			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
+			pr_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
 				    len, addr, ret);
 			return -EIO;
 		}
@@ -354,7 +355,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return len;
 	else if (ret > 0) {
 		if (i2c_debug == 1)
-			em28xx_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
+			pr_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
 				    ret);
 		return -ENXIO;
 	}
@@ -386,7 +387,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	/* Read value */
 	ret = dev->em28xx_read_reg_req_len(dev, 0x06, addr, buf, len);
 	if (ret < 0) {
-		em28xx_warn("reading from i2c device at 0x%x failed (error=%i)\n",
+		pr_warn("reading from i2c device at 0x%x failed (error=%i)\n",
 			    addr, ret);
 		return ret;
 	}
@@ -409,7 +410,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return len;
 	else if (ret > 0) {
 		if (i2c_debug == 1)
-			em28xx_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
+			pr_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
 				    ret);
 		return -ENXIO;
 	}
@@ -672,7 +673,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 	/* Check if board has eeprom */
 	err = i2c_master_recv(&dev->i2c_client[bus], &buf, 0);
 	if (err < 0) {
-		em28xx_info("board has no eeprom\n");
+		pr_info("board has no eeprom\n");
 		return -ENODEV;
 	}
 
@@ -685,7 +686,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 				    dev->eeprom_addrwidth_16bit,
 				    len, data);
 	if (err != len) {
-		em28xx_errdev("failed to read eeprom (err=%d)\n", err);
+		pr_err("failed to read eeprom (err=%d)\n", err);
 		goto error;
 	}
 
@@ -695,7 +696,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 			       16, 1, data, len, true);
 
 		if (dev->eeprom_addrwidth_16bit)
-			em28xx_info("eeprom %06x: ... (skipped)\n", 256);
+			pr_info("eeprom %06x: ... (skipped)\n", 256);
 	}
 
 	if (dev->eeprom_addrwidth_16bit &&
@@ -707,10 +708,10 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		dev->hash = em28xx_hash_mem(data, len, 32);
 		mc_start = (data[1] << 8) + 4;	/* usually 0x0004 */
 
-		em28xx_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
+		pr_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
 			    data[0], data[1], data[2], data[3], dev->hash);
-		em28xx_info("EEPROM info:\n");
-		em28xx_info("\tmicrocode start address = 0x%04x, boot configuration = 0x%02x\n",
+		pr_info("EEPROM info:\n");
+		pr_info("\tmicrocode start address = 0x%04x, boot configuration = 0x%02x\n",
 			    mc_start, data[2]);
 		/*
 		 * boot configuration (address 0x0002):
@@ -729,7 +730,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		err = em28xx_i2c_read_block(dev, bus, mc_start + 46, 1, 2,
 					    data);
 		if (err != 2) {
-			em28xx_errdev("failed to read hardware configuration data from eeprom (err=%d)\n",
+			pr_err("failed to read hardware configuration data from eeprom (err=%d)\n",
 				      err);
 			goto error;
 		}
@@ -747,7 +748,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		err = em28xx_i2c_read_block(dev, bus, hwconf_offset, 1, len,
 					    data);
 		if (err != len) {
-			em28xx_errdev("failed to read hardware configuration data from eeprom (err=%d)\n",
+			pr_err("failed to read hardware configuration data from eeprom (err=%d)\n",
 				      err);
 			goto error;
 		}
@@ -756,7 +757,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		/* NOTE: not all devices provide this type of dataset */
 		if (data[0] != 0x1a || data[1] != 0xeb ||
 		    data[2] != 0x67 || data[3] != 0x95) {
-			em28xx_info("\tno hardware configuration dataset found in eeprom\n");
+			pr_info("\tno hardware configuration dataset found in eeprom\n");
 			kfree(data);
 			return 0;
 		}
@@ -767,11 +768,11 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		   data[0] == 0x1a && data[1] == 0xeb &&
 		   data[2] == 0x67 && data[3] == 0x95) {
 		dev->hash = em28xx_hash_mem(data, len, 32);
-		em28xx_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
+		pr_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
 			    data[0], data[1], data[2], data[3], dev->hash);
-		em28xx_info("EEPROM info:\n");
+		pr_info("EEPROM info:\n");
 	} else {
-		em28xx_info("unknown eeprom format or eeprom corrupted !\n");
+		pr_info("unknown eeprom format or eeprom corrupted !\n");
 		err = -ENODEV;
 		goto error;
 	}
@@ -782,46 +783,46 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 
 	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
 	case 0:
-		em28xx_info("\tNo audio on board.\n");
+		pr_info("\tNo audio on board.\n");
 		break;
 	case 1:
-		em28xx_info("\tAC97 audio (5 sample rates)\n");
+		pr_info("\tAC97 audio (5 sample rates)\n");
 		break;
 	case 2:
 		if (dev->chip_id < CHIP_ID_EM2860)
-			em28xx_info("\tI2S audio, sample rate=32k\n");
+			pr_info("\tI2S audio, sample rate=32k\n");
 		else
-			em28xx_info("\tI2S audio, 3 sample rates\n");
+			pr_info("\tI2S audio, 3 sample rates\n");
 		break;
 	case 3:
 		if (dev->chip_id < CHIP_ID_EM2860)
-			em28xx_info("\tI2S audio, 3 sample rates\n");
+			pr_info("\tI2S audio, 3 sample rates\n");
 		else
-			em28xx_info("\tI2S audio, 5 sample rates\n");
+			pr_info("\tI2S audio, 5 sample rates\n");
 		break;
 	}
 
 	if (le16_to_cpu(dev_config->chip_conf) & 1 << 3)
-		em28xx_info("\tUSB Remote wakeup capable\n");
+		pr_info("\tUSB Remote wakeup capable\n");
 
 	if (le16_to_cpu(dev_config->chip_conf) & 1 << 2)
-		em28xx_info("\tUSB Self power capable\n");
+		pr_info("\tUSB Self power capable\n");
 
 	switch (le16_to_cpu(dev_config->chip_conf) & 0x3) {
 	case 0:
-		em28xx_info("\t500mA max power\n");
+		pr_info("\t500mA max power\n");
 		break;
 	case 1:
-		em28xx_info("\t400mA max power\n");
+		pr_info("\t400mA max power\n");
 		break;
 	case 2:
-		em28xx_info("\t300mA max power\n");
+		pr_info("\t300mA max power\n");
 		break;
 	case 3:
-		em28xx_info("\t200mA max power\n");
+		pr_info("\t200mA max power\n");
 		break;
 	}
-	em28xx_info("\tTable at offset 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
+	pr_info("\tTable at offset 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
 		    dev_config->string_idx_table,
 		    le16_to_cpu(dev_config->string1),
 		    le16_to_cpu(dev_config->string2),
@@ -914,7 +915,7 @@ void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus)
 		if (rc < 0)
 			continue;
 		i2c_devicelist[i] = i;
-		em28xx_info("found i2c device @ 0x%x on bus %d [%s]\n",
+		pr_info("found i2c device @ 0x%x on bus %d [%s]\n",
 			    i << 1, bus, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 
@@ -949,7 +950,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 
 	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
 	if (retval < 0) {
-		em28xx_errdev("%s: i2c_add_adapter failed! retval [%d]\n",
+		pr_err("%s: i2c_add_adapter failed! retval [%d]\n",
 			      __func__, retval);
 		return retval;
 	}
@@ -961,7 +962,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 	if (!bus) {
 		retval = em28xx_i2c_eeprom(dev, bus, &dev->eedata, &dev->eedata_len);
 		if ((retval < 0) && (retval != -ENODEV)) {
-			em28xx_errdev("%s: em28xx_i2_eeprom failed! retval [%d]\n",
+			pr_err("%s: em28xx_i2_eeprom failed! retval [%d]\n",
 				      __func__, retval);
 
 			return retval;
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 580f3853505d..e8e1f768d45e 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -21,6 +21,8 @@
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include "em28xx.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -29,8 +31,6 @@
 #include <linux/slab.h>
 #include <linux/bitrev.h>
 
-#include "em28xx.h"
-
 #define EM28XX_SNAPSHOT_KEY				KEY_CAMERA
 #define EM28XX_BUTTONS_DEBOUNCED_QUERY_INTERVAL		500 /* [ms] */
 #define EM28XX_BUTTONS_VOLATILE_QUERY_INTERVAL		100 /* [ms] */
@@ -567,7 +567,7 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
 	struct input_dev *input_dev;
 	int err;
 
-	em28xx_info("Registering snapshot button...\n");
+	pr_info("Registering snapshot button...\n");
 	input_dev = input_allocate_device();
 	if (!input_dev)
 		return -ENOMEM;
@@ -591,7 +591,7 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
 
 	err = input_register_device(input_dev);
 	if (err) {
-		em28xx_errdev("input_register_device failed\n");
+		pr_err("input_register_device failed\n");
 		input_free_device(input_dev);
 		return err;
 	}
@@ -631,7 +631,7 @@ static void em28xx_init_buttons(struct em28xx *dev)
 		} else if (button->role == EM28XX_BUTTON_ILLUMINATION) {
 			/* Check sanity */
 			if (!em28xx_find_led(dev, EM28XX_LED_ILLUMINATION)) {
-				em28xx_errdev("BUG: illumination button defined, but no illumination LED.\n");
+				pr_err("BUG: illumination button defined, but no illumination LED.\n");
 				goto next_button;
 			}
 		}
@@ -667,7 +667,7 @@ static void em28xx_shutdown_buttons(struct em28xx *dev)
 	dev->num_button_polling_addresses = 0;
 	/* Deregister input devices */
 	if (dev->sbutton_input_dev != NULL) {
-		em28xx_info("Deregistering snapshot button\n");
+		pr_info("Deregistering snapshot button\n");
 		input_unregister_device(dev->sbutton_input_dev);
 		dev->sbutton_input_dev = NULL;
 	}
@@ -696,18 +696,18 @@ static int em28xx_ir_init(struct em28xx *dev)
 		i2c_rc_dev_addr = em28xx_probe_i2c_ir(dev);
 		if (!i2c_rc_dev_addr) {
 			dev->board.has_ir_i2c = 0;
-			em28xx_warn("No i2c IR remote control device found.\n");
+			pr_warn("No i2c IR remote control device found.\n");
 			return -ENODEV;
 		}
 	}
 
 	if (dev->board.ir_codes == NULL && !dev->board.has_ir_i2c) {
 		/* No remote control support */
-		em28xx_warn("Remote control support is not available for this card.\n");
+		pr_warn("Remote control support is not available for this card.\n");
 		return 0;
 	}
 
-	em28xx_info("Registering input extension\n");
+	pr_info("Registering input extension\n");
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	if (!ir)
@@ -810,7 +810,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	if (err)
 		goto error;
 
-	em28xx_info("Input extension successfully initalized\n");
+	pr_info("Input extension successfully initalized\n");
 
 	return 0;
 
@@ -831,7 +831,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
 		return 0;
 	}
 
-	em28xx_info("Closing input extension\n");
+	pr_info("Closing input extension\n");
 
 	em28xx_shutdown_buttons(dev);
 
@@ -860,7 +860,7 @@ static int em28xx_ir_suspend(struct em28xx *dev)
 	if (dev->is_audio_only)
 		return 0;
 
-	em28xx_info("Suspending input extension\n");
+	pr_info("Suspending input extension\n");
 	if (ir)
 		cancel_delayed_work_sync(&ir->work);
 	cancel_delayed_work_sync(&dev->buttons_query_work);
@@ -877,7 +877,7 @@ static int em28xx_ir_resume(struct em28xx *dev)
 	if (dev->is_audio_only)
 		return 0;
 
-	em28xx_info("Resuming input extension\n");
+	pr_info("Resuming input extension\n");
 	/* if suspend calls ir_raw_event_unregister(), the should call
 	   ir_raw_event_register() */
 	if (ir)
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 119877bb8a1e..3efabc19bfe9 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -26,6 +26,8 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "em28xx.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -37,7 +39,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 
-#include "em28xx.h"
 #include "em28xx-v4l.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
@@ -413,7 +414,7 @@ static int em28xx_set_alternate(struct em28xx *dev)
 			dev->alt, dev->max_pkt_size);
 	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
 	if (errCode < 0) {
-		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
+		pr_err("cannot change alternate number to %d (error=%i)\n",
 			      dev->alt, errCode);
 		return errCode;
 	}
@@ -2047,7 +2048,7 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	ret = v4l2_fh_open(filp);
 	if (ret) {
-		em28xx_errdev("%s: v4l2_fh_open() returned error %d\n",
+		pr_err("%s: v4l2_fh_open() returned error %d\n",
 			      __func__, ret);
 		mutex_unlock(&dev->lock);
 		return ret;
@@ -2102,7 +2103,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (v4l2 == NULL)
 		return 0;
 
-	em28xx_info("Closing video extension\n");
+	pr_info("Closing video extension\n");
 
 	mutex_lock(&dev->lock);
 
@@ -2113,17 +2114,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	em28xx_v4l2_media_release(dev);
 
 	if (video_is_registered(&v4l2->radio_dev)) {
-		em28xx_info("V4L2 device %s deregistered\n",
+		pr_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(&v4l2->radio_dev));
 		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
-		em28xx_info("V4L2 device %s deregistered\n",
+		pr_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(&v4l2->vbi_dev));
 		video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
-		em28xx_info("V4L2 device %s deregistered\n",
+		pr_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(&v4l2->vdev));
 		video_unregister_device(&v4l2->vdev);
 	}
@@ -2153,7 +2154,7 @@ static int em28xx_v4l2_suspend(struct em28xx *dev)
 	if (!dev->has_video)
 		return 0;
 
-	em28xx_info("Suspending video extension\n");
+	pr_info("Suspending video extension\n");
 	em28xx_stop_urbs(dev);
 	return 0;
 }
@@ -2166,7 +2167,7 @@ static int em28xx_v4l2_resume(struct em28xx *dev)
 	if (!dev->has_video)
 		return 0;
 
-	em28xx_info("Resuming video extension\n");
+	pr_info("Resuming video extension\n");
 	/* what do we do here */
 	return 0;
 }
@@ -2203,7 +2204,8 @@ static int em28xx_v4l2_close(struct file *filp)
 		em28xx_videodbg("setting alternate 0\n");
 		errCode = usb_set_interface(dev->udev, 0, 0);
 		if (errCode < 0) {
-			em28xx_errdev("cannot change alternate number to 0 (error=%i)\n", errCode);
+			pr_err("cannot change alternate number to 0 (error=%i)\n",
+			       errCode);
 		}
 	}
 
@@ -2420,13 +2422,12 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		return 0;
 	}
 
-	em28xx_info("Registering V4L2 extension\n");
+	pr_info("Registering V4L2 extension\n");
 
 	mutex_lock(&dev->lock);
 
 	v4l2 = kzalloc(sizeof(struct em28xx_v4l2), GFP_KERNEL);
-	if (v4l2 == NULL) {
-		em28xx_info("em28xx_v4l: memory allocation failed\n");
+	if (!v4l2) {
 		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
@@ -2439,7 +2440,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 #endif
 	ret = v4l2_device_register(&dev->udev->dev, &v4l2->v4l2_dev);
 	if (ret < 0) {
-		em28xx_errdev("Call to v4l2_device_register() failed!\n");
+		pr_err("Call to v4l2_device_register() failed!\n");
 		goto err;
 	}
 
@@ -2523,7 +2524,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Configure audio */
 	ret = em28xx_audio_setup(dev);
 	if (ret < 0) {
-		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
+		pr_err("%s: Error while setting audio - error [%d]!\n",
 			      __func__, ret);
 		goto unregister_dev;
 	}
@@ -2551,7 +2552,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		/* Send a reset to other chips via gpio */
 		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
 		if (ret < 0) {
-			em28xx_errdev("%s: em28xx_write_reg - msp34xx(1) failed! error [%d]\n",
+			pr_err("%s: em28xx_write_reg - msp34xx(1) failed! error [%d]\n",
 				      __func__, ret);
 			goto unregister_dev;
 		}
@@ -2559,7 +2560,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
 		if (ret < 0) {
-			em28xx_errdev("%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
+			pr_err("%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
 				      __func__, ret);
 			goto unregister_dev;
 		}
@@ -2661,7 +2662,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	ret = video_register_device(&v4l2->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
 	if (ret) {
-		em28xx_errdev("unable to register video device (error=%i).\n",
+		pr_err("unable to register video device (error=%i).\n",
 			      ret);
 		goto unregister_dev;
 	}
@@ -2691,7 +2692,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		ret = video_register_device(&v4l2->vbi_dev, VFL_TYPE_VBI,
 					    vbi_nr[dev->devno]);
 		if (ret < 0) {
-			em28xx_errdev("unable to register vbi device\n");
+			pr_err("unable to register vbi device\n");
 			goto unregister_dev;
 		}
 	}
@@ -2702,10 +2703,10 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		ret = video_register_device(&v4l2->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
-			em28xx_errdev("can't register radio device\n");
+			pr_err("can't register radio device\n");
 			goto unregister_dev;
 		}
-		em28xx_info("Registered radio device as %s\n",
+		pr_info("Registered radio device as %s\n",
 			    video_device_node_name(&v4l2->radio_dev));
 	}
 
@@ -2715,17 +2716,17 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_mc_create_media_graph(dev->media_dev);
 	if (ret) {
-		em28xx_errdev("failed to create media graph\n");
+		pr_err("failed to create media graph\n");
 		em28xx_v4l2_media_release(dev);
 		goto unregister_dev;
 	}
 #endif
 
-	em28xx_info("V4L2 video device registered as %s\n",
+	pr_info("V4L2 video device registered as %s\n",
 		    video_device_node_name(&v4l2->vdev));
 
 	if (video_is_registered(&v4l2->vbi_dev))
-		em28xx_info("V4L2 VBI device registered as %s\n",
+		pr_info("V4L2 VBI device registered as %s\n",
 			    video_device_node_name(&v4l2->vbi_dev));
 
 	/* Save some power by putting tuner to sleep */
@@ -2734,7 +2735,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* initialize videobuf2 stuff */
 	em28xx_vb2_setup(dev);
 
-	em28xx_info("V4L2 extension successfully initialized\n");
+	pr_info("V4L2 extension successfully initialized\n");
 
 	kref_get(&dev->ref);
 
@@ -2743,17 +2744,17 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 unregister_dev:
 	if (video_is_registered(&v4l2->radio_dev)) {
-		em28xx_info("V4L2 device %s deregistered\n",
+		pr_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(&v4l2->radio_dev));
 		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
-		em28xx_info("V4L2 device %s deregistered\n",
+		pr_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(&v4l2->vbi_dev));
 		video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
-		em28xx_info("V4L2 device %s deregistered\n",
+		pr_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(&v4l2->vdev));
 		video_unregister_device(&v4l2->vdev);
 	}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index d148463b22c1..0f6830f5078b 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -29,6 +29,8 @@
 #define EM28XX_VERSION "0.2.2"
 #define DRIVER_DESC    "Empia em28xx device driver"
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/workqueue.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
@@ -797,20 +799,4 @@ void em28xx_free_device(struct kref *ref);
 int em28xx_detect_sensor(struct em28xx *dev);
 int em28xx_init_camera(struct em28xx *dev);
 
-/* printk macros */
-
-#define em28xx_err(fmt, arg...) do {\
-	printk(KERN_ERR fmt , ##arg); } while (0)
-
-#define em28xx_errdev(fmt, arg...) do {\
-	printk(KERN_ERR "%s: "fmt,\
-			dev->name , ##arg); } while (0)
-
-#define em28xx_info(fmt, arg...) do {\
-	printk(KERN_INFO "%s: "fmt,\
-			dev->name , ##arg); } while (0)
-#define em28xx_warn(fmt, arg...) do {\
-	printk(KERN_WARNING "%s: "fmt,\
-			dev->name , ##arg); } while (0)
-
 #endif
-- 
2.7.4


