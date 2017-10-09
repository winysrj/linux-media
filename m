Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33769 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754009AbdJIKTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 08/24] media: v4l2-dev: document VFL_DIR_* direction defines
Date: Mon,  9 Oct 2017 07:19:14 -0300
Message-Id: <150e771ce68cc38453ddc77f55d5ff9f9142e34a.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L_DIR_* direction flags document the direction for a
V4L2 device node. Convert them to enum and document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-dev.h | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index f182b47dfd71..87dac58c7799 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -40,11 +40,21 @@ enum vfl_devnode_type {
 };
 #define VFL_TYPE_MAX VFL_TYPE_TOUCH
 
-/* Is this a receiver, transmitter or mem-to-mem? */
-/* Ignored for VFL_TYPE_SUBDEV. */
-#define VFL_DIR_RX		0
-#define VFL_DIR_TX		1
-#define VFL_DIR_M2M		2
+/**
+ * enum  vfl_direction - Identifies if a &struct video_device corresponds
+ *	to a receiver, a transmitter or a mem-to-mem device.
+ *
+ * @VFL_DIR_RX:		device is a receiver.
+ * @VFL_DIR_TX:		device is a transmitter.
+ * @VFL_DIR_M2M:	device is a memory to memory device.
+ *
+ * Note: Ignored if &enum vfl_devnode_type is %VFL_TYPE_SUBDEV.
+ */
+enum vfl_devnode_direction {
+	VFL_DIR_RX,
+	VFL_DIR_TX,
+	VFL_DIR_M2M,
+};
 
 struct v4l2_ioctl_callbacks;
 struct video_device;
@@ -249,7 +259,7 @@ struct video_device
 	/* device info */
 	char name[32];
 	enum vfl_devnode_type vfl_type;
-	int vfl_dir;
+	enum vfl_devnode_direction vfl_dir;
 	int minor;
 	u16 num;
 	unsigned long flags;
-- 
2.13.6
