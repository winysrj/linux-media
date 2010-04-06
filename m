Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488Ab0DFSS4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:56 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIuIT005731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:56 -0400
Date: Tue, 6 Apr 2010 15:18:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 15/26] V4L/DVB: ir-core: re-add some debug functions for
 keytable changes
Message-ID: <20100406151801.5110df76@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index d3bc909..00db928 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -99,6 +99,8 @@ static int ir_do_setkeycode(struct input_dev *dev,
 
 		/* Did the user wish to remove the mapping? */
 		if (keycode == KEY_RESERVED || keycode == KEY_UNKNOWN) {
+			IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
+				   i, scancode);
 			rc_tab->len--;
 			memmove(&rc_tab->scan[i], &rc_tab->scan[i + 1],
 				(rc_tab->len - i) * sizeof(struct ir_scancode));
@@ -114,6 +116,9 @@ static int ir_do_setkeycode(struct input_dev *dev,
 		if (ir_resize_table(rc_tab))
 			return -ENOMEM;
 
+		IR_dprintk(1, "#%d: New scan 0x%04x with key 0x%04x\n",
+			   i, scancode, keycode);
+
 		/* i is the proper index to insert our new keycode */
 		memmove(&rc_tab->scan[i + 1], &rc_tab->scan[i],
 			(rc_tab->len - i) * sizeof(struct ir_scancode));
@@ -122,6 +127,8 @@ static int ir_do_setkeycode(struct input_dev *dev,
 		rc_tab->len++;
 		set_bit(keycode, dev->keybit);
 	} else {
+		IR_dprintk(1, "#%d: Replacing scan 0x%04x with key 0x%04x\n",
+			   i, scancode, keycode);
 		/* A previous mapping was updated... */
 		clear_bit(old_keycode, dev->keybit);
 		/* ...but another scancode might use the same keycode */
@@ -223,6 +230,10 @@ static int ir_getkeycode(struct input_dev *dev,
 	}
 	spin_unlock_irqrestore(&rc_tab->lock, flags);
 
+	if (key == KEY_RESERVED)
+		IR_dprintk(1, "unknown key for scancode 0x%04x\n",
+			   scancode);
+
 	*keycode = key;
 	return 0;
 }
@@ -242,8 +253,9 @@ u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
 	int keycode;
 
 	ir_getkeycode(dev, scancode, &keycode);
-	IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-		   dev->name, scancode, keycode);
+	if (keycode != KEY_RESERVED)
+		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
+			   dev->name, scancode, keycode);
 	return keycode;
 }
 EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
@@ -385,6 +397,9 @@ int __ir_input_register(struct input_dev *input_dev,
 	if (rc < 0)
 		goto out_table;
 
+	IR_dprintk(1, "Registered input device on %s for %s remote.\n",
+		   driver_name, rc_tab->name);
+
 	return 0;
 
 out_table:
-- 
1.6.6.1


