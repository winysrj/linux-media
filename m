Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36566 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbcGBJqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 05:46:25 -0400
MIME-Version: 1.0
From: Stephen Backway <stev391@gmail.com>
Date: Sat, 2 Jul 2016 19:46:23 +1000
Message-ID: <CAMMNwaLAA2=vddaaWVRxB-q-SUtccBq+StOJMd-8JZjs=2vW+w@mail.gmail.com>
Subject: [PATCH] cx23885: Add support for Hauppauge WinTV quadHD DVB version
To: linux-media@vger.kernel.org
Cc: stoth@linuxtv.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support fo the Hauppauge WinTV quadHD DVB version.
IR support has not been provided, all 4 tuners, demodulators etc are working.
Further documentation can be found on Linux TV wiki.

Signed-Off-by: Stephen Backway <stev391@gmail.com>

---

diff --git a/Documentation/video4linux/CARDLIST.cx23885
b/Documentation/video4linux/CARDLIST.cx23885
index 85a8fdc..00ba0e5 100644
--- a/Documentation/video4linux/CARDLIST.cx23885
+++ b/Documentation/video4linux/CARDLIST.cx23885
@@ -54,3 +54,4 @@
  53 -> Hauppauge WinTV Starburst                           [0070:c12a]
  54 -> ViewCast 260e                                       [1576:0260]
  55 -> ViewCast 460e                                       [1576:0460]
+ 56 -> Hauppauge WinTV-quadHD (DVB)               [0070:6a28,0070:6b28]
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c
b/drivers/media/pci/cx23885/cx23885-cards.c
index 310ee76..bff1ffbb 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -765,6 +765,11 @@ struct cx23885_board cx23885_boards[] = {
             .amux   = CX25840_AUDIO7,
         } },
     },
+    [CX23885_BOARD_HAUPPAUGE_QUADHD_DVB] = {
+        .name        = "Hauppauge WinTV-QuadHD-DVB",
+        .portb        = CX23885_MPEG_DVB,
+        .portc        = CX23885_MPEG_DVB,
+    },
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);

@@ -1060,6 +1065,14 @@ struct cx23885_subid cx23885_subids[] = {
         .subvendor = 0x1576,
         .subdevice = 0x0460,
         .card      = CX23885_BOARD_VIEWCAST_460E,
+    }, {
+        .subvendor = 0x0070,
+        .subdevice = 0x6a28,
+        .card      = CX23885_BOARD_HAUPPAUGE_QUADHD_DVB, /* Tuner Pair 1 */
+    }, {
+        .subvendor = 0x0070,
+        .subdevice = 0x6b28,
+        .card      = CX23885_BOARD_HAUPPAUGE_QUADHD_DVB, /* Tuner Pair 2 */
     },
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1257,6 +1270,14 @@ static void hauppauge_eeprom(struct cx23885_dev
*dev, u8 *eeprom_data)
     case 150329:
         /* WinTV-HVR5525 (PCIe, DVB-S/S2, DVB-T/T2/C) */
         break;
+    case 166100:
+        /* WinTV-QuadHD (DVB) Tuner Pair 1 (PCIe, IR, half height,
+            DVB-T/T2/C, DVB-T/T2/C */
+        break;
+    case 166101:
+        /* WinTV-QuadHD (DVB) Tuner Pair 2 (PCIe, IR, half height,
+            DVB-T/T2/C, DVB-T/T2/C */
+        break;
     default:
         printk(KERN_WARNING "%s: warning: "
             "unknown hauppauge model #%d\n",
@@ -1729,20 +1750,22 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
         cx23885_gpio_set(dev, GPIO_2);
         break;
     case CX23885_BOARD_HAUPPAUGE_HVR5525:
+    case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
         /*
-         * GPIO-00 IR_WIDE
-         * GPIO-02 wake#
-         * GPIO-03 VAUX Pres.
-         * GPIO-07 PROG#
-         * GPIO-08 SAT_RESN
-         * GPIO-09 TER_RESN
-         * GPIO-10 B2_SENSE
-         * GPIO-11 B1_SENSE
-         * GPIO-15 IR_LED_STATUS
-         * GPIO-19 IR_NARROW
-         * GPIO-20 Blauster1
-         * ALTGPIO VAUX_SWITCH
-         * AUX_PLL_CLK : Blaster2
+         * HVR5525 GPIO Details:
+         *  GPIO-00 IR_WIDE
+         *  GPIO-02 wake#
+         *  GPIO-03 VAUX Pres.
+         *  GPIO-07 PROG#
+         *  GPIO-08 SAT_RESN
+         *  GPIO-09 TER_RESN
+         *  GPIO-10 B2_SENSE
+         *  GPIO-11 B1_SENSE
+         *  GPIO-15 IR_LED_STATUS
+         *  GPIO-19 IR_NARROW
+         *  GPIO-20 Blauster1
+         *  ALTGPIO VAUX_SWITCH
+         *  AUX_PLL_CLK : Blaster2
          */
         /* Put the parts into reset and back */
         cx23885_gpio_enable(dev, GPIO_8 | GPIO_9, 1);
@@ -1802,6 +1825,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
     case CX23885_BOARD_HAUPPAUGE_HVR1255:
     case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
     case CX23885_BOARD_HAUPPAUGE_HVR1210:
+    case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
         /* FIXME: Implement me */
         break;
     case CX23885_BOARD_HAUPPAUGE_HVR1270:
@@ -2000,6 +2024,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
     case CX23885_BOARD_HAUPPAUGE_STARBURST:
     case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
     case CX23885_BOARD_HAUPPAUGE_HVR5525:
+    case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
         if (dev->i2c_bus[0].i2c_rc == 0)
             hauppauge_eeprom(dev, eeprom+0xc0);
         break;
@@ -2145,6 +2170,14 @@ void cx23885_card_setup(struct cx23885_dev *dev)
         ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
         ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
         break;
+    case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+        ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
+        ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+        ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+        ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
+        ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+        ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+        break;
     case CX23885_BOARD_HAUPPAUGE_HVR1250:
     case CX23885_BOARD_HAUPPAUGE_HVR1500:
     case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c
b/drivers/media/pci/cx23885/cx23885-dvb.c
index f041b69..f656907 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -2269,6 +2269,106 @@ static int dvb_register(struct cx23885_tsport *port)
         }
         break;
     }
+    case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB: {
+
+        switch (port->nr) {
+
+        /* port b - Terrestrial/cable */
+        case 1:
+            /* attach frontend */
+            memset(&si2168_config, 0, sizeof(si2168_config));
+            si2168_config.i2c_adapter = &adapter;
+            si2168_config.fe = &fe0->dvb.frontend;
+            si2168_config.ts_mode = SI2168_TS_SERIAL;
+            memset(&info, 0, sizeof(struct i2c_board_info));
+            strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+            info.addr = 0x64;
+            info.platform_data = &si2168_config;
+            request_module("%s", info.type);
+            client_demod = i2c_new_device(&dev->i2c_bus[0].i2c_adap, &info);
+            if (!client_demod || !client_demod->dev.driver)
+                goto frontend_detach;
+            if (!try_module_get(client_demod->dev.driver->owner)) {
+                i2c_unregister_device(client_demod);
+                goto frontend_detach;
+            }
+            port->i2c_client_demod = client_demod;
+
+            /* attach tuner */
+            memset(&si2157_config, 0, sizeof(si2157_config));
+            si2157_config.fe = fe0->dvb.frontend;
+            si2157_config.if_port = 1;
+            memset(&info, 0, sizeof(struct i2c_board_info));
+            strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+            info.addr = 0x60;
+            info.platform_data = &si2157_config;
+            request_module("%s", info.type);
+            client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap, &info);
+            if (!client_tuner || !client_tuner->dev.driver) {
+                module_put(client_demod->dev.driver->owner);
+                i2c_unregister_device(client_demod);
+                port->i2c_client_demod = NULL;
+                goto frontend_detach;
+            }
+            if (!try_module_get(client_tuner->dev.driver->owner)) {
+                i2c_unregister_device(client_tuner);
+                module_put(client_demod->dev.driver->owner);
+                i2c_unregister_device(client_demod);
+                port->i2c_client_demod = NULL;
+                goto frontend_detach;
+            }
+            port->i2c_client_tuner = client_tuner;
+            break;
+
+        /* port c - terrestrial/cable */
+        case 2:
+            /* attach frontend */
+            memset(&si2168_config, 0, sizeof(si2168_config));
+            si2168_config.i2c_adapter = &adapter;
+            si2168_config.fe = &fe0->dvb.frontend;
+            si2168_config.ts_mode = SI2168_TS_SERIAL;
+            memset(&info, 0, sizeof(struct i2c_board_info));
+            strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+            info.addr = 0x66;
+            info.platform_data = &si2168_config;
+            request_module("%s", info.type);
+            client_demod = i2c_new_device(&dev->i2c_bus[0].i2c_adap, &info);
+            if (!client_demod || !client_demod->dev.driver)
+                goto frontend_detach;
+            if (!try_module_get(client_demod->dev.driver->owner)) {
+                i2c_unregister_device(client_demod);
+                goto frontend_detach;
+            }
+            port->i2c_client_demod = client_demod;
+
+            /* attach tuner */
+            memset(&si2157_config, 0, sizeof(si2157_config));
+            si2157_config.fe = fe0->dvb.frontend;
+            si2157_config.if_port = 1;
+            memset(&info, 0, sizeof(struct i2c_board_info));
+            strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+            info.addr = 0x62;
+            info.platform_data = &si2157_config;
+            request_module("%s", info.type);
+            client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap, &info);
+            if (!client_tuner || !client_tuner->dev.driver) {
+                module_put(client_demod->dev.driver->owner);
+                i2c_unregister_device(client_demod);
+                port->i2c_client_demod = NULL;
+                goto frontend_detach;
+            }
+            if (!try_module_get(client_tuner->dev.driver->owner)) {
+                i2c_unregister_device(client_tuner);
+                module_put(client_demod->dev.driver->owner);
+                i2c_unregister_device(client_demod);
+                port->i2c_client_demod = NULL;
+                goto frontend_detach;
+            }
+            port->i2c_client_tuner = client_tuner;
+            break;
+        }
+        break;
+    }
     default:
         printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
             " isn't supported yet\n",
diff --git a/drivers/media/pci/cx23885/cx23885.h
b/drivers/media/pci/cx23885/cx23885.h
index b1a5409..c212ddc 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -103,6 +103,7 @@
 #define CX23885_BOARD_HAUPPAUGE_STARBURST      53
 #define CX23885_BOARD_VIEWCAST_260E            54
 #define CX23885_BOARD_VIEWCAST_460E            55
+#define CX23885_BOARD_HAUPPAUGE_QUADHD_DVB    56

 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
