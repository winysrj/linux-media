Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbcGUUS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/12] [media] v4l2-async: document the remaining stuff
Date: Thu, 21 Jul 2016 17:18:14 -0300
Message-Id: <5ec652fa872560b8bb02d324dd6e6b635bc2d647.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are one enum and 4 functions undocumented there.
Document them. That will fix the broken links at the
v4l2-subdev.rst file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-async.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 1d6d7da4c45d..8e2a236a4d03 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -23,6 +23,19 @@ struct v4l2_async_notifier;
 /* A random max subdevice number, used to allocate an array on stack */
 #define V4L2_MAX_SUBDEVS 128U
 
+/**
+ * enum v4l2_async_match_type - type of asynchronous subdevice logic to be used
+ *	in order to identify a match
+ *
+ * @V4L2_ASYNC_MATCH_CUSTOM: Match will use the logic provided by &struct
+ * 	v4l2_async_subdev.match ops
+ * @V4L2_ASYNC_MATCH_DEVNAME: Match will use the device name
+ * @V4L2_ASYNC_MATCH_I2C: Match will check for I2C adapter ID and address
+ * @V4L2_ASYNC_MATCH_OF: Match will use OF node
+ *
+ * This enum is used by the asyncrhronous sub-device logic to define the
+ * algorithm that will be used to match an asynchronous device.
+ */
 enum v4l2_async_match_type {
 	V4L2_ASYNC_MATCH_CUSTOM,
 	V4L2_ASYNC_MATCH_DEVNAME,
@@ -91,9 +104,35 @@ struct v4l2_async_notifier {
 		       struct v4l2_async_subdev *asd);
 };
 
+/**
+ * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
+ *
+ * @v4l2_dev: pointer to &struct v4l2_device
+ * @notifier: pointer to &struct v4l2_async_notifier
+ */
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier);
+
+/**
+ * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
+ *
+ * @notifier: pointer to &struct v4l2_async_notifier
+ */
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
+
+/**
+ * v4l2_async_register_subdev - registers a sub-device to the asynchronous
+ * 	subdevice framework
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ */
 int v4l2_async_register_subdev(struct v4l2_subdev *sd);
+
+/**
+ * v4l2_async_unregister_subdev - unregisters a sub-device to the asynchronous
+ * 	subdevice framework
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ */
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
 #endif
-- 
2.7.4

