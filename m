Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33097 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S980228AbdDYDMv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 23:12:51 -0400
Received: by mail-pg0-f66.google.com with SMTP id 63so8099599pgh.0
        for <linux-media@vger.kernel.org>; Mon, 24 Apr 2017 20:12:51 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] rainshadow-cec: Fix missing spin_lock_init()
Date: Tue, 25 Apr 2017 03:12:46 +0000
Message-Id: <20170425031246.9592-1-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

The driver allocates the spinlock but not initialize it.
Use spin_lock_init() on it to initialize it correctly.

This is detected by Coccinelle semantic patch.

Fixes: 0f314f6c2e77 ("[media] rainshadow-cec: new RainShadow Tech HDMI
CEC driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
index 541ca54..8f562ed 100644
--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -336,6 +336,7 @@ static int rain_connect(struct serio *serio, struct serio_driver *drv)
 	serio_set_drvdata(serio, rain);
 	INIT_WORK(&rain->work, rain_irq_work_handler);
 	mutex_init(&rain->write_lock);
+	spin_lock_init(&rain->buf_lock);
 
 	err = serio_open(serio, drv);
 	if (err)
