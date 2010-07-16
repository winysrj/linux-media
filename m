Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab0GPRXx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 13:23:53 -0400
Date: Fri, 16 Jul 2010 13:23:51 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org
Subject: [PATCH] input: fix wiring up default setkeycode/setkeycodebig
Message-ID: <20100716172351.GA4364@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I believe there's a mistake in 94977ff15f4214ee4630cf4a67195a1d48da771c,
where the conditions on which to set a setkeycodebig function are
incorrect. Previously, we had the case where if the dev didn't provide
its own setkeycode, we'd set the default input layer one. Now, we set
setkeycode big if the dev provides its own setkeycode but doesn't
provide setkeycodebig. Devices that provide neither setkeycode nor
setkeycodebig wind up with neither, which blows up horribly later on
down the road when a setkeycode{,big} operation is attempted. Such is
the case with the thinkpad_acpi driver's input device registered for the
extra hotkey buttons on my own t61. This makes it happy again, and seems
to be an obvious fix for a thinko.

Oh yeah, patch is against the linuxtv staging/other tree, not sure where
else the previously referenced hash can be found just yet.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/input/input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 43aeb71..ce5d90d 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1850,7 +1850,7 @@ int input_register_device(struct input_dev *dev)
 			dev->getkeycodebig_from_scancode = input_default_getkeycode_from_scancode;
 	}
 
-	if (dev->setkeycode) {
+	if (!dev->setkeycode) {
 		if (!dev->setkeycodebig)
 			dev->setkeycodebig = input_default_setkeycode;
 	}
-- 
1.7.1.1


-- 
Jarod Wilson
jarod@redhat.com

