Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:34301 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752688AbeD1HqL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 03:46:11 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, jasmin@anw.at,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] media: Revert cleanup ktime_set() usage
Date: Sat, 28 Apr 2018 09:45:51 +0200
Message-Id: <1524901551-4458-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

This reverts 8b0e195314fa, because media-tree drivers should use the
API functions to initialize variables of type ktime_t.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dmxdev.c     | 2 +-
 drivers/media/pci/cx88/cx88-input.c | 6 ++++--
 drivers/media/pci/pt3/pt3.c         | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 61a750f..cb078d6 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -622,7 +622,7 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 				 struct dmxdev_filter *filter,
 				 struct dmxdev_feed *feed)
 {
-	ktime_t timeout = 0;
+	ktime_t timeout = ktime_set(0, 0);
 	struct dmx_pes_filter_params *para = &filter->params.pes;
 	enum dmx_output otype;
 	int ret;
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 16233e8..2f5debc 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -180,7 +180,8 @@ static enum hrtimer_restart cx88_ir_work(struct hrtimer *timer)
 	struct cx88_IR *ir = container_of(timer, struct cx88_IR, timer);
 
 	cx88_ir_handle_key(ir);
-	missed = hrtimer_forward_now(&ir->timer, ir->polling * 1000000LL);
+	missed = hrtimer_forward_now(&ir->timer,
+				     ktime_set(0, ir->polling * 1000000));
 	if (missed > 1)
 		ir_dprintk("Missed ticks %ld\n", missed - 1);
 
@@ -200,7 +201,8 @@ static int __cx88_ir_start(void *priv)
 	if (ir->polling) {
 		hrtimer_init(&ir->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		ir->timer.function = cx88_ir_work;
-		hrtimer_start(&ir->timer, ir->polling * 1000000LL,
+		hrtimer_start(&ir->timer,
+			      ktime_set(0, ir->polling * 1000000),
 			      HRTIMER_MODE_REL);
 	}
 	if (ir->sampling) {
diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index da74828..8ced807 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -464,7 +464,7 @@ static int pt3_fetch_thread(void *data)
 
 		pt3_proc_dma(adap);
 
-		delay = PT3_FETCH_DELAY * NSEC_PER_MSEC;
+		delay = ktime_set(0, PT3_FETCH_DELAY * NSEC_PER_MSEC);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		freezable_schedule_hrtimeout_range(&delay,
 					PT3_FETCH_DELAY_DELTA * NSEC_PER_MSEC,
-- 
2.7.4
