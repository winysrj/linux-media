Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45508 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2D3PGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 11:06:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3A003R7SNEX030@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 16:06:50 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3A0088ASN447@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 16:06:40 +0100 (BST)
Date: Mon, 30 Apr 2012 17:06:38 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Avoid crash with null platform_data
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335798398-4704-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In commit "s5p-fimc: Handle sub-device interdependencies using deferred.."
there was a check added for pdata->num_clients without first checking 
pdata against NULL. This causes a crash when platform_data is not set, 
which is a valid use case. Fix this regression by skipping the MIPI-CSIS
subdev registration also when pdata is null.

Reported-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 1587498..f653259 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -448,6 +448,8 @@ static int fimc_md_register_platform_entities(struct fimc_md *fmd)
 	 * Check if there is any sensor on the MIPI-CSI2 bus and
 	 * if not skip the s5p-csis module loading.
 	 */
+	if (pdata == NULL)
+		return 0;
 	for (i = 0; i < pdata->num_clients; i++) {
 		if (pdata->isp_info[i].bus_type == FIMC_MIPI_CSI2) {
 			ret = 1;
-- 
1.7.10

