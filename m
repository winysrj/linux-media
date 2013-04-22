Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63117 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3DVOHC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:07:02 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00CYSTVGUVI0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:07:01 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 10/12] exynos4-is: Remove debugfs entries properly
Date: Mon, 22 Apr 2013 16:03:45 +0200
Message-id: <1366639427-14253-11-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure both debugfs: fimc_is directory and the fw_log file
are properly removed in the driver cleanup sequence.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index c4049d4..ca72b02 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -766,7 +766,7 @@ static const struct file_operations fimc_is_debugfs_fops = {
 
 static void fimc_is_debugfs_remove(struct fimc_is *is)
 {
-	debugfs_remove(is->debugfs_entry);
+	debugfs_remove_recursive(is->debugfs_entry);
 	is->debugfs_entry = NULL;
 }
 
-- 
1.7.9.5

