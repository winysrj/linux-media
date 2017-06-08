Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34006 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbdFHKFT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 06:05:19 -0400
Received: by mail-pf0-f181.google.com with SMTP id 9so15592652pfj.1
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 03:05:19 -0700 (PDT)
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
Subject: [PATCH 2/3] media: ngene: Replace semaphore stream_mutex with mutex
Date: Thu,  8 Jun 2017 15:34:57 +0530
Message-Id: <1496916298-5909-3-git-send-email-binoy.jayan@linaro.org>
In-Reply-To: <1496916298-5909-1-git-send-email-binoy.jayan@linaro.org>
References: <1496916298-5909-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The semaphore 'stream_mutex' is used as a simple mutex, so
it should be written as one. Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/media/pci/ngene/ngene-core.c | 14 +++++++-------
 drivers/media/pci/ngene/ngene.h      |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index dfbd1e0..59f2e5f 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -560,7 +560,7 @@ static int ngene_command_stream_control(struct ngene *dev, u8 stream,
 	u16 BsSPI = ((stream & 1) ? 0x9800 : 0x9700);
 	u16 BsSDO = 0x9B00;
 
-	down(&dev->stream_mutex);
+	mutex_lock(&dev->stream_mutex);
 	memset(&com, 0, sizeof(com));
 	com.cmd.hdr.Opcode = CMD_CONTROL;
 	com.cmd.hdr.Length = sizeof(struct FW_STREAM_CONTROL) - 2;
@@ -587,16 +587,16 @@ static int ngene_command_stream_control(struct ngene *dev, u8 stream,
 			chan->HWState = HWSTATE_STOP;
 			spin_unlock_irq(&chan->state_lock);
 			if (ngene_command(dev, &com) < 0) {
-				up(&dev->stream_mutex);
+				mutex_unlock(&dev->stream_mutex);
 				return -1;
 			}
 			/* clear_buffers(chan); */
 			flush_buffers(chan);
-			up(&dev->stream_mutex);
+			mutex_unlock(&dev->stream_mutex);
 			return 0;
 		}
 		spin_unlock_irq(&chan->state_lock);
-		up(&dev->stream_mutex);
+		mutex_unlock(&dev->stream_mutex);
 		return 0;
 	}
 
@@ -693,10 +693,10 @@ static int ngene_command_stream_control(struct ngene *dev, u8 stream,
 	spin_unlock_irq(&chan->state_lock);
 
 	if (ngene_command(dev, &com) < 0) {
-		up(&dev->stream_mutex);
+		mutex_unlock(&dev->stream_mutex);
 		return -1;
 	}
-	up(&dev->stream_mutex);
+	mutex_unlock(&dev->stream_mutex);
 	return 0;
 }
 
@@ -1347,7 +1347,7 @@ static int ngene_start(struct ngene *dev)
 	init_waitqueue_head(&dev->tx_wq);
 	init_waitqueue_head(&dev->rx_wq);
 	mutex_init(&dev->cmd_mutex);
-	sema_init(&dev->stream_mutex, 1);
+	mutex_init(&dev->stream_mutex);
 	sema_init(&dev->pll_mutex, 1);
 	sema_init(&dev->i2c_switch_mutex, 1);
 	spin_lock_init(&dev->cmd_lock);
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index e600b70..0dd15d6 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -763,7 +763,7 @@ struct ngene {
 	wait_queue_head_t     cmd_wq;
 	int                   cmd_done;
 	struct mutex          cmd_mutex;
-	struct semaphore      stream_mutex;
+	struct mutex          stream_mutex;
 	struct semaphore      pll_mutex;
 	struct semaphore      i2c_switch_mutex;
 	int                   i2c_current_channel;
-- 
Binoy Jayan
