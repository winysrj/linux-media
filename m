Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39078 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752927AbdHKJ5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:21 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 02/20] v4l2-subdev.h: add pad and stream aware s_stream
Date: Fri, 11 Aug 2017 11:56:45 +0200
Message-Id: <20170811095703.6170-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
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
index 7e63124450a963da..c258b1524f94f8ff 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -643,6 +643,9 @@ struct v4l2_subdev_pad_config {
  *
  * @set_frame_desc: set the low level media bus frame parameters, @fd array
  *                  may be adjusted by the subdev driver to device capabilities.
+ *
+ * @s_stream: used to notify the driver that a stream will start or has
+ *	stopped.
  */
 struct v4l2_subdev_pad_ops {
 	int (*init_cfg)(struct v4l2_subdev *sd,
@@ -683,6 +686,8 @@ struct v4l2_subdev_pad_ops {
 			      struct v4l2_mbus_frame_desc *fd);
 	int (*set_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
 			      struct v4l2_mbus_frame_desc *fd);
+	int (*s_stream)(struct v4l2_subdev *sd, unsigned int pad,
+			unsigned int stream, int enable);
 };
 
 /**
-- 
2.13.3
