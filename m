Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41423 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932939AbdEAQKT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:10:19 -0400
Subject: [PATCH 5/7] rc-core: ir-raw - leave the internals of rc_dev alone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:10:17 +0200
Message-ID: <149365501711.13489.17027324920634077369.stgit@zeus.hardeman.nu>
In-Reply-To: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the REP_DELAY value with a static value, which makes more sense.
Automatic repeat handling in the input layer has no relevance for the drivers
idea of "a long time".

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-ir-raw.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index ae7785c4fbe7..967ab9531e0a 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -102,20 +102,18 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 	s64			delta; /* ns */
 	DEFINE_IR_RAW_EVENT(ev);
 	int			rc = 0;
-	int			delay;
 
 	if (!dev->raw)
 		return -EINVAL;
 
 	now = ktime_get();
 	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
-	delay = MS_TO_NS(dev->input_dev->rep[REP_DELAY]);
 
 	/* Check for a long duration since last event or if we're
 	 * being called for the first time, note that delta can't
 	 * possibly be negative.
 	 */
-	if (delta > delay || !dev->raw->last_type)
+	if (delta > MS_TO_NS(500) || !dev->raw->last_type)
 		type |= IR_START_EVENT;
 	else
 		ev.duration = delta;
