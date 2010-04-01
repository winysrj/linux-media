Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758765Ab0DAR61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:27 -0400
Date: Thu, 1 Apr 2010 14:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/15] V4L/DVB: saa7134: use a full scancode table for M135A
Message-ID: <20100401145632.47402b6b@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keymaps.c b/drivers/media/IR/ir-keymaps.c
index dfc777b..55e7acd 100644
--- a/drivers/media/IR/ir-keymaps.c
+++ b/drivers/media/IR/ir-keymaps.c
@@ -122,55 +122,57 @@ static struct ir_scancode ir_codes_avermedia_dvbt[] = {
 };
 IR_TABLE(avermedia_dvbt, IR_TYPE_UNKNOWN, ir_codes_avermedia_dvbt);
 
-/* Mauro Carvalho Chehab <mchehab@infradead.org> */
-static struct ir_scancode ir_codes_avermedia_m135a[] = {
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
+/*
+ * Avermedia M135A with IR model RM-JX
+ * The same codes exist on both Positivo (BR) and original IR
+ * Mauro Carvalho Chehab <mchehab@infradead.org>
+ */
+static struct ir_scancode ir_codes_avermedia_m135a_rm_jx[] = {
+	{ 0x0200, KEY_POWER2 },
+	{ 0x022e, KEY_DOT },		/* '.' */
+	{ 0x0201, KEY_MODE },		/* TV/FM or SOURCE */
+
+	{ 0x0205, KEY_1 },
+	{ 0x0206, KEY_2 },
+	{ 0x0207, KEY_3 },
+	{ 0x0209, KEY_4 },
+	{ 0x020a, KEY_5 },
+	{ 0x020b, KEY_6 },
+	{ 0x020d, KEY_7 },
+	{ 0x020e, KEY_8 },
+	{ 0x020f, KEY_9 },
+	{ 0x0211, KEY_0 },
+
+	{ 0x0213, KEY_RIGHT },		/* -> or L */
+	{ 0x0212, KEY_LEFT },		/* <- or R */
+
+	{ 0x0217, KEY_SLEEP },		/* Capturar Imagem or Snapshot */
+	{ 0x0210, KEY_SHUFFLE },	/* Amostra or 16 chan prev */
+
+	{ 0x0303, KEY_CHANNELUP },
+	{ 0x0302, KEY_CHANNELDOWN },
+	{ 0x021f, KEY_VOLUMEUP },
+	{ 0x021e, KEY_VOLUMEDOWN },
+	{ 0x020c, KEY_ENTER },		/* Full Screen */
+
+	{ 0x0214, KEY_MUTE },
+	{ 0x0208, KEY_AUDIO },
+
+	{ 0x0203, KEY_TEXT },		/* Teletext */
+	{ 0x0204, KEY_EPG },
+	{ 0x022b, KEY_TV2 },		/* TV2 or PIP */
+
+	{ 0x021d, KEY_RED },
+	{ 0x021c, KEY_YELLOW },
+	{ 0x0301, KEY_GREEN },
+	{ 0x0300, KEY_BLUE },
+
+	{ 0x021a, KEY_PLAYPAUSE },
+	{ 0x0219, KEY_RECORD },
+	{ 0x0218, KEY_PLAY },
+	{ 0x021b, KEY_STOP },
 };
-IR_TABLE(avermedia_m135a, IR_TYPE_UNKNOWN, ir_codes_avermedia_m135a);
+IR_TABLE(aver-m135a-RM-JX, IR_TYPE_NEC, ir_codes_avermedia_m135a_rm_jx);
 
 /* Oldrich Jedlicka <oldium.pro@seznam.cz> */
 static struct ir_scancode ir_codes_avermedia_cardbus[] = {
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 8c67904..d7e73de 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -524,9 +524,9 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPSTATUS0, 0x4);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M135A:
-		ir_codes     = &ir_codes_avermedia_m135a_table;
+		ir_codes     = &ir_codes_avermedia_m135a_rm_jx_table;
 		mask_keydown = 0x0040000;
-		mask_keycode = 0x00013f;
+		mask_keycode = 0xffff;
 		nec_gpio     = 1;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index c662980..c30b283 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -102,7 +102,7 @@ void ir_rc5_timer_keyup(unsigned long data);
 extern struct ir_scancode_table ir_codes_empty_table;
 extern struct ir_scancode_table ir_codes_avermedia_table;
 extern struct ir_scancode_table ir_codes_avermedia_dvbt_table;
-extern struct ir_scancode_table ir_codes_avermedia_m135a_table;
+extern struct ir_scancode_table ir_codes_avermedia_m135a_rm_jx_table;
 extern struct ir_scancode_table ir_codes_avermedia_cardbus_table;
 extern struct ir_scancode_table ir_codes_apac_viewcomp_table;
 extern struct ir_scancode_table ir_codes_pixelview_table;
-- 
1.6.6.1


