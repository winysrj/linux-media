Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:38151 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932439Ab0BCUcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:32:31 -0500
Message-ID: <4B69DD3F.2000103@arcor.de>
Date: Wed, 03 Feb 2010 21:31:59 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 12/15] -  tm6000 bugfix tuner reset time and tuner param
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -221,12 +239,13 @@ struct usb_device_id tm6000_id_table [] = {
     { USB_DEVICE(0x2040, 0x6600), .driver_info =
TM6010_BOARD_HAUPPAUGE_900H },
     { USB_DEVICE(0x6000, 0xdec0), .driver_info =
TM6010_BOARD_BEHOLD_WANDER },
     { USB_DEVICE(0x6000, 0xdec1), .driver_info =
TM6010_BOARD_BEHOLD_VOYAGER },
     { USB_DEVICE(0x0ccd, 0x0086), .driver_info =
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
