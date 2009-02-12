Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1CDG9XZ013834
	for <video4linux-list@redhat.com>; Thu, 12 Feb 2009 08:16:09 -0500
Received: from web2701.mail.kcd.yahoo.co.jp (web2701.mail.kcd.yahoo.co.jp
	[124.147.36.218])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n1CDFnch010379
	for <video4linux-list@redhat.com>; Thu, 12 Feb 2009 08:15:50 -0500
Message-ID: <20090212131547.69780.qmail@web2701.mail.kcd.yahoo.co.jp>
Date: Thu, 12 Feb 2009 22:15:47 +0900 (JST)
From: indika katugampala <indika_20012001@yahoo.co.jp>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Subject: [PATCH] support added for IO-DATA GV/MVP SZ - EMPIA-2820 chipset 
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Added support for IO-DATA GV/MVP SZ tv capture device.

Analog TV (audio + video) is working fine.
Haven't tested S-VIDEO and COMPOSITE yet.


Signed-off-by: Indika Katugampala <indika_20012001@yahoo.co.jp>
 

------





diff -r b07848302e6c linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c Wed Feb 11 15:18:36 2009 -0200
 +++ b/linux/drivers/media/video/em28xx/em28xx-cards.c Thu Feb 12 19:41:11 2009 +0900
@@ -1359,8 +1359,28 @@ struct em28xx_board em28xx_boards[] = {
     .vmux     = SAA7115_SVIDEO3,
    .amux     = EM28XX_AMUX_LINE_IN,
   } },
   },
+ [EM2820_BOARD_IODATA_GVMVP_SZ] = {
+  .name       = "IO-DATA GV-MVP/SZ",
 +  .tuner_type   = TUNER_PHILIPS_FM1236_MK3,
+  .tuner_gpio   = default_tuner_gpio,
 +  .tda9887_conf = TDA9887_PRESENT,
+  .decoder      = EM28XX_TVP5150,
+  .input        = { {
 +   .type     = EM28XX_VMUX_TELEVISION,
+   .vmux     = TVP5150_COMPOSITE0,
 +   .amux     = EM28XX_AMUX_VIDEO,
+  }, { /* Composite has not been tested yet */
 +   .type     = EM28XX_VMUX_COMPOSITE1,
+   .vmux     = TVP5150_COMPOSITE1,
 +   .amux     = EM28XX_AMUX_VIDEO,
+  }, { /* S-video has not been tested yet */
 +   .type     = EM28XX_VMUX_SVIDEO,
+   .vmux     = TVP5150_SVIDEO,
+   .amux     = EM28XX_AMUX_VIDEO,
 +  }},
+ },
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
  
 /* table of devices that work with this driver */
@@ -1462,8 +1482,10 @@ struct usb_device_id em28xx_id_table [] 
  { USB_DEVICE(0x0413, 0x6023),
     .driver_info = EM2800_BOARD_LEADTEK_WINFAST_USBII },
  { USB_DEVICE(0x093b, 0xa005),
     .driver_info = EM2861_BOARD_PLEXTOR_PX_TV100U },
+ { USB_DEVICE(0x04bb, 0x0515),
 +   .driver_info = EM2820_BOARD_IODATA_GVMVP_SZ },
  { },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
  
@@ -1654,9 +1676,18 @@ void em28xx_pre_card_setup(struct em28xx
   break;
  case EM2860_BOARD_EASYCAP:
    em28xx_write_regs(dev, 0x08, "\xf8", 1);
   break;
-
 + case EM2820_BOARD_IODATA_GVMVP_SZ:
+  em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
 +  msleep(70);
+  em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf7);
+  msleep(10);
 +  em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfe);
+  msleep(70);
+  em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
 +  msleep(70);
+  break;
  }
  
  em28xx_gpio_set(dev, dev->board.tuner_gpio);
  em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
 diff -r b07848302e6c linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h Wed Feb 11 15:18:36 2009 -0200
 +++ b/linux/drivers/media/video/em28xx/em28xx.h Thu Feb 12 19:41:11 2009 +0900
@@ -101,8 +101,9 @@
 #define EM2820_BOARD_PROLINK_PLAYTV_BOX4_USB2   61
  #define EM2820_BOARD_GADMEI_TVR200    62
 #define EM2860_BOARD_KAIOMY_TVNPC_U2              63
 #define EM2860_BOARD_EASYCAP                      64
 +#define EM2820_BOARD_IODATA_GVMVP_SZ              65
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
 #define EM28XX_DEF_BUF 8


 
 

 
---------------------------------
Power up the Internet with Yahoo! Toolbar.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
