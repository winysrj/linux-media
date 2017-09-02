Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38977 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752469AbdIBLmw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:42:52 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 7/7] media: rc: include device name in rc udev event
Date: Sat,  2 Sep 2017 12:42:48 +0100
Message-Id: <09b077a9d9d953046bb8c9e12684fc977e8bcf4c.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This name is also stored in the input's device name, but that
is not available in TX only hardware (no input device).

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index cf0c407d8f5b..9d9bdd1dec78 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1480,6 +1480,8 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 		ADD_HOTPLUG_VAR("NAME=%s", dev->rc_map.name);
 	if (dev->driver_name)
 		ADD_HOTPLUG_VAR("DRV_NAME=%s", dev->driver_name);
+	if (dev->device_name)
+		ADD_HOTPLUG_VAR("DEV_NAME=%s", dev->device_name);
 
 	return 0;
 }
-- 
2.13.5
