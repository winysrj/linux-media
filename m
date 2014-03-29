Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38315 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaC2QLd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 12:11:33 -0400
Subject: [PATCH 09/11] saa7134: NEC scancode fix
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: james.hogan@imgtec.com, m.chehab@samsung.com
Date: Sat, 29 Mar 2014 17:11:31 +0100
Message-ID: <20140329161131.13234.4806.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver codes the two address bytes in reverse order when compared to the
other drivers, so make it consistent (and update the keymap, note that the
result is a prefix change from 0x6b86 -> 0x866b, and the latter is pretty
common among the NECX keymaps. While not conclusive, it's still a strong hint
that the change is correct).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/pci/saa7134/saa7134-input.c |    2 -
 drivers/media/rc/keymaps/rc-behold.c      |   68 +++++++++++++++--------------
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 43dd8bd..887429b 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -346,7 +346,7 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
 		return 0;
 
 	*protocol = RC_TYPE_NEC;
-	*scancode = RC_SCANCODE_NECX(((data[10] << 8) | data[11]), data[9]);
+	*scancode = RC_SCANCODE_NECX(data[11] << 8 | data[10], data[9]);
 	*toggle = 0;
 	return 1;
 }
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index d6519f8..520a96f 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -30,8 +30,8 @@ static struct rc_map_table behold[] = {
 	/*  0x1c            0x12  *
 	 *  TV/FM          POWER  *
 	 *                        */
-	{ 0x6b861c, KEY_TUNER },	/* XXX KEY_TV / KEY_RADIO */
-	{ 0x6b8612, KEY_POWER },
+	{ 0x866b1c, KEY_TUNER },	/* XXX KEY_TV / KEY_RADIO */
+	{ 0x866b12, KEY_POWER },
 
 	/*  0x01    0x02    0x03  *
 	 *   1       2       3    *
@@ -42,28 +42,28 @@ static struct rc_map_table behold[] = {
 	 *  0x07    0x08    0x09  *
 	 *   7       8       9    *
 	 *                        */
-	{ 0x6b8601, KEY_1 },
-	{ 0x6b8602, KEY_2 },
-	{ 0x6b8603, KEY_3 },
-	{ 0x6b8604, KEY_4 },
-	{ 0x6b8605, KEY_5 },
-	{ 0x6b8606, KEY_6 },
-	{ 0x6b8607, KEY_7 },
-	{ 0x6b8608, KEY_8 },
-	{ 0x6b8609, KEY_9 },
+	{ 0x866b01, KEY_1 },
+	{ 0x866b02, KEY_2 },
+	{ 0x866b03, KEY_3 },
+	{ 0x866b04, KEY_4 },
+	{ 0x866b05, KEY_5 },
+	{ 0x866b06, KEY_6 },
+	{ 0x866b07, KEY_7 },
+	{ 0x866b08, KEY_8 },
+	{ 0x866b09, KEY_9 },
 
 	/*  0x0a    0x00    0x17  *
 	 * RECALL    0      MODE  *
 	 *                        */
-	{ 0x6b860a, KEY_AGAIN },
-	{ 0x6b8600, KEY_0 },
-	{ 0x6b8617, KEY_MODE },
+	{ 0x866b0a, KEY_AGAIN },
+	{ 0x866b00, KEY_0 },
+	{ 0x866b17, KEY_MODE },
 
 	/*  0x14          0x10    *
 	 * ASPECT      FULLSCREEN *
 	 *                        */
-	{ 0x6b8614, KEY_SCREEN },
-	{ 0x6b8610, KEY_ZOOM },
+	{ 0x866b14, KEY_SCREEN },
+	{ 0x866b10, KEY_ZOOM },
 
 	/*          0x0b          *
 	 *           Up           *
@@ -74,17 +74,17 @@ static struct rc_map_table behold[] = {
 	 *         0x015          *
 	 *         Down           *
 	 *                        */
-	{ 0x6b860b, KEY_CHANNELUP },
-	{ 0x6b8618, KEY_VOLUMEDOWN },
-	{ 0x6b8616, KEY_OK },		/* XXX KEY_ENTER */
-	{ 0x6b860c, KEY_VOLUMEUP },
-	{ 0x6b8615, KEY_CHANNELDOWN },
+	{ 0x866b0b, KEY_CHANNELUP },
+	{ 0x866b18, KEY_VOLUMEDOWN },
+	{ 0x866b16, KEY_OK },		/* XXX KEY_ENTER */
+	{ 0x866b0c, KEY_VOLUMEUP },
+	{ 0x866b15, KEY_CHANNELDOWN },
 
 	/*  0x11            0x0d  *
 	 *  MUTE            INFO  *
 	 *                        */
-	{ 0x6b8611, KEY_MUTE },
-	{ 0x6b860d, KEY_INFO },
+	{ 0x866b11, KEY_MUTE },
+	{ 0x866b0d, KEY_INFO },
 
 	/*  0x0f    0x1b    0x1a  *
 	 * RECORD PLAY/PAUSE STOP *
@@ -93,26 +93,26 @@ static struct rc_map_table behold[] = {
 	 *TELETEXT  AUDIO  SOURCE *
 	 *           RED   YELLOW *
 	 *                        */
-	{ 0x6b860f, KEY_RECORD },
-	{ 0x6b861b, KEY_PLAYPAUSE },
-	{ 0x6b861a, KEY_STOP },
-	{ 0x6b860e, KEY_TEXT },
-	{ 0x6b861f, KEY_RED },	/*XXX KEY_AUDIO	*/
-	{ 0x6b861e, KEY_VIDEO },
+	{ 0x866b0f, KEY_RECORD },
+	{ 0x866b1b, KEY_PLAYPAUSE },
+	{ 0x866b1a, KEY_STOP },
+	{ 0x866b0e, KEY_TEXT },
+	{ 0x866b1f, KEY_RED },	/*XXX KEY_AUDIO	*/
+	{ 0x866b1e, KEY_VIDEO },
 
 	/*  0x1d   0x13     0x19  *
 	 * SLEEP  PREVIEW   DVB   *
 	 *         GREEN    BLUE  *
 	 *                        */
-	{ 0x6b861d, KEY_SLEEP },
-	{ 0x6b8613, KEY_GREEN },
-	{ 0x6b8619, KEY_BLUE },	/* XXX KEY_SAT	*/
+	{ 0x866b1d, KEY_SLEEP },
+	{ 0x866b13, KEY_GREEN },
+	{ 0x866b19, KEY_BLUE },	/* XXX KEY_SAT	*/
 
 	/*  0x58           0x5c   *
 	 * FREEZE        SNAPSHOT *
 	 *                        */
-	{ 0x6b8658, KEY_SLOW },
-	{ 0x6b865c, KEY_CAMERA },
+	{ 0x866b58, KEY_SLOW },
+	{ 0x866b5c, KEY_CAMERA },
 
 };
 

