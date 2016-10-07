Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53298 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935466AbcJGQBP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:15 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 04/22] [media] v4l2-subdev.h: add prepare_stream op
Date: Fri,  7 Oct 2016 18:00:49 +0200
Message-Id: <20161007160107.5074-5-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In some cases, for example MIPI CSI-2 input on i.MX6, the sending and
receiving subdevice need to be prepared in lock-step before the actual
streaming can start. In the i.MX6 MIPI CSI-2 case, the sender needs to
put its MIPI CSI-2 transmitter lanes into stop state, and the receiver
needs to configure its D-PHY and detect the stop state on all active
lanes. Only then the sender can be enabled to stream data and the
receiver can lock its PLL to the clock lane.

This patch adds a prepare_stream(sd) callback that can be issued to all
v4l2_subdevs before calling s_stream(sd, 1).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/media/v4l2-subdev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index cf778c5..6502f43 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -395,6 +395,7 @@ struct v4l2_subdev_video_ops {
 	int (*g_tvnorms)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
+	int (*prepare_stream)(struct v4l2_subdev *sd);
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 	int (*g_pixelaspect)(struct v4l2_subdev *sd, struct v4l2_fract *aspect);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
-- 
2.9.3

