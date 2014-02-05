Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaBEQlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 20/47] adv7842: Remove deprecated video-level DV timings operations
Date: Wed,  5 Feb 2014 17:42:11 +0100
Message-Id: <1391618558-5580-21-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7842.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 78d21fd..7fd9325 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2892,8 +2892,6 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 	.s_dv_timings = adv7842_s_dv_timings,
 	.g_dv_timings = adv7842_g_dv_timings,
 	.query_dv_timings = adv7842_query_dv_timings,
-	.enum_dv_timings = adv7842_enum_dv_timings,
-	.dv_timings_cap = adv7842_dv_timings_cap,
 	.enum_mbus_fmt = adv7842_enum_mbus_fmt,
 	.g_mbus_fmt = adv7842_g_mbus_fmt,
 	.try_mbus_fmt = adv7842_g_mbus_fmt,
-- 
1.8.3.2

