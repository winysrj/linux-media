Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52177 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab0DOVqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 17:46:38 -0400
Subject: [PATCH 7/8] ir-core: fix table resize during keymap init
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Thu, 15 Apr 2010 23:46:30 +0200
Message-ID: <20100415214630.14142.13319.stgit@localhost.localdomain>
In-Reply-To: <20100415214520.14142.56114.stgit@localhost.localdomain>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/IR/ir-keytable.c would alloc a suitably sized keymap table
only to have it resized as it is populated with the initial keymap.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-keytable.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 01bddc4..b8baf8f 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -77,6 +77,7 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
  * @rc_tab:	the struct ir_scancode_table to set the keycode in
  * @scancode:	the scancode for the ir command
  * @keycode:	the keycode for the ir command
+ * @resize:	whether the keytable may be shrunk
  * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
  *
  * This routine is used internally to manipulate the scancode->keycode table.
@@ -84,7 +85,8 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
  */
 static int ir_do_setkeycode(struct input_dev *dev,
 			    struct ir_scancode_table *rc_tab,
-			    int scancode, int keycode)
+			    int scancode, int keycode,
+			    bool resize)
 {
 	unsigned int i;
 	int old_keycode = KEY_RESERVED;
@@ -128,7 +130,7 @@ static int ir_do_setkeycode(struct input_dev *dev,
 
 	if (old_keycode == KEY_RESERVED) {
 		/* No previous mapping found, we might need to grow the table */
-		if (ir_resize_table(rc_tab))
+		if (resize && ir_resize_table(rc_tab))
 			return -ENOMEM;
 
 		IR_dprintk(1, "#%d: New scan 0x%04x with key 0x%04x\n",
@@ -176,7 +178,7 @@ static int ir_setkeycode(struct input_dev *dev,
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
 
 	spin_lock_irqsave(&rc_tab->lock, flags);
-	rc = ir_do_setkeycode(dev, rc_tab, scancode, keycode);
+	rc = ir_do_setkeycode(dev, rc_tab, scancode, keycode, true);
 	spin_unlock_irqrestore(&rc_tab->lock, flags);
 	return rc;
 }
@@ -203,7 +205,7 @@ static int ir_setkeytable(struct input_dev *dev,
 	spin_lock_irqsave(&rc_tab->lock, flags);
 	for (i = 0; i < from->size; i++) {
 		rc = ir_do_setkeycode(dev, to, from->scan[i].scancode,
-				      from->scan[i].keycode);
+				      from->scan[i].keycode, false);
 		if (rc)
 			break;
 	}

