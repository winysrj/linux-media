Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp509.mail.kks.yahoo.co.jp ([114.111.99.158]:23426 "HELO
	smtp509.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755223Ab2CJPpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 10:45:25 -0500
From: tskd2@yahoo.co.jp
To: linux-media@vger.kernel.org
Cc: Akihiro Tsukada <tskd2@yahoo.co.jp>
Subject: [PATCH 1/4] dvb: earth-pt1: stop polling data when no one accesses the device
Date: Sun, 11 Mar 2012 00:38:13 +0900
Message-Id: <1331393896-17902-1-git-send-email-tskd2@yahoo.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd2@yahoo.co.jp>

The driver started a kthread to poll the DMA buffers soon after probing,
which relsuleted in 1000/sec sleeps and wakeups of the thread doing nothing
useful until someone started feeding.
This patch changes the creation and destruction of the kthread depending on the number of users.

Signed-off-by: Akihiro Tsukada <tskd2@yahoo.co.jp>
---
 drivers/media/dvb/pt1/pt1.c |   73 +++++++++++++++++++++++++++++-------------
 1 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb/pt1/pt1.c b/drivers/media/dvb/pt1/pt1.c
index b81df5f..463f784 100644
--- a/drivers/media/dvb/pt1/pt1.c
+++ b/drivers/media/dvb/pt1/pt1.c
@@ -77,6 +77,8 @@ struct pt1 {
 	struct pt1_adapter *adaps[PT1_NR_ADAPS];
 	struct pt1_table *tables;
 	struct task_struct *kthread;
+	int table_index;
+	int buf_index;
 
 	struct mutex lock;
 	int power;
@@ -303,30 +305,25 @@ static int pt1_filter(struct pt1 *pt1, struct pt1_buffer_page *page)
 static int pt1_thread(void *data)
 {
 	struct pt1 *pt1;
-	int table_index;
-	int buf_index;
 	struct pt1_buffer_page *page;
 
 	pt1 = data;
 	set_freezable();
 
-	table_index = 0;
-	buf_index = 0;
-
 	while (!kthread_should_stop()) {
 		try_to_freeze();
 
-		page = pt1->tables[table_index].bufs[buf_index].page;
+		page = pt1->tables[pt1->table_index].bufs[pt1->buf_index].page;
 		if (!pt1_filter(pt1, page)) {
 			schedule_timeout_interruptible((HZ + 999) / 1000);
 			continue;
 		}
 
-		if (++buf_index >= PT1_NR_BUFS) {
+		if (++pt1->buf_index >= PT1_NR_BUFS) {
 			pt1_increment_table_count(pt1);
-			buf_index = 0;
-			if (++table_index >= pt1_nr_tables)
-				table_index = 0;
+			pt1->buf_index = 0;
+			if (++pt1->table_index >= pt1_nr_tables)
+				pt1->table_index = 0;
 		}
 	}
 
@@ -477,21 +474,60 @@ err:
 	return ret;
 }
 
+static int pt1_start_polling(struct pt1 *pt1)
+{
+	int ret = 0;
+
+	mutex_lock(&pt1->lock);
+	if (!pt1->kthread) {
+		pt1->kthread = kthread_run(pt1_thread, pt1, "earth-pt1");
+		if (IS_ERR(pt1->kthread)) {
+			ret = PTR_ERR(pt1->kthread);
+			pt1->kthread = NULL;
+		}
+	}
+	mutex_unlock(&pt1->lock);
+	return ret;
+}
+
 static int pt1_start_feed(struct dvb_demux_feed *feed)
 {
 	struct pt1_adapter *adap;
 	adap = container_of(feed->demux, struct pt1_adapter, demux);
-	if (!adap->users++)
+	if (!adap->users++) {
+		int ret;
+
+		ret = pt1_start_polling(adap->pt1);
+		if (ret)
+			return ret;
 		pt1_set_stream(adap->pt1, adap->index, 1);
+	}
 	return 0;
 }
 
+static void pt1_stop_polling(struct pt1 *pt1)
+{
+	int i, count;
+
+	mutex_lock(&pt1->lock);
+	for (i = 0, count = 0; i < PT1_NR_ADAPS; i++)
+		count += pt1->adaps[i]->users;
+
+	if (count == 0 && pt1->kthread) {
+		kthread_stop(pt1->kthread);
+		pt1->kthread = NULL;
+	}
+	mutex_unlock(&pt1->lock);
+}
+
 static int pt1_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct pt1_adapter *adap;
 	adap = container_of(feed->demux, struct pt1_adapter, demux);
-	if (!--adap->users)
+	if (!--adap->users) {
 		pt1_set_stream(adap->pt1, adap->index, 0);
+		pt1_stop_polling(adap->pt1);
+	}
 	return 0;
 }
 
@@ -1020,7 +1056,8 @@ static void __devexit pt1_remove(struct pci_dev *pdev)
 	pt1 = pci_get_drvdata(pdev);
 	regs = pt1->regs;
 
-	kthread_stop(pt1->kthread);
+	if (pt1->kthread)
+		kthread_stop(pt1->kthread);
 	pt1_cleanup_tables(pt1);
 	pt1_cleanup_frontends(pt1);
 	pt1_disable_ram(pt1);
@@ -1043,7 +1080,6 @@ pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	void __iomem *regs;
 	struct pt1 *pt1;
 	struct i2c_adapter *i2c_adap;
-	struct task_struct *kthread;
 
 	ret = pci_enable_device(pdev);
 	if (ret < 0)
@@ -1139,17 +1175,8 @@ pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret < 0)
 		goto err_pt1_cleanup_frontends;
 
-	kthread = kthread_run(pt1_thread, pt1, "pt1");
-	if (IS_ERR(kthread)) {
-		ret = PTR_ERR(kthread);
-		goto err_pt1_cleanup_tables;
-	}
-
-	pt1->kthread = kthread;
 	return 0;
 
-err_pt1_cleanup_tables:
-	pt1_cleanup_tables(pt1);
 err_pt1_cleanup_frontends:
 	pt1_cleanup_frontends(pt1);
 err_pt1_disable_ram:
-- 
1.7.7.6

