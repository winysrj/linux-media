Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62517 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3CZRag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:36 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 08/10] s5p-fimc: Ensure proper s_power() call order in the
 ISP datapaths
Date: Tue, 26 Mar 2013 18:29:50 +0100
Message-id: <1364318992-20562-9-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
References: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the FIMC-IS firmware communicates with an image sensor directly
through the ISP I2C bus controllers the sub-devices power supplies
cannot be simply enabled from left to right or disabled from right
to left along the processing pipeline. Thus a subdev index to call
s_power() on is looked up from a table, rather than doing the op call
based on increasing/decreasing indexes.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   26 ++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 53bfd20..06d1eb4 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -128,23 +128,33 @@ static int __subdev_set_power(struct v4l2_subdev *sd, int on)
  *
  * Needs to be called with the graph mutex held.
  */
-static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
+static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool on)
 {
-	unsigned int i;
-	int ret;
+	static const u8 seq[2][IDX_MAX - 1] = {
+		{ IDX_IS_ISP, IDX_SENSOR, IDX_CSIS, IDX_FLITE },
+		{ IDX_CSIS, IDX_FLITE, IDX_SENSOR, IDX_IS_ISP },
+	};
+	int i, ret = 0;
 
 	if (p->subdevs[IDX_SENSOR] == NULL)
 		return -ENXIO;
 
-	for (i = 0; i < IDX_MAX; i++) {
-		unsigned int idx = state ? (IDX_MAX - 1) - i : i;
+	for (i = 0; i < IDX_MAX - 1; i++) {
+		unsigned int idx = seq[on][i];
+
+		ret = __subdev_set_power(p->subdevs[idx], on);
+
 
-		ret = __subdev_set_power(p->subdevs[idx], state);
 		if (ret < 0 && ret != -ENXIO)
-			return ret;
+			goto error;
 	}
-
 	return 0;
+error:
+	for (; i >= 0; i--) {
+		unsigned int idx = seq[on][i];
+		__subdev_set_power(p->subdevs[idx], !on);
+	}
+	return ret;
 }
 
 /**
-- 
1.7.9.5

