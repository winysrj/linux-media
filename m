Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaDQON3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 18/49] adv7511: Remove deprecated video-level DV timings operations
Date: Thu, 17 Apr 2014 16:12:49 +0200
Message-Id: <1397744000-23967-19-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index f4a1431..d77a1db 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -692,8 +692,6 @@ static const struct v4l2_subdev_video_ops adv7511_video_ops = {
 	.s_stream = adv7511_s_stream,
 	.s_dv_timings = adv7511_s_dv_timings,
 	.g_dv_timings = adv7511_g_dv_timings,
-	.enum_dv_timings = adv7511_enum_dv_timings,
-	.dv_timings_cap = adv7511_dv_timings_cap,
 };
 
 /* ------------------------------ AUDIO OPS ------------------------------ */
-- 
1.8.3.2

