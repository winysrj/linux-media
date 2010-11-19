Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52209 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0KSXmu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:42:50 -0500
Subject: [PATCH 02/10] saa7134: use full keycode for BeholdTV
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:42:46 +0100
Message-ID: <20101119234246.3511.78869.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Using the full keycode for BeholdTV hardware makes another module
parameter unnecessary.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/keymaps/rc-behold.c        |   70 ++++++++++++++-------------
 drivers/media/video/saa7134/saa7134-input.c |   19 +------
 2 files changed, 37 insertions(+), 52 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index ae4d235..c64c356 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -29,8 +29,8 @@ static struct rc_map_table behold[] = {
 	/*  0x1c            0x12  *
 	 *  TV/FM          POWER  *
 	 *                        */
-	{ 0x1c, KEY_TUNER },	/* XXX KEY_TV / KEY_RADIO */
-	{ 0x12, KEY_POWER },
+	{ 0x6b861c, KEY_TUNER },	/* XXX KEY_TV / KEY_RADIO */
+	{ 0x6b8612, KEY_POWER },
 
 	/*  0x01    0x02    0x03  *
 	 *   1       2       3    *
@@ -41,28 +41,28 @@ static struct rc_map_table behold[] = {
 	 *  0x07    0x08    0x09  *
 	 *   7       8       9    *
 	 *                        */
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
+	{ 0x6b8601, KEY_1 },
+	{ 0x6b8602, KEY_2 },
+	{ 0x6b8603, KEY_3 },
+	{ 0x6b8604, KEY_4 },
+	{ 0x6b8605, KEY_5 },
+	{ 0x6b8606, KEY_6 },
+	{ 0x6b8607, KEY_7 },
+	{ 0x6b8608, KEY_8 },
+	{ 0x6b8609, KEY_9 },
 
 	/*  0x0a    0x00    0x17  *
 	 * RECALL    0      MODE  *
 	 *                        */
-	{ 0x0a, KEY_AGAIN },
-	{ 0x00, KEY_0 },
-	{ 0x17, KEY_MODE },
+	{ 0x6b860a, KEY_AGAIN },
+	{ 0x6b8600, KEY_0 },
+	{ 0x6b8617, KEY_MODE },
 
 	/*  0x14          0x10    *
 	 * ASPECT      FULLSCREEN *
 	 *                        */
-	{ 0x14, KEY_SCREEN },
-	{ 0x10, KEY_ZOOM },
+	{ 0x6b8614, KEY_SCREEN },
+	{ 0x6b8610, KEY_ZOOM },
 
 	/*          0x0b          *
 	 *           Up           *
@@ -73,17 +73,17 @@ static struct rc_map_table behold[] = {
 	 *         0x015          *
 	 *         Down           *
 	 *                        */
-	{ 0x0b, KEY_CHANNELUP },
-	{ 0x18, KEY_VOLUMEDOWN },
-	{ 0x16, KEY_OK },		/* XXX KEY_ENTER */
-	{ 0x0c, KEY_VOLUMEUP },
-	{ 0x15, KEY_CHANNELDOWN },
+	{ 0x6b860b, KEY_CHANNELUP },
+	{ 0x6b8618, KEY_VOLUMEDOWN },
+	{ 0x6b8616, KEY_OK },		/* XXX KEY_ENTER */
+	{ 0x6b860c, KEY_VOLUMEUP },
+	{ 0x6b8615, KEY_CHANNELDOWN },
 
 	/*  0x11            0x0d  *
 	 *  MUTE            INFO  *
 	 *                        */
-	{ 0x11, KEY_MUTE },
-	{ 0x0d, KEY_INFO },
+	{ 0x6b8611, KEY_MUTE },
+	{ 0x6b860d, KEY_INFO },
 
 	/*  0x0f    0x1b    0x1a  *
 	 * RECORD PLAY/PAUSE STOP *
@@ -92,26 +92,26 @@ static struct rc_map_table behold[] = {
 	 *TELETEXT  AUDIO  SOURCE *
 	 *           RED   YELLOW *
 	 *                        */
-	{ 0x0f, KEY_RECORD },
-	{ 0x1b, KEY_PLAYPAUSE },
-	{ 0x1a, KEY_STOP },
-	{ 0x0e, KEY_TEXT },
-	{ 0x1f, KEY_RED },	/*XXX KEY_AUDIO	*/
-	{ 0x1e, KEY_YELLOW },	/*XXX KEY_SOURCE	*/
+	{ 0x6b860f, KEY_RECORD },
+	{ 0x6b861b, KEY_PLAYPAUSE },
+	{ 0x6b861a, KEY_STOP },
+	{ 0x6b860e, KEY_TEXT },
+	{ 0x6b861f, KEY_RED },	/*XXX KEY_AUDIO	*/
+	{ 0x6b861e, KEY_YELLOW },	/*XXX KEY_SOURCE	*/
 
 	/*  0x1d   0x13     0x19  *
 	 * SLEEP  PREVIEW   DVB   *
 	 *         GREEN    BLUE  *
 	 *                        */
-	{ 0x1d, KEY_SLEEP },
-	{ 0x13, KEY_GREEN },
-	{ 0x19, KEY_BLUE },	/* XXX KEY_SAT	*/
+	{ 0x6b861d, KEY_SLEEP },
+	{ 0x6b8613, KEY_GREEN },
+	{ 0x6b8619, KEY_BLUE },	/* XXX KEY_SAT	*/
 
 	/*  0x58           0x5c   *
 	 * FREEZE        SNAPSHOT *
 	 *                        */
-	{ 0x58, KEY_SLOW },
-	{ 0x5c, KEY_CAMERA },
+	{ 0x6b8658, KEY_SLOW },
+	{ 0x6b865c, KEY_CAMERA },
 
 };
 
@@ -119,7 +119,7 @@ static struct rc_map_list behold_map = {
 	.map = {
 		.scan    = behold,
 		.size    = ARRAY_SIZE(behold),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.ir_type = IR_TYPE_NEC,
 		.name    = RC_MAP_BEHOLD,
 	}
 };
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 4fdc165..10dc9ad 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -41,11 +41,6 @@ static int pinnacle_remote;
 module_param(pinnacle_remote, int, 0644);    /* Choose Pinnacle PCTV remote */
 MODULE_PARM_DESC(pinnacle_remote, "Specify Pinnacle PCTV remote: 0=coloured, 1=grey (defaults to 0)");
 
-static unsigned int disable_other_ir;
-module_param(disable_other_ir, int, 0644);
-MODULE_PARM_DESC(disable_other_ir, "disable full codes of "
-    "alternative remotes from other manufacturers");
-
 #define dprintk(fmt, arg...)	if (ir_debug) \
 	printk(KERN_DEBUG "%s/ir: " fmt, dev->name , ## arg)
 #define i2cdprintk(fmt, arg...)    if (ir_debug) \
@@ -282,22 +277,12 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 		i2cdprintk("read error\n");
 		return -EIO;
 	}
-	/* IR of this card normally decode signals NEC-standard from
-	 * - Sven IHOO MT 5.1R remote. xxyye718
-	 * - Sven DVD HD-10xx remote. xxyyf708
-	 * - BBK ...
-	 * - mayby others
-	 * So, skip not our, if disable full codes mode.
-	 */
-	if (data[10] != 0x6b && data[11] != 0x86 && disable_other_ir)
-		return 0;
 
-	/* Wrong data decode fix */
 	if (data[9] != (unsigned char)(~data[8]))
 		return 0;
 
-	*ir_key = data[9];
-	*ir_raw = data[9];
+	*ir_raw = ((data[10] << 16) | (data[11] << 8) | (data[9] << 0));
+	*ir_key = *ir_raw;
 
 	return 1;
 }

