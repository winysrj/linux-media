Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59449 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbcARQKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:10:42 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O15017JCOXPOM20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:10:41 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/3] s5k6a3: Fix VIDIOC_SUBDEV_G_FMT ioctl for TRY format
Date: Mon, 18 Jan 2016 17:10:25 +0100
Message-id: <1453133427-20793-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133427-20793-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133427-20793-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_SUBDEV_G_FMT ioctl should return TRY format previously
set with VIDIOC_SUBDEV_S_FMT. Currently it is not the case as
only ACTIVE formats are saved in the driver. Since the driver
doesn't alter hardware state in the set_fmt op anyway, the
op can save the format in both TRY and ACTIVE case.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5k6a3.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index b1b1574..ba74b91 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -144,8 +144,7 @@ static int s5k6a3_set_fmt(struct v4l2_subdev *sd,
 	mf = __s5k6a3_get_format(sensor, cfg, fmt->pad, fmt->which);
 	if (mf) {
 		mutex_lock(&sensor->lock);
-		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-			*mf = fmt->format;
+		*mf = fmt->format;
 		mutex_unlock(&sensor->lock);
 	}
 	return 0;
-- 
1.7.9.5

