Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:49825 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbcGENVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 09:21:14 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id u65DL9Q1030120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 5 Jul 2016 13:21:11 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] adv7511: the h/vsync polarities were always positive
Message-ID: <577BB445.10402@cisco.com>
Date: Tue, 5 Jul 2016 15:21:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correctly set the h/vsync polarities instead of keeping to the
default (positive).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 161cbdb..f062694 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -763,6 +763,11 @@ static int adv7511_s_dv_timings(struct v4l2_subdev *sd,
 	/* save timings */
 	state->dv_timings = *timings;

+	/* set h/vsync polarities */
+	adv7511_wr_and_or(sd, 0x17, 0x9f,
+		((timings->bt.polarities & V4L2_DV_VSYNC_POS_POL) ? 0 : 0x40) |
+		((timings->bt.polarities & V4L2_DV_HSYNC_POS_POL) ? 0 : 0x20));
+
 	/* update quantization range based on new dv_timings */
 	adv7511_set_rgb_quantization_mode(sd, state->rgb_quantization_range_ctrl);

-- 
2.8.1


