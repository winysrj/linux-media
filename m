Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:46549 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753580AbcIAV1U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 17:27:20 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v2 4/7] [media] rc-ir-raw: do not generate any receiving thread
 for raw transmitters
Date: Fri, 02 Sep 2016 02:16:26 +0900
Message-id: <20160901171629.15422-5-andi.shyti@samsung.com>
In-reply-to: <20160901171629.15422-1-andi.shyti@samsung.com>
References: <20160901171629.15422-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Raw IR transmitters do not need any thread listening for
occurring events. Check the driver type before running the
thread.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/rc-ir-raw.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 144304c..64ddc3d 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -274,12 +274,19 @@ int ir_raw_event_register(struct rc_dev *dev)
 	INIT_KFIFO(dev->raw->kfifo);
 
 	spin_lock_init(&dev->raw->lock);
-	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-				       "rc%u", dev->minor);
 
-	if (IS_ERR(dev->raw->thread)) {
-		rc = PTR_ERR(dev->raw->thread);
-		goto out;
+	/*
+	 * raw transmitters do not need any event registration
+	 * because the event is coming from userspace
+	 */
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
+					       "rc%u", dev->minor);
+
+		if (IS_ERR(dev->raw->thread)) {
+			rc = PTR_ERR(dev->raw->thread);
+			goto out;
+		}
 	}
 
 	mutex_lock(&ir_raw_handler_lock);
-- 
2.9.3

