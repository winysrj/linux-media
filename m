Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:34245 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbdFMI7E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 04:59:04 -0400
Received: by mail-pg0-f41.google.com with SMTP id v18so57641112pgb.1
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 01:59:04 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rajendra <rnayak@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cao jin <caoj.fnst@cn.fujitsu.com>, linux-media@vger.kernel.org
Subject: [PATCH v2 1/3] media: ngene: Replace semaphore cmd_mutex with mutex
Date: Tue, 13 Jun 2017 14:28:48 +0530
Message-Id: <1497344330-13915-2-git-send-email-binoy.jayan@linaro.org>
In-Reply-To: <1497344330-13915-1-git-send-email-binoy.jayan@linaro.org>
References: <1497344330-13915-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The semaphore 'cmd_mutex' is used as a simple mutex, so
it should be written as one. Also, replace down with
mutex_destroy to ensure sane state when ngene_stop is
called.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/media/pci/ngene/ngene-core.c | 12 ++++++------
 drivers/media/pci/ngene/ngene.h      |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index ce69e64..eeb61eb 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -336,9 +336,9 @@ int ngene_command(struct ngene *dev, struct ngene_command *com)
 {
 	int result;
 
-	down(&dev->cmd_mutex);
+	mutex_lock(&dev->cmd_mutex);
 	result = ngene_command_mutex(dev, com);
-	up(&dev->cmd_mutex);
+	mutex_unlock(&dev->cmd_mutex);
 	return result;
 }
 
@@ -1283,7 +1283,7 @@ static int ngene_load_firm(struct ngene *dev)
 
 static void ngene_stop(struct ngene *dev)
 {
-	down(&dev->cmd_mutex);
+	mutex_destroy(&dev->cmd_mutex);
 	i2c_del_adapter(&(dev->channel[0].i2c_adapter));
 	i2c_del_adapter(&(dev->channel[1].i2c_adapter));
 	ngwritel(0, NGENE_INT_ENABLE);
@@ -1346,7 +1346,7 @@ static int ngene_start(struct ngene *dev)
 	init_waitqueue_head(&dev->cmd_wq);
 	init_waitqueue_head(&dev->tx_wq);
 	init_waitqueue_head(&dev->rx_wq);
-	sema_init(&dev->cmd_mutex, 1);
+	mutex_init(&dev->cmd_mutex);
 	sema_init(&dev->stream_mutex, 1);
 	sema_init(&dev->pll_mutex, 1);
 	sema_init(&dev->i2c_switch_mutex, 1);
@@ -1606,10 +1606,10 @@ static void ngene_unlink(struct ngene *dev)
 	com.in_len = 3;
 	com.out_len = 1;
 
-	down(&dev->cmd_mutex);
+	mutex_lock(&dev->cmd_mutex);
 	ngwritel(0, NGENE_INT_ENABLE);
 	ngene_command_mutex(dev, &com);
-	up(&dev->cmd_mutex);
+	mutex_unlock(&dev->cmd_mutex);
 }
 
 void ngene_shutdown(struct pci_dev *pdev)
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 10d8f74..e600b70 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -762,7 +762,7 @@ struct ngene {
 
 	wait_queue_head_t     cmd_wq;
 	int                   cmd_done;
-	struct semaphore      cmd_mutex;
+	struct mutex          cmd_mutex;
 	struct semaphore      stream_mutex;
 	struct semaphore      pll_mutex;
 	struct semaphore      i2c_switch_mutex;
-- 
Binoy Jayan
