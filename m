Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaBEQlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH 15/47] media: davinci: vpif: Switch to pad-level DV operations
Date: Wed,  5 Feb 2014 17:42:06 +0100
Message-Id: <1391618558-5580-16-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video-level enum_dv_timings and dv_timings_cap operations are
deprecated in favor of the pad-level versions. All subdev drivers
implement the pad-level versions, switch to them.

Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 4 +++-
 drivers/media/platform/davinci/vpif_display.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 735ec47..d0081eb 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1723,7 +1723,9 @@ vpif_enum_dv_timings(struct file *file, void *priv,
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
index 9d115cd..20979c4 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1380,7 +1380,9 @@ vpif_enum_dv_timings(struct file *file, void *priv,
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

