Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60296 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaBHGPB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 01:15:01 -0500
Received: by mail-ee0-f42.google.com with SMTP id b15so1907302eek.29
        for <linux-media@vger.kernel.org>; Fri, 07 Feb 2014 22:14:59 -0800 (PST)
Received: from [192.168.1.100] ([188.24.81.114])
        by mx.google.com with ESMTPSA id s46sm24983677eeb.0.2014.02.07.22.14.58
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 07 Feb 2014 22:14:58 -0800 (PST)
Message-ID: <52F5CB61.3000206@gmail.com>
Date: Sat, 08 Feb 2014 08:14:57 +0200
From: GEORGE <geoubuntu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7134: Add support for Snazio TvPVR PRO
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: POJAR GEORGE <geoubuntu <at> gmail.com>
Date: Fri, 7 Feb 2014 21:34:41 +0200
Subject: [PATCH] saa7134: Add support for Snazio TvPVR PRO

Signed-off-by: POJAR GEORGE <geoubuntu <at> gmail.com>
---

diff -ruN a/drivers/media/pci/saa7134/saa7134-cards.c 
b/drivers/media/pci/saa7134/saa7134-cards.c
--- a/drivers/media/pci/saa7134/saa7134-cards.c    2013-04-09 
06:45:51.000000000 +0300
+++ b/drivers/media/pci/saa7134/saa7134-cards.c    2014-02-08 
06:25:21.604675000 +0200
@@ -5827,7 +5827,37 @@
              .gpio = 0x0000800,
          },
      },
-
+    [SAA7134_BOARD_SNAZIO_TVPVR_PRO] = {
+        .name           = "SnaZio TvPVR PRO",
+        .audio_clock    = 0x00187de7,
+        .tuner_type     = TUNER_PHILIPS_TDA8290,
+        .radio_type     = UNSET,
+        .tuner_addr     = ADDR_UNSET,
+        .radio_addr     = ADDR_UNSET,
+        .gpiomask       = 1 << 21,
+        .inputs         = {{
+            .name = name_tv,
+            .vmux = 1,
+            .amux = TV,
+            .gpio = 0x0000000,
+            .tv   = 1,
+        },{
+            .name = name_comp1,     /* Composite input */
+            .vmux = 3,
+            .amux = LINE2,
+            .gpio = 0x0000000,
+        },{
+            .name = name_svideo,    /* S-Video input */
+            .vmux = 8,
+            .amux = LINE2,
+            .gpio = 0x0000000,
+        }},
+        .radio = {
+            .name = name_radio,
+            .amux = TV,
+            .gpio = 0x0200000,
+        },
+    },
  };

  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -7080,6 +7110,24 @@
          .subdevice    = 0x2055, /* AverTV Satellite Hybrid+FM A706 */
          .driver_data  = SAA7134_BOARD_AVERMEDIA_A706,
      }, {
+        .vendor       = PCI_VENDOR_ID_PHILIPS,
+        .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+        .subvendor    = 0x1779,
+        .subdevice    = 0x13cf,
+        .driver_data  = SAA7134_BOARD_SNAZIO_TVPVR_PRO,
+    }, {
+        .vendor       = PCI_VENDOR_ID_PHILIPS,
+        .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+        .subvendor    = 0x1779,
+        .subdevice    = 0x13d0,
+        .driver_data  = SAA7134_BOARD_SNAZIO_TVPVR_PRO,
+    }, {
+        .vendor       = PCI_VENDOR_ID_PHILIPS,
+        .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+        .subvendor    = 0x1779,
+        .subdevice    = 0x13d1,
+        .driver_data  = SAA7134_BOARD_SNAZIO_TVPVR_PRO,
+    }, {
          /* --- boards without eeprom + subsystem ID --- */
          .vendor       = PCI_VENDOR_ID_PHILIPS,
          .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7608,6 +7656,7 @@
      case SAA7134_BOARD_BEHOLD_H7:
      case SAA7134_BOARD_BEHOLD_A7:
      case SAA7134_BOARD_KWORLD_PC150U:
+    case SAA7134_BOARD_SNAZIO_TVPVR_PRO:
          dev->has_remote = SAA7134_REMOTE_I2C;
          break;
      case SAA7134_BOARD_AVERMEDIA_A169_B:
diff -ruN a/drivers/media/pci/saa7134/saa7134.h 
b/drivers/media/pci/saa7134/saa7134.h
--- a/drivers/media/pci/saa7134/saa7134.h    2014-01-08 
06:45:52.000000000 +0200
+++ b/drivers/media/pci/saa7134/saa7134.h    2014-02-08 
06:18:58.816686000 +0200
@@ -338,6 +338,7 @@
  #define SAA7134_BOARD_ASUSTeK_PS3_100      190
  #define SAA7134_BOARD_HAWELL_HW_9004V1      191
  #define SAA7134_BOARD_AVERMEDIA_A706        192
+#define SAA7134_BOARD_SNAZIO_TVPVR_PRO      193

  #define SAA7134_MAXBOARDS 32
  #define SAA7134_INPUT_MAX 8
diff -ruN a/drivers/media/pci/saa7134/saa7134-input.c 
b/drivers/media/pci/saa7134/saa7134-input.c
--- a/drivers/media/pci/saa7134/saa7134-input.c    2013-04-09 
06:45:51.000000000 +0300
+++ b/drivers/media/pci/saa7134/saa7134-input.c    2014-02-08 
07:39:22.560543000 +0200
@@ -258,6 +258,54 @@
      return 1;
  }

+/* copied and modified from get_key_msi_tvanywhere_plus() */
+static int get_key_snazio_tvpvr_pro(struct IR_i2c *ir, u32 *ir_key,
+                       u32 *ir_raw)
+{
+    unsigned char b;
+    int gpio;
+
+    /* <dev> is needed to access GPIO. Used by the saa_readl macro. */
+    struct saa7134_dev *dev = ir->c->adapter->algo_data;
+    if (dev == NULL) {
+        i2cdprintk("get_key_snazio_tvpvr_pro: "
+               "ir->c->adapter->algo_data is NULL!\n");
+        return -EIO;
+    }
+
+    /* rising SAA7134_GPIO_GPRESCAN reads the status */
+
+    saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+    saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+
+    gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
+
+    /* GPIO&0x40 is pulsed low when a button is pressed. Don't do
+       I2C receive if gpio&0x40 is not low. */
+
+    if (gpio & 0x40)
+        return 0;       /* No button press */
+
+    /* GPIO says there is a button press. Get it. */
+
+    if (1 != i2c_master_recv(ir->c, &b, 1)) {
+        i2cdprintk("read error\n");
+        return -EIO;
+    }
+
+    /* No button press */
+
+    if (b == 0xff)
+        return 0;
+
+    /* Button pressed */
+
+    dprintk("get_key_snazio_tvpvr_pro: Key = 0x%02X\n", b);
+    *ir_key = b;
+    *ir_raw = b;
+    return 1;
+}
+
  static int get_key_purpletv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
  {
      unsigned char b;
@@ -1006,6 +1054,22 @@
          dev->init_data.ir_codes = RC_MAP_FLYDVB;
          info.addr = 0x0b;
          break;
+    case SAA7134_BOARD_SNAZIO_TVPVR_PRO:
+        /* copied and modified from MSI TV@nywhere Plus */
+        dev->init_data.name = "SnaZio TvPVR PRO";
+        dev->init_data.get_key = get_key_snazio_tvpvr_pro;
+        dev->init_data.ir_codes = RC_MAP_SNAZIO_TVPVR_PRO;
+        dev->init_data.polling_interval = 50;
+        info.addr = 0x30;
+        /* MSI TV@nywhere Plus controller doesn't seem to
+           respond to probes unless we read something from
+           an existing device. Weird...
+           REVISIT: might no longer be needed */
+        rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
+        dprintk("probe 0x%02x @ %s: %s\n",
+            msg_msi.addr, dev->i2c_adap.name,
+            (1 == rc) ? "yes" : "no");
+        break;
      default:
          dprintk("No I2C IR support for board %x\n", dev->board);
          return;
diff -ruN a/drivers/media/rc/keymaps/Makefile 
b/drivers/media/rc/keymaps/Makefile
--- a/drivers/media/rc/keymaps/Makefile    2013-12-11 06:45:50.000000000 
+0200
+++ b/drivers/media/rc/keymaps/Makefile    2014-02-08 06:01:00.552718000 
+0200
@@ -81,6 +81,7 @@
              rc-real-audio-220-32-keys.o \
              rc-reddo.o \
              rc-snapstream-firefly.o \
+            rc-snazio-tvpvr-pro.o \
              rc-streamzap.o \
              rc-tbs-nec.o \
              rc-technisat-usb2.o \
diff -ruN a/drivers/media/rc/keymaps/rc-snazio-tvpvr-pro.c 
b/drivers/media/rc/keymaps/rc-snazio-tvpvr-pro.c
--- a/drivers/media/rc/keymaps/rc-snazio-tvpvr-pro.c    1970-01-01 
02:00:00.000000000 +0200
+++ b/drivers/media/rc/keymaps/rc-snazio-tvpvr-pro.c    2014-02-08 
06:00:28.292719000 +0200
@@ -0,0 +1,111 @@
+/* msi-tvanywhere-plus.h - Keytable for msi_tvanywhere_plus Remote 
Controller
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+/*
+  Keycodes for remote on the SnaZio TvPVR PRO.
+  POJAR GEORGE <geoubuntu@gmail.com>
+*/
+
+static struct rc_map_table snazio_tvpvr_pro[] = {
+
+/*  ---- Remote Button Layout ----
+
+    POWER   SOURCE  SCAN    MUTE
+    TV/FM   1       2       3
+    |>      4       5       6
+    <|      7       8       9
+    ^^UP    0       +       RECALL
+    vvDN    RECORD  STOP    PLAY
+
+    MINIMIZE          ZOOM
+
+          CH+
+      VOL-                   VOL+
+          CH-
+
+    SNAPSHOT           MTS
+
+     <<      FUNC    >>     RESET
+*/
+
+    { 0x01, KEY_1 },        /* 1 */
+    { 0x0b, KEY_2 },        /* 2 */
+    { 0x1b, KEY_3 },        /* 3 */
+    { 0x05, KEY_4 },        /* 4 */
+    { 0x09, KEY_5 },        /* 5 */
+    { 0x15, KEY_6 },        /* 6 */
+    { 0x06, KEY_7 },        /* 7 */
+    { 0x0a, KEY_8 },        /* 8 */
+    { 0x12, KEY_9 },        /* 9 */
+    { 0x02, KEY_0 },        /* 0 */
+    { 0x10, KEY_KPPLUS },        /* + */
+    { 0x13, KEY_AGAIN },        /* Recall */
+
+    { 0x1e, KEY_POWER },        /* Power */
+    { 0x07, KEY_VIDEO },        /* Source */
+    { 0x1c, KEY_SEARCH },        /* Scan */
+    { 0x18, KEY_MUTE },        /* Mute */
+
+    { 0x03, KEY_RADIO },        /* TV/FM */
+
+    { 0x3f, KEY_RIGHT },        /* |> and Ch+ */
+    { 0x37, KEY_LEFT },        /* <| and Ch- */
+    { 0x2c, KEY_UP },        /* ^^Up and >> */
+    { 0x24, KEY_DOWN },        /* vvDn and << */
+
+    { 0x00, KEY_RECORD },        /* Record */
+    { 0x08, KEY_STOP },        /* Stop */
+    { 0x11, KEY_PLAY },        /* Play */
+
+    { 0x0f, KEY_CLOSE },        /* Minimize */
+    { 0x19, KEY_ZOOM },        /* Zoom */
+    { 0x1a, KEY_CAMERA },        /* Snapshot */
+    { 0x0d, KEY_LANGUAGE },        /* MTS */
+
+    { 0x14, KEY_VOLUMEDOWN },    /* Vol- */
+    { 0x16, KEY_VOLUMEUP },        /* Vol+ */
+    { 0x17, KEY_CHANNELDOWN },    /* Ch- */
+    { 0x1f, KEY_CHANNELUP },    /* Ch+ */
+
+    { 0x04, KEY_REWIND },        /* << */
+    { 0x0e, KEY_MENU },        /* Function */
+    { 0x0c, KEY_FASTFORWARD },    /* >> */
+    { 0x1d, KEY_RESTART },        /* Reset */
+};
+
+static struct rc_map_list snazio_tvpvr_pro_map = {
+    .map = {
+        .scan    = snazio_tvpvr_pro,
+        .size    = ARRAY_SIZE(snazio_tvpvr_pro),
+        .rc_type = RC_TYPE_UNKNOWN,
+        .name    = RC_MAP_SNAZIO_TVPVR_PRO,
+    }
+};
+
+static int __init init_rc_map_snazio_tvpvr_pro(void)
+{
+    return rc_map_register(&snazio_tvpvr_pro_map);
+}
+
+static void __exit exit_rc_map_snazio_tvpvr_pro(void)
+{
+    rc_map_unregister(&snazio_tvpvr_pro_map);
+}
+
+module_init(init_rc_map_snazio_tvpvr_pro)
+module_exit(exit_rc_map_snazio_tvpvr_pro)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("POJAR GEORGE <geoubuntu@gmail.com>");
diff -ruN a/include/media/rc-map.h b/include/media/rc-map.h
--- a/include/media/rc-map.h    2014-02-08 06:45:59.000000000 +0200
+++ b/include/media/rc-map.h    2014-02-08 06:08:47.896704000 +0200
@@ -177,6 +177,7 @@
  #define RC_MAP_REAL_AUDIO_220_32_KEYS "rc-real-audio-220-32-keys"
  #define RC_MAP_REDDO                     "rc-reddo"
  #define RC_MAP_SNAPSTREAM_FIREFLY        "rc-snapstream-firefly"
+#define RC_MAP_SNAZIO_TVPVR_PRO          "rc-snazio-tvpvr-pro"
  #define RC_MAP_STREAMZAP                 "rc-streamzap"
  #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
  #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"
