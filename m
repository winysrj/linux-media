Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaBEQlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 14/47] media: bfin_capture: Switch to pad-level DV operations
Date: Wed,  5 Feb 2014 17:42:05 +0100
Message-Id: <1391618558-5580-15-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video-level enum_dv_timings and dv_timings_cap operations are
deprecated in favor of the pad-level versions. All subdev drivers
implement the pad-level versions, switch to them.

Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 2819165..5928d1d 100644
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

