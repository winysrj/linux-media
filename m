Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0IPFVx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 01:21:53 -0400
Date: Thu, 16 Sep 2010 01:21:38 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: [PATCH 1/4] IR: export ir_keyup so imon driver can use it directly
Message-ID: <20100916052138.GB23299@redhat.com>
References: <20100916051932.GA23299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100916051932.GA23299@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From d31919ac08ba9a203bd673bbed18e78293ceaa68 Mon Sep 17 00:00:00 2001
From: Jarod Wilson <jarod@redhat.com>
Date: Wed, 15 Sep 2010 14:31:12 -0400
Subject: [PATCH 1/4] IR: export ir_keyup so imon driver can use it directly
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The imon driver currently reimplements its own version of ir_keyup
(along with key release timer functionality also already present in the
core IR code). A follow-up imon patch will make use of ir_keyup and the
IR stack's key release code.

Trivial extraction from David Härdeman's pending rc-core merge and
device interface abstraction patchset to facilitate merging a patch
based on his imon input dev split patch ahead of the larger churn, which
is slated for post-2.6.37-rc1 (after Dmitry's large keycode patches are
merged in mainline).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ir-keytable.c |    3 ++-
 include/media/ir-core.h        |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 7961d59..59510cd 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -285,7 +285,7 @@ EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
  * This routine is used to signal that a key has been released on the
  * remote control. It reports a keyup input event via input_report_key().
  */
-static void ir_keyup(struct ir_input_dev *ir)
+void ir_keyup(struct ir_input_dev *ir)
 {
 	if (!ir->keypressed)
 		return;
@@ -295,6 +295,7 @@ static void ir_keyup(struct ir_input_dev *ir)
 	input_sync(ir->input_dev);
 	ir->keypressed = false;
 }
+EXPORT_SYMBOL_GPL(ir_keyup);
 
 /**
  * ir_timer_keyup() - generates a keyup event after a timeout
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index eb7fddf..4dd43d4 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -157,6 +157,7 @@ void ir_input_unregister(struct input_dev *input_dev);
 
 void ir_repeat(struct input_dev *dev);
 void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
+void ir_keyup(struct ir_input_dev *ir);
 u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
 
 /* From ir-raw-event.c */
-- 
1.7.2.2


-- 
Jarod Wilson
jarod@redhat.com

