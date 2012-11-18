Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:42828 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab2KRPNN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 10:13:13 -0500
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 6/7] ir-rx51: Remove useless variable from struct lirc_rx51
Date: Sun, 18 Nov 2012 17:13:08 +0200
Message-Id: <1353251589-26143-7-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As clearly visible from the patch, this variable has no useful purpose
what so ever. Thus, it can be removed altogether without any side
effects.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/ir-rx51.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 96ed23d..edb1562 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -57,7 +57,6 @@ struct lirc_rx51 {
 	unsigned int	freq;		/* carrier frequency */
 	unsigned int	duty_cycle;	/* carrier duty cycle */
 	unsigned int	irq_num;
-	unsigned int	match;
 	int		wbuf[WBUF_LEN];
 	int		wbuf_index;
 	unsigned long	device_is_open;
@@ -102,8 +101,6 @@ static int init_timing_params(struct lirc_rx51 *lirc_rx51)
 	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
 	omap_dm_timer_start(lirc_rx51->pulse_timer);
 
-	lirc_rx51->match = 0;
-
 	return 0;
 }
 
@@ -113,11 +110,7 @@ static int pulse_timer_set_timeout(struct lirc_rx51 *lirc_rx51, int usec)
 
 	BUG_ON(usec < 0);
 
-	if (lirc_rx51->match == 0)
-		counter = omap_dm_timer_read_counter(lirc_rx51->pulse_timer);
-	else
-		counter = lirc_rx51->match;
-
+	counter = omap_dm_timer_read_counter(lirc_rx51->pulse_timer);
 	counter += (u32)(lirc_rx51->fclk_khz * usec / (1000));
 	omap_dm_timer_set_match(lirc_rx51->pulse_timer, 1, counter);
 	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer,
-- 
1.8.0

