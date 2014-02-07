Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:35294 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBGR4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 12:56:21 -0500
Received: by mail-ea0-f179.google.com with SMTP id q10so1463728ead.10
        for <linux-media@vger.kernel.org>; Fri, 07 Feb 2014 09:56:20 -0800 (PST)
Received: from [192.168.1.100] ([188.24.80.42])
        by mx.google.com with ESMTPSA id d9sm18991626eei.9.2014.02.07.09.56.18
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 07 Feb 2014 09:56:19 -0800 (PST)
Message-ID: <52F51E41.7000000@gmail.com>
Date: Fri, 07 Feb 2014 19:56:17 +0200
From: GEORGE <geoubuntu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] bttv: Add support for Kworld V-Stream Xpert TV PVR878
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 From 27c5541a93bee007d41a70b393c97ea19c62ace2 Mon Sep 17 00:00:00 2001
From: POJAR GEORGE <geoubuntu@gmail.com>
Date: Fri, 7 Feb 2014 19:34:41 +0200
Subject: [PATCH] bttv: Add support for Kworld V-Stream Xpert TV PVR878

Signed-off-by: POJAR GEORGE <geoubuntu@gmail.com>
---
  Documentation/video4linux/CARDLIST.bttv |  1 +
  drivers/media/video/bt8xx/bttv-cards.c  | 16 ++++++++++++++++
  drivers/media/video/bt8xx/bttv-input.c  |  1 +
  drivers/media/video/bt8xx/bttv.h        |  1 +
  4 files changed, 19 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.bttv 
b/Documentation/video4linux/CARDLIST.bttv
index 4739d56..0103fe4 100644
--- a/Documentation/video4linux/CARDLIST.bttv
+++ b/Documentation/video4linux/CARDLIST.bttv
@@ -158,3 +158,4 @@
  157 -> Geovision GV-800(S) (master) [800a:763d]
  158 -> Geovision GV-800(S) (slave) [800b:763d,800c:763d,800d:763d]
  159 -> ProVideo PV183 
[1830:1540,1831:1540,1832:1540,1833:1540,1834:1540,1835:1540,1836:1540,1837:1540]
+160 -> Kworld V-Stream Xpert TV PVR878
diff --git a/drivers/media/video/bt8xx/bttv-cards.c 
b/drivers/media/video/bt8xx/bttv-cards.c
index 49efcf6..7e02b8e 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -2916,6 +2916,22 @@ struct tvcard bttv_tvcards[] = {
          .tuner_type     = TUNER_ABSENT,
          .tuner_addr    = ADDR_UNSET,
      },
+    [BTTV_BOARD_KWORLD_VSTREAM_XPERT] = {
+        /* POJAR GEORGE <geoubuntu@gmail.com> */
+        .name           = "Kworld V-Stream Xpert TV PVR878",
+        .video_inputs   = 3,
+        /* .audio_inputs= 1, */
+        .svhs           = 2,
+        .gpiomask       = 0x001c0007,
+        .muxsel         = MUXSEL(2, 3, 1, 1),
+        .gpiomux        = { 0, 1, 2, 2 },
+        .gpiomute     = 3,
+        .pll            = PLL_28,
+        .tuner_type     = TUNER_TENA_9533_DI,
+        .tuner_addr    = ADDR_UNSET,
+        .has_remote     = 1,
+        .has_radio      = 1,
+    },
  };

  static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
diff --git a/drivers/media/video/bt8xx/bttv-input.c 
b/drivers/media/video/bt8xx/bttv-input.c
index 6bf05a7..3af1e23 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -391,6 +391,7 @@ int bttv_input_init(struct bttv *btv)
      case BTTV_BOARD_ASKEY_CPH03X:
      case BTTV_BOARD_CONCEPTRONIC_CTVFMI2:
      case BTTV_BOARD_CONTVFMI:
+    case BTTV_BOARD_KWORLD_VSTREAM_XPERT:
          ir_codes         = RC_MAP_PIXELVIEW;
          ir->mask_keycode = 0x001F00;
          ir->mask_keyup   = 0x006000;
diff --git a/drivers/media/video/bt8xx/bttv.h 
b/drivers/media/video/bt8xx/bttv.h
index 6fd2a8e..dd926d8 100644
--- a/drivers/media/video/bt8xx/bttv.h
+++ b/drivers/media/video/bt8xx/bttv.h
@@ -184,6 +184,7 @@
  #define BTTV_BOARD_GEOVISION_GV800S       0x9d
  #define BTTV_BOARD_GEOVISION_GV800S_SL       0x9e
  #define BTTV_BOARD_PV183                   0x9f
+#define BTTV_BOARD_KWORLD_VSTREAM_XPERT    0xa0


  /* more card-specific defines */
-- 
1.9.rc1

