Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:48905 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754425AbdBGQI6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 11:08:58 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/4] media-ctl: propagate frame interval
Date: Tue,  7 Feb 2017 17:08:49 +0100
Message-Id: <20170207160850.10299-4-p.zabel@pengutronix.de>
In-Reply-To: <20170207160850.10299-1-p.zabel@pengutronix.de>
References: <20170207160850.10299-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Same as the media bus format, the frame interval should be propagated
from output pads to connected entities' input pads.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 utils/media-ctl/libv4l2subdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index eadfc875..81d6420f 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -694,8 +694,8 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 		return ret;
 
 
-	/* If the pad is an output pad, automatically set the same format on
-	 * the remote subdev input pads, if any.
+	/* If the pad is an output pad, automatically set the same format and
+	 * frame interval on the remote subdev input pads, if any.
 	 */
 	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
 		for (i = 0; i < pad->entity->num_links; ++i) {
@@ -709,6 +709,10 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 			    link->sink->entity->info.type == MEDIA_ENT_T_V4L2_SUBDEV) {
 				remote_format = format;
 				set_format(link->sink, &remote_format);
+
+				ret = set_frame_interval(link->sink, &interval);
+				if (ret < 0)
+					return ret;
 			}
 		}
 	}
-- 
2.11.0

