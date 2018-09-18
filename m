Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36033 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727756AbeIRUCW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 16:02:22 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] media: rc: some events are dropped by userspace
Date: Tue, 18 Sep 2018 15:29:27 +0100
Message-Id: <20180918142930.6686-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

libevdev (which is used by libinput) gets a list of keycodes from the
input device on creation. Any events with keycodes which are not in this
list are silently dropped. So, set all keycodes on device creation since
we do not know which will be used if the keymap changes.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index ca68e1d2b2f9..97086fbbed41 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -289,20 +289,9 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
 			old_keycode == KEY_RESERVED ? "New" : "Replacing",
 			rc_map->scan[index].scancode, new_keycode);
 		rc_map->scan[index].keycode = new_keycode;
-		__set_bit(new_keycode, dev->input_dev->keybit);
 	}
 
 	if (old_keycode != KEY_RESERVED) {
-		/* A previous mapping was updated... */
-		__clear_bit(old_keycode, dev->input_dev->keybit);
-		/* ... but another scancode might use the same keycode */
-		for (i = 0; i < rc_map->len; i++) {
-			if (rc_map->scan[i].keycode == old_keycode) {
-				__set_bit(old_keycode, dev->input_dev->keybit);
-				break;
-			}
-		}
-
 		/* Possibly shrink the keytable, failure is not a problem */
 		ir_resize_table(dev, rc_map, GFP_ATOMIC);
 	}
@@ -1759,6 +1748,8 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 	set_bit(EV_REP, dev->input_dev->evbit);
 	set_bit(EV_MSC, dev->input_dev->evbit);
 	set_bit(MSC_SCAN, dev->input_dev->mscbit);
+	bitmap_fill(dev->input_dev->keybit, KEY_CNT);
+
 	if (dev->open)
 		dev->input_dev->open = ir_open;
 	if (dev->close)
-- 
2.17.1
