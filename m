Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43676 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3HWJdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:33:50 -0400
Date: Fri, 23 Aug 2013 12:33:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] i2c/ov9650: off by one in ov965x_enum_frame_sizes()
Message-ID: <20130823093348.GI31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ">" should be ">=" otherwise we read one space beyond the end of the
array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 1dbb811..4da90c6 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1083,7 +1083,7 @@ static int ov965x_enum_frame_sizes(struct v4l2_subdev *sd,
 {
 	int i = ARRAY_SIZE(ov965x_formats);
 
-	if (fse->index > ARRAY_SIZE(ov965x_framesizes))
+	if (fse->index >= ARRAY_SIZE(ov965x_framesizes))
 		return -EINVAL;
 
 	while (--i)
