Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:19876 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0EZEvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 00:51:46 -0400
Received: by fg-out-1718.google.com with SMTP id e12so615426fga.1
        for <linux-media@vger.kernel.org>; Tue, 25 May 2010 21:51:45 -0700 (PDT)
Date: Wed, 26 May 2010 14:52:19 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bee Hock Goh <beehock@gmail.com>
Subject: tm6000, alsa
Message-ID: <20100526145219.11c81de0@glory.loctelecom.ru>
In-Reply-To: <20100518172329.6d9b520a@glory.loctelecom.ru>
References: <20100518172329.6d9b520a@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/uaCWLF59XnFUZqcH6d=AYGX"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/uaCWLF59XnFUZqcH6d=AYGX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi 

Patches for review.
Add new data structure list_head for many tm6000 cards.
Rework tm6000-alsa.
Comment some old code befor remove.

Now tm6000-alsa not load when tm6000 start. Need load tm6000-alsa manualy

[  210.777562] tm6000: New video device @ 480 Mbps (6000:dec0, ifnum 0)
[  210.777566] tm6000: Found Beholder Wander DVB-T/TV/FM USB2.0
[  211.700009] Board version = 0x67980bf4
[  211.900011] board=0x67980bf4
[  212.024512] tm6000 #0: i2c eeprom 00: 42 59 54 45 12 01 00 02 00 00 00 40 00 60 c0 de  BYTE.......@.`..
[  212.216012] tm6000 #0: i2c eeprom 10: 01 00 10 20 40 01 28 03 42 00 65 00 68 00 6f 00  ... @.(.B.e.h.o.
[  212.408012] tm6000 #0: i2c eeprom 20: 6c 00 64 00 65 00 72 00 20 00 49 00 6e 00 74 00  l.d.e.r. .I.n.t.
[  212.600012] tm6000 #0: i2c eeprom 30: 6c 00 2e 00 20 00 4c 00 74 00 64 00 2e 00 ff ff  l... .L.t.d.....
[  212.792012] tm6000 #0: i2c eeprom 40: 22 03 42 00 65 00 68 00 6f 00 6c 00 64 00 20 00  ".B.e.h.o.l.d. .
[  212.984012] tm6000 #0: i2c eeprom 50: 54 00 56 00 20 00 57 00 61 00 6e 00 64 00 65 00  T.V. .W.a.n.d.e.
[  213.176011] tm6000 #0: i2c eeprom 60: 72 00 ff ff ff ff ff ff ff ff 1a 03 56 00 69 00  r...........V.i.
[  213.368012] tm6000 #0: i2c eeprom 70: 64 00 65 00 6f 00 43 00 61 00 70 00 74 00 75 00  d.e.o.C.a.p.t.u.
[  213.560012] tm6000 #0: i2c eeprom 80: 72 00 65 00 ff ff ff ff ff ff ff ff ff ff ff ff  r.e.............
[  213.752012] tm6000 #0: i2c eeprom 90: ff ff ff ff 16 03 30 00 30 00 30 00 30 00 30 00  ......0.0.0.0.0.
[  213.944011] tm6000 #0: i2c eeprom a0: 30 00 32 00 30 00 34 00 31 00 ff ff ff ff ff ff  0.2.0.4.1.......
[  214.136009] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  214.328012] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  214.520014] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  214.712012] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  214.904012] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  215.084013]   ................
[  215.104890] tuner 1-0061: chip found @ 0xc2 (tm6000 #0)
[  215.160471] xc5000 1-0061: creating new instance
[  215.216511] xc5000: Successfully identified at address 0x61
[  215.216515] xc5000: Firmware has not been loaded previously
[  215.216522] tuner 1-0061: Tuner frontend module has no way to set config
[  215.328012] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  215.328019] usb 1-1: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[  215.365986] xc5000: firmware read 12401 bytes.
[  215.365989] xc5000: firmware uploading...
[  227.128008] xc5000: firmware upload complete...
[  229.036083] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: 0)
[  229.036114] usbcore: registered new interface driver tm6000
[  229.052288] tm6000: open called (dev=video0)
[  230.484571] Original value=255

load tm6000-alsa manualy
[  259.141425] tm6000 ALSA driver for DMA sound loaded

unload tm6000-alsa
[  309.364210] tm6000 ALSA driver for DMA sound unloaded

load tm6000-alsa manualy
[  320.118131] tm6000 ALSA driver for DMA sound loaded

ALSA devices created
arecord -l

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: ALC883 Digital [ALC883 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 2: ALC883 Analog [ALC883 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: default [], device 0: tm6000 Digital [tm6000 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

If need I can rework this patches or it can be upload to tm6000 tree.

With my best regards, Dmitry.

--MP_/uaCWLF59XnFUZqcH6d=AYGX
Content-Type: text/x-patch; name=tm6000-alsa.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000-alsa.diff

diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000-alsa.c
--- a/linux/drivers/staging/tm6000/tm6000-alsa.c	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-alsa.c	Wed May 26 08:36:16 2010 +1000
@@ -68,6 +68,9 @@
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;       /* ID for this card */
 static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
+
+static struct snd_card *snd_tm6000_cards[SNDRV_CARDS];
+static int devno;
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 10)
 static unsigned int dummy;
@@ -353,7 +356,8 @@
  * Alsa Constructor - Component probe
  */
 
-int tm6000_audio_init(struct tm6000_core *dev, int idx)
+//int tm6000_audio_init(struct tm6000_core *dev, int idx)
+int tm6000_audio_initdev(struct tm6000_core *dev, int idx)
 {
 	struct snd_card         *card;
 	struct snd_tm6000_card  *chip;
@@ -419,6 +423,7 @@
 	if (rc < 0)
 		goto error;
 
+	snd_tm6000_cards[idx] = card;
 
 	return 0;
 
@@ -426,14 +431,49 @@
 	snd_card_free(card);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(tm6000_audio_init);
+//EXPORT_SYMBOL_GPL(tm6000_audio_init);
+#if 1
+static int tm6000_audio_init(void)
+{
+	struct tm6000_core *dev = NULL;
+	struct list_head *list;
 
-#if 0
+//	tm6000_dmasound_init = alsa_device_init;
+//	tm6000_dmasound_exit = alsa_device_exit;
+
+	printk(KERN_INFO "tm6000 ALSA driver for DMA sound loaded\n");
+
+	list_for_each(list,&tm6000_devlist) {
+		dev = list_entry(list, struct tm6000_core, devlist);
+		if (!tm6000_audio_initdev(dev, devno))
+			devno++;
+		else
+			printk(KERN_INFO "tm6000 ALSA: audio init failed\n");
+	}
+
+	if (dev == NULL)
+		printk(KERN_INFO "tm6000 ALSA: no tm6000 cards found\n");
+
+	return 0;
+
+}
+
 /*
  * module remove
  */
 static void tm6000_audio_fini(void)
 {
+	int idx;
+
+	for (idx = 0; idx < devno; idx++) {
+		snd_card_free(snd_tm6000_cards[idx]);
+	}
+
+//	tm6000_dmasound_init = NULL;
+//	tm6000_dmasound_exit = NULL;
+	printk(KERN_INFO "tm6000 ALSA driver for DMA sound unloaded\n");
+
+	return;
 }
 
 module_init(tm6000_audio_init);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/uaCWLF59XnFUZqcH6d=AYGX
Content-Type: text/x-patch; name=tm6000-cards.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000-cards.diff

diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Wed May 26 08:36:41 2010 +1000
@@ -56,6 +56,12 @@
 module_param_array(card,  int, NULL, 0444);
 
 static unsigned long tm6000_devused;
+
+DEFINE_MUTEX(tm6000_devlist_lock);
+EXPORT_SYMBOL(tm6000_devlist_lock);
+LIST_HEAD(tm6000_devlist);
+EXPORT_SYMBOL(tm6000_devlist);
+static LIST_HEAD(mops_list);
 
 #if 0
 /* This will be needed sooner or later, to allow selecting video mux entries */
@@ -723,6 +716,13 @@
 		}
 #endif
 	}
+
+	mutex_lock(&tm6000_devlist_lock);
+//	list_for_each_entry(mops, &mops_list, next)
+//		mpeg_ops_attach(mops, dev);
+	list_add_tail(&dev->devlist, &tm6000_devlist);
+	mutex_unlock(&tm6000_devlist_lock);
+
 	mutex_unlock(&dev->lock);
 	return 0;
 
@@ -957,6 +957,13 @@
 
 	mutex_lock(&dev->lock);
 
+	/* unregister */
+	mutex_lock(&tm6000_devlist_lock);
+	list_del(&dev->devlist);
+//	list_for_each_entry(mops, &mops_list, next)
+//		mpeg_ops_detach(mops, dev);
+	mutex_unlock(&tm6000_devlist_lock);
+
 #ifdef CONFIG_VIDEO_TM6000_DVB
 	if (dev->dvb) {
 		tm6000_dvb_unregister(dev);
@@ -991,6 +998,7 @@
 static int __init tm6000_module_init(void)
 {
 	int result;
+	INIT_LIST_HEAD(&tm6000_devlist);
 
 	printk(KERN_INFO "tm6000" " v4l2 driver version %d.%d.%d loaded\n",
 	       (TM6000_VERSION  >> 16) & 0xff,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/uaCWLF59XnFUZqcH6d=AYGX
Content-Type: text/x-patch; name=tm6000-header.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000-header.diff

diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000.h
--- a/linux/drivers/staging/tm6000/tm6000.h	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000.h	Wed May 26 08:38:12 2010 +1000
@@ -154,6 +154,7 @@
 	int				model;		/* index in the device_data struct */
 	int				devno;		/* marks the number of this device */
 	enum tm6000_devtype		dev_type;	/* type of device */
+	struct list_head		devlist;
 
 	v4l2_std_id                     norm;           /* Current norm */
 	int				width,height;	/* Selected resolution */
@@ -228,6 +229,8 @@
 			V4L2_STD_NTSC_M_JP|V4L2_STD_SECAM
 
 /* In tm6000-cards.c */
+extern struct list_head  tm6000_devlist;
+extern struct mutex tm6000_devlist_lock;
 
 int tm6000_tuner_callback (void *ptr, int component, int command, int arg);
 int tm6000_xc5000_callback (void *ptr, int component, int command, int arg);
@@ -289,7 +294,7 @@
 int tm6000_queue_init(struct tm6000_core *dev);
 
 /* In tm6000-alsa.c */
-int tm6000_audio_init(struct tm6000_core *dev, int idx);
+//int tm6000_audio_init(struct tm6000_core *dev, int idx);
 
 
 /* Debug stuff */

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/uaCWLF59XnFUZqcH6d=AYGX--
