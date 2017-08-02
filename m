Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35554 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbdHBUav (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 16:30:51 -0400
Received: by mail-pg0-f44.google.com with SMTP id v189so25432030pgd.2
        for <linux-media@vger.kernel.org>; Wed, 02 Aug 2017 13:30:51 -0700 (PDT)
Received: from [192.168.0.21] (wsip-68-15-115-196.ok.ok.cox.net. [68.15.115.196])
        by smtp.googlemail.com with ESMTPSA id q89sm42334474pfd.156.2017.08.02.13.30.49
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Aug 2017 13:30:49 -0700 (PDT)
To: linux-media <linux-media@vger.kernel.org>
From: Perry Gilfillan <tuxokc@gmail.com>
Subject: Revisiting the Digiflower DVR2000B capture card
Message-ID: <232138d2-48ed-4f91-787e-3ceab4fcc02d@gmail.com>
Date: Wed, 2 Aug 2017 15:30:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many years ago when the 2.6 kernel was all the rage I had a working 
patch to support this card:

https://wiki.zoneminder.com/Digiflower

With the latest Fedora 26 kernel sources with the following patch 
applied, the wired input and logical source are scrambled and I don't 
know what changed.

Fanout                        Fanout
Input  Camera  Source         Input  Camera  Source
1      .....   videoX(??)      9     .....   videoX(??)
2      .....   videoX(4)      10     .....   videoX(12)
3      porch   videoX(3)      11     solar videoX(11)
4      .....   videoX(2)      12     .....   videoX(10)
5      .....   videoX(1)      13     .....   videoX(9)
6      .....   videoX(0)      14     .....   videoX(8)
7      .....   videoX(6)      15     south   videoX(13)
8      north   videoX(5)      16     .....   videoX(14)

Inputs 1 and 9 (Source 7 and 15) simply don't work at all, and they are 
all out of order.

What am I not doing, or what changed?

Any help will be much appreciated!



--- media_build/linux/drivers/media/pci/bt8xx/bttv-cards.c 2016-12-24 
19:07:32.963090964 -0600
+++ media_build.digiflower/linux/drivers/media/pci/bt8xx/bttv-cards.c 
2016-12-24 16:58:34.689715697 -0600
@@ -90,6 +90,8 @@ static void identify_by_eeprom(struct bt
                     unsigned char eeprom_data[256]);
  static int pvr_boot(struct bttv *btv);

+static void digiflower_dvr2000b_muxsel(struct bttv *btv, unsigned int 
input);
+
  /* config variables */
  static unsigned int triton1;
  static unsigned int vsfx;
@@ -344,6 +346,7 @@ static struct CARD {
      { 0x15401837, BTTV_BOARD_PV183,         "Provideo PV183-8" },
      { 0x3116f200, BTTV_BOARD_TVT_TD3116,    "Tongwei Video Technology 
TD-3116" },
      { 0x02280279, BTTV_BOARD_APOSONIC_WDVR, "Aposonic W-DVR" },
+    { 0x00000000, BTTV_BOARD_DIGIFLOWER_DVR2000B, "Digi-Flower DVR2000B" },
      { 0, -1, NULL }
  };

@@ -2885,6 +2888,25 @@ struct tvcard bttv_tvcards[] = {
          .no_tda7432    = 1,
          .pll            = PLL_35,
      },
+    [BTTV_BOARD_DIGIFLOWER_DVR2000B] = {
+        .name           = "Digi-Flower DVR2000B (master?)",
+        .video_inputs   = 16,
+        /* .audio_inputs   = 0, */
+        /* .tuner          = UNSET, */
+        .svhs           = NO_SVHS,
+        .tuner_type    = TUNER_ABSENT,
+        .tuner_addr    = ADDR_UNSET,
+        /* .radio_addr    = ADDR_UNSET, */
+        .no_gpioirq    = 1,
+//        .gpiomask    = 0x0,
+        .gpiomask2    = 0x140007,
+        .muxsel        = MUXSEL ( 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 
2, 2, 2, 2 ),
+        .muxsel_hook    = digiflower_dvr2000b_muxsel,
+        .gpiomux    = { 0, 0, 0, 0 }, /* card has no audio */
+        .no_msp34xx    = 1,
+        .no_tda7432    = 1,
+        .pll            = PLL_28,
+    },
  };

  static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
@@ -4868,6 +4894,21 @@ static void gv800s_init(struct bttv *btv
      master[btv->c.nr+3] = btv;
  }

+/* DB1 = Top connector fan-out.  DB2 = Bottom connector fan-out. */
+#define DB1    0x100000
+#define DB2    0x040000
+
+static void digiflower_dvr2000b_muxsel(struct bttv *btv, unsigned int 
input)
+{
+    static const int masks[] = {
+        DB1,   DB1|1, DB1|2, DB1|3,
+        DB1|4, DB1|5, DB1|6, DB1|7,
+        DB2,   DB2|1, DB2|2, DB2|3,
+        DB2|4, DB2|5, DB2|6, DB2|7,
+    };
+    gpio_write(masks[input%16]);
+}
+
  /* 
----------------------------------------------------------------------- */
  /* motherboard chipset specific 
stuff                                      */

--- media_build/linux/drivers/media/pci/bt8xx/bttv.h 2016-08-22 
03:58:36.000000000 -0500
+++ media_build.digiflower/linux/drivers/media/pci/bt8xx/bttv.h 
2016-12-24 16:59:38.365786180 -0600
@@ -190,6 +190,7 @@
  #define BTTV_BOARD_CYBERVISION_CV06        0xa4
  #define BTTV_BOARD_KWORLD_VSTREAM_XPERT    0xa5
  #define BTTV_BOARD_PCI_8604PW              0xa6
+#define BTTV_BOARD_DIGIFLOWER_DVR2000B     0xa7

  /* more card-specific defines */
  #define PT2254_L_CHANNEL 0x10
