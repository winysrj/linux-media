Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67B0C10F00
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B18F82075A
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfBVLgg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:36:36 -0500
Received: from gofer.mess.org ([88.97.38.141]:37379 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbfBVLgg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:36:36 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 697CE604A1; Fri, 22 Feb 2019 11:36:34 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     "# 4 . 20+" <stable@vger.kernel.org>
Subject: [PATCH] Revert "media: rc: some events are dropped by userspace"
Date:   Fri, 22 Feb 2019 11:36:34 +0000
Message-Id: <20190222113634.27985-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When an rc device is created, we do not know what key codes it will
support, since a new keymap might be loaded at some later point. So,
we set all keybit in the input device.

The uevent for the input device includes all the key codes, of which
there are now 768. This overflows the size of the uevent
(UEVENT_BUFFER_SIZE) and no event is generated.

Revert for now until we figure out a different solution.

This reverts commit fec225a04330d0f222d24feb5bea045526031675.

Cc: <stable@vger.kernel.org> # 4.20+
Reported-by: Christian Holpert <christian@holpert.de>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index dc38e9c0a2ff..141fbf191bc4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -280,6 +280,7 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
 				      unsigned int new_keycode)
 {
 	int old_keycode = rc_map->scan[index].keycode;
+	int i;
 
 	/* Did the user wish to remove the mapping? */
 	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
@@ -294,9 +295,20 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
 			old_keycode == KEY_RESERVED ? "New" : "Replacing",
 			rc_map->scan[index].scancode, new_keycode);
 		rc_map->scan[index].keycode = new_keycode;
+		__set_bit(new_keycode, dev->input_dev->keybit);
 	}
 
 	if (old_keycode != KEY_RESERVED) {
+		/* A previous mapping was updated... */
+		__clear_bit(old_keycode, dev->input_dev->keybit);
+		/* ... but another scancode might use the same keycode */
+		for (i = 0; i < rc_map->len; i++) {
+			if (rc_map->scan[i].keycode == old_keycode) {
+				__set_bit(old_keycode, dev->input_dev->keybit);
+				break;
+			}
+		}
+
 		/* Possibly shrink the keytable, failure is not a problem */
 		ir_resize_table(dev, rc_map, GFP_ATOMIC);
 	}
@@ -1759,7 +1771,6 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 	set_bit(EV_REP, dev->input_dev->evbit);
 	set_bit(EV_MSC, dev->input_dev->evbit);
 	set_bit(MSC_SCAN, dev->input_dev->mscbit);
-	bitmap_fill(dev->input_dev->keybit, KEY_CNT);
 
 	/* Pointer/mouse events */
 	set_bit(EV_REL, dev->input_dev->evbit);
-- 
2.20.1

