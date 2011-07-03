Return-path: <mchehab@pedra>
Received: from fox.seas.upenn.edu ([158.130.68.12]:58953 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1GCUbw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 16:31:52 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
	jarod@redhat.com
Cc: Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 2/2] mceusb: increase default timeout to 100ms
Date: Sun,  3 Jul 2011 16:13:53 -0400
Message-Id: <1309724033-27804-2-git-send-email-rafi@seas.upenn.edu>
In-Reply-To: <1309724033-27804-1-git-send-email-rafi@seas.upenn.edu>
References: <1309724033-27804-1-git-send-email-rafi@seas.upenn.edu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---
This changes the default to something a little more sane.  I have one
mceusb device that currently does not respond properly to the initial
polling and is left using the default timeout.  1ms does not work well.

I propose changing the default to 100ms to match the timeout reported by
my other mceusb device and works fine for me.
---
 drivers/media/rc/mceusb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 377f826..956d296 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1082,7 +1082,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protos = RC_TYPE_ALL;
-	rc->timeout = US_TO_NS(1000);
+	rc->timeout = MS_TO_NS(100);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
 		rc->s_tx_carrier = mceusb_set_tx_carrier;
-- 
1.7.5.4

