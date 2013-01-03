Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:62089 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3ACPmN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 10:42:13 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG2001L13MAAMA0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:42:12 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG2002IS3M47G90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:42:12 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] m5mols: Fix typo in get_fmt callback
Date: Thu, 03 Jan 2013 16:42:02 +0100
Message-id: <1357227722-28763-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check of return value from __find_format() was inverted
by mistake. This patch fixes regression introduced in commit
5565a2ad47 [media] m5mols: Protect driver data with a mutex

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 8131d65..b9b4485 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -556,1 +556,1 @@ static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	mutex_lock(&info->lock);

 	format = __find_format(info, fh, fmt->which, info->res_type);
-	if (!format)
+	if (format)
 		fmt->format = *format;
 	else
 		ret = -EINVAL;
--
1.7.9.5

