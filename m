Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42810
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbcHKQ2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 12:28:41 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] v4l2-async: remove unneeded .registered_async callback
Date: Thu, 11 Aug 2016 12:28:16 -0400
Message-Id: <1470932896-25843-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1470932896-25843-1-git-send-email-javier@osg.samsung.com>
References: <1470932896-25843-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_subdev_core_ops .registered_async callback was added to notify
a subdev when its entity has been registered with the media device, to
allow for example to modify the media graph (i.e: adding entities/links).

But that's not needed since there is already a .registered callback in
struct v4l2_subdev_internal_ops that's called after the entity has been
registered with the media device in v4l2_device_register_subdev().

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/v4l2-core/v4l2-async.c | 7 -------
 include/media/v4l2-subdev.h          | 3 ---
 2 files changed, 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index a4b224d92572..5bada202b2d3 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -119,13 +119,6 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 		return ret;
 	}
 
-	ret = v4l2_subdev_call(sd, core, registered_async);
-	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, asd);
-		return ret;
-	}
-
 	if (list_empty(&notifier->waiting) && notifier->complete)
 		return notifier->complete(notifier);
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2a2240c99b30..6baad1387203 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -184,8 +184,6 @@ struct v4l2_subdev_io_pin_config {
  *		     for it to be warned when the value of a control changes.
  *
  * @unsubscribe_event: remove event subscription from the control framework.
- *
- * @registered_async: the subdevice has been registered async.
  */
 struct v4l2_subdev_core_ops {
 	int (*log_status)(struct v4l2_subdev *sd);
@@ -211,7 +209,6 @@ struct v4l2_subdev_core_ops {
 			       struct v4l2_event_subscription *sub);
 	int (*unsubscribe_event)(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 				 struct v4l2_event_subscription *sub);
-	int (*registered_async)(struct v4l2_subdev *sd);
 };
 
 /**
-- 
2.5.5

