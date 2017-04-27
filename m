Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164087AbdD0S0P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 14:26:15 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 1/5] v4l2-subdev: Provide a port mapping for asynchronous subdevs
Date: Thu, 27 Apr 2017 19:26:00 +0100
Message-Id: <1493317564-18026-2-git-send-email-kbingham@kernel.org>
In-Reply-To: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Devices such as the the ADV748x support multiple parallel stream routes
through a single chip. This leads towards needing to provide multiple
distinct entities and subdevs from a single device-tree node.

To distinguish these separate outputs, the device-tree binding must
specify each endpoint link with a unique (to the device) non-zero port
number.

This number allows async subdev registrations to identify the correct
subdevice to bind and link.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-async.c  | 7 +++++++
 drivers/media/v4l2-core/v4l2-subdev.c | 1 +
 include/media/v4l2-async.h            | 1 +
 include/media/v4l2-subdev.h           | 2 ++
 4 files changed, 11 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 1815e54e8a38..875e6ce646ec 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -42,6 +42,13 @@ static bool match_devname(struct v4l2_subdev *sd,
 
 static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
+	/*
+	 * If set, we must match the device tree port, with the subdev port.
+	 * This is a fast match, so do this first
+	 */
+	if (sd->port && sd->port != asd->match.of.port)
+		return -1;
+
 	return !of_node_cmp(of_node_full_name(sd->of_node),
 			    of_node_full_name(asd->match.of.node));
 }
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index da78497ae5ed..67f816f90ac3 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -607,6 +607,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->flags = 0;
 	sd->name[0] = '\0';
 	sd->grp_id = 0;
+	sd->port = 0;
 	sd->dev_priv = NULL;
 	sd->host_priv = NULL;
 #if defined(CONFIG_MEDIA_CONTROLLER)
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 5b501309b6a7..2988960613ec 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -56,6 +56,7 @@ struct v4l2_async_subdev {
 	union {
 		struct {
 			const struct device_node *node;
+			u32 port;
 		} of;
 		struct {
 			const char *name;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0ab1c5df6fac..1c1731b491e5 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -782,6 +782,7 @@ struct v4l2_subdev_platform_data {
  * @ctrl_handler: The control handler of this subdev. May be NULL.
  * @name: Name of the sub-device. Please notice that the name must be unique.
  * @grp_id: can be used to group similar subdevs. Value is driver-specific
+ * @port: driver-specific value to bind multiple subdevs with a single DT node.
  * @dev_priv: pointer to private data
  * @host_priv: pointer to private data used by the device where the subdev
  *	is attached.
@@ -814,6 +815,7 @@ struct v4l2_subdev {
 	struct v4l2_ctrl_handler *ctrl_handler;
 	char name[V4L2_SUBDEV_NAME_SIZE];
 	u32 grp_id;
+	u32 port;
 	void *dev_priv;
 	void *host_priv;
 	struct video_device *devnode;
-- 
2.7.4
