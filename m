Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E78C10F0C
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0838320661
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfCHN4i (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:56:38 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:48748 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbfCHN4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 08:56:32 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 2Fz7hPu8XI8AW2FzChLWFl; Fri, 08 Mar 2019 14:56:30 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 5/9] v4l2-subdev: add release() internal op
Date:   Fri,  8 Mar 2019 14:56:21 +0100
Message-Id: <20190308135625.11278-6-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
References: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfACdcE0cPS2rLGfu372taeC34S1lAywkR4NlMCsUvZ/F8obcioZCGgjNTN3X5YwLa+qbMwzWHjilWqzh0bVpHKM422Tpu/O0XZgFlTRRHDGHDLt9VNTA
 lDSkhxYDuk3PrBbOmOa6rz4sMrsKGzLjF+r1LiNdVQwvVW4G9rZ6fqqtPzwsKCmoWvpLwy6exzR1+xBVMQWx4rfxSARQxavQzeYvRV9yI8WzgHxQJZkSPL83
 P2EDWkpARa/AuDyr/fzU2MMRWTjH3U+TzfC0HnW14yhVTAFM8uU1uF+uEpKxgOrVvjpBD9fVwckTZ6QcGsOSlw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If the subdevice created a device node, then the v4l2_subdev cannot
be freed until the last user of the device node closes it.

This means that we need a release() callback in v4l2_subdev_internal_ops
that is called from the video_device release function so the subdevice
driver can postpone freeing memory until the that callback is called.

If no video device node was created then the release callback can
be called immediately when the subdev is unregistered.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-device.c | 19 ++++++++++++++-----
 include/media/v4l2-subdev.h           | 13 ++++++++++++-
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index e0ddb9a52bd1..7cca0de1b730 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -216,10 +216,18 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
+static void v4l2_subdev_release(struct v4l2_subdev *sd)
+{
+	struct module *owner = !sd->owner_v4l2_dev ? sd->owner : NULL;
+
+	if (sd->internal_ops && sd->internal_ops->release)
+		sd->internal_ops->release(sd);
+	module_put(owner);
+}
+
 static void v4l2_device_release_subdev_node(struct video_device *vdev)
 {
-	struct v4l2_subdev *sd = video_get_drvdata(vdev);
-	sd->devnode = NULL;
+	v4l2_subdev_release(video_get_drvdata(vdev));
 	kfree(vdev);
 }
 
@@ -318,8 +326,9 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 		media_device_unregister_entity(&sd->entity);
 	}
 #endif
-	video_unregister_device(sd->devnode);
-	if (!sd->owner_v4l2_dev)
-		module_put(sd->owner);
+	if (sd->devnode)
+		video_unregister_device(sd->devnode);
+	else
+		v4l2_subdev_release(sd);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 349e1c18cf48..0ee7ecd5ce77 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -755,7 +755,17 @@ struct v4l2_subdev_ops {
  *
  * @open: called when the subdev device node is opened by an application.
  *
- * @close: called when the subdev device node is closed.
+ * @close: called when the subdev device node is closed. Please note that
+ * 	it is possible for @close to be called after @unregistered!
+ *
+ * @release: called when the last user of the subdev device is gone. This
+ *	happens after the @unregistered callback and when the last open
+ *	filehandle to the v4l-subdevX device node was closed. If no device
+ *	node was created for this sub-device, then the @release callback
+ *	is called right after the @unregistered callback.
+ *	The @release callback is typically used to free the memory containing
+ *	the v4l2_subdev structure. It is almost certainly required for any
+ *	sub-device that sets the V4L2_SUBDEV_FL_HAS_DEVNODE flag.
  *
  * .. note::
  *	Never call this from drivers, only the v4l2 framework can call
@@ -766,6 +776,7 @@ struct v4l2_subdev_internal_ops {
 	void (*unregistered)(struct v4l2_subdev *sd);
 	int (*open)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
 	int (*close)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
+	void (*release)(struct v4l2_subdev *sd);
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32
-- 
2.20.1

