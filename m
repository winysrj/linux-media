Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52564 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbbGTTQi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:16:38 -0400
Subject: [PATCH 2/7] [PATCH FIXES] Revert "[media] rc: rc-loopback: Add
 loopback of filter scancodes"
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 20 Jul 2015 21:16:36 +0200
Message-ID: <20150720191636.24633.31611.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
References: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 2e4ebde269236da2a41183522127715b6d9d80ce.

The current code is not mature enough, the API should allow a single
protocol to be specified. Also, the current code contains heuristics
that will depend on module load order.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-loopback.c |   36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index d8bdf63..63dace8 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -26,7 +26,6 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 #include <media/rc-core.h>
 
 #define DRIVER_NAME	"rc-loopback"
@@ -177,39 +176,6 @@ static int loop_set_carrier_report(struct rc_dev *dev, int enable)
 	return 0;
 }
 
-static int loop_set_wakeup_filter(struct rc_dev *dev,
-				  struct rc_scancode_filter *sc_filter)
-{
-	static const unsigned int max = 512;
-	struct ir_raw_event *raw;
-	int ret;
-	int i;
-
-	/* fine to disable filter */
-	if (!sc_filter->mask)
-		return 0;
-
-	/* encode the specified filter and loop it back */
-	raw = kmalloc_array(max, sizeof(*raw), GFP_KERNEL);
-	ret = ir_raw_encode_scancode(dev->enabled_wakeup_protocols, sc_filter,
-				     raw, max);
-	/* still loop back the partial raw IR even if it's incomplete */
-	if (ret == -ENOBUFS)
-		ret = max;
-	if (ret >= 0) {
-		/* do the loopback */
-		for (i = 0; i < ret; ++i)
-			ir_raw_event_store(dev, &raw[i]);
-		ir_raw_event_handle(dev);
-
-		ret = 0;
-	}
-
-	kfree(raw);
-
-	return ret;
-}
-
 static int __init loop_init(void)
 {
 	struct rc_dev *rc;
@@ -229,7 +195,6 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
-	rc->encode_wakeup	= true;
 	rc->allowed_protocols	= RC_BIT_ALL;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
@@ -244,7 +209,6 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->s_learning_mode	= loop_set_learning_mode;
 	rc->s_carrier_report	= loop_set_carrier_report;
-	rc->s_wakeup_filter	= loop_set_wakeup_filter;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;

