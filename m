Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50985 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752178AbdGBLGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Jul 2017 07:06:11 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] [media] rc: mce kbd decoder not needed for IR TX drivers
Date: Sun,  2 Jul 2017 12:06:09 +0100
Message-Id: <931e664353f2275b4d8856e46ba895cd1eb78ad0.1498992850.git.sean@mess.org>
In-Reply-To: <cover.1498992850.git.sean@mess.org>
References: <cover.1498992850.git.sean@mess.org>
In-Reply-To: <cover.1498992850.git.sean@mess.org>
References: <cover.1498992850.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this patch, an input device is created which is not necessary.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 6a4d58b..0e07442 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -358,6 +358,9 @@ static int ir_mce_kbd_register(struct rc_dev *dev)
 	struct input_dev *idev;
 	int i, ret;
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
+		return 0;
+
 	idev = input_allocate_device();
 	if (!idev)
 		return -ENOMEM;
-- 
2.9.4
