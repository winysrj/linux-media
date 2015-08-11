Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33183 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965175AbbHKPXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 11:23:01 -0400
Received: by iods203 with SMTP id s203so8662926iod.0
        for <linux-media@vger.kernel.org>; Tue, 11 Aug 2015 08:23:01 -0700 (PDT)
From: Abhilash Jindal <klock.android@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Abhilash Jindal <klock.android@gmail.com>
Subject: [PATCH] [media] bt8xxx: Use monotonic time
Date: Tue, 11 Aug 2015 11:22:57 -0400
Message-Id: <1439306577-3281-1-git-send-email-klock.android@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wall time obtained from do_gettimeofday is susceptible to sudden jumps due to
user setting the time or due to NTP.

Monotonic time is constantly increasing time better suited for comparing two
timestamps.

Signed-off-by: Abhilash Jindal <klock.android@gmail.com>
---
 drivers/media/pci/bt8xx/bttv-input.c |   23 +++++++++--------------
 drivers/media/pci/bt8xx/bttvp.h      |    2 +-
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 67c8d6b..0f21771 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -194,21 +194,18 @@ static u32 bttv_rc5_decode(unsigned int code)
 static void bttv_rc5_timer_end(unsigned long data)
 {
 	struct bttv_ir *ir = (struct bttv_ir *)data;
-	struct timeval tv;
+	ktime_t tv;
 	u32 gap, rc5, scancode;
 	u8 toggle, command, system;
 
 	/* get time */
-	do_gettimeofday(&tv);
+	tv = ktime_get();
 
+	gap = ktime_to_us(ktime_sub(tv, ir->base_time));
 	/* avoid overflow with gap >1s */
-	if (tv.tv_sec - ir->base_time.tv_sec > 1) {
+	if (gap > USEC_PER_SEC) {
 		gap = 200000;
-	} else {
-		gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
-		    tv.tv_usec - ir->base_time.tv_usec;
-	}
-
+	} 
 	/* signal we're ready to start a new code */
 	ir->active = false;
 
@@ -249,7 +246,7 @@ static void bttv_rc5_timer_end(unsigned long data)
 static int bttv_rc5_irq(struct bttv *btv)
 {
 	struct bttv_ir *ir = btv->remote;
-	struct timeval tv;
+	ktime_t tv;
 	u32 gpio;
 	u32 gap;
 	unsigned long current_jiffies;
@@ -259,14 +256,12 @@ static int bttv_rc5_irq(struct bttv *btv)
 
 	/* get time of bit */
 	current_jiffies = jiffies;
-	do_gettimeofday(&tv);
+	tv = ktime_get();
 
+	gap = ktime_to_us(ktime_sub(tv, ir->base_time));
 	/* avoid overflow with gap >1s */
-	if (tv.tv_sec - ir->base_time.tv_sec > 1) {
+	if (gap > USEC_PER_SEC) {
 		gap = 200000;
-	} else {
-		gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
-		    tv.tv_usec - ir->base_time.tv_usec;
 	}
 
 	dprintk("RC5 IRQ: gap %d us for %s\n",
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index a444cfb..31bf79d 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -140,7 +140,7 @@ struct bttv_ir {
 	bool			rc5_gpio;   /* Is RC5 legacy GPIO enabled? */
 	u32                     last_bit;   /* last raw bit seen */
 	u32                     code;       /* raw code under construction */
-	struct timeval          base_time;  /* time of last seen code */
+	ktime_t          				base_time;  /* time of last seen code */
 	bool                    active;     /* building raw code */
 };
 
-- 
1.7.9.5

