Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:45530 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbaKTVJx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 16:09:53 -0500
Subject: [PATCH] rc-core: fix toggle handling in the rc6 decoder
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mailinglists@openelec.tv, m.chehab@samsung.com
Date: Thu, 20 Nov 2014 22:09:54 +0100
Message-ID: <20141120210954.26599.144.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The toggle bit shouldn't be cleared before the toggle value is calculated.

This should probably go into 3.17.x as well.

Fixes: 120703f9eb32 ([media] rc-core: document the protocol type)
Tested-by: Stephan Raue <mailinglists@openelec.tv>
Signed-off-by: David Härdeman <david@hardeman.nu>
Cc: stable@vger.kernel.org
---
 drivers/media/rc/ir-rc6-decoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index f1f098e..d16bc67 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -259,8 +259,8 @@ again:
 			case 32:
 				if ((scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
 					protocol = RC_TYPE_RC6_MCE;
-					scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
 					toggle = !!(scancode & RC6_6A_MCE_TOGGLE_MASK);
+					scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
 				} else {
 					protocol = RC_BIT_RC6_6A_32;
 					toggle = 0;

