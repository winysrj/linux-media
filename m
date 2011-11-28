Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:62760 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1K1Tqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 14:46:38 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 5/5] tm6000: bugfix data check
Date: Mon, 28 Nov 2011 20:46:20 +0100
Message-Id: <1322509580-14460-5-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

beholder use a map with 3 bytes, but many rc maps have 2 bytes, so I add a workaround for beholder rc.

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/video/tm6000/tm6000-input.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index 405d127..ae7772e 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -178,9 +178,21 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 			poll_result->rc_data = ir->urb_data[0];
 			break;
 		case RC_TYPE_NEC:
-			if (ir->urb_data[1] == ((ir->key_addr >> 8) & 0xff)) {
+			switch (dev->model) {
+			case 10:
+			case 11:
+			case 14:
+			case 15:
+				if (ir->urb_data[1] ==
+					((ir->key_addr >> 8) & 0xff)) {
+					poll_result->rc_data =
+					ir->urb_data[0]
+					| ir->urb_data[1] << 8;
+				}
+				break;
+			default:
 				poll_result->rc_data = ir->urb_data[0]
-							| ir->urb_data[1] << 8;
+					| ir->urb_data[1] << 8;
 			}
 			break;
 		default:
@@ -238,8 +250,6 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 		return;
 	}
 
-	dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
-
 	if (ir->pwled) {
 		if (ir->pwledcnt >= PWLED_OFF) {
 			ir->pwled = 0;
@@ -250,6 +260,7 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 	}
 
 	if (ir->key) {
+		dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
 		rc_keydown(ir->rc, poll_result.rc_data, 0);
 		ir->key = 0;
 		ir->pwled = 1;
@@ -333,7 +344,7 @@ int tm6000_ir_int_start(struct tm6000_core *dev)
 		ir->int_urb->transfer_buffer, size,
 		tm6000_ir_urb_received, dev,
 		dev->int_in.endp->desc.bInterval);
-	err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
+	err = usb_submit_urb(ir->int_urb, GFP_ATOMIC);
 	if (err) {
 		kfree(ir->int_urb->transfer_buffer);
 		usb_free_urb(ir->int_urb);
-- 
1.7.7

