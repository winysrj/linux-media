Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44278 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab2EWJyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:55 -0400
Subject: [PATCH 37/43] rc-core: don't report scancodes via input devices
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:14 +0200
Message-ID: <20120523094514.14474.52659.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scancode that is reported via the input device(s) is now incomplete
(missing the protocol) and redundant.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-keytable.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index 84c6e96..d0777cb 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -611,17 +611,10 @@ void rc_keytable_repeat(struct rc_keytable *kt)
 	unsigned long flags;
 
 	spin_lock_irqsave(&kt->key_lock, flags);
-
-	input_event(kt->idev, EV_MSC, MSC_SCAN, kt->last_scancode);
-	input_sync(kt->idev);
-
-	if (!kt->key_pressed)
-		goto out;
-
-	kt->keyup_jiffies = jiffies + msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
-	mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
-
-out:
+	if (kt->key_pressed) {
+		kt->keyup_jiffies = jiffies + msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
+		mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
+	}
 	spin_unlock_irqrestore(&kt->key_lock, flags);
 }
 
@@ -660,8 +653,6 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 	if (new_event)
 		rc_do_keyup(kt, false);
 
-	input_event(kt->idev, EV_MSC, MSC_SCAN, scancode);
-
 	if (new_event && keycode != KEY_RESERVED) {
 		/* Register a keypress */
 		kt->key_pressed = true;
@@ -675,8 +666,8 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 			   kt->dev->input_name, keycode, protocol,
 			   (long long unsigned)scancode);
 		input_report_key(kt->idev, keycode, 1);
+		input_sync(kt->idev);
 	}
-	input_sync(kt->idev);
 
 	if (autoup && kt->key_pressed) {
 		kt->keyup_jiffies = jiffies + msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
@@ -799,8 +790,6 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev,
 	idev->close = rc_input_close;
 	set_bit(EV_KEY, idev->evbit);
 	set_bit(EV_REP, idev->evbit);
-	set_bit(EV_MSC, idev->evbit);
-	set_bit(MSC_SCAN, idev->mscbit);
 	input_set_drvdata(idev, kt);
 	setup_timer(&kt->timer_keyup, rc_timer_keyup, (unsigned long)kt);
 

