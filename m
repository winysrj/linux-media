Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2119 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3CKLql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 02/42] v4l2-core: add code to check for specific ops.
Date: Mon, 11 Mar 2013 12:45:40 +0100
Message-Id: <5270e1d72ea8bf5e78f09c37f414551a050ae02f.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch adds a v4l2_subdev_has_op() macro and a v4l2_device_has_op macro to
quickly check if a specific subdev or any subdev supports a particular subdev
operation.

This makes it easy for drivers to disable certain ioctls if none of the subdevs
supports the necessary functionality.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-device.h |   13 +++++++++++++
 include/media/v4l2-subdev.h |    3 +++
 2 files changed, 16 insertions(+)

diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index d61febf..c9b1593 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -190,4 +190,17 @@ v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev);
 			##args);					\
 })
 
+#define v4l2_device_has_op(v4l2_dev, o, f)				\
+({									\
+	struct v4l2_subdev *__sd;					\
+	bool __result = false;						\
+	list_for_each_entry(__sd, &(v4l2_dev)->subdevs, list) {		\
+		if (v4l2_subdev_has_op(__sd, o, f)) {			\
+			__result = true;				\
+			break;						\
+		}							\
+	}								\
+	__result;							\
+})
+
 #endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b137a5e..0740c06 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -687,4 +687,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
 	((!(sd) || !(sd)->v4l2_dev || !(sd)->v4l2_dev->notify) ? -ENODEV : \
 	 (sd)->v4l2_dev->notify((sd), (notification), (arg)))
 
+#define v4l2_subdev_has_op(sd, o, f) \
+	((sd)->ops->o && (sd)->ops->o->f)
+
 #endif
-- 
1.7.10.4

