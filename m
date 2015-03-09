Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbbCIVXC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:23:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/18] ov7670: check for valid width/height in ov7670_enum_frame_interval
Date: Mon,  9 Mar 2015 22:22:09 +0100
Message-Id: <1425936143-5658-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The width and height should be checked in the enum_frame_interval
op. This fixes a v4l2-compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index b984752..81a1e44 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1073,10 +1073,33 @@ static int ov7670_enum_frame_interval(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_pad_config *cfg,
 				      struct v4l2_subdev_frame_interval_enum *fie)
 {
+	struct ov7670_info *info = to_state(sd);
+	unsigned int n_win_sizes = info->devtype->n_win_sizes;
+	int i;
+
 	if (fie->pad)
 		return -EINVAL;
 	if (fie->index >= ARRAY_SIZE(ov7670_frame_rates))
 		return -EINVAL;
+
+	/*
+	 * Check if the width/height is valid.
+	 *
+	 * If a minimum width/height was requested, filter out the capture
+	 * windows that fall outside that.
+	 */
+	for (i = 0; i < n_win_sizes; i++) {
+		struct ov7670_win_size *win = &info->devtype->win_sizes[i];
+
+		if (info->min_width && win->width < info->min_width)
+			continue;
+		if (info->min_height && win->height < info->min_height)
+			continue;
+		if (fie->width == win->width && fie->height == win->height)
+			break;
+	}
+	if (i == n_win_sizes)
+		return -EINVAL;
 	fie->interval.numerator = 1;
 	fie->interval.denominator = ov7670_frame_rates[fie->index];
 	return 0;
-- 
2.1.4

