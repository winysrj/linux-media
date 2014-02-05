Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaBEQl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 24/47] tvp7002: Remove deprecated video-level DV timings operations
Date: Wed,  5 Feb 2014 17:42:15 +0100
Message-Id: <1391618558-5580-25-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp7002.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 9f56fd5..fa901a9 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -926,7 +926,6 @@ static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
 static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
 	.g_dv_timings = tvp7002_g_dv_timings,
 	.s_dv_timings = tvp7002_s_dv_timings,
-	.enum_dv_timings = tvp7002_enum_dv_timings,
 	.query_dv_timings = tvp7002_query_dv_timings,
 	.s_stream = tvp7002_s_stream,
 	.g_mbus_fmt = tvp7002_mbus_fmt,
-- 
1.8.3.2

