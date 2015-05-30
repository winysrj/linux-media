Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34236 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbbE3SKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2015 14:10:40 -0400
Received: by wgv5 with SMTP id 5so85187895wgv.1
        for <linux-media@vger.kernel.org>; Sat, 30 May 2015 11:10:38 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH v2 3/4] b2c2: Add external stream control
Date: Sat, 30 May 2015 19:10:08 +0100
Message-Id: <1433009409-5622-4-git-send-email-jdenson@gmail.com>
In-Reply-To: <1433009409-5622-1-git-send-email-jdenson@gmail.com>
References: <1433009409-5622-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some demods are aware that their stream has stopped, such as whilst
tuning. Allow them to control the flexcop receive and output
streams.

This avoids flexcop_pci_irq_check_work from triggering and resetting
the stream unneccesarily due to a lack of data.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/common/b2c2/flexcop-common.h    |  3 +++
 drivers/media/common/b2c2/flexcop-hw-filter.c | 38 ++++++++++++++++++++-------
 drivers/media/pci/b2c2/flexcop-pci.c          |  5 +++-
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-common.h b/drivers/media/common/b2c2/flexcop-common.h
index 184adda..fa606ec 100644
--- a/drivers/media/common/b2c2/flexcop-common.h
+++ b/drivers/media/common/b2c2/flexcop-common.h
@@ -91,6 +91,8 @@ struct flexcop_device {
 	int feedcount;
 	int pid_filtering;
 	int fullts_streaming_state;
+	int use_external_stream_control;
+	int external_stream_started;
 	int skip_6_hw_pid_filter;
 
 	/* bus specific callbacks */
@@ -178,6 +180,7 @@ int flexcop_pid_feed_control(struct flexcop_device *fc,
 		struct dvb_demux_feed *dvbdmxfeed, int onoff);
 void flexcop_hw_filter_init(struct flexcop_device *fc);
 void flexcop_stream_reset(struct flexcop_device *fc);
+void flexcop_external_stream_control(struct flexcop_device *fc, int onoff);
 
 void flexcop_smc_ctrl(struct flexcop_device *fc, int onoff);
 
diff --git a/drivers/media/common/b2c2/flexcop-hw-filter.c b/drivers/media/common/b2c2/flexcop-hw-filter.c
index da000ba..8fdeaa2 100644
--- a/drivers/media/common/b2c2/flexcop-hw-filter.c
+++ b/drivers/media/common/b2c2/flexcop-hw-filter.c
@@ -171,6 +171,8 @@ static int flexcop_toggle_fullts_streaming(struct flexcop_device *fc, int onoff)
 	return 0;
 }
 
+static void flexcop_stream_control(struct flexcop_device *fc, int onoff);
+
 int flexcop_pid_feed_control(struct flexcop_device *fc,
 		struct dvb_demux_feed *dvbdmxfeed, int onoff)
 {
@@ -206,15 +208,9 @@ int flexcop_pid_feed_control(struct flexcop_device *fc,
 
 	/* if it was the first or last feed request change the stream-status */
 	if (fc->feedcount == onoff) {
-		flexcop_rcv_data_ctrl(fc, onoff);
-		if (fc->stream_control) /* device specific stream control */
-			fc->stream_control(fc, onoff);
-
-		/* feeding stopped -> reset the flexcop filter*/
-		if (onoff == 0) {
-			flexcop_reset_block_300(fc);
-			flexcop_hw_filter_init(fc);
-		}
+		if (!fc->use_external_stream_control ||
+		    fc->external_stream_started)
+			flexcop_stream_control(fc, onoff);
 	}
 	return 0;
 }
@@ -257,3 +253,27 @@ void flexcop_stream_reset(struct flexcop_device *fc)
 	spin_unlock_irq(&fc->demux.lock);
 }
 EXPORT_SYMBOL(flexcop_stream_reset);
+
+void flexcop_stream_control(struct flexcop_device *fc, int onoff)
+{
+	flexcop_rcv_data_ctrl(fc, onoff);
+
+	/* device specific stream control */
+	if (fc->stream_control)
+		fc->stream_control(fc, onoff);
+
+	/* feeding stopped -> reset the flexcop filter*/
+	if (onoff == 0) {
+		flexcop_reset_block_300(fc);
+		flexcop_hw_filter_init(fc);
+	}
+}
+
+void flexcop_external_stream_control(struct flexcop_device *fc, int onoff)
+{
+	fc->external_stream_started = onoff;
+
+	/* only change stream if feed already requested */
+	if (fc->feedcount)
+		flexcop_stream_control(fc, onoff);
+}
diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
index eb3b31f..cd49790 100644
--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -62,6 +62,7 @@ struct flexcop_pci {
 	int count;
 	int count_prev;
 	int stream_problem;
+	int stream_started;
 
 	spinlock_t irq_lock;
 	unsigned long last_irq;
@@ -107,7 +108,7 @@ static void flexcop_pci_irq_check_work(struct work_struct *work)
 		container_of(work, struct flexcop_pci, irq_check_work.work);
 	struct flexcop_device *fc = fc_pci->fc_dev;
 
-	if (fc->feedcount) {
+	if (fc_pci->stream_started) {
 
 		if (fc_pci->count == fc_pci->count_prev) {
 			deb_chk("no IRQ since the last check\n");
@@ -232,6 +233,7 @@ static int flexcop_pci_stream_control(struct flexcop_device *fc, int onoff)
 		flexcop_dma_control_timer_irq(fc, FC_DMA_1, 1);
 		deb_irq("IRQ enabled\n");
 		fc_pci->count_prev = fc_pci->count;
+		fc_pci->stream_started = 1;
 	} else {
 		flexcop_dma_control_timer_irq(fc, FC_DMA_1, 0);
 		deb_irq("IRQ disabled\n");
@@ -239,6 +241,7 @@ static int flexcop_pci_stream_control(struct flexcop_device *fc, int onoff)
 		flexcop_dma_xfer_control(fc, FC_DMA_1,
 			 FC_DMA_SUBADDR_0 | FC_DMA_SUBADDR_1, 0);
 		deb_irq("DMA xfer disabled\n");
+		fc_pci->stream_started = 0;
 	}
 	return 0;
 }
-- 
2.1.0

