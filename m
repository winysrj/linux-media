Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:41292 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab0CSSWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 14:22:35 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7134: add support for one more remote control for Avermedia M135A
Date: Fri, 19 Mar 2010 14:55:46 -0300
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Message-Id: <201003191455.46559.herton@mandriva.com.br>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change adds support for one more remote control type for Avermedia
M135A. The new remote control reports slightly different codes, and was
necessary to extend the mask_keycode to differentiate between original
remote control. One of the remote controls I had matched the original
binding, but some keys reported duplicated codes, probably because the
previous mask_keycode missing valid bits, so this should fix also
original remote control support ("The keys bellow aren't ok" comment).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/media/IR/ir-keymaps.c               |  141 +++++++++++++++++++---------
 drivers/media/video/saa7134/saa7134-input.c |    2 
 2 files changed, 97 insertions(+), 46 deletions(-)

(sorry this is a resend of previous patch, I forgot [PATCH] in subject)

diff -p -up linux-2.6.33.1-1.1mnb/drivers/media/IR/ir-keymaps.c.orig linux-2.6.33.1-1.1mnb/drivers/media/IR/ir-keymaps.c
--- linux-2.6.33.1-1.1mnb/drivers/media/IR/ir-keymaps.c.orig	2010-03-18 22:25:12.000000000 -0300
+++ linux-2.6.33.1-1.1mnb/drivers/media/IR/ir-keymaps.c	2010-03-18 22:46:29.000000000 -0300
@@ -122,51 +122,102 @@ EXPORT_SYMBOL_GPL(ir_codes_avermedia_dvb
 
 /* Mauro Carvalho Chehab <mchehab@infradead.org> */
 static struct ir_scancode ir_codes_avermedia_m135a[] = {
-	{ 0x00, KEY_POWER2 },
-	{ 0x2e, KEY_DOT },		/* '.' */
-	{ 0x01, KEY_MODE },		/* TV/FM */
-
-	{ 0x05, KEY_1 },
-	{ 0x06, KEY_2 },
-	{ 0x07, KEY_3 },
-	{ 0x09, KEY_4 },
-	{ 0x0a, KEY_5 },
-	{ 0x0b, KEY_6 },
-	{ 0x0d, KEY_7 },
-	{ 0x0e, KEY_8 },
-	{ 0x0f, KEY_9 },
-	{ 0x11, KEY_0 },
-
-	{ 0x13, KEY_RIGHT },		/* -> */
-	{ 0x12, KEY_LEFT },		/* <- */
-
-	{ 0x17, KEY_SLEEP },		/* Capturar Imagem */
-	{ 0x10, KEY_SHUFFLE },		/* Amostra */
-
-	/* FIXME: The keys bellow aren't ok */
-
-	{ 0x43, KEY_CHANNELUP },
-	{ 0x42, KEY_CHANNELDOWN },
-	{ 0x1f, KEY_VOLUMEUP },
-	{ 0x1e, KEY_VOLUMEDOWN },
-	{ 0x0c, KEY_ENTER },
-
-	{ 0x14, KEY_MUTE },
-	{ 0x08, KEY_AUDIO },
-
-	{ 0x03, KEY_TEXT },
-	{ 0x04, KEY_EPG },
-	{ 0x2b, KEY_TV2 },		/* TV2 */
-
-	{ 0x1d, KEY_RED },
-	{ 0x1c, KEY_YELLOW },
-	{ 0x41, KEY_GREEN },
-	{ 0x40, KEY_BLUE },
-
-	{ 0x1a, KEY_PLAYPAUSE },
-	{ 0x19, KEY_RECORD },
-	{ 0x18, KEY_PLAY },
-	{ 0x1b, KEY_STOP },
+	/* Remote control type 01 (32/54 keys) */
+	{ 0x100, KEY_POWER2 },
+	{ 0x12e, KEY_DOT },		/* '.' */
+	{ 0x101, KEY_MODE },		/* TV/FM */
+
+	{ 0x105, KEY_1 },
+	{ 0x106, KEY_2 },
+	{ 0x107, KEY_3 },
+	{ 0x109, KEY_4 },
+	{ 0x10a, KEY_5 },
+	{ 0x10b, KEY_6 },
+	{ 0x10d, KEY_7 },
+	{ 0x10e, KEY_8 },
+	{ 0x10f, KEY_9 },
+	{ 0x111, KEY_0 },
+
+	{ 0x113, KEY_RIGHT },		/* -> */
+	{ 0x112, KEY_LEFT },		/* <- */
+
+	{ 0x117, KEY_SHUFFLE },		/* Capturar Imagem */
+	{ 0x110, KEY_F13 },		/* Amostra */
+
+	{ 0x183, KEY_CHANNELUP },
+	{ 0x182, KEY_CHANNELDOWN },
+	{ 0x11f, KEY_VOLUMEUP },
+	{ 0x11e, KEY_VOLUMEDOWN },
+	{ 0x10c, KEY_ENTER },
+
+	{ 0x114, KEY_MUTE },
+	{ 0x108, KEY_AUDIO },
+
+	{ 0x103, KEY_TEXT },
+	{ 0x104, KEY_EPG },
+	{ 0x12b, KEY_TV2 },		/* TV2 */
+
+	{ 0x11d, KEY_RED },
+	{ 0x11c, KEY_YELLOW },
+	{ 0x181, KEY_GREEN },
+	{ 0x180, KEY_BLUE },
+
+	{ 0x11a, KEY_PLAYPAUSE },
+	{ 0x119, KEY_RECORD },
+	{ 0x118, KEY_PLAY },
+	{ 0x11b, KEY_STOP },
+
+	/* Remote control type 04 (44 keys) */
+	{ 0x201, KEY_POWER2 },
+	{ 0x206, KEY_MUTE },
+	{ 0x208, KEY_MODE },
+
+	{ 0x209, KEY_1 },
+	{ 0x20a, KEY_2 },
+	{ 0x20b, KEY_3 },
+	{ 0x20c, KEY_4 },
+	{ 0x20d, KEY_5 },
+	{ 0x20e, KEY_6 },
+	{ 0x20f, KEY_7 },
+	{ 0x210, KEY_8 },
+	{ 0x211, KEY_9 },
+	{ 0x24c, KEY_DOT },
+	{ 0x212, KEY_0 },
+	{ 0x207, KEY_LAST },
+
+	{ 0x213, KEY_AUDIO },
+	{ 0x240, KEY_ZOOM },
+	{ 0x241, KEY_HOME },
+	{ 0x242, KEY_BACK },
+	{ 0x247, KEY_UP },
+	{ 0x248, KEY_DOWN },
+	{ 0x249, KEY_LEFT },
+	{ 0x24a, KEY_RIGHT },
+	{ 0x24b, KEY_OK },
+	{ 0x204, KEY_VOLUMEUP },
+	{ 0x205, KEY_VOLUMEDOWN },
+	{ 0x202, KEY_CHANNELUP },
+	{ 0x203, KEY_CHANNELDOWN },
+
+	{ 0x243, KEY_TV },
+	{ 0x244, KEY_VIDEO },
+	{ 0x245, KEY_MP3 },
+	{ 0x246, KEY_MHP },
+
+	{ 0x214, KEY_TEXT },
+	{ 0x215, KEY_EPG },
+	{ 0x21a, KEY_MEDIA },
+	{ 0x21b, KEY_SHUFFLE },
+
+	{ 0x217, KEY_RECORD },
+	{ 0x216, KEY_PLAYPAUSE },
+	{ 0x218, KEY_STOP },
+	{ 0x219, KEY_PAUSE },
+
+	{ 0x21f, KEY_PREVIOUS },
+	{ 0x21d, KEY_REWIND },
+	{ 0x21c, KEY_FORWARD },
+	{ 0x21e, KEY_NEXT },
 };
 
 struct ir_scancode_table ir_codes_avermedia_m135a_table = {
diff -p -up linux-2.6.33.1-1.1mnb/drivers/media/video/saa7134/saa7134-input.c.orig linux-2.6.33.1-1.1mnb/drivers/media/video/saa7134/saa7134-input.c
--- linux-2.6.33.1-1.1mnb/drivers/media/video/saa7134/saa7134-input.c.orig	2010-03-18 22:23:50.000000000 -0300
+++ linux-2.6.33.1-1.1mnb/drivers/media/video/saa7134/saa7134-input.c	2010-03-18 23:40:01.000000000 -0300
@@ -523,7 +523,7 @@ int saa7134_input_init1(struct saa7134_d
 	case SAA7134_BOARD_AVERMEDIA_M135A:
 		ir_codes     = &ir_codes_avermedia_m135a_table;
 		mask_keydown = 0x0040000;
-		mask_keycode = 0x00013f;
+		mask_keycode = 0x00077f;
 		nec_gpio     = 1;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
