Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:53855 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab3CZRad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:33 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 07/10] s5p-fimc: Ensure proper s_stream() call order in the
 ISP datapaths
Date: Tue, 26 Mar 2013 18:29:49 +0100
Message-id: <1364318992-20562-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
References: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the FIMC-IS firmware communicates with an image sensor directly
through the ISP I2C bus controllers data streaming cannot be simply
enabled from left to right or disabled from right to left along the
processing pipeline. Thus a subdev index to call s_stream() on is
looked up from a table, rather than doing the op call based on
increasing/decreasing indexes.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index d519ee7..53bfd20 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -225,28 +225,36 @@ static int __fimc_pipeline_close(struct fimc_pipeline *p)
 }
 
 /**
- * __fimc_pipeline_s_stream - invoke s_stream on pipeline subdevs
+ * __fimc_pipeline_s_stream - call s_stream() on pipeline subdevs
  * @pipeline: video pipeline structure
- * @on: passed as the s_stream call argument
+ * @on: passed as the s_stream() callback argument
  */
 static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 {
-	int i, ret;
+	static const u8 seq[2][IDX_MAX] = {
+		{ IDX_FIMC, IDX_SENSOR, IDX_IS_ISP, IDX_CSIS, IDX_FLITE },
+		{ IDX_CSIS, IDX_FLITE, IDX_FIMC, IDX_SENSOR, IDX_IS_ISP },
+	};
+	int i, ret = 0;
 
 	if (p->subdevs[IDX_SENSOR] == NULL)
 		return -ENODEV;
 
 	for (i = 0; i < IDX_MAX; i++) {
-		unsigned int idx = on ? (IDX_MAX - 1) - i : i;
+		unsigned int idx = seq[on][i];
 
 		ret = v4l2_subdev_call(p->subdevs[idx], video, s_stream, on);
 
 		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-			return ret;
+			goto error;
 	}
-
 	return 0;
-
+error:
+	for (; i >= 0; i--) {
+		unsigned int idx = seq[on][i];
+		v4l2_subdev_call(p->subdevs[idx], video, s_stream, !on);
+	}
+	return ret;
 }
 
 /* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
-- 
1.7.9.5

