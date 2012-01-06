Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42253 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab2AFVe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 16:34:58 -0500
Received: by eaad14 with SMTP id d14so1203104eaa.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 13:34:57 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------hr2nORpFtW9dHl6Tva8t5u
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] rc-videomate-m1f.c Rename to match remote controler name
References: <op.v7n77sv031sqp4@00-25-22-b5-7b-09.dummy.porta.siemens.net>
Date: Fri, 06 Jan 2012 22:34:53 +0100
MIME-Version: 1.0
From: =?utf-8?B?U2FtdWVsIFJha2l0bmnEjWFu?= <samuel.rakitnican@gmail.com>
Message-ID: <op.v7ol8fr731sqp4@00-25-22-b5-7b-09.dummy.porta.siemens.net>
In-Reply-To: <op.v7n77sv031sqp4@00-25-22-b5-7b-09.dummy.porta.siemens.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------------hr2nORpFtW9dHl6Tva8t5u
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

On Fri, 06 Jan 2012 17:32:06 +0100, Samuel Rakitni=C4=8Dan  =

<samuel.rakitnican@gmail.com> wrote:

> This remote was added with support for card Compro VideoMate M1F.
>
> This remote is shipped with various Compro cards, not this one only.
>
> Furthermore this remote can be bought separately under name Compro
> VideoMate K100.
> 	http://compro.com.tw/en/product/k100/k100.html
>
> So give it a proper name.
>
>
> Signed-off-by: Samuel Rakitni=C4=8Dan <samuel.rakitnican@gmail.com>

Resending a mail version for patchwork..
------------hr2nORpFtW9dHl6Tva8t5u
Content-Disposition: attachment; filename=k100.diff
Content-Type: text/plain; name=k100.diff
Content-Transfer-Encoding: 7bit

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 36e4d5e..82d898a 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -85,7 +85,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-trekstor.o \
 			rc-tt-1500.o \
 			rc-twinhan1027.o \
-			rc-videomate-m1f.o \
+			rc-videomate-k100.o \
 			rc-videomate-s350.o \
 			rc-videomate-tv-pvr.o \
 			rc-winfast.o \
diff --git a/drivers/media/rc/keymaps/rc-videomate-k100.c b/drivers/media/rc/keymaps/rc-videomate-k100.c
index 3bd1de1..23ee05e 100644
--- a/drivers/media/rc/keymaps/rc-videomate-k100.c
+++ b/drivers/media/rc/keymaps/rc-videomate-k100.c
@@ -1,4 +1,4 @@
-/* videomate-m1f.h - Keytable for videomate_m1f Remote Controller
+/* videomate-k100.h - Keytable for videomate_k100 Remote Controller
  *
  * keymap imported from ir-keymaps.c
  *
@@ -13,7 +13,7 @@
 #include <media/rc-map.h>
 #include <linux/module.h>
 
-static struct rc_map_table videomate_m1f[] = {
+static struct rc_map_table videomate_k100[] = {
 	{ 0x01, KEY_POWER },
 	{ 0x31, KEY_TUNER },
 	{ 0x33, KEY_VIDEO },
@@ -67,27 +67,27 @@ static struct rc_map_table videomate_m1f[] = {
 	{ 0x18, KEY_TEXT },
 };
 
-static struct rc_map_list videomate_m1f_map = {
+static struct rc_map_list videomate_k100_map = {
 	.map = {
-		.scan    = videomate_m1f,
-		.size    = ARRAY_SIZE(videomate_m1f),
+		.scan    = videomate_k100,
+		.size    = ARRAY_SIZE(videomate_k100),
 		.rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
-		.name    = RC_MAP_VIDEOMATE_M1F,
+		.name    = RC_MAP_VIDEOMATE_K100,
 	}
 };
 
-static int __init init_rc_map_videomate_m1f(void)
+static int __init init_rc_map_videomate_k100(void)
 {
-	return rc_map_register(&videomate_m1f_map);
+	return rc_map_register(&videomate_k100_map);
 }
 
-static void __exit exit_rc_map_videomate_m1f(void)
+static void __exit exit_rc_map_videomate_k100(void)
 {
-	rc_map_unregister(&videomate_m1f_map);
+	rc_map_unregister(&videomate_k100_map);
 }
 
-module_init(init_rc_map_videomate_m1f)
-module_exit(exit_rc_map_videomate_m1f)
+module_init(init_rc_map_videomate_k100)
+module_exit(exit_rc_map_videomate_k100)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pavel Osnova <pvosnova@gmail.com>");
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 1b15b0d..22ecd72 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -755,7 +755,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		polling      = 50; /* ms */
 		break;
 	case SAA7134_BOARD_VIDEOMATE_M1F:
-		ir_codes     = RC_MAP_VIDEOMATE_M1F;
+		ir_codes     = RC_MAP_VIDEOMATE_K100;
 		mask_keycode = 0x0ff00;
 		mask_keyup   = 0x040000;
 		break;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 183d701..f688bde 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -147,7 +147,7 @@ void rc_map_init(void);
 #define RC_MAP_TREKSTOR                  "rc-trekstor"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
 #define RC_MAP_TWINHAN_VP1027_DVBS       "rc-twinhan1027"
-#define RC_MAP_VIDEOMATE_M1F             "rc-videomate-m1f"
+#define RC_MAP_VIDEOMATE_K100            "rc-videomate-k100"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"

------------hr2nORpFtW9dHl6Tva8t5u--

