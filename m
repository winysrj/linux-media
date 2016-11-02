Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:49863 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755580AbcKBKkz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 06:40:55 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 4/6] [media] rc-ir-raw: do not generate any receiving thread
 for raw transmitters
Date: Wed, 02 Nov 2016 19:40:08 +0900
Message-id: <20161102104010.26959-5-andi.shyti@samsung.com>
In-reply-to: <20161102104010.26959-1-andi.shyti@samsung.com>
References: <20161102104010.26959-1-andi.shyti@samsung.com>
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
index 205ecc6..db3701f 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -275,12 +275,19 @@ int ir_raw_event_register(struct rc_dev *dev)
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
2.10.1

