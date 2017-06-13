Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35407 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdFMI7Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 04:59:16 -0400
Received: by mail-pf0-f177.google.com with SMTP id l89so64602532pfi.2
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 01:59:11 -0700 (PDT)
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
Subject: [PATCH v2 3/3] media: ngene: Replace semaphore i2c_switch_mutex with mutex
Date: Tue, 13 Jun 2017 14:28:50 +0530
Message-Id: <1497344330-13915-4-git-send-email-binoy.jayan@linaro.org>
In-Reply-To: <1497344330-13915-1-git-send-email-binoy.jayan@linaro.org>
References: <1497344330-13915-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The semaphore 'i2c_switch_mutex' is used as a simple mutex, so
it should be written as one. Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/media/pci/ngene/ngene-core.c | 2 +-
 drivers/media/pci/ngene/ngene-i2c.c  | 6 +++---
 drivers/media/pci/ngene/ngene.h      | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index ea64901..8c92cb7 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1345,7 +1345,7 @@ static int ngene_start(struct ngene *dev)
 	mutex_init(&dev->cmd_mutex);
 	mutex_init(&dev->stream_mutex);
 	sema_init(&dev->pll_mutex, 1);
-	sema_init(&dev->i2c_switch_mutex, 1);
+	mutex_init(&dev->i2c_switch_mutex);
 	spin_lock_init(&dev->cmd_lock);
 	for (i = 0; i < MAX_STREAM; i++)
 		spin_lock_init(&dev->channel[i].state_lock);
diff --git a/drivers/media/pci/ngene/ngene-i2c.c b/drivers/media/pci/ngene/ngene-i2c.c
index cf39fcf..fbf3635 100644
--- a/drivers/media/pci/ngene/ngene-i2c.c
+++ b/drivers/media/pci/ngene/ngene-i2c.c
@@ -118,7 +118,7 @@ static int ngene_i2c_master_xfer(struct i2c_adapter *adapter,
 		(struct ngene_channel *)i2c_get_adapdata(adapter);
 	struct ngene *dev = chan->dev;
 
-	down(&dev->i2c_switch_mutex);
+	mutex_lock(&dev->i2c_switch_mutex);
 	ngene_i2c_set_bus(dev, chan->number);
 
 	if (num == 2 && msg[1].flags & I2C_M_RD && !(msg[0].flags & I2C_M_RD))
@@ -136,11 +136,11 @@ static int ngene_i2c_master_xfer(struct i2c_adapter *adapter,
 					    msg[0].buf, msg[0].len, 0))
 			goto done;
 
-	up(&dev->i2c_switch_mutex);
+	mutex_unlock(&dev->i2c_switch_mutex);
 	return -EIO;
 
 done:
-	up(&dev->i2c_switch_mutex);
+	mutex_unlock(&dev->i2c_switch_mutex);
 	return num;
 }
 
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 0dd15d6..7c7cd21 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -765,7 +765,7 @@ struct ngene {
 	struct mutex          cmd_mutex;
 	struct mutex          stream_mutex;
 	struct semaphore      pll_mutex;
-	struct semaphore      i2c_switch_mutex;
+	struct mutex          i2c_switch_mutex;
 	int                   i2c_current_channel;
 	int                   i2c_current_bus;
 	spinlock_t            cmd_lock;
-- 
Binoy Jayan
