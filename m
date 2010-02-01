Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:33037 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821Ab0BAUg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 15:36:28 -0500
Message-ID: <4B673B2D.6040507@arcor.de>
Date: Mon, 01 Feb 2010 21:35:57 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] -  tm6000 DVB support
References: <4B673790.3030706@arcor.de>
In-Reply-To: <4B673790.3030706@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add Terratec Cinergy Hybrid XE
bugfix i2c transfer
add frontend callback
add init for tm6010
add digital-init for tm6010
add callback for analog/digital switch
bugfix usb transfer in DVB-mode

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/media/common/tuners/tuner-xc2028.c
b/drivers/media/common/tuners/tuner-xc2028.c
index ed50168..2297c00 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <media/tuner.h>
 #include <linux/mutex.h>
+#include "compat.h"
 #include <asm/unaligned.h>
 #include "tuner-i2c.h"
 #include "tuner-xc2028.h"
@@ -994,6 +995,13 @@ static int generic_set_freq(struct dvb_frontend
*fe, u32 freq /* in HZ */,
            buf[0], buf[1], buf[2], buf[3],
            freq / 1000000, (freq % 1000000) / 1000);
 
+    if (priv->ctrl.switch_mode) {
+        if (new_mode == T_ANALOG_TV)
+            do_tuner_callback(fe, SWITCH_TV_MODE, 0);
+        if (new_mode == T_DIGITAL_TV)
+            do_tuner_callback(fe, SWITCH_TV_MODE, 1);
+    }
+   
     rc = 0;
 
 ret:
@@ -1114,7 +1122,11 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 
     /* All S-code tables need a 200kHz shift */
     if (priv->ctrl.demod) {
-        demod = priv->ctrl.demod + 200;
+        if (priv->ctrl.fname == "xc3028L-v36.fw") {
+            demod = priv->ctrl.demod;
+        } else {
+            demod = priv->ctrl.demod + 200;
+        }
         /*
          * The DTV7 S-code table needs a 700 kHz shift.
          * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
@@ -1123,8 +1135,8 @@ static int xc2028_set_params(struct dvb_frontend *fe,
          * use this firmware after initialization, but a tune to a UHF
          * channel should then cause DTV78 to be used.
          */
-        if (type & DTV7)
-            demod += 500;
+        if (type  & DTV7)
+        demod += 500;
     }
 
     return generic_set_freq(fe, p->frequency,
@@ -1240,6 +1252,10 @@ static const struct dvb_tuner_ops
xc2028_dvb_tuner_ops = {
     .get_rf_strength   = xc2028_signal,
     .set_params        = xc2028_set_params,
     .sleep             = xc2028_sleep,
+#if 0
+    int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
+    int (*get_status)(struct dvb_frontend *fe, u32 *status);
+#endif
 };
 
 struct dvb_frontend *xc2028_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/common/tuners/tuner-xc2028.h
b/drivers/media/common/tuners/tuner-xc2028.h
index 9778c96..c9a4fb4 100644
--- a/drivers/media/common/tuners/tuner-xc2028.h
+++ b/drivers/media/common/tuners/tuner-xc2028.h
@@ -42,6 +42,7 @@ struct xc2028_ctrl {
     unsigned int        disable_power_mgmt:1;
     unsigned int            read_not_reliable:1;
     unsigned int        demod;
+    unsigned int        switch_mode:1;
     enum firmware_type    type:2;
 };
 
@@ -54,6 +55,7 @@ struct xc2028_config {
 /* xc2028 commands for callback */
 #define XC2028_TUNER_RESET    0
 #define XC2028_RESET_CLK    1
+#define SWITCH_TV_MODE        2
 
 #if defined(CONFIG_MEDIA_TUNER_XC2028) ||
(defined(CONFIG_MEDIA_TUNER_XC2028_MODULE) && defined(MODULE))
 extern struct dvb_frontend *xc2028_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb/frontends/zl10353.h
b/drivers/media/dvb/frontends/zl10353.h
index 6e3ca9e..015bc36 100644
--- a/drivers/media/dvb/frontends/zl10353.h
+++ b/drivers/media/dvb/frontends/zl10353.h
@@ -45,6 +45,8 @@ struct zl10353_config
     /* clock control registers (0x51-0x54) */
     u8 clock_ctl_1;  /* default: 0x46 */
     u8 pll_0;        /* default: 0x15 */
+   
+    int tm6000:1;
 };
 
 #if defined(CONFIG_DVB_ZL10353) || (defined(CONFIG_DVB_ZL10353_MODULE)
&& defined(MODULE))
diff --git a/drivers/staging/tm6000/hack.c b/drivers/staging/tm6000/hack.c
index f181fce..c1e1880 100644
--- a/drivers/staging/tm6000/hack.c
+++ b/drivers/staging/tm6000/hack.c
@@ -37,7 +37,6 @@ static inline int tm6000_snd_control_msg(struct
tm6000_core *dev, __u8 request,
 
 static int pseudo_zl10353_pll(struct tm6000_core *tm6000_dev, struct
dvb_frontend_parameters *p)
 {
-    int ret;
     u8 *data = kzalloc(50*sizeof(u8), GFP_KERNEL);
 
 printk(KERN_ALERT "should set frequency %u\n", p->frequency);
@@ -51,7 +50,7 @@ printk(KERN_ALERT "and bandwith %u\n",
p->u.ofdm.bandwidth);
     }
 
     // init ZL10353
-    data[0] = 0x0b;
+/*    data[0] = 0x0b;
     ret = tm6000_snd_control_msg(tm6000_dev, 0x10, 0x501e, 0x00, data,
0x1);
     msleep(15);
     data[0] = 0x80;
@@ -159,7 +158,7 @@ printk(KERN_ALERT "and bandwith %u\n",
p->u.ofdm.bandwidth);
             msleep(15);
             data[0] = 0x5a;
             ret = tm6000_snd_control_msg(tm6000_dev, 0x10, 0x651e,
0x00, data, 0x1);
-            msleep(15);
+            msleep(15)
             data[0] = 0xe9;
             ret = tm6000_snd_control_msg(tm6000_dev, 0x10, 0x661e,
0x00, data, 0x1);
             msleep(15);
@@ -189,7 +188,162 @@ printk(KERN_ALERT "and bandwith %u\n",
p->u.ofdm.bandwidth);
             msleep(15);
         break;
     }
-
+*/
+    switch(p->u.ofdm.bandwidth) {
+        case BANDWIDTH_8_MHZ:
+            data[0] = 0x03;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x501e,0,data,1);
+            msleep(40);
+            data[0] = 0x44;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x511e,0,data,1);
+            msleep(40);
+            data[0] = 0x40;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+            msleep(40);
+            data[0] = 0x46;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x521e,0,data,1);
+            msleep(40);
+            data[0] = 0x15;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x531e,0,data,1);
+            msleep(40);
+            data[0] = 0x0f;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x541e,0,data,1);
+            msleep(40);
+            data[0] = 0x80;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+            msleep(40);
+            data[0] = 0x01;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+            msleep(40);
+            data[0] = 0x00;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+            msleep(40);
+            data[0] = 0x8b;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x631e,0,data,1);
+            msleep(40);
+            data[0] = 0x75;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xcc1e,0,data,1);
+            msleep(40);
+            data[0] = 0xe6; //0x19;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6c1e,0,data,1);
+            msleep(40);
+            data[0] = 0x09; //0xf7;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6d1e,0,data,1);
+            msleep(40);
+            data[0] = 0x67;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x651e,0,data,1);
+            msleep(40);
+            data[0] = 0xe5;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x661e,0,data,1);
+            msleep(40);
+            data[0] = 0x75;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5c1e,0,data,1);
+            msleep(40);
+            data[0] = 0x17;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5f1e,0,data,1);
+            msleep(40);
+            data[0] = 0x40;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5e1e,0,data,1);
+            msleep(40);
+            data[0] = 0x01;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x701e,0,data,1);
+            msleep(40);
+            break;
+        case BANDWIDTH_7_MHZ:
+            data[0] = 0x03;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x501e,0,data,1);
+            msleep(40);
+            data[0] = 0x44;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x511e,0,data,1);
+            msleep(40);
+            data[0] = 0x40;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+            msleep(40);
+            data[0] = 0x46;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x521e,0,data,1);
+            msleep(40);
+            data[0] = 0x15;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x531e,0,data,1);
+            msleep(40);
+            data[0] = 0x0f;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x541e,0,data,1);
+            msleep(40);
+            data[0] = 0x80;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+            msleep(40);
+            data[0] = 0x01;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+            msleep(40);
+            data[0] = 0x00;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+            msleep(40);
+            data[0] = 0x83;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x631e,0,data,1);
+            msleep(40);
+            data[0] = 0xa3;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xcc1e,0,data,1);
+            msleep(40);
+            data[0] = 0xe6; //0x19;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6c1e,0,data,1);
+            msleep(40);
+            data[0] = 0x09; //0xf7;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6d1e,0,data,1);
+            msleep(40);
+            data[0] = 0x5a;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x651e,0,data,1);
+            msleep(40);
+            data[0] = 0xe9;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x661e,0,data,1);
+            msleep(40);
+            data[0] = 0x86;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5c1e,0,data,1);
+            msleep(40);
+            data[0] = 0x17;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5f1e,0,data,1);
+            msleep(40);
+            data[0] = 0x40;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5e1e,0,data,1);
+            msleep(40);
+            data[0] = 0x01;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x701e,0,data,1);
+            msleep(40);
+            break;
+        default:
+            printk(KERN_ALERT "tm6000: bandwidth not supported\n");
+    }
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x0f1f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x091f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x0b1f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
     kfree(data);
 
     return 0;
diff --git a/drivers/staging/tm6000/tm6000-cards.c
b/drivers/staging/tm6000/tm6000-cards.c
index 59fb505..652a54a 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -32,7 +32,7 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 #include "tuner-xc2028.h"
-#include "tuner-xc5000.h"
+#include "xc5000.h"
 
 #define TM6000_BOARD_UNKNOWN            0
 #define TM5600_BOARD_GENERIC            1
@@ -44,6 +44,10 @@
 #define TM6000_BOARD_FREECOM_AND_SIMILAR    7
 #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV    8
 #define TM6010_BOARD_HAUPPAUGE_900H        9
+#define TM6010_BOARD_BEHOLD_WANDER        10
+#define TM6010_BOARD_BEHOLD_VOYAGER        11
+#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE    12
+
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
@@ -208,7 +212,21 @@ struct tm6000_board tm6000_boards[] = {
         },
         .gpio_addr_tun_reset = TM6000_GPIO_2,
     },
-
+    [TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
+        .name         = "Terratec Cinergy Hybrid XE",
+        .tuner_type   = TUNER_XC2028, /* has a XC3028 */
+        .tuner_addr   = 0xc2 >> 1,
+        .demod_addr   = 0x1e >> 1,
+        .type         = TM6010,
+        .caps = {
+            .has_tuner    = 1,
+            .has_dvb      = 1,
+            .has_zl10353  = 1,
+            .has_eeprom   = 1,
+            .has_remote   = 1,
+        },
+        .gpio_addr_tun_reset = TM6010_GPIO_2,
+    }
 };
 
 /* table of devices that work with this driver */
@@ -221,12 +239,13 @@ struct usb_device_id tm6000_id_table [] = {
     { USB_DEVICE(0x2040, 0x6600), .driver_info =
TM6010_BOARD_HAUPPAUGE_900H },
     { USB_DEVICE(0x6000, 0xdec0), .driver_info =
TM6010_BOARD_BEHOLD_WANDER },
     { USB_DEVICE(0x6000, 0xdec1), .driver_info =
TM6010_BOARD_BEHOLD_VOYAGER },
+    { USB_DEVICE(0x0ccd, 0x0086), .driver_info =
TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE },
     { },
 };
 
 /* Tuner callback to provide the proper gpio changes needed for xc2028 */
 
-static int tm6000_tuner_callback(void *ptr, int component, int command,
int arg)
+int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 {
     int rc=0;
     struct tm6000_core *dev = ptr;
@@ -252,11 +271,14 @@ static int tm6000_tuner_callback(void *ptr, int
component, int command, int arg)
         switch (arg) {
         case 0:
             tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+                    dev->tuner_reset_gpio, 0x01);
+            msleep(60);
+            tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
                     dev->tuner_reset_gpio, 0x00);
-            msleep(130);
+            msleep(75);
             tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
                     dev->tuner_reset_gpio, 0x01);
-            msleep(130);
+            msleep(60);
             break;
         case 1:
             tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT,
@@ -269,13 +291,33 @@ static int tm6000_tuner_callback(void *ptr, int
component, int command, int arg)
                         TM6000_GPIO_CLK, 0);
             if (rc<0)
                 return rc;
-            msleep(100);
+            msleep(10);
             rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
                         TM6000_GPIO_CLK, 1);
-            msleep(100);
+            msleep(10);
+            break;
+        }
+        break;
+       
+    case SWITCH_TV_MODE:
+        /* switch between analog and  digital */
+        switch (arg) {
+        case 0:
+            printk(KERN_INFO "switch to analog");
+            tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+                    TM6010_GPIO_5, 1);
+            printk(KERN_INFO "analog");
+            break;
+        case 1:
+            printk(KERN_INFO "switch to digital");
+            tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+                    TM6010_GPIO_5, 0);
+            printk(KERN_INFO "digital");
             break;
         }
+    break;
     }
+   
     return (rc);
 }
 
@@ -290,7 +332,7 @@ static void tm6000_config_tuner (struct tm6000_core
*dev)
     memset(&tun_setup, 0, sizeof(tun_setup));
     tun_setup.type   = dev->tuner_type;
     tun_setup.addr   = dev->tuner_addr;
-    tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
+    tun_setup.mode_mask = T_ANALOG_TV | T_RADIO | T_DIGITAL_TV;
     tun_setup.tuner_callback = tm6000_tuner_callback;
 
     v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr,
&tun_setup);
@@ -302,15 +344,19 @@ static void tm6000_config_tuner (struct
tm6000_core *dev)
         memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
         memset (&ctl,0,sizeof(ctl));
 
-        ctl.mts   = 1;
-        ctl.read_not_reliable = 1;
+        ctl.input1 = 1;
+        ctl.read_not_reliable = 0;
         ctl.msleep = 10;
-
+        ctl.demod = XC3028_FE_ZARLINK456;
+        ctl.vhfbw7 = 1;
+        ctl.uhfbw8 = 1;
+        ctl.switch_mode = 1;
         xc2028_cfg.tuner = TUNER_XC2028;
         xc2028_cfg.priv  = &ctl;
 
         switch(dev->model) {
         case TM6010_BOARD_HAUPPAUGE_900H:
+        case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
             ctl.fname = "xc3028L-v36.fw";
             break;
         default:
@@ -402,6 +448,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
         }
 #endif
     }
+    return 0;
 
 err2:
     v4l2_device_unregister(&dev->v4l2_dev);
@@ -459,13 +506,13 @@ static int tm6000_usb_probe(struct usb_interface
*interface,
     /* Check to see next free device and mark as used */
     nr=find_first_zero_bit(&tm6000_devused,TM6000_MAXBOARDS);
     if (nr >= TM6000_MAXBOARDS) {
-        printk ("tm6000: Supports only %i em28xx
boards.\n",TM6000_MAXBOARDS);
+        printk ("tm6000: Supports only %i tm60xx
boards.\n",TM6000_MAXBOARDS);
         usb_put_dev(usbdev);
         return -ENOMEM;
     }
 
     /* Create and initialize dev struct */
-    dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+    dev = kzalloc(sizeof(*(dev)), GFP_KERNEL);
     if (dev == NULL) {
         printk ("tm6000" ": out of memory!\n");
         usb_put_dev(usbdev);
diff --git a/drivers/staging/tm6000/tm6000-core.c
b/drivers/staging/tm6000/tm6000-core.c
index d41af1d..33bbbd3 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -219,33 +219,53 @@ int tm6000_init_analog_mode (struct tm6000_core *dev)
 
 int tm6000_init_digital_mode (struct tm6000_core *dev)
 {
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00ff, 0x08);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00ff, 0x00);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x003f, 0x01);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00df, 0x08);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e2, 0x0c);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e8, 0xff);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0xd8);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c0, 0x40);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c1, 0xd0);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c3, 0x09);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00da, 0x37);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d1, 0xd8);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d2, 0xc0);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d6, 0x60);
-
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e2, 0x0c);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e8, 0xff);
-    tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0x08);
-    msleep(50);
-
-    tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
-    msleep(50);
-    tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x01);
-    msleep(50);
-    tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
-    msleep(100);
-
+    if (dev->dev_type == TM6010) {
+        int val;
+        u8 buf[2];
+       
+        /* digital init */
+        val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xcc, 0);
+        val &= ~0x60;
+        tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xcc, val);
+        val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xc0, 0);
+        val |= 0x40;
+        tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xc0, val);
+        tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xfe, 0x28);
+        tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0xe2, 0xfc);
+        tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0xe6, 0xff);
+        tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0xf1, 0xfe);
+        tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
+        printk (KERN_INFO "buf %#x %#x \n", buf[0], buf[1]);
+       
+
+    } else  {
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00ff, 0x08);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00ff, 0x00);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x003f, 0x01);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00df, 0x08);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e2, 0x0c);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e8, 0xff);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0xd8);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c0, 0x40);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c1, 0xd0);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c3, 0x09);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00da, 0x37);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d1, 0xd8);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d2, 0xc0);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d6, 0x60);
+
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e2, 0x0c);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e8, 0xff);
+        tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0x08);
+        msleep(50);
+
+        tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
+        msleep(50);
+        tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x01);
+        msleep(50);
+        tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
+        msleep(100);
+    }
     return 0;
 }
 
@@ -394,7 +414,15 @@ struct reg_init tm6010_init_tab[] = {
     { REQ_07_SET_GET_AVREG, 0x3f, 0x00 },
 
     { REQ_05_SET_GET_USBREG, 0x18, 0x00 },
-
+   
+    /* additional from Terratec Cinergy Hybrid XE */
+    { REQ_07_SET_GET_AVREG, 0xdc, 0xaa },
+    { REQ_07_SET_GET_AVREG, 0xdd, 0x30 },
+    { REQ_07_SET_GET_AVREG, 0xde, 0x20 },
+    { REQ_07_SET_GET_AVREG, 0xdf, 0xd0 },
+    { REQ_04_EN_DISABLE_MCU_INT, 0x02, 0x00 },
+    { REQ_07_SET_GET_AVREG, 0xd8, 0x2f },
+   
     /* set remote wakeup key:any key wakeup */
     { REQ_07_SET_GET_AVREG,  0xe5,  0xfe },
     { REQ_07_SET_GET_AVREG,  0xda,  0xff },
@@ -404,6 +432,7 @@ int tm6000_init (struct tm6000_core *dev)
 {
     int board, rc=0, i, size;
     struct reg_init *tab;
+    u8 buf[40];
 
     if (dev->dev_type == TM6010) {
         tab = tm6010_init_tab;
@@ -424,61 +453,129 @@ int tm6000_init (struct tm6000_core *dev)
         }
     }
 
-    msleep(5); /* Just to be conservative */
-
-    /* Check board version - maybe 10Moons specific */
-    board=tm6000_get_reg16 (dev, 0x40, 0, 0);
-    if (board >=0) {
-        printk (KERN_INFO "Board version = 0x%04x\n",board);
-    } else {
-        printk (KERN_ERR "Error %i while retrieving board
version\n",board);
-    }
-
+    /* hack */
     if (dev->dev_type == TM6010) {
-        /* Turn xceive 3028 on */
-        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_3, 0x01);
-        msleep(11);
-    }
-
-    /* Reset GPIO1 and GPIO4. */
-    for (i=0; i< 2; i++) {
-        rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-                    dev->tuner_reset_gpio, 0x00);
-        if (rc<0) {
-            printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
-            return rc;
-        }
-
-        msleep(10); /* Just to be conservative */
-        rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-                    dev->tuner_reset_gpio, 0x01);
-        if (rc<0) {
-            printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
-            return rc;
-        }
-
-        msleep(10);
-        rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 0);
-        if (rc<0) {
-            printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
-            return rc;
-        }
-
-        msleep(10);
-        rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 1);
-        if (rc<0) {
-            printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
-            return rc;
-        }
-
-        if (!i) {
-            rc=tm6000_get_reg16(dev, 0x40,0,0);
-            if (rc>=0) {
-                printk ("board=%d\n", rc);
+       
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_4, 0);
+        msleep(15);
+               
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_1, 0);
+   
+        msleep(50);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_1, 1);
+       
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x0010, 0x4400, buf, 2);
+       
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
+   
+        msleep(15);
+        buf[0] = 0x12;
+        buf[1] = 0x34;
+        tm6000_read_write_usb (dev, 0x40, 0x10, 0xf432, 0x0000, buf, 2);
+   
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
+   
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0x0032, 0x0000, buf, 2);
+
+        msleep(15);
+        buf[0] = 0x00;
+        buf[1] = 0x01;
+        tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
+   
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0x00c0, 0x0000, buf, 39);
+   
+        msleep(15);
+        buf[0] = 0x00;
+        buf[1] = 0x00;
+        tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
+   
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0x7f1f, 0x0000, buf, 2);
+//        printk(KERN_INFO "buf %#x %#x \n", buf[0], buf [1]);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_4, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                    TM6010_GPIO_0, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_7, 0);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_5, 1);
+   
+        msleep(15);
+   
+        for (i=0; i< size; i++) {
+            rc= tm6000_set_reg (dev, tab[i].req, tab[i].reg, tab[i].val);
+            if (rc<0) {
+                printk (KERN_ERR "Error %i while setting req %d, "
+                         "reg %d to value %d\n", rc,
+                         tab[i].req,tab[i].reg, tab[i].val);
+                return rc;
             }
         }
+           
+        msleep(15);
+   
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_4, 0);
+        msleep(15);
+
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_1, 0);
+   
+        msleep(50);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_1, 1);
+       
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
+//        printk(KERN_INFO "buf %#x %#x \n", buf[0], buf[1]);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 0);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 0);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 1);
+        msleep(15);
     }
+    /* hack end */
+   
+    msleep(5); /* Just to be conservative */
 
+    /* Check board version - maybe 10Moons specific */
+    if (dev->dev_type == TM5600) {
+         board=tm6000_get_reg16 (dev, 0x40, 0, 0);
+        if (board >=0) {
+            printk (KERN_INFO "Board version = 0x%04x\n",board);
+        } else {
+            printk (KERN_ERR "Error %i while retrieving board
version\n",board);
+        }
+    }
+   
     msleep(50);
 
     return 0;
diff --git a/drivers/staging/tm6000/tm6000-dvb.c
b/drivers/staging/tm6000/tm6000-dvb.c
index e900d6d..31458d3 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -17,7 +17,9 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/kernel.h>
 #include <linux/usb.h>
+#include <compat.h>
 
 #include "tm6000.h"
 #include "tm6000-regs.h"
@@ -30,17 +32,61 @@
 
 #include "tuner-xc2028.h"
 
+static void inline print_err_status (struct tm6000_core *dev,
+                     int packet, int status)
+{
+    char *errmsg = "Unknown";
+
+    switch(status) {
+    case -ENOENT:
+        errmsg = "unlinked synchronuously";
+        break;
+    case -ECONNRESET:
+        errmsg = "unlinked asynchronuously";
+        break;
+    case -ENOSR:
+        errmsg = "Buffer error (overrun)";
+        break;
+    case -EPIPE:
+        errmsg = "Stalled (device not responding)";
+        break;
+    case -EOVERFLOW:
+        errmsg = "Babble (bad cable?)";
+        break;
+    case -EPROTO:
+        errmsg = "Bit-stuff error (bad cable?)";
+        break;
+    case -EILSEQ:
+        errmsg = "CRC/Timeout (could be anything)";
+        break;
+    case -ETIME:
+        errmsg = "Device does not respond";
+        break;
+    }
+    if (packet<0) {
+        dprintk(dev, 1, "URB status %d [%s].\n",
+            status, errmsg);
+    } else {
+        dprintk(dev, 1, "URB packet %d, status %d [%s].\n",
+            packet, status, errmsg);
+    }
+}
+
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
+static void tm6000_urb_received(struct urb *urb, struct pt_regs *ptregs)
+#else
 static void tm6000_urb_received(struct urb *urb)
+#endif
 {
     int ret;
     struct tm6000_core* dev = urb->context;
 
-    if(urb->status != 0){
-        printk(KERN_ERR "tm6000: status != 0\n");
+    if(urb->status != 0) {
+        print_err_status (dev,0,urb->status);
     }
     else if(urb->actual_length>0){
-        dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer,
-                           urb->actual_length);
+        dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer,
urb->actual_length);
     }
 
     if(dev->dvb->streams > 0) {
@@ -56,49 +102,37 @@ static void tm6000_urb_received(struct urb *urb)
 int tm6000_start_stream(struct tm6000_core *dev)
 {
     int ret;
-    unsigned int pipe, maxPaketSize;
+    unsigned int pipe, size;
     struct tm6000_dvb *dvb = dev->dvb;
 
     printk(KERN_INFO "tm6000: got start stream request %s\n",__FUNCTION__);
 
     tm6000_init_digital_mode(dev);
 
-/*
-    ret = tm6000_set_led_status(tm6000_dev, 0x1);
-    if(ret < 0) {
-        return -1;
-    }
-*/
-
     dvb->bulk_urb = usb_alloc_urb(0, GFP_KERNEL);
     if(dvb->bulk_urb == NULL) {
         printk(KERN_ERR "tm6000: couldn't allocate urb\n");
         return -ENOMEM;
     }
 
-    maxPaketSize = dev->bulk_in->desc.wMaxPacketSize;
+    pipe = usb_rcvbulkpipe(dev->udev, dev->bulk_in->desc.bEndpointAddress
+                              & USB_ENDPOINT_NUMBER_MASK);
+                             
+    size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
+    size = size * 15; // 512 x 8 or 12 or 15
 
-    dvb->bulk_urb->transfer_buffer = kzalloc(maxPaketSize, GFP_KERNEL);
+    dvb->bulk_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
     if(dvb->bulk_urb->transfer_buffer == NULL) {
         usb_free_urb(dvb->bulk_urb);
         printk(KERN_ERR "tm6000: couldn't allocate transfer buffer!\n");
         return -ENOMEM;
     }
-
-    pipe = usb_rcvbulkpipe(dev->udev, dev->bulk_in->desc.bEndpointAddress
-                              & USB_ENDPOINT_NUMBER_MASK);
-
+   
     usb_fill_bulk_urb(dvb->bulk_urb, dev->udev, pipe,
                          dvb->bulk_urb->transfer_buffer,
-                         maxPaketSize,
+                         size,
                          tm6000_urb_received, dev);
 
-    ret = usb_set_interface(dev->udev, 0, 1);
-    if(ret < 0) {
-        printk(KERN_ERR "tm6000: error %i in %s during set
interface\n", ret, __FUNCTION__);
-        return ret;
-    }
-
     ret = usb_clear_halt(dev->udev, pipe);
     if(ret < 0) {
         printk(KERN_ERR "tm6000: error %i in %s during pipe
reset\n",ret,__FUNCTION__);
@@ -107,15 +141,14 @@ int tm6000_start_stream(struct tm6000_core *dev)
     else {
         printk(KERN_ERR "tm6000: pipe resetted\n");
     }
-
-//     mutex_lock(&tm6000_driver.open_close_mutex);
+   
+//    mutex_lock(&tm6000_driver.open_close_mutex);
     ret = usb_submit_urb(dvb->bulk_urb, GFP_KERNEL);
 
-
-//     mutex_unlock(&tm6000_driver.open_close_mutex);
+//    mutex_unlock(&tm6000_driver.open_close_mutex);
     if (ret) {
         printk(KERN_ERR "tm6000: submit of urb failed (error=%i)\n",ret);
-
+       
         kfree(dvb->bulk_urb->transfer_buffer);
         usb_free_urb(dvb->bulk_urb);
         return ret;
@@ -126,18 +159,12 @@ int tm6000_start_stream(struct tm6000_core *dev)
 
 void tm6000_stop_stream(struct tm6000_core *dev)
 {
-    int ret;
     struct tm6000_dvb *dvb = dev->dvb;
 
-//     tm6000_set_led_status(tm6000_dev, 0x0);
-
-    ret = usb_set_interface(dev->udev, 0, 0);
-    if(ret < 0) {
-        printk(KERN_ERR "tm6000: error %i in %s during set
interface\n",ret,__FUNCTION__);
-    }
-
     if(dvb->bulk_urb) {
+        printk (KERN_INFO "urb killing\n");
         usb_kill_urb(dvb->bulk_urb);
+        printk (KERN_INFO "urb buffer free\n");
         kfree(dvb->bulk_urb->transfer_buffer);
         usb_free_urb(dvb->bulk_urb);
         dvb->bulk_urb = NULL;
@@ -154,7 +181,7 @@ int tm6000_start_feed(struct dvb_demux_feed *feed)
     mutex_lock(&dvb->mutex);
     if(dvb->streams == 0) {
         dvb->streams = 1;
-//         mutex_init(&tm6000_dev->streaming_mutex);
+//        mutex_init(&tm6000_dev->streming_mutex);
         tm6000_start_stream(dev);
     }
     else {
@@ -173,14 +200,17 @@ int tm6000_stop_feed(struct dvb_demux_feed *feed) {
     printk(KERN_INFO "tm6000: got stop feed request %s\n",__FUNCTION__);
 
     mutex_lock(&dvb->mutex);
-    --dvb->streams;
 
-    if(0 == dvb->streams) {
+    printk (KERN_INFO "stream %#x\n", dvb->streams);
+    --(dvb->streams);
+    if(dvb->streams == 0) {
+        printk (KERN_INFO "stop stream\n");
         tm6000_stop_stream(dev);
-//         mutex_destroy(&tm6000_dev->streaming_mutex);
+//        mutex_destroy(&tm6000_dev->streaming_mutex);
     }
+   
     mutex_unlock(&dvb->mutex);
-//     mutex_destroy(&tm6000_dev->streaming_mutex);
+//    mutex_destroy(&tm6000_dev->streaming_mutex);
 
     return 0;
 }
@@ -191,13 +221,16 @@ int tm6000_dvb_attach_frontend(struct tm6000_core
*dev)
 
     if(dev->caps.has_zl10353) {
         struct zl10353_config config =
-                    {.demod_address = dev->demod_addr >> 1,
+                    {.demod_address = dev->demod_addr,
                      .no_tuner = 1,
-//                      .input_frequency = 0x19e9,
-//                      .r56_agc_targets =  0x1c,
+                     .parallel_ts = 1,
+                     .if2 = 45700,
+                     .disable_i2c_gate_ctrl = 1,
+                     .tm6000 = 1,
                     };
 
         dvb->frontend = pseudo_zl10353_attach(dev, &config,
+//        dvb->frontend = dvb_attach (zl10353_attach, &config,
                                &dev->i2c_adap);
     }
     else {
@@ -235,7 +268,8 @@ int tm6000_dvb_register(struct tm6000_core *dev)
             .i2c_adap = &dev->i2c_adap,
             .i2c_addr = dev->tuner_addr,
         };
-
+       
+        dvb->frontend->callback = tm6000_tuner_callback;
         ret = dvb_register_frontend(&dvb->adapter, dvb->frontend);
         if (ret < 0) {
             printk(KERN_ERR
@@ -258,8 +292,8 @@ int tm6000_dvb_register(struct tm6000_core *dev)
     dvb->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING
                                 | DMX_MEMORY_BASED_FILTERING;
     dvb->demux.priv = dev;
-    dvb->demux.filternum = 256;
-    dvb->demux.feednum = 256;
+    dvb->demux.filternum = 5; //256;
+    dvb->demux.feednum = 5; //256;
     dvb->demux.start_feed = tm6000_start_feed;
     dvb->demux.stop_feed = tm6000_stop_feed;
     dvb->demux.write_to_decoder = NULL;
@@ -307,7 +341,7 @@ void tm6000_dvb_unregister(struct tm6000_core *dev)
         usb_free_urb(bulk_urb);
     }
 
-//     mutex_lock(&tm6000_driver.open_close_mutex);
+//    mutex_lock(&tm6000_driver.open_close_mutex);
     if(dvb->frontend) {
         dvb_frontend_detach(dvb->frontend);
         dvb_unregister_frontend(dvb->frontend);
@@ -317,6 +351,6 @@ void tm6000_dvb_unregister(struct tm6000_core *dev)
     dvb_dmx_release(&dvb->demux);
     dvb_unregister_adapter(&dvb->adapter);
     mutex_destroy(&dvb->mutex);
-//     mutex_unlock(&tm6000_driver.open_close_mutex);
+//    mutex_unlock(&tm6000_driver.open_close_mutex);
 
 }
diff --git a/drivers/staging/tm6000/tm6000-i2c.c
b/drivers/staging/tm6000/tm6000-i2c.c
index 4da10f5..3e43ad7 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -86,6 +86,11 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
                 msgs[i].len == 1 ? 0 : msgs[i].buf[1],
                 msgs[i + 1].buf, msgs[i + 1].len);
             i++;
+           
+            if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+                tm6000_set_reg(dev, 0x32, 0,0);
+                tm6000_set_reg(dev, 0x33, 0,0);
+            }
             if (i2c_debug >= 2)
                 for (byte = 0; byte < msgs[i].len; byte++)
                     printk(" %02x", msgs[i].buf[byte]);
@@ -99,6 +104,12 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
                 REQ_16_SET_GET_I2C_WR1_RDN,
                 addr | msgs[i].buf[0] << 8, 0,
                 msgs[i].buf + 1, msgs[i].len - 1);
+               
+           
+            if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+                tm6000_set_reg(dev, 0x32, 0,0);
+                tm6000_set_reg(dev, 0x33, 0,0);
+            }
         }
         if (i2c_debug >= 2)
             printk("\n");
@@ -198,7 +209,7 @@ static struct i2c_algorithm tm6000_algo = {
 
 static struct i2c_adapter tm6000_adap_template = {
     .owner = THIS_MODULE,
-    .class = I2C_CLASS_TV_ANALOG,
+    .class = I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL,
     .name = "tm6000",
     .id = I2C_HW_B_TM6000,
     .algo = &tm6000_algo,
diff --git a/drivers/staging/tm6000/tm6000.h
b/drivers/staging/tm6000/tm6000.h
index 877cbf6..e403ca0 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -23,12 +23,15 @@
 // Use the tm6000-hack, instead of the proper initialization code
 //#define HACK 1
 
+#include "compat.h"
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/videobuf-vmalloc.h>
 #include "tm6000-usb-isoc.h"
 #include <linux/i2c.h>
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)
 #include <linux/mutex.h>
+#endif
 #include <media/v4l2-device.h>
 
 
@@ -78,6 +81,10 @@ struct tm6000_dmaqueue {
     /* thread for generating video stream*/
     struct task_struct         *kthread;
     wait_queue_head_t          wq;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+    struct semaphore           *notify;
+    int                        rmmod:1;
+#endif
     /* Counters to control fps rate */
     int                        frame;
     int                        ini_jiffies;
@@ -90,12 +97,14 @@ enum tm6000_core_state {
     DEV_MISCONFIGURED = 0x04,
 };
 
+#if 1
 /* io methods */
 enum tm6000_io_method {
     IO_NONE,
     IO_READ,
     IO_MMAP,
 };
+#endif
 
 enum tm6000_mode {
     TM6000_MODE_UNKNOWN=0,
@@ -202,6 +211,9 @@ struct tm6000_fh {
             V4L2_STD_PAL_M|V4L2_STD_PAL_60|V4L2_STD_NTSC_M| \
             V4L2_STD_NTSC_M_JP|V4L2_STD_SECAM
 
+/* In tm6000-cards.c */
+
+int tm6000_tuner_callback (void *ptr, int component, int command, int arg);
 /* In tm6000-core.c */
 
 int tm6000_read_write_usb (struct tm6000_core *dev, u8 reqtype, u8 req,
@@ -209,7 +221,6 @@ int tm6000_read_write_usb (struct tm6000_core *dev,
u8 reqtype, u8 req,
 int tm6000_get_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_set_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_init (struct tm6000_core *dev);
-int tm6000_init_after_firmware (struct tm6000_core *dev);
 
 int tm6000_init_analog_mode (struct tm6000_core *dev);
 int tm6000_init_digital_mode (struct tm6000_core *dev);
@@ -231,7 +242,12 @@ int tm6000_set_standard (struct tm6000_core *dev,
v4l2_std_id *norm);
 int tm6000_i2c_register(struct tm6000_core *dev);
 int tm6000_i2c_unregister(struct tm6000_core *dev);
 
+#if 1
 /* In tm6000-queue.c */
+#if 0
+int tm6000_init_isoc(struct tm6000_core *dev, int max_packets);
+void tm6000_uninit_isoc(struct tm6000_core *dev);
+#endif
 
 int tm6000_v4l2_mmap(struct file *filp, struct vm_area_struct *vma);
 
@@ -276,3 +292,4 @@ extern int tm6000_debug;
         __FUNCTION__ , ##arg); } while (0)
 
 
+#endif

-- 
Stefan Ringel <stefan.ringel@arcor.de>

