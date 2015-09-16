Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64623 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbbIPMb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 08:31:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 1/1] Fix --data-prefix option documentation
Date: Wed, 16 Sep 2015 15:31:50 +0300
Message-Id: <1442406710-10234-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 yavta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/yavta.c b/yavta.c
index b627725..8e983a3 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1766,7 +1766,7 @@ static void usage(const char *argv0)
 	printf("-t, --time-per-frame num/denom	Set the time per frame (eg. 1/25 = 25 fps)\n");
 	printf("-u, --userptr			Use the user pointers streaming method\n");
 	printf("-w, --set-control 'ctrl value'	Set control 'ctrl' to 'value'\n");
-	printf("    --buffer-prefix		Write portions of buffer before data_offset\n");
+	printf("    --data-prefix		Write portions of buffer data before data_offset\n");
 	printf("    --buffer-size		Buffer size in bytes\n");
 	printf("    --enum-formats		Enumerate formats\n");
 	printf("    --enum-inputs		Enumerate inputs\n");
-- 
2.1.0.231.g7484e3b

