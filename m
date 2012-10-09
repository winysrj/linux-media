Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59292 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab2JIWBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 18:01:17 -0400
Received: by mail-gh0-f174.google.com with SMTP id g15so1715114ghb.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 15:01:16 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] [for 3.7] stk1160: Add support for S-Video input
Date: Tue,  9 Oct 2012 19:01:03 -0300
Message-Id: <1349820063-21955-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to fully replace easycap driver with stk1160,
it's also necessary to add S-Video support.

A similar patch backported for v3.2 kernel has been
tested by three different users.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Hi Mauro,

I'm sending this for inclusion in v3.7 second media pull request.
I realize it's very late, so I understand if you don't
want to pick it.

 drivers/media/usb/stk1160/stk1160-core.c |   15 +++++++++++----
 drivers/media/usb/stk1160/stk1160-v4l.c  |    7 ++++++-
 drivers/media/usb/stk1160/stk1160.h      |    3 ++-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index b627408..34a26e0 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -100,12 +100,21 @@ int stk1160_write_reg(struct stk1160 *dev, u16 reg, u16 value)
 
 void stk1160_select_input(struct stk1160 *dev)
 {
+	int route;
 	static const u8 gctrl[] = {
-		0x98, 0x90, 0x88, 0x80
+		0x98, 0x90, 0x88, 0x80, 0x98
 	};
 
-	if (dev->ctl_input < ARRAY_SIZE(gctrl))
+	if (dev->ctl_input == STK1160_SVIDEO_INPUT)
+		route = SAA7115_SVIDEO3;
+	else
+		route = SAA7115_COMPOSITE0;
+
+	if (dev->ctl_input < ARRAY_SIZE(gctrl)) {
+		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
+				route, 0, 0);
 		stk1160_write_reg(dev, STK1160_GCTRL, gctrl[dev->ctl_input]);
+	}
 }
 
 /* TODO: We should break this into pieces */
@@ -351,8 +360,6 @@ static int stk1160_probe(struct usb_interface *interface,
 
 	/* i2c reset saa711x */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, reset, 0);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
-				0, 0, 0);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
 
 	/* reset stk1160 to default values */
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index fe6e857..6694f9e 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -419,7 +419,12 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	if (i->index > STK1160_MAX_INPUT)
 		return -EINVAL;
 
-	sprintf(i->name, "Composite%d", i->index);
+	/* S-Video special handling */
+	if (i->index == STK1160_SVIDEO_INPUT)
+		sprintf(i->name, "S-Video");
+	else
+		sprintf(i->name, "Composite%d", i->index);
+
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	i->std = dev->vdev.tvnorms;
 	return 0;
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 3feba00..68c8707 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -46,7 +46,8 @@
 
 #define STK1160_MIN_PKT_SIZE 3072
 
-#define STK1160_MAX_INPUT 3
+#define STK1160_MAX_INPUT 4
+#define STK1160_SVIDEO_INPUT 4
 
 #define STK1160_I2C_TIMEOUT 100
 
-- 
1.7.4.4

