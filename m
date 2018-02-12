Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58467 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933694AbeBLPCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 10:02:13 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] media: rc: get start time just before calling driver tx
Date: Mon, 12 Feb 2018 15:02:11 +0000
Message-Id: <20180212150211.28355-5-sean@mess.org>
In-Reply-To: <20180212150211.28355-1-sean@mess.org>
References: <20180212150211.28355-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code gets the start time before copying the IR from
userspace (could cause page faults) and encoding IR. This means
that the gap calculation could be off.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index b25dcff71791..30af7ba9e5ce 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -247,8 +247,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		goto out_unlock;
 	}
 
-	start = ktime_get();
-
 	if (!dev->tx_ir) {
 		ret = -EINVAL;
 		goto out_unlock;
@@ -341,6 +339,8 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		duration += txbuf[i];
 	}
 
+	start = ktime_get();
+
 	ret = dev->tx_ir(dev, txbuf, count);
 	if (ret < 0)
 		goto out_kfree;
-- 
2.14.3
