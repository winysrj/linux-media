Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52612 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412Ab0G3CSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:18:00 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 11/13] IR: report unknown scancodes the in-kernel decoders found.
Date: Fri, 30 Jul 2010 05:17:13 +0300
Message-Id: <1280456235-2024-12-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This way it is possible to use evtest to create keymap for unknown remote.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-keytable.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 34b9c07..ba7678a 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -339,6 +339,8 @@ void ir_repeat(struct input_dev *dev)
 
 	spin_lock_irqsave(&ir->keylock, flags);
 
+	input_event(dev, EV_MSC, MSC_SCAN, ir->last_scancode);
+
 	if (!ir->keypressed)
 		goto out;
 
@@ -370,6 +372,8 @@ void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
 
 	spin_lock_irqsave(&ir->keylock, flags);
 
+	input_event(dev, EV_MSC, MSC_SCAN, scancode);
+
 	/* Repeat event? */
 	if (ir->keypressed &&
 	    ir->last_scancode == scancode &&
@@ -383,9 +387,11 @@ void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
 	ir->last_toggle = toggle;
 	ir->last_keycode = keycode;
 
+
 	if (keycode == KEY_RESERVED)
 		goto out;
 
+
 	/* Register a keypress */
 	ir->keypressed = true;
 	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
@@ -480,6 +486,8 @@ int __ir_input_register(struct input_dev *input_dev,
 
 	set_bit(EV_KEY, input_dev->evbit);
 	set_bit(EV_REP, input_dev->evbit);
+	set_bit(EV_MSC, input_dev->evbit);
+	set_bit(MSC_SCAN, input_dev->mscbit);
 
 	if (ir_setkeytable(input_dev, &ir_dev->rc_tab, rc_tab)) {
 		rc = -ENOMEM;
-- 
1.7.0.4

