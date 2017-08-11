Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39198 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752935AbdHKJ5Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:25 -0400
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
Subject: [PATCH 05/20] v4l2-core: verify all streams formats on multiplexed links
Date: Fri, 11 Aug 2017 11:56:48 +0200
Message-Id: <20170811095703.6170-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the format validation for multiplexed pads to verify all streams
which are part of the multiplexed link. This might take the verification
to an extreme as it could be argued that one should be able to configure
and start just one stream without having to configure other streams
which the user never intends to start.

It could also be argued that the multiplexer and demultiplexer needs to
know about all formats which could be activated before any stream could
be started. In such case the number of streams described in the frame
descriptor should be dynamic and only possible and configured streams
should be reported which would then solve this issue.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 72 +++++++++++++++++++++++++++++++----
 1 file changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index d6c1a3b777dd2fcd..43cd2b5e3d8ea323 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -541,20 +541,76 @@ v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 	return -EINVAL;
 }
 
+static int v4l2_subdev_link_validate_muxed(struct media_link *link)
+{
+	struct v4l2_mbus_frame_desc sink_fd, source_fd;
+	struct v4l2_subdev *sink_sd, *source_sd;
+	unsigned int i;
+	int ret;
+
+	/* Require both pads in a link to be multiplexed */
+	if ((link->source->flags & MEDIA_PAD_FL_MUXED) == 0 ||
+	    (link->sink->flags & MEDIA_PAD_FL_MUXED) == 0)
+		return -EINVAL;
+
+	sink_sd = media_entity_to_v4l2_subdev(link->sink->entity);
+	source_sd = media_entity_to_v4l2_subdev(link->source->entity);
+
+	/* If not both provide frame descs there is not much to be done */
+	ret = v4l2_subdev_call(sink_sd, pad, get_frame_desc,
+			       link->sink->index, &sink_fd);
+	if (ret < 0)
+		return 0;
+	ret = v4l2_subdev_call(source_sd, pad, get_frame_desc,
+			       link->source->index, &source_fd);
+	if (ret < 0)
+		return 0;
+
+	/* Check both side multiplex same number of streams */
+	if (sink_fd.num_entries != source_fd.num_entries)
+		return -EINVAL;
+
+	/* Verify all formats of the multiplexed pads by examining the
+	 * format of the pads which are routed to them. Maybe this is
+	 * a bad idea...
+	 */
+	for (i = 0; i < sink_fd.num_entries; i++) {
+		struct v4l2_subdev_format sink_fmt, source_fmt;
+
+		sink_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		sink_fmt.pad = sink_fd.entry[i].csi2.pad;
+		ret = v4l2_subdev_call(sink_sd, pad, get_fmt, NULL, &sink_fmt);
+		if (ret < 0)
+			return 0;
+
+		source_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		source_fmt.pad = source_fd.entry[i].csi2.pad;
+		ret = v4l2_subdev_call(source_sd, pad, get_fmt, NULL,
+				       &source_fmt);
+		if (ret < 0)
+			return 0;
+
+		ret = v4l2_subdev_call(sink_sd, pad, link_validate, link,
+					&source_fmt, &sink_fmt);
+		if (ret == -ENOIOCTLCMD)
+			ret = v4l2_subdev_link_validate_default(sink_sd, link,
+								&source_fmt,
+								&sink_fmt);
+		if (ret)
+			return -EPIPE;
+	}
+
+	return 0;
+}
+
 int v4l2_subdev_link_validate(struct media_link *link)
 {
 	struct v4l2_subdev *sink;
 	struct v4l2_subdev_format sink_fmt, source_fmt;
 	int rval;
 
-	/* Require both pads in a link to be multiplexed if one is */
-	if ((link->source->flags | link->sink->flags) & MEDIA_PAD_FL_MUXED) {
-		if ((link->source->flags & MEDIA_PAD_FL_MUXED) == 0)
-			return -EINVAL;
-		if ((link->sink->flags & MEDIA_PAD_FL_MUXED) == 0)
-			return -EINVAL;
-		return 0;
-	}
+	if ((link->source->flags | link->sink->flags) & MEDIA_PAD_FL_MUXED)
+		return v4l2_subdev_link_validate_muxed(link);
 
 	rval = v4l2_subdev_link_validate_get_format(
 		link->source, &source_fmt);
-- 
2.13.3
