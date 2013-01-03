Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49173 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3ACPpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 10:45:25 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG2001EF3RJLA20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:24 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG2002B73RD7GA0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:24 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/5] s5p-fimc: Fix return value of
 __fimc_md_create_flite_source_links()
Date: Thu, 03 Jan 2013 16:45:08 +0100
Message-id: <1357227910-28870-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
References: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure 'ret' is not used uninitialized.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index e77dba7..41ddfee 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -594,7 +594,7 @@ static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
 {
 	struct media_entity *source, *sink;
 	unsigned int flags = MEDIA_LNK_FL_ENABLED;
-	int i, ret;
+	int i, ret = 0;
 
 	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
 		struct fimc_lite *fimc = fmd->fimc_lite[i];
-- 
1.7.9.5

