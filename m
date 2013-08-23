Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41653 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3HWJdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:33:09 -0400
Date: Fri, 23 Aug 2013 12:33:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] s5k6aa: off by one in s5k6aa_enum_frame_interval()
Message-ID: <20130823093306.GH31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check is off by one so we could read one space past the end of the
array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 789c02a..629a5cd 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1003,7 +1003,7 @@ static int s5k6aa_enum_frame_interval(struct v4l2_subdev *sd,
 	const struct s5k6aa_interval *fi;
 	int ret = 0;
 
-	if (fie->index > ARRAY_SIZE(s5k6aa_intervals))
+	if (fie->index >= ARRAY_SIZE(s5k6aa_intervals))
 		return -EINVAL;
 
 	v4l_bound_align_image(&fie->width, S5K6AA_WIN_WIDTH_MIN,
