Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:35883 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3GXO5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 10:57:43 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQG009AM47KQN80@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Jul 2013 23:57:41 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] V4L: s5c73m3: Add format propagation for TRY formats
Date: Wed, 24 Jul 2013 16:57:32 +0200
Message-id: <1374677852-2006-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Hajda <a.hajda@samsung.com>

Resolution set on ISP pad of S5C73M3-OIF subdev should be
propagated to source pad for TRY and ACTIVE formats.
The patch adds missing propagation for TRY format.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 825ea86..b76ec0e 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1111,6 +1111,11 @@ static int s5c73m3_oif_set_fmt(struct v4l2_subdev *sd,
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
 		*mf = fmt->format;
+		if (fmt->pad == OIF_ISP_PAD) {
+			mf = v4l2_subdev_get_try_format(fh, OIF_SOURCE_PAD);
+			mf->width = fmt->format.width;
+			mf->height = fmt->format.height;
+		}
 	} else {
 		switch (fmt->pad) {
 		case OIF_ISP_PAD:
-- 
1.7.9.5

