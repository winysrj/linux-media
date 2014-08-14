Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42108 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaHNHLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 03:11:20 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAA0041CBYVDQB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Aug 2014 16:11:19 +0900 (KST)
From: panpan liu <panpan1.liu@samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] videobuf2-core: modify the num of users
Date: Thu, 14 Aug 2014 15:11:01 +0800
Message-id: <1408000262-2774-1-git-send-email-panpan1.liu@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If num_users returns 1 or more than 1, that means we are not the
only user of the plane's memory.

Signed-off-by: panpan liu <panpan1.liu@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c359006..d3a4b8f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -625,7 +625,7 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 		 * case anyway. If num_users() returns more than 1,
 		 * we are not the only user of the plane's memory.
 		 */
-		if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
+		if (mem_priv && call_memop(vb, num_users, mem_priv) >= 1)
 			return true;
 	}
 	return false;
-- 
1.7.9.5

