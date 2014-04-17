Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaDQON2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 14/49] media: davinci: vpif: Switch to pad-level DV operations
Date: Thu, 17 Apr 2014 16:12:45 +0200
Message-Id: <1397744000-23967-15-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video-level enum_dv_timings and dv_timings_cap operations are
deprecated in favor of the pad-level versions. All subdev drivers
implement the pad-level versions, switch to them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 4 +++-
 drivers/media/platform/davinci/vpif_display.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 8dea0b8..f976438 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1730,7 +1730,9 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 	struct channel_obj *ch = fh->channel;
 	int ret;
 
-	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
+	timings->pad = 0;
+
+	ret = v4l2_subdev_call(ch->sd, pad, enum_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -EINVAL;
 	return ret;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index aed41ed..f4bc39a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1386,7 +1386,9 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 	struct channel_obj *ch = fh->channel;
 	int ret;
 
-	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
+	timings->pad = 0;
+
+	ret = v4l2_subdev_call(ch->sd, pad, enum_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -EINVAL;
 	return ret;
-- 
1.8.3.2

