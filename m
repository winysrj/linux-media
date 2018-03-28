Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:39131 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbeC1RP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 13:15:28 -0400
Received: by mail-pg0-f65.google.com with SMTP id b9so1173696pgf.6
        for <linux-media@vger.kernel.org>; Wed, 28 Mar 2018 10:15:28 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 4/5] dvb: earth-pt1: add support for suspend/resume
Date: Thu, 29 Mar 2018 02:15:02 +0900
Message-Id: <20180328171503.30541-5-tskd08@gmail.com>
In-Reply-To: <20180328171503.30541-1-tskd08@gmail.com>
References: <20180328171503.30541-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Without this patch, re-loading of the module was required after resume.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v1:
- none

 drivers/media/pci/pt1/pt1.c | 107 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 60bf517e7fe..80510616c4c 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -461,12 +461,18 @@ static int pt1_thread(void *data)
 {
 	struct pt1 *pt1;
 	struct pt1_buffer_page *page;
+	bool was_frozen;
 
 	pt1 = data;
 	set_freezable();
 
-	while (!kthread_should_stop()) {
-		try_to_freeze();
+	while (!kthread_freezable_should_stop(&was_frozen)) {
+		if (was_frozen) {
+			int i;
+
+			for (i = 0; i < PT1_NR_ADAPS; i++)
+				pt1_set_stream(pt1, i, !!pt1->adaps[i]->users);
+		}
 
 		page = pt1->tables[pt1->table_index].bufs[pt1->buf_index].page;
 		if (!pt1_filter(pt1, page)) {
@@ -1165,6 +1171,98 @@ static void pt1_i2c_init(struct pt1 *pt1)
 		pt1_i2c_emit(pt1, i, 0, 0, 1, 1, 0);
 }
 
+#ifdef CONFIG_PM_SLEEP
+
+static int pt1_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pt1 *pt1 = pci_get_drvdata(pdev);
+
+	pt1_init_streams(pt1);
+	pt1_disable_ram(pt1);
+	pt1->power = 0;
+	pt1->reset = 1;
+	pt1_update_power(pt1);
+	return 0;
+}
+
+static int pt1_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pt1 *pt1 = pci_get_drvdata(pdev);
+	int ret;
+	int i;
+
+	pt1->power = 0;
+	pt1->reset = 1;
+	pt1_update_power(pt1);
+
+	pt1_i2c_init(pt1);
+	pt1_i2c_wait(pt1);
+
+	ret = pt1_sync(pt1);
+	if (ret < 0)
+		goto resume_err;
+
+	pt1_identify(pt1);
+
+	ret = pt1_unlock(pt1);
+	if (ret < 0)
+		goto resume_err;
+
+	ret = pt1_reset_pci(pt1);
+	if (ret < 0)
+		goto resume_err;
+
+	ret = pt1_reset_ram(pt1);
+	if (ret < 0)
+		goto resume_err;
+
+	ret = pt1_enable_ram(pt1);
+	if (ret < 0)
+		goto resume_err;
+
+	pt1_init_streams(pt1);
+
+	pt1->power = 1;
+	pt1_update_power(pt1);
+	msleep(20);
+
+	pt1->reset = 0;
+	pt1_update_power(pt1);
+	usleep_range(1000, 2000);
+
+	for (i = 0; i < PT1_NR_ADAPS; i++)
+		dvb_frontend_reinitialise(pt1->adaps[i]->fe);
+
+	pt1_init_table_count(pt1);
+	for (i = 0; i < pt1_nr_tables; i++) {
+		int j;
+
+		for (j = 0; j < PT1_NR_BUFS; j++)
+			pt1->tables[i].bufs[j].page->upackets[PT1_NR_UPACKETS-1]
+				= 0;
+		pt1_increment_table_count(pt1);
+	}
+	pt1_register_tables(pt1, pt1->tables[0].addr >> PT1_PAGE_SHIFT);
+
+	pt1->table_index = 0;
+	pt1->buf_index = 0;
+	for (i = 0; i < PT1_NR_ADAPS; i++) {
+		pt1->adaps[i]->upacket_count = 0;
+		pt1->adaps[i]->packet_count = 0;
+		pt1->adaps[i]->st_count = -1;
+	}
+
+	return 0;
+
+resume_err:
+	dev_info(&pt1->pdev->dev, "failed to resume PT1/PT2.");
+	return 0;	/* resume anyway */
+}
+
+#endif /* CONFIG_PM_SLEEP */
+
 static void pt1_remove(struct pci_dev *pdev)
 {
 	struct pt1 *pt1;
@@ -1325,11 +1423,16 @@ static const struct pci_device_id pt1_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pt1_id_table);
 
+static SIMPLE_DEV_PM_OPS(pt1_pm_ops, pt1_suspend, pt1_resume);
+
 static struct pci_driver pt1_driver = {
 	.name		= DRIVER_NAME,
 	.probe		= pt1_probe,
 	.remove		= pt1_remove,
 	.id_table	= pt1_id_table,
+#if CONFIG_PM_SLEEP
+	.driver.pm	= &pt1_pm_ops,
+#endif
 };
 
 module_pci_driver(pt1_driver);
-- 
2.16.3
