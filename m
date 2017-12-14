Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:33994 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754271AbdLNTJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:16 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH/RFC v2 01/15] v4l2-subdev.h: add pad and stream aware s_stream
Date: Thu, 14 Dec 2017 20:08:21 +0100
Message-Id: <20171214190835.7672-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To be able to start and stop individual streams of a multiplexed pad the
s_stream operation needs to be both pad and stream aware. Add a new
operation to pad ops to facilitate this.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/v4l2-subdev.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index a30a94fad8dbacde..7288209338a48fda 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -669,6 +669,9 @@ struct v4l2_subdev_pad_config {
  *
  * @set_frame_desc: set the low level media bus frame parameters, @fd array
  *                  may be adjusted by the subdev driver to device capabilities.
+ *
+ * @s_stream: used to notify the driver that a stream will start or has
+ *	stopped.
  */
 struct v4l2_subdev_pad_ops {
 	int (*init_cfg)(struct v4l2_subdev *sd,
@@ -713,6 +716,8 @@ struct v4l2_subdev_pad_ops {
 			   struct v4l2_subdev_routing *route);
 	int (*set_routing)(struct v4l2_subdev *sd,
 			   struct v4l2_subdev_routing *route);
+	int (*s_stream)(struct v4l2_subdev *sd, unsigned int pad,
+			unsigned int stream, int enable);
 };
 
 /**
-- 
2.15.1
