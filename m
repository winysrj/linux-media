Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:33664 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbeC0PRX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 11:17:23 -0400
Received: by mail-pl0-f66.google.com with SMTP id c11-v6so14277345plo.0
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 08:17:23 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hiranotaka@zng.info,
        Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 5/5] dvb: earth-pt1: replace schedule_timeout with usleep_range
Date: Wed, 28 Mar 2018 00:16:02 +0900
Message-Id: <20180327151602.12250-6-tskd08@gmail.com>
In-Reply-To: <20180327151602.12250-1-tskd08@gmail.com>
References: <20180327151602.12250-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

As described in Document/timers/timers-howto.txt,
hrtimer-based delay should be used for small sleeps.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/pci/pt1/pt1.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 1a83a624776..4f84672974d 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -18,7 +18,10 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/sched/signal.h>
+#include <linux/hrtimer.h>
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -327,7 +330,7 @@ static int pt1_unlock(struct pt1 *pt1)
 	for (i = 0; i < 3; i++) {
 		if (pt1_read_reg(pt1, 0) & 0x80000000)
 			return 0;
-		schedule_timeout_uninterruptible((HZ + 999) / 1000);
+		usleep_range(1000, 2000);
 	}
 	dev_err(&pt1->pdev->dev, "could not unlock\n");
 	return -EIO;
@@ -341,7 +344,7 @@ static int pt1_reset_pci(struct pt1 *pt1)
 	for (i = 0; i < 10; i++) {
 		if (pt1_read_reg(pt1, 0) & 0x00000001)
 			return 0;
-		schedule_timeout_uninterruptible((HZ + 999) / 1000);
+		usleep_range(1000, 2000);
 	}
 	dev_err(&pt1->pdev->dev, "could not reset PCI\n");
 	return -EIO;
@@ -355,7 +358,7 @@ static int pt1_reset_ram(struct pt1 *pt1)
 	for (i = 0; i < 10; i++) {
 		if (pt1_read_reg(pt1, 0) & 0x00000002)
 			return 0;
-		schedule_timeout_uninterruptible((HZ + 999) / 1000);
+		usleep_range(1000, 2000);
 	}
 	dev_err(&pt1->pdev->dev, "could not reset RAM\n");
 	return -EIO;
@@ -372,7 +375,7 @@ static int pt1_do_enable_ram(struct pt1 *pt1)
 			if ((pt1_read_reg(pt1, 0) & 0x00000004) != status)
 				return 0;
 		}
-		schedule_timeout_uninterruptible((HZ + 999) / 1000);
+		usleep_range(1000, 2000);
 	}
 	dev_err(&pt1->pdev->dev, "could not enable RAM\n");
 	return -EIO;
@@ -382,7 +385,7 @@ static int pt1_enable_ram(struct pt1 *pt1)
 {
 	int i, ret;
 	int phase;
-	schedule_timeout_uninterruptible((HZ + 999) / 1000);
+	usleep_range(1000, 2000);
 	phase = pt1->pdev->device == 0x211a ? 128 : 166;
 	for (i = 0; i < phase; i++) {
 		ret = pt1_do_enable_ram(pt1);
@@ -469,6 +472,9 @@ static int pt1_thread(void *data)
 	struct pt1_buffer_page *page;
 	bool was_frozen;
 
+#define PT1_FETCH_DELAY 10
+#define PT1_FETCH_DELAY_DELTA 2
+
 	pt1 = data;
 	set_freezable();
 
@@ -482,7 +488,13 @@ static int pt1_thread(void *data)
 
 		page = pt1->tables[pt1->table_index].bufs[pt1->buf_index].page;
 		if (!pt1_filter(pt1, page)) {
-			schedule_timeout_interruptible((HZ + 999) / 1000);
+			ktime_t delay;
+
+			delay = PT1_FETCH_DELAY * NSEC_PER_MSEC;
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_hrtimeout_range(&delay,
+					PT1_FETCH_DELAY_DELTA * NSEC_PER_MSEC,
+					HRTIMER_MODE_REL);
 			continue;
 		}
 
@@ -718,7 +730,7 @@ pt1_update_power(struct pt1 *pt1)
 		adap = pt1->adaps[i];
 		switch (adap->voltage) {
 		case SEC_VOLTAGE_13: /* actually 11V */
-			bits |= 1 << 1;
+			bits |= 1 << 2;
 			break;
 		case SEC_VOLTAGE_18: /* actually 15V */
 			bits |= 1 << 1 | 1 << 2;
@@ -772,7 +784,7 @@ static int pt1_wakeup(struct dvb_frontend *fe)
 	adap = container_of(fe->dvb, struct pt1_adapter, adap);
 	adap->sleep = 0;
 	pt1_update_power(adap->pt1);
-	schedule_timeout_uninterruptible((HZ + 999) / 1000);
+	usleep_range(1000, 2000);
 
 	ret = config_demod(adap->demod_i2c_client, adap->pt1->fe_clk);
 	if (ret == 0 && adap->orig_init)
@@ -1079,7 +1091,7 @@ static int pt1_i2c_end(struct pt1 *pt1, int addr)
 	do {
 		if (signal_pending(current))
 			return -EINTR;
-		schedule_timeout_interruptible((HZ + 999) / 1000);
+		usleep_range(1000, 2000);
 	} while (pt1_read_reg(pt1, 0) & 0x00000080);
 	return 0;
 }
@@ -1382,11 +1394,11 @@ static int pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pt1->power = 1;
 	pt1_update_power(pt1);
-	schedule_timeout_uninterruptible((HZ + 49) / 50);
+	msleep(20);
 
 	pt1->reset = 0;
 	pt1_update_power(pt1);
-	schedule_timeout_uninterruptible((HZ + 999) / 1000);
+	usleep_range(1000, 2000);
 
 	ret = pt1_init_frontends(pt1);
 	if (ret < 0)
-- 
2.16.3
