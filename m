Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:58166 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3CGM6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 07:58:20 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJA00K6XK0UQ060@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 21:58:18 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MJA009ISK0SAK40@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 21:58:18 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] m5mols: Fix bug in stream on handler
Date: Thu, 07 Mar 2013 13:57:53 +0100
Message-id: <1362661073-11646-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Hajda <a.hajda@samsung.com>

Due to improper condition check streaming start for some pixel
formats was prevent and the s_stream just reatuned -EINVAL.
This fixes regression introduced in commit 5565a2ad47cdd8e697
[media] m5mols: Protect driver data with a mutex.

Cc: stable@vger.kernel.org # 3.7
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index d4e7567..0b899cb 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -724,7 +724,7 @@ static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
 	if (enable) {
 		if (is_code(code, M5MOLS_RESTYPE_MONITOR))
 			ret = m5mols_start_monitor(info);
-		if (is_code(code, M5MOLS_RESTYPE_CAPTURE))
+		else if (is_code(code, M5MOLS_RESTYPE_CAPTURE))
 			ret = m5mols_start_capture(info);
 		else
 			ret = -EINVAL;
-- 
1.7.9.5

