Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50227 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3L1MQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 04/24] em28xx: make em28xx-video to be a separate module
Date: Sat, 28 Dec 2013 10:15:56 -0200
Message-Id: <1388232976-20061-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Now that all analog-specific code are at em28xx-video, convert
it into an em28xx extension and load it as a separate module.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/Kconfig         |  6 ++-
 drivers/media/usb/em28xx/Makefile        |  5 ++-
 drivers/media/usb/em28xx/em28xx-camera.c |  1 +
 drivers/media/usb/em28xx/em28xx-cards.c  | 25 +++--------
 drivers/media/usb/em28xx/em28xx-core.c   | 12 +++++
 drivers/media/usb/em28xx/em28xx-v4l.h    | 24 ++++++++++
 drivers/media/usb/em28xx/em28xx-vbi.c    |  1 +
 drivers/media/usb/em28xx/em28xx-video.c  | 77 ++++++++++++++++++++++----------
 drivers/media/usb/em28xx/em28xx.h        | 23 ++--------
 9 files changed, 110 insertions(+), 64 deletions(-)
 create mode 100644 drivers/media/usb/em28xx/em28xx-v4l.h

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index d6ba514d31eb..838fc9dbb747 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -1,8 +1,12 @@
 config VIDEO_EM28XX
-	tristate "Empia EM28xx USB video capture support"
+	tristate "Empia EM28xx USB devices support"
 	depends on VIDEO_DEV && I2C
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
+
+config VIDEO_EM28XX_V4L2
+	tristate "Empia EM28xx analog TV, video capture and/or webcam support"
+	depends on VIDEO_EM28XX && I2C
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
index ad6d48557940..3f850d5063d0 100644
--- a/drivers/media/usb/em28xx/Makefile
+++ b/drivers/media/usb/em28xx/Makefile
@@ -1,10 +1,11 @@
-em28xx-y +=	em28xx-video.o em28xx-i2c.o em28xx-cards.o
-em28xx-y +=	em28xx-core.o  em28xx-vbi.o em28xx-camera.o
+em28xx-y +=	em28xx-core.o em28xx-i2c.o em28xx-cards.o em28xx-camera.o
 
+em28xx-v4l-objs := em28xx-video.o em28xx-vbi.o
 em28xx-alsa-objs := em28xx-audio.o
 em28xx-rc-objs := em28xx-input.o
 
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx.o
+obj-$(CONFIG_VIDEO_EM28XX_V4L2) += em28xx-v4l.o
 obj-$(CONFIG_VIDEO_EM28XX_ALSA) += em28xx-alsa.o
 obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
 obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index d666741797d4..c29f5c4e7b40 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -454,3 +454,4 @@ int em28xx_init_camera(struct em28xx *dev)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(em28xx_init_camera);
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4a439e5031e6..53dc82409bc2 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2159,6 +2159,8 @@ struct em28xx_board em28xx_boards[] = {
 		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
 };
+EXPORT_SYMBOL_GPL(em28xx_boards);
+
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
 /* table of devices that work with this driver */
@@ -2827,10 +2829,6 @@ static void em28xx_card_setup(struct em28xx *dev)
 				"tuner", dev->tuner_addr, NULL);
 		}
 	}
-
-	em28xx_tuner_setup(dev);
-
-	em28xx_init_camera(dev);
 }
 
 
@@ -2848,11 +2846,12 @@ static void request_module_async(struct work_struct *work)
 	em28xx_init_extension(dev);
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
+	if (dev->has_video)
+		request_module("em28xx-v4l");
 	if (dev->has_audio_class)
 		request_module("snd-usb-audio");
 	else if (dev->has_alsa_audio)
 		request_module("em28xx-alsa");
-
 	if (dev->board.has_dvb)
 		request_module("em28xx-dvb");
 	if (dev->board.buttons ||
@@ -2881,18 +2880,12 @@ void em28xx_release_resources(struct em28xx *dev)
 {
 	/*FIXME: I2C IR should be disconnected */
 
-	em28xx_release_analog_resources(dev);
-
 	if (dev->def_i2c_bus)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
 	if (dev->clk)
 		v4l2_clk_unregister_fixed(dev->clk);
 
-	v4l2_ctrl_handler_free(&dev->ctrl_handler);
-
-	v4l2_device_unregister(&dev->v4l2_dev);
-
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
@@ -3277,6 +3270,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->alt   = -1;
 	dev->is_audio_only = has_audio && !(has_video || has_dvb);
 	dev->has_alsa_audio = has_audio;
+	dev->has_video = has_video;
 	dev->audio_ifnum = ifnum;
 
 	/* Checks if audio is provided by some interface */
@@ -3316,10 +3310,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	/* allocate device struct */
 	mutex_init(&dev->lock);
-	mutex_lock(&dev->lock);
 	retval = em28xx_init_dev(dev, udev, interface, nr);
 	if (retval) {
-		goto unlock_and_free;
+		goto err_free;
 	}
 
 	if (usb_xfer_mode < 0) {
@@ -3362,7 +3355,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		if (retval) {
 			printk(DRIVER_NAME
 			       ": Failed to pre-allocate USB transfer buffers for DVB.\n");
-			goto unlock_and_free;
+			goto err_free;
 		}
 	}
 
@@ -3371,13 +3364,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* Should be the last thing to do, to avoid newer udev's to
 	   open the device before fully initializing it
 	 */
-	mutex_unlock(&dev->lock);
 
 	return 0;
 
-unlock_and_free:
-	mutex_unlock(&dev->lock);
-
 err_free:
 	kfree(dev->alt_max_pkt_size_isoc);
 	kfree(dev);
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 3012912d2997..1113d4e107d8 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -33,6 +33,18 @@
 
 #include "em28xx.h"
 
+#define DRIVER_AUTHOR "Ludovico Cavedon <cavedon@sssup.it>, " \
+		      "Markus Rechberger <mrechberger@gmail.com>, " \
+		      "Mauro Carvalho Chehab <mchehab@infradead.org>, " \
+		      "Sascha Sommer <saschasommer@freenet.de>"
+
+#define DRIVER_DESC         "Empia em28xx based USB core driver"
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(EM28XX_VERSION);
+
 /* #define ENABLE_DEBUG_ISOC_FRAMES */
 
 static unsigned int core_debug;
diff --git a/drivers/media/usb/em28xx/em28xx-v4l.h b/drivers/media/usb/em28xx/em28xx-v4l.h
new file mode 100644
index 000000000000..2cf75a547dbe
--- /dev/null
+++ b/drivers/media/usb/em28xx/em28xx-v4l.h
@@ -0,0 +1,24 @@
+/*
+   em28xx-video.c - driver for Empia EM2800/EM2820/2840 USB
+                    video capture devices
+
+   Copyright (C) 2013 Mauro Carvalho Chehab <m.chehab@samsung.com>
+
+   This program is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation version 2 of the License.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
+int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
+extern struct vb2_ops em28xx_vbi_qops;
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 39f39c527c13..db3d655600df 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 
 #include "em28xx.h"
+#include "em28xx-v4l.h"
 
 static unsigned int vbibufs = 5;
 module_param(vbibufs, int, 0644);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 63f09b62d546..b0b1a3d4534b 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 
 #include "em28xx.h"
+#include "em28xx-v4l.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
@@ -141,11 +142,13 @@ static struct em28xx_fmt format[] = {
 	},
 };
 
+static int em28xx_vbi_supported(struct em28xx *dev);
+
 /*
  * em28xx_wake_i2c()
  * configure i2c attached devices
  */
-void em28xx_wake_i2c(struct em28xx *dev)
+static void em28xx_wake_i2c(struct em28xx *dev)
 {
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
@@ -153,7 +156,7 @@ void em28xx_wake_i2c(struct em28xx *dev)
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
 }
 
-int em28xx_colorlevels_set_default(struct em28xx *dev)
+static int em28xx_colorlevels_set_default(struct em28xx *dev)
 {
 	em28xx_write_reg(dev, EM28XX_R20_YGAIN, CONTRAST_DEFAULT);
 	em28xx_write_reg(dev, EM28XX_R21_YOFFSET, BRIGHTNESS_DEFAULT);
@@ -171,7 +174,7 @@ int em28xx_colorlevels_set_default(struct em28xx *dev)
 	return em28xx_write_reg(dev, EM28XX_R1A_BOFFSET, 0x00);
 }
 
-int em28xx_set_outfmt(struct em28xx *dev)
+static int em28xx_set_outfmt(struct em28xx *dev)
 {
 	int ret;
 	u8 fmt, vinctrl;
@@ -278,7 +281,7 @@ static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
 }
 
 /* FIXME: this only function read values from dev */
-int em28xx_resolution_set(struct em28xx *dev)
+static int em28xx_resolution_set(struct em28xx *dev)
 {
 	int width, height;
 	width = norm_maxw(dev);
@@ -310,7 +313,7 @@ int em28xx_resolution_set(struct em28xx *dev)
 	return em28xx_scaler_set(dev, dev->hscale, dev->vscale);
 }
 
-int em28xx_vbi_supported(struct em28xx *dev)
+static int em28xx_vbi_supported(struct em28xx *dev)
 {
 	/* Modprobe option to manually disable */
 	if (disable_vbi == 1)
@@ -330,7 +333,7 @@ int em28xx_vbi_supported(struct em28xx *dev)
 }
 
 /* Set USB alternate setting for analog video */
-int em28xx_set_alternate(struct em28xx *dev)
+static int em28xx_set_alternate(struct em28xx *dev)
 {
 	int errCode;
 	int i;
@@ -1020,7 +1023,7 @@ static struct vb2_ops em28xx_video_qops = {
 	.wait_finish    = vb2_ops_wait_finish,
 };
 
-int em28xx_vb2_setup(struct em28xx *dev)
+static int em28xx_vb2_setup(struct em28xx *dev)
 {
 	int rc;
 	struct vb2_queue *q;
@@ -1088,7 +1091,7 @@ static void video_mux(struct em28xx *dev, int index)
 	em28xx_audio_analog_set(dev);
 }
 
-void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
+static void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
 {
 	struct em28xx *dev = priv;
 
@@ -1625,7 +1628,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 		reg->val = ret;
 	} else {
 		__le16 val = 0;
-		ret = em28xx_read_reg_req_len(dev, USB_REQ_GET_STATUS,
+		ret = dev->em28xx_read_reg_req_len(dev, USB_REQ_GET_STATUS,
 						   reg->reg, (char *)&val, 2);
 		if (ret < 0)
 			return ret;
@@ -1872,11 +1875,11 @@ static int em28xx_v4l2_open(struct file *filp)
 }
 
 /*
- * em28xx_realease_resources()
+ * em28xx_v4l2_fini()
  * unregisters the v4l2,i2c and usb devices
  * called when the device gets disconected or at module unload
 */
-void em28xx_release_analog_resources(struct em28xx *dev)
+static int em28xx_v4l2_fini(struct em28xx *dev)
 {
 
 	/*FIXME: I2C IR should be disconnected */
@@ -1906,6 +1909,8 @@ void em28xx_release_analog_resources(struct em28xx *dev)
 			video_device_release(dev->vdev);
 		dev->vdev = NULL;
 	}
+
+	return 0;
 }
 
 /*
@@ -1924,16 +1929,18 @@ static int em28xx_v4l2_close(struct file *filp)
 	vb2_fop_release(filp);
 	mutex_lock(&dev->lock);
 
+	if (dev->disconnected) {
+		v4l2_ctrl_handler_free(&dev->ctrl_handler);
+		v4l2_device_unregister(&dev->v4l2_dev);
+
+		kfree(dev->alt_max_pkt_size_isoc);
+		dev->users = 0;
+		goto exit;
+	}
+
 	if (dev->users == 1) {
 		/* the device is already disconnect,
 		   free the remaining resources */
-		if (dev->disconnected) {
-			em28xx_release_resources(dev);
-			kfree(dev->alt_max_pkt_size_isoc);
-			mutex_unlock(&dev->lock);
-			kfree(dev);
-			return 0;
-		}
 
 		/* Save some power by putting tuner to sleep */
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
@@ -1952,6 +1959,7 @@ static int em28xx_v4l2_close(struct file *filp)
 	}
 
 	dev->users--;
+exit:
 	mutex_unlock(&dev->lock);
 	return 0;
 }
@@ -2047,8 +2055,6 @@ static struct video_device em28xx_radio_template = {
 
 /******************************** usb interface ******************************/
 
-
-
 static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 					const struct video_device *template,
 					const char *type_name)
@@ -2122,7 +2128,7 @@ static void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
 	}
 }
 
-void em28xx_tuner_setup(struct em28xx *dev)
+static void em28xx_tuner_setup(struct em28xx *dev)
 {
 	struct tuner_setup           tun_setup;
 	struct v4l2_frequency        f;
@@ -2181,7 +2187,7 @@ void em28xx_tuner_setup(struct em28xx *dev)
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
 }
 
-int em28xx_register_analog_devices(struct em28xx *dev)
+static int em28xx_v4l2_init(struct em28xx *dev)
 {
 	u8 val;
 	int ret;
@@ -2214,6 +2220,10 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
 		       EM28XX_VINCTRL_CCIR656_ENABLE;
 
+        /* Initialize tuner and camera */
+	em28xx_tuner_setup(dev);
+	em28xx_init_camera(dev);
+
 	/* Configure audio */
 	ret = em28xx_audio_setup(dev);
 	if (ret < 0) {
@@ -2424,7 +2434,28 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 
 	/* initialize videobuf2 stuff */
 	em28xx_vb2_setup(dev);
-	return 0;
 
 err:
+	mutex_unlock(&dev->lock);
+	return ret;
+}
+
+static struct em28xx_ops v4l2_ops = {
+	.id   = EM28XX_V4L2,
+	.name = "Em28xx v4l2 Extension",
+	.init = em28xx_v4l2_init,
+	.fini = em28xx_v4l2_fini,
+};
+
+static int __init em28xx_dvb_register(void)
+{
+	return em28xx_register_extension(&v4l2_ops);
 }
+
+static void __exit em28xx_dvb_unregister(void)
+{
+	em28xx_unregister_extension(&v4l2_ops);
+}
+
+module_init(em28xx_dvb_register);
+module_exit(em28xx_dvb_unregister);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7ae05ebc13c1..9d6f43e4681f 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -26,7 +26,7 @@
 #ifndef _EM28XX_H
 #define _EM28XX_H
 
-#define EM28XX_VERSION "0.2.0"
+#define EM28XX_VERSION "0.2.1"
 
 #include <linux/workqueue.h>
 #include <linux/i2c.h>
@@ -474,6 +474,7 @@ struct em28xx_eeprom {
 #define EM28XX_AUDIO   0x10
 #define EM28XX_DVB     0x20
 #define EM28XX_RC      0x30
+#define EM28XX_V4L2    0x40
 
 /* em28xx resource types (used for res_get/res_lock etc */
 #define EM28XX_RESOURCE_VIDEO 0x01
@@ -527,6 +528,7 @@ struct em28xx {
 
 	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
 	unsigned char disconnected:1;	/* device has been diconnected */
+	unsigned int has_video:1;
 	unsigned int has_audio_class:1;
 	unsigned int has_alsa_audio:1;
 	unsigned int is_audio_only:1;
@@ -723,14 +725,9 @@ int em28xx_write_ac97(struct em28xx *dev, u8 reg, u16 val);
 int em28xx_audio_analog_set(struct em28xx *dev);
 int em28xx_audio_setup(struct em28xx *dev);
 
-int em28xx_colorlevels_set_default(struct em28xx *dev);
 const struct em28xx_led *em28xx_find_led(struct em28xx *dev,
 					 enum em28xx_led_role role);
 int em28xx_capture_start(struct em28xx *dev, int start);
-int em28xx_vbi_supported(struct em28xx *dev);
-int em28xx_set_outfmt(struct em28xx *dev);
-int em28xx_resolution_set(struct em28xx *dev);
-int em28xx_set_alternate(struct em28xx *dev);
 int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		      int num_bufs, int max_pkt_size, int packet_multiplier);
 int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
@@ -742,31 +739,17 @@ void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode);
 void em28xx_stop_urbs(struct em28xx *dev);
 int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode);
 int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio);
-void em28xx_wake_i2c(struct em28xx *dev);
 int em28xx_register_extension(struct em28xx_ops *dev);
 void em28xx_unregister_extension(struct em28xx_ops *dev);
 void em28xx_init_extension(struct em28xx *dev);
 void em28xx_close_extension(struct em28xx *dev);
 
-/* Provided by em28xx-video.c */
-void em28xx_tuner_setup(struct em28xx *dev);
-int em28xx_vb2_setup(struct em28xx *dev);
-int em28xx_register_analog_devices(struct em28xx *dev);
-void em28xx_release_analog_resources(struct em28xx *dev);
-void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv);
-int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
-int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
-extern const struct v4l2_ctrl_ops em28xx_ctrl_ops;
-
 /* Provided by em28xx-cards.c */
 extern struct em28xx_board em28xx_boards[];
 extern struct usb_device_id em28xx_id_table[];
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_release_resources(struct em28xx *dev);
 
-/* Provided by em28xx-vbi.c */
-extern struct vb2_ops em28xx_vbi_qops;
-
 /* Provided by em28xx-camera.c */
 int em28xx_detect_sensor(struct em28xx *dev);
 int em28xx_init_camera(struct em28xx *dev);
-- 
1.8.3.1

