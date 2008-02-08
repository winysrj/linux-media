Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m18HbtJ1020327
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 12:37:55 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.250])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m18HbY3c010374
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 12:37:34 -0500
Received: by an-out-0708.google.com with SMTP id c31so1748306ana.124
	for <video4linux-list@redhat.com>; Fri, 08 Feb 2008 09:37:29 -0800 (PST)
Message-ID: <9c4b1d600802080937h3dbbb388s9abb760feb084f4@mail.gmail.com>
Date: Fri, 8 Feb 2008 15:37:28 -0200
From: "Adrian Pardini" <pardo.bsso@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1202429587.20032.75.camel@pc08.localdom.local>
MIME-Version: 1.0
References: <9c4b1d600802071009q7fc69d4cj88c3ec2586e484a0@mail.gmail.com>
	<20080207173926.53b9e0ce@gaivota>
	<1202421849.20032.25.camel@pc08.localdom.local>
	<9c4b1d600802071528p70de4e55ud582ef66d9ebb3d7@mail.gmail.com>
	<1202429587.20032.75.camel@pc08.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] New card entry (saa7134) and FM support for TNF9835
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

Hello,
As hermann suggested I removed the tuner stuff and switched to the TNF5335
(tuner=69), and left only the TV(mono) input. Also I made some cosmetic
changes to comply with the CodingStyle rules.

Hope everything is ok.
Cheers,
Adrian.

---
diff -uprN -X dontdiff
v4l-dvb/linux/Documentation/video4linux/CARDLIST.saa7134
v4l-dvb-modified/linux/Documentation/video4linux/CARDLIST.saa7134
--- v4l-dvb/linux/Documentation/video4linux/CARDLIST.saa7134    2008-02-06
22:54:07.000000000 -0200
+++ v4l-dvb-modified/linux/Documentation/video4linux/CARDLIST.saa7134
2008-02-08 14:54:51.000000000 -0200
@@ -130,3 +130,4 @@
 129 -> Beholder BeholdTV 607 / BeholdTV 609
[5ace:6070,5ace:6071,5ace:6072,5ace:6073,5ace:6090,5ace:6091,5ace:6092,5ace:6093]
 130 -> Beholder BeholdTV M6 / BeholdTV M6 Extra [5ace:6190,5ace:6193]
 131 -> Twinhan Hybrid DTV-DVB 3056 PCI          [1822:0022]
+132 -> Genius TVGO AM11MCE
diff -uprN -X dontdiff
v4l-dvb/linux/drivers/media/common/ir-keymaps.cv4l-dvb-modified/linux/drivers/media/common/ir-
keymaps.c
--- v4l-dvb/linux/drivers/media/common/ir-keymaps.c    2008-02-06 22:54:
07.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/common/ir-keymaps.c    2008-02-08
14:54:51.000000000 -0200
@@ -2037,3 +2037,49 @@ IR_KEYTAB_TYPE ir_codes_behold[IR_KEYTAB
 };

 EXPORT_SYMBOL_GPL(ir_codes_behold);
+
+/*
+ * Remote control for the Genius TVGO A11MCE
+ * Adrian Pardini <pardo.bsso@gmail.com>
+ */
+IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE] = {
+    /* Keys 0 to 9 */
+    [0x48] = KEY_0,
+    [0x09] = KEY_1,
+    [0x1d] = KEY_2,
+    [0x1f] = KEY_3,
+    [0x19] = KEY_4,
+    [0x1b] = KEY_5,
+    [0x11] = KEY_6,
+    [0x17] = KEY_7,
+    [0x12] = KEY_8,
+    [0x16] = KEY_9,
+
+    [0x54] = KEY_RECORD,        /* recording */
+    [0x06] = KEY_MUTE,        /* mute */
+    [0x10] = KEY_POWER,
+    [0x40] = KEY_LAST,        /* recall */
+    [0x4c] = KEY_CHANNELUP,        /* channel / program + */
+    [0x00] = KEY_CHANNELDOWN,    /* channel / program - */
+    [0x0d] = KEY_VOLUMEUP,
+    [0x15] = KEY_VOLUMEDOWN,
+    [0x4d] = KEY_OK,        /* also labeled as Pause */
+    [0x1c] = KEY_ZOOM,        /* full screen and Stop*/
+    [0x02] = KEY_MODE,        /* AV Source or Rewind*/
+    [0x04] = KEY_LIST,        /* -/-- */
+    /* small arrows above numbers */
+    [0x1a] = KEY_NEXT,        /* also Fast Forward */
+    [0x0e] = KEY_PREVIOUS,    /* also Rewind */
+    /* these are in a rather non standard layout and have
+    an alternate name written */
+    [0x1e] = KEY_UP,        /* Video Setting */
+    [0x0a] = KEY_DOWN,        /* Video Default */
+    [0x05] = KEY_LEFT,        /* Snapshot */
+    [0x0c] = KEY_RIGHT,        /* Hide Panel */
+    /* Four buttons without label */
+    [0x49] = KEY_RED,
+    [0x0b] = KEY_GREEN,
+    [0x13] = KEY_YELLOW,
+    [0x50] = KEY_BLUE,
+};
+EXPORT_SYMBOL_GPL(ir_codes_genius_tvgo_a11mce);
diff -uprN -X dontdiff v4l-dvb/linux/drivers/media/video/saa7134/saa7134-
cards.c v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134-cards.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c    2008-02-06
22:54:10.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134-cards.c
2008-02-08 14:57:07.000000000 -0200
@@ -3992,6 +3992,44 @@ struct saa7134_board saa7134_boards[] =
             .gpio   = 0x0200000,
         },
     },
+    [SAA7134_BOARD_GENIUS_TVGO_A11MCE] = {
+        /* Adrian Pardini <pardo.bsso@gmail.com> */
+        .name        = "Genius TVGO AM11MCE",
+        .audio_clock    = 0x00200000,
+        .tuner_type    = TUNER_TNF_5335MF,
+        .radio_type     = UNSET,
+        .tuner_addr    = ADDR_UNSET,
+        .radio_addr    = ADDR_UNSET,
+        .gpiomask       = 0xf000,
+        .inputs         = {{
+            .name = name_tv_mono,
+            .vmux = 1,
+            .amux = LINE2,
+            .gpio = 0x0000,
+            .tv   = 1,
+        }, {
+            .name = name_comp1,
+            .vmux = 3,
+            .amux = LINE1,
+            .gpio = 0x2000,
+            .tv = 1
+        }, {
+            .name = name_svideo,
+            .vmux = 8,
+            .amux = LINE1,
+            .gpio = 0x2000,
+    } },
+        .radio = {
+            .name = name_radio,
+            .amux = LINE2,
+            .gpio = 0x1000,
+        },
+        .mute = {
+            .name = name_mute,
+            .amux = LINE2,
+            .gpio = 0x6000,
+        },
+    },
 };

 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5130,6 +5168,7 @@ int saa7134_board_init1(struct saa7134_d
     case SAA7134_BOARD_BEHOLD_409:
     case SAA7134_BOARD_BEHOLD_505FM:
     case SAA7134_BOARD_BEHOLD_507_9FM:
+    case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
         dev->has_remote = SAA7134_REMOTE_GPIO;
         break;
     case SAA7134_BOARD_FLYDVBS_LR300:
diff -uprN -X dontdiff v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h
v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134.h
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h    2008-02-06 22:54:
10.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134.h
2008-02-08 14:35:55.000000000 -0200
@@ -260,6 +260,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_607_9FM    129
 #define SAA7134_BOARD_BEHOLD_M6        130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
+#define SAA7134_BOARD_GENIUS_TVGO_A11MCE 132

 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8
diff -uprN -X dontdiff v4l-dvb/linux/drivers/media/video/saa7134/saa7134-
input.c v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134-input.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c    2008-02-06
22:54:10.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134-input.c
2008-02-08 14:37:40.000000000 -0200
@@ -406,6 +406,12 @@ int saa7134_input_init1(struct saa7134_d
         mask_keyup   = 0x8000000;
         polling      = 50; //ms
         break;
+    case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
+        ir_codes     = ir_codes_genius_tvgo_a11mce;
+        mask_keycode = 0xff;
+        mask_keydown = 0xf00000;
+        polling = 50; /* ms */
+        break;
     }
     if (NULL == ir_codes) {
         printk("%s: Oops: IR config error [card=%d]\n",
diff -uprN -X dontdiff
v4l-dvb/linux/include/media/ir-common.hv4l-dvb-modified/linux/include/media/ir-
common.h
--- v4l-dvb/linux/include/media/ir-common.h    2008-02-06
22:54:11.000000000-0200
+++ v4l-dvb-modified/linux/include/media/ir-common.h    2008-02-08 14:38:
37.000000000 -0200
@@ -142,6 +142,7 @@ extern IR_KEYTAB_TYPE ir_codes_tt_1500[I
 extern IR_KEYTAB_TYPE ir_codes_fusionhdtv_mce[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_behold[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pinnacle_pctv_hd[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE];

 #endif
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
