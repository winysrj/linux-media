Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:42819 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab2KRPNN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 10:13:13 -0500
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 2/7] ir-rx51: Clean up timer initialization code
Date: Sun, 18 Nov 2012 17:13:04 +0200
Message-Id: <1353251589-26143-3-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove a redundant macro definition. This is unneeded and becomes more
readable once the actual timer code is refactored a little.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/ir-rx51.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 125d4c3..f22e5e4 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -105,11 +105,9 @@ static int init_timing_params(struct lirc_rx51 *lirc_rx51)
 	return 0;
 }
 
-#define tics_after(a, b) ((long)(b) - (long)(a) < 0)
-
 static int pulse_timer_set_timeout(struct lirc_rx51 *lirc_rx51, int usec)
 {
-	int counter;
+	int counter, counter_now;
 
 	BUG_ON(usec < 0);
 
@@ -122,11 +120,8 @@ static int pulse_timer_set_timeout(struct lirc_rx51 *lirc_rx51, int usec)
 	omap_dm_timer_set_match(lirc_rx51->pulse_timer, 1, counter);
 	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer,
 				     OMAP_TIMER_INT_MATCH);
-	if (tics_after(omap_dm_timer_read_counter(lirc_rx51->pulse_timer),
-		       counter)) {
-		return 1;
-	}
-	return 0;
+	counter_now = omap_dm_timer_read_counter(lirc_rx51->pulse_timer);
+	return (counter - counter_now) < 0;
 }
 
 static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
-- 
1.8.0

