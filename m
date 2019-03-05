Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DE2C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30E79206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfCEJ67 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:58:59 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:39146 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbfCEJ6z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 04:58:55 -0500
Received: from test-no.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 16qVhtdVBLMwI16qbhrctj; Tue, 05 Mar 2019 10:58:53 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 6/9] v4l2-subdev: add release() internal op
Date:   Tue,  5 Mar 2019 10:58:44 +0100
Message-Id: <20190305095847.21428-7-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOgZY9pHGq3jUv18ey9Nq2SqEEKLwqmmK3derkwav4eWjAt6zOaumShOc11pK5piiRj3JhquRmsiWcxoh1tPrTvpmX5CFaVHbmU09GkJ5qKzrA4829P2
 dMkWOyG6ZtjLH+593MOVx9x8QhzrDA7IgoCcVDxBwN1ZlYWMXoXvq/qMSNMevR0fSXV4OA2D+f2JHN9UkQKQGVfdcnpSejeIkPXCnQpXgzeSUUrwMbcFhWdv
 YcgdUbxLzH2c7lJl4j2BOvvrx5KyAc5mIwd7SbWXqt47+xkduKf9asv9l6N6mPdbGxpFVWadyDCXH0sMbb6iaQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

If the subdevice created a device node, then the v4l2_subdev cannot
be freed until the last user of the device node closes it.

This means that we need a release() callback in v4l2_subdev_internal_ops
that is called from the video_device release function so the subdevice
driver can postpone freeing memory until the that callback is called.

If no video device node was created then the release callback can
be called immediately when the subdev is unregistered.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-device.c | 19 ++++++++++++++-----
 include/media/v4l2-subdev.h           |  3 +++
 2 files changed, 17 insertions(+), 5 deletions(-)

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
index 349e1c18cf48..2f2d1c8947e6 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -757,6 +757,8 @@ struct v4l2_subdev_ops {
  *
  * @close: called when the subdev device node is closed.
  *
+ * @release: called when the subdev device node is released.
+ *
  * .. note::
  *	Never call this from drivers, only the v4l2 framework can call
  *	these ops.
@@ -766,6 +768,7 @@ struct v4l2_subdev_internal_ops {
 	void (*unregistered)(struct v4l2_subdev *sd);
 	int (*open)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
 	int (*close)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
+	void (*release)(struct v4l2_subdev *sd);
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32
-- 
2.20.1

