Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40351 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbaDCXfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:35:00 -0400
Subject: [PATCH 44/49] rc-core: don't report scancodes via input devices
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:34:58 +0200
Message-ID: <20140403233458.27099.36806.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
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
index 5709ae6..23a66c7 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -645,17 +645,10 @@ void rc_keytable_repeat(struct rc_keytable *kt)
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
 
@@ -695,8 +688,6 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 	if (new_event)
 		rc_do_keyup(kt, false);
 
-	input_event(kt->idev, EV_MSC, MSC_SCAN, scancode);
-
 	if (new_event && keycode != KEY_RESERVED) {
 		/* Register a keypress */
 		kt->key_pressed = true;
@@ -710,8 +701,8 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 			   kt->dev->input_name, keycode, protocol,
 			   (long long unsigned)scancode);
 		input_report_key(kt->idev, keycode, 1);
+		input_sync(kt->idev);
 	}
-	input_sync(kt->idev);
 
 	if (autoup && kt->key_pressed) {
 		kt->keyup_jiffies = jiffies + msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
@@ -811,8 +802,6 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
 	idev->close = rc_input_close;
 	set_bit(EV_KEY, idev->evbit);
 	set_bit(EV_REP, idev->evbit);
-	set_bit(EV_MSC, idev->evbit);
-	set_bit(MSC_SCAN, idev->mscbit);
 	input_set_drvdata(idev, kt);
 	setup_timer(&kt->timer_keyup, rc_timer_keyup, (unsigned long)kt);
 

