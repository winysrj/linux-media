Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3206 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaAaLMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 06:12:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: detlev.casanova@gmail.com, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/2] v4l2-device: add inherit_private_ctrls field
Date: Fri, 31 Jan 2014 12:12:06 +0100
Message-Id: <1391166726-27026-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391166726-27026-1-git-send-email-hverkuil@xs4all.nl>
References: <1391166726-27026-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some drivers that implement a simple video pipeline may want to inherit
private controls from their subdevs and expose them through the video node.
That way there is no need to create v4l-subdev nodes to access the private
controls of the sub-devices.

Without this drivers are force to either hack the subdev driver to remove
the is_private setting, or manually add those controls to the bridge driver.

It's the bridge driver that determines whether or not the v4l-subdev nodes
are created, so the bridge driver should also be able to control this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-device.c |  2 +-
 include/media/v4l2-device.h           | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 7045cb2..bf1b047 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -170,7 +170,7 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 
 	/* This just returns 0 if either of the two args is NULL */
 	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler,
-				    false, NULL);
+				    v4l2_dev->inherit_private_ctrls, NULL);
 	if (err)
 		goto error_unregister;
 
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index c9b1593..8350ce5 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -56,6 +56,11 @@ struct v4l2_device {
 			unsigned int notification, void *arg);
 	/* The control handler. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
+	/*
+	 * If true, then when adding controls from a sub-device also
+	 * add the private controls. Used in v4l2_device_register_subdev().
+	 */
+	bool inherit_private_ctrls;
 	/* Device's priority state */
 	struct v4l2_prio_state prio;
 	/* BKL replacement mutex. Temporary solution only. */
@@ -107,7 +112,10 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev);
 
 /* Register a subdev with a v4l2 device. While registered the subdev module
    is marked as in-use. An error is returned if the module is no longer
-   loaded when you attempt to register it. */
+   loaded when you attempt to register it. The controls of the subdev are
+   automatically added to the control handler defined in v4l2_dev. Depending
+   on the inherit_private_ctrls field of v4l2_dev the private controls of
+   the subdev may also be added. */
 int __must_check v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 						struct v4l2_subdev *sd);
 /* Unregister a subdev with a v4l2 device. Can also be called if the subdev
-- 
1.8.5.2

