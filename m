Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32DFC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 768A3206A3
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfBUOV6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:21:58 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51736 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbfBUOV4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:21:56 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wpETg3zIdLMwIwpEYg1DVA; Thu, 21 Feb 2019 15:21:54 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6/7] v4l2-device: v4l2_device_release_subdev_node can't reference sd
Date:   Thu, 21 Feb 2019 15:21:47 +0100
Message-Id: <20190221142148.3412-7-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKkiTtITKTCYaPqL5gMAGSWSW0EcLRzFNnF7FJn8rgEH9dHSuZsDLJ/WbjPN07V9kdSWHGOpvIVwOWpKyvSXg9nnggH3bdmt/MxLf2XPk3UsdpWotqmm
 S0kBcxeSTAlhQRQmPfO/qZCQYSgfRDfZ+4XDfbgqV8uB1/ZxtfJS/CIpCN/Ds9BxYZKcO5QG7LkigCxChmXa+M+3WQ87uU9iuKq7WXTAfOfGvmCZgbkXDyH/
 TQ5gEDk4sj61b570XFrW7g7ny6MGDQn29twKSGtRmCHJAd/4Aj3bfuKzwBUNkSYKdIM/ptOaB2+5JUu/5clLQA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When the v4l-subdev device node is released it calls the
v4l2_device_release_subdev_node() function which sets sd->devnode
to NULL.

However, the v4l2_subdev struct may already be released causing this
to write in freed memory.

Instead just use the regular video_device_release release function
(just calls kfree) and set sd->devnode to NULL right after the
video_unregister_device() call.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-device.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index e0ddb9a52bd1..57a7b220fa4d 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -216,13 +216,6 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
-static void v4l2_device_release_subdev_node(struct video_device *vdev)
-{
-	struct v4l2_subdev *sd = video_get_drvdata(vdev);
-	sd->devnode = NULL;
-	kfree(vdev);
-}
-
 int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 {
 	struct video_device *vdev;
@@ -250,7 +243,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 		vdev->dev_parent = sd->dev;
 		vdev->v4l2_dev = v4l2_dev;
 		vdev->fops = &v4l2_subdev_fops;
-		vdev->release = v4l2_device_release_subdev_node;
+		vdev->release = video_device_release;
 		vdev->ctrl_handler = sd->ctrl_handler;
 		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
 					      sd->owner);
@@ -319,6 +312,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 	}
 #endif
 	video_unregister_device(sd->devnode);
+	sd->devnode = NULL;
 	if (!sd->owner_v4l2_dev)
 		module_put(sd->owner);
 }
-- 
2.20.1

