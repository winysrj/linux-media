Return-path: <mchehab@pedra>
Received: from realvnc.com ([146.101.152.142]:52659 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0JTLOF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 07:14:05 -0400
Received: from localhost ([127.0.0.1] helo=grape.realvnc.ltd)
	by realvnc.com with esmtp (Exim 4.71)
	(envelope-from <adrian.taylor@realvnc.com>)
	id 1P8WKU-0007L7-SQ
	for linux-media@vger.kernel.org; Wed, 20 Oct 2010 11:55:35 +0100
Received: from [192.168.0.181] (clove.realvnc.ltd [192.168.0.181])
	by grape.realvnc.ltd (8.13.7/8.13.7) with ESMTP id o9KAtXM9015797
	for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 11:55:33 +0100
Message-ID: <4CBECAA5.9060804@realvnc.com>
Date: Wed, 20 Oct 2010 11:55:33 +0100
From: Adrian Taylor <adrian.taylor@realvnc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Support for Elgato Video Capture
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch allows this device successfully to show video, at least from
its composite input.

I have no information about the true hardware contents of this device and so
this patch is based solely on fiddling with things until it worked. The
chip appears to be em2860, and the closest device with equivalent inputs
is the Typhoon DVD Maker. Copying the settings for that device appears
to do the trick. That's what this patch does.

Signed-off-by: Adrian Taylor <adrian.taylor@realvnc.com>

---
  drivers/media/video/em28xx/em28xx-cards.c |   16 ++++++++++++++++
  drivers/media/video/em28xx/em28xx.h       |    1 +
  2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c 
b/drivers/media/video/em28xx/em28xx-cards.c
index 3a4fd85..5806f62 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1667,6 +1667,20 @@ struct em28xx_board em28xx_boards[] = {
         .tuner_gpio    = reddo_dvb_c_usb_box,
         .has_dvb       = 1,
     },
+   [EM2860_BOARD_ELGATO_VIDEO_CAPTURE] = {
+       .name         = "Elgato Video Capture",
+       .decoder      = EM28XX_SAA711X,
+       .tuner_type   = TUNER_ABSENT,   /* Capture only device */
+       .input        = { {
+           .type  = EM28XX_VMUX_COMPOSITE1,
+           .vmux  = SAA7115_COMPOSITE0,
+           .amux  = EM28XX_AMUX_LINE_IN,
+       }, {
+           .type  = EM28XX_VMUX_SVIDEO,
+           .vmux  = SAA7115_SVIDEO3,
+           .amux  = EM28XX_AMUX_LINE_IN,
+       } },
+   },
  };
  const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);

@@ -1788,6 +1802,8 @@ struct usb_device_id em28xx_id_table[] = {
             .driver_info = EM2820_BOARD_IODATA_GVMVP_SZ },
     { USB_DEVICE(0xeb1a, 0x50a6),
             .driver_info = EM2860_BOARD_GADMEI_UTV330 },
+   { USB_DEVICE(0x0fd9, 0x0033),
+           .driver_info = EM2860_BOARD_ELGATO_VIDEO_CAPTURE},
     { },
  };
  MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/video/em28xx/em28xx.h 
b/drivers/media/video/em28xx/em28xx.h
index b252d1b..23733b8 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -113,6 +113,7 @@
  #define EM2870_BOARD_REDDO_DVB_C_USB_BOX          73
  #define EM2800_BOARD_VC211A              74
  #define EM2882_BOARD_DIKOM_DK300         75
+#define EM2860_BOARD_ELGATO_VIDEO_CAPTURE         76

  /* Limits minimum and default number of buffers */
  #define EM28XX_MIN_BUF 4
-- 
1.7.0.4

