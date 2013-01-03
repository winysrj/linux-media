Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:17528 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3ACPpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 10:45:24 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG2008YN3RCGY30@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:23 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG2002B73RD7GA0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:22 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/5] s5p-fimc: Prevent potential buffer overflow
Date: Thu, 03 Jan 2013 16:45:07 +0100
Message-id: <1357227910-28870-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
References: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the hard coded csi_sensors[] array size with a relevant
constant to make sure we don't iterate beyond the actual array.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 8b43f98..e77dba7 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -627,7 +627,7 @@ static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
  */
 static int fimc_md_create_links(struct fimc_md *fmd)
 {
-	struct v4l2_subdev *csi_sensors[2] = { NULL };
+	struct v4l2_subdev *csi_sensors[CSIS_MAX_ENTITIES] = { NULL };
 	struct v4l2_subdev *sensor, *csis;
 	struct s5p_fimc_isp_info *pdata;
 	struct fimc_sensor_info *s_info;
@@ -692,7 +692,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 						       pad, link_mask);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(fmd->csis); i++) {
+	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
 		if (fmd->csis[i].sd == NULL)
 			continue;
 		source = &fmd->csis[i].sd->entity;
-- 
1.7.9.5

