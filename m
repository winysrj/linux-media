Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0HAUUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 16:20:45 -0400
Date: Sun, 1 Aug 2010 17:21:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Udi Atar <udia@siano-ms.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/6] V4L/DVB: standardize names at rc-dib0700 tables
Message-ID: <20100801172110.3c1da080@pedra>
In-Reply-To: <cover.1280693675.git.mchehab@redhat.com>
References: <cover.1280693675.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a more standard way to name those tables, as they're currently used
by the script that coverts those tables to be loaded via userspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/keymaps/rc-dib0700-nec.c b/drivers/media/IR/keymaps/rc-dib0700-nec.c
index f5809f4..ae18320 100644
--- a/drivers/media/IR/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/IR/keymaps/rc-dib0700-nec.c
@@ -17,7 +17,7 @@
 
 #include <media/rc-map.h>
 
-static struct ir_scancode dib0700_table[] = {
+static struct ir_scancode dib0700_nec_table[] = {
 	/* Key codes for the Pixelview SBTVD remote */
 	{ 0x8613, KEY_MUTE },
 	{ 0x8612, KEY_POWER },
@@ -98,10 +98,10 @@ static struct ir_scancode dib0700_table[] = {
 	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
 };
 
-static struct rc_keymap dib0700_map = {
+static struct rc_keymap dib0700_nec_map = {
 	.map = {
-		.scan    = dib0700_table,
-		.size    = ARRAY_SIZE(dib0700_table),
+		.scan    = dib0700_nec_table,
+		.size    = ARRAY_SIZE(dib0700_nec_table),
 		.ir_type = IR_TYPE_NEC,
 		.name    = RC_MAP_DIB0700_NEC_TABLE,
 	}
@@ -109,12 +109,12 @@ static struct rc_keymap dib0700_map = {
 
 static int __init init_rc_map(void)
 {
-	return ir_register_map(&dib0700_map);
+	return ir_register_map(&dib0700_nec_map);
 }
 
 static void __exit exit_rc_map(void)
 {
-	ir_unregister_map(&dib0700_map);
+	ir_unregister_map(&dib0700_nec_map);
 }
 
 module_init(init_rc_map)
diff --git a/drivers/media/IR/keymaps/rc-dib0700-rc5.c b/drivers/media/IR/keymaps/rc-dib0700-rc5.c
index e2d0fd2..4a4797c 100644
--- a/drivers/media/IR/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/IR/keymaps/rc-dib0700-rc5.c
@@ -17,7 +17,7 @@
 
 #include <media/rc-map.h>
 
-static struct ir_scancode dib0700_table[] = {
+static struct ir_scancode dib0700_rc5_table[] = {
 	/* Key codes for the tiny Pinnacle remote*/
 	{ 0x0700, KEY_MUTE },
 	{ 0x0701, KEY_MENU }, /* Pinnacle logo */
@@ -209,10 +209,10 @@ static struct ir_scancode dib0700_table[] = {
 	{ 0x1d3d, KEY_POWER },
 };
 
-static struct rc_keymap dib0700_map = {
+static struct rc_keymap dib0700_rc5_map = {
 	.map = {
-		.scan    = dib0700_table,
-		.size    = ARRAY_SIZE(dib0700_table),
+		.scan    = dib0700_rc5_table,
+		.size    = ARRAY_SIZE(dib0700_rc5_table),
 		.ir_type = IR_TYPE_RC5,
 		.name    = RC_MAP_DIB0700_RC5_TABLE,
 	}
@@ -220,12 +220,12 @@ static struct rc_keymap dib0700_map = {
 
 static int __init init_rc_map(void)
 {
-	return ir_register_map(&dib0700_map);
+	return ir_register_map(&dib0700_rc5_map);
 }
 
 static void __exit exit_rc_map(void)
 {
-	ir_unregister_map(&dib0700_map);
+	ir_unregister_map(&dib0700_rc5_map);
 }
 
 module_init(init_rc_map)
-- 
1.7.1


