Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49812 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaEZTt7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:49:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 01/11] v4l: subdev: Extend default link validation to cover field order
Date: Mon, 26 May 2014 21:50:02 +0200
Message-Id: <1401133812-8745-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field order must match between the source and sink pads, or the sink
pad field order must be NONE. This allows connecting an interlaced
source to a bridge that has no hardware support for interlaced formats.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 058c1a6..752cca0 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -468,11 +468,20 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_format *source_fmt,
 				      struct v4l2_subdev_format *sink_fmt)
 {
+	/* The width, height and code must match. */
 	if (source_fmt->format.width != sink_fmt->format.width
 	    || source_fmt->format.height != sink_fmt->format.height
 	    || source_fmt->format.code != sink_fmt->format.code)
 		return -EINVAL;
 
+	/* The field order must match, or the sink field order must be NONE
+	 * to support interlaced hardware connected to bridges that support
+	 * progressive formats only.
+	 */
+	if (source_fmt->format.field != sink_fmt->format.field &&
+	    sink_fmt->format.field != V4L2_FIELD_NONE)
+		return -EINVAL;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_default);
-- 
1.8.5.5

