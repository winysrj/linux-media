Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34235 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbcGSP5J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:57:09 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [RFC 1/7] [media] rc-main: assign driver type during allocation
Date: Wed, 20 Jul 2016 00:56:52 +0900
Message-id: <1468943818-26025-2-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver type can be assigned immediately when an RC device
requests to the framework to allocate the device.

This is an 'enum rc_driver_type' data type and specifies whether
the device is a raw receiver or scancode receiver. The type will
be given as parameter to the rc_allocate_device device.

Suggested-by: Sean Young <sean@mess.org>
Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/rc-main.c | 4 +++-
 include/media/rc-core.h    | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 7dfc7c2..6403674 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1346,7 +1346,7 @@ static struct device_type rc_dev_type = {
 	.uevent		= rc_dev_uevent,
 };
 
-struct rc_dev *rc_allocate_device(void)
+struct rc_dev *rc_allocate_device(enum rc_driver_type type)
 {
 	struct rc_dev *dev;
 
@@ -1373,6 +1373,8 @@ struct rc_dev *rc_allocate_device(void)
 	dev->dev.class = &rc_class;
 	device_initialize(&dev->dev);
 
+	dev->driver_type = type;
+
 	__module_get(THIS_MODULE);
 	return dev;
 }
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index b6586a9..c6bf1ef 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -185,7 +185,7 @@ struct rc_dev {
  * Remote Controller, at sys/class/rc.
  */
 
-struct rc_dev *rc_allocate_device(void);
+struct rc_dev *rc_allocate_device(enum rc_driver_type);
 void rc_free_device(struct rc_dev *dev);
 int rc_register_device(struct rc_dev *dev);
 void rc_unregister_device(struct rc_dev *dev);
-- 
2.8.1

