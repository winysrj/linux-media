Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38906 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaDQON1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 13/49] media: bfin_capture: Switch to pad-level DV operations
Date: Thu, 17 Apr 2014 16:12:44 +0200
Message-Id: <1397744000-23967-14-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video-level enum_dv_timings and dv_timings_cap operations are
deprecated in favor of the pad-level versions. All subdev drivers
implement the pad-level versions, switch to them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 200bec9..22fb701 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -648,7 +648,9 @@ static int bcap_enum_dv_timings(struct file *file, void *priv,
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
 
-	return v4l2_subdev_call(bcap_dev->sd, video,
+	timings->pad = 0;
+
+	return v4l2_subdev_call(bcap_dev->sd, pad,
 			enum_dv_timings, timings);
 }
 
-- 
1.8.3.2

