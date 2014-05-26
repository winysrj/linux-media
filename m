Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49561 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEZTFz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:05:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] v4l: s5k6a3: Return V4L2_FIELD_NONE from pad-level set format
Date: Mon, 26 May 2014 21:06:03 +0200
Message-Id: <1401131165-3542-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor is progressive, always return the field order set to
V4L2_FIELD_NONE.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/s5k6a3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index 7bc2271..c11a408 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -115,6 +115,7 @@ static void s5k6a3_try_format(struct v4l2_mbus_framefmt *mf)
 
 	fmt = find_sensor_format(mf);
 	mf->code = fmt->code;
+	mf->field = V4L2_FIELD_NONE;
 	v4l_bound_align_image(&mf->width, S5K6A3_SENSOR_MIN_WIDTH,
 			      S5K6A3_SENSOR_MAX_WIDTH, 0,
 			      &mf->height, S5K6A3_SENSOR_MIN_HEIGHT,
-- 
1.8.5.5

