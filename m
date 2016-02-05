Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55272 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbcBETKT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:19 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 1/8] [media] v4l2-subdev: add registered_async subdev core operation
Date: Fri,  5 Feb 2016 16:09:51 -0300
Message-Id: <1454699398-8581-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 sub-devices that are registered asynchronously have no way to know
when they have been registration with a V4L2 device but they might need
to take some action after this.

So let's add a callback that can be executed by the V4L2 async core to
allow sub-devices drivers to do any needed initialization that depends
on the registration.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 include/media/v4l2-subdev.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b273cf9ac047..11e2dfec0198 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -179,6 +179,8 @@ struct v4l2_subdev_io_pin_config {
  *		     for it to be warned when the value of a control changes.
  *
  * @unsubscribe_event: remove event subscription from the control framework.
+ *
+ * @registered_async: the subdevice has been registered async.
  */
 struct v4l2_subdev_core_ops {
 	int (*log_status)(struct v4l2_subdev *sd);
@@ -211,6 +213,7 @@ struct v4l2_subdev_core_ops {
 			       struct v4l2_event_subscription *sub);
 	int (*unsubscribe_event)(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 				 struct v4l2_event_subscription *sub);
+	int (*registered_async)(struct v4l2_subdev *sd);
 };
 
 /**
-- 
2.5.0

