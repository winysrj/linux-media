Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41979 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933399AbeGIWjv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 18:39:51 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 07/17] media: platform: video-mux: Register a subdev notifier
Date: Mon,  9 Jul 2018 15:39:07 -0700
Message-Id: <1531175957-1973-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse neighbor remote devices on the video muxes input ports, add them to a
subdev notifier, and register the subdev notifier for the video mux, by
calling v4l2_async_register_fwnode_subdev().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v5:
- add missing select V4L2_FWNODE to Kconfig for VIDEO_MUX
Changes since v4:
- none
Changes since v3:
- pass num_pads - 1 (num_input_pads) to video_mux_async_register().
Changes since v2:
- none
Changes since v1:
- add #include <linux/slab.h> for kcalloc() declaration.
---
 drivers/media/platform/Kconfig     |  1 +
 drivers/media/platform/video-mux.c | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 210b44a..6c3b2b7 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -58,6 +58,7 @@ config VIDEO_MUX
 	select MULTIPLEXER
 	depends on VIDEO_V4L2 && OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
 	select REGMAP
+	select V4L2_FWNODE
 	help
 	  This driver provides support for N:1 video bus multiplexers.
 
diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index 1fb8872..e54a719 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -21,8 +21,10 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 
 struct video_mux {
@@ -207,6 +209,38 @@ static const struct v4l2_subdev_ops video_mux_subdev_ops = {
 	.video = &video_mux_subdev_video_ops,
 };
 
+static int video_mux_parse_endpoint(struct device *dev,
+				    struct v4l2_fwnode_endpoint *vep,
+				    struct v4l2_async_subdev *asd)
+{
+	/*
+	 * it's not an error if remote is missing on a video-mux
+	 * input port, return -ENOTCONN to skip this endpoint with
+	 * no error.
+	 */
+	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
+}
+
+static int video_mux_async_register(struct video_mux *vmux,
+				    unsigned int num_input_pads)
+{
+	unsigned int i, *ports;
+	int ret;
+
+	ports = kcalloc(num_input_pads, sizeof(*ports), GFP_KERNEL);
+	if (!ports)
+		return -ENOMEM;
+	for (i = 0; i < num_input_pads; i++)
+		ports[i] = i;
+
+	ret = v4l2_async_register_fwnode_subdev(
+		&vmux->subdev, sizeof(struct v4l2_async_subdev),
+		ports, num_input_pads, video_mux_parse_endpoint);
+
+	kfree(ports);
+	return ret;
+}
+
 static int video_mux_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -272,7 +306,7 @@ static int video_mux_probe(struct platform_device *pdev)
 
 	vmux->subdev.entity.ops = &video_mux_ops;
 
-	return v4l2_async_register_subdev(&vmux->subdev);
+	return video_mux_async_register(vmux, num_pads - 1);
 }
 
 static int video_mux_remove(struct platform_device *pdev)
-- 
2.7.4
