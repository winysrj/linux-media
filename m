Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33542 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbbE3SKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2015 14:10:38 -0400
Received: by wgez8 with SMTP id z8so85176510wge.0
        for <linux-media@vger.kernel.org>; Sat, 30 May 2015 11:10:37 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH v2 2/4] b2c2: Move stream reset code from flexcop-pci to flexcop
Date: Sat, 30 May 2015 19:10:07 +0100
Message-Id: <1433009409-5622-3-git-send-email-jdenson@gmail.com>
In-Reply-To: <1433009409-5622-1-git-send-email-jdenson@gmail.com>
References: <1433009409-5622-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As this bit of code is resetting the flexcop stream and the hardware
filter a better place for it is in flexcop-hw-filter.c

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/common/b2c2/flexcop-common.h    |  1 +
 drivers/media/common/b2c2/flexcop-hw-filter.c | 17 ++++++++++++++++-
 drivers/media/pci/b2c2/flexcop-pci.c          | 14 +-------------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-common.h b/drivers/media/common/b2c2/flexcop-common.h
index 2b2460e..184adda 100644
--- a/drivers/media/common/b2c2/flexcop-common.h
+++ b/drivers/media/common/b2c2/flexcop-common.h
@@ -177,6 +177,7 @@ void flexcop_dump_reg(struct flexcop_device *fc,
 int flexcop_pid_feed_control(struct flexcop_device *fc,
 		struct dvb_demux_feed *dvbdmxfeed, int onoff);
 void flexcop_hw_filter_init(struct flexcop_device *fc);
+void flexcop_stream_reset(struct flexcop_device *fc);
 
 void flexcop_smc_ctrl(struct flexcop_device *fc, int onoff);
 
diff --git a/drivers/media/common/b2c2/flexcop-hw-filter.c b/drivers/media/common/b2c2/flexcop-hw-filter.c
index 8220257..da000ba 100644
--- a/drivers/media/common/b2c2/flexcop-hw-filter.c
+++ b/drivers/media/common/b2c2/flexcop-hw-filter.c
@@ -218,7 +218,6 @@ int flexcop_pid_feed_control(struct flexcop_device *fc,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(flexcop_pid_feed_control);
 
 void flexcop_hw_filter_init(struct flexcop_device *fc)
 {
@@ -242,3 +241,19 @@ void flexcop_hw_filter_init(struct flexcop_device *fc)
 
 	flexcop_null_filter_ctrl(fc, 1);
 }
+
+void flexcop_stream_reset(struct flexcop_device *fc)
+{
+	struct dvb_demux_feed *feed;
+
+	spin_lock_irq(&fc->demux.lock);
+	list_for_each_entry(feed, &fc->demux.feed_list, list_head) {
+		flexcop_pid_feed_control(fc, feed, 0);
+	}
+
+	list_for_each_entry(feed, &fc->demux.feed_list, list_head) {
+		flexcop_pid_feed_control(fc, feed, 1);
+	}
+	spin_unlock_irq(&fc->demux.lock);
+}
+EXPORT_SYMBOL(flexcop_stream_reset);
diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
index 8b5e0b3..eb3b31f 100644
--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -112,21 +112,9 @@ static void flexcop_pci_irq_check_work(struct work_struct *work)
 		if (fc_pci->count == fc_pci->count_prev) {
 			deb_chk("no IRQ since the last check\n");
 			if (fc_pci->stream_problem++ == 3) {
-				struct dvb_demux_feed *feed;
 				deb_info("flexcop-pci: stream problem, resetting pid filter\n");
 
-				spin_lock_irq(&fc->demux.lock);
-				list_for_each_entry(feed, &fc->demux.feed_list,
-						list_head) {
-					flexcop_pid_feed_control(fc, feed, 0);
-				}
-
-				list_for_each_entry(feed, &fc->demux.feed_list,
-						list_head) {
-					flexcop_pid_feed_control(fc, feed, 1);
-				}
-				spin_unlock_irq(&fc->demux.lock);
-
+				flexcop_stream_reset(fc);
 				fc_pci->stream_problem = 0;
 			}
 		} else {
-- 
2.1.0

