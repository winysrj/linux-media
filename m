Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:47046 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbeAODst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 22:48:49 -0500
Received: by mail-pg0-f68.google.com with SMTP id s9so5557135pgq.13
        for <linux-media@vger.kernel.org>; Sun, 14 Jan 2018 19:48:48 -0800 (PST)
From: Shawn Guo <shawn.guo@linaro.org>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] dma-buf/sw_sync: fix document of sw_sync_create_fence_data
Date: Mon, 15 Jan 2018 11:47:59 +0800
Message-Id: <1515988079-8677-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The structure should really be sw_sync_create_fence_data rather than
sw_sync_ioctl_create_fence which is the function name.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma-buf/sw_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 24f83f9eeaed..7779bdbd18d1 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -43,14 +43,14 @@
  * timelines.
  *
  * Fences can be created with SW_SYNC_IOC_CREATE_FENCE ioctl with struct
- * sw_sync_ioctl_create_fence as parameter.
+ * sw_sync_create_fence_data as parameter.
  *
  * To increment the timeline counter, SW_SYNC_IOC_INC ioctl should be used
  * with the increment as u32. This will update the last signaled value
  * from the timeline and signal any fence that has a seqno smaller or equal
  * to it.
  *
- * struct sw_sync_ioctl_create_fence
+ * struct sw_sync_create_fence_data
  * @value:	the seqno to initialise the fence with
  * @name:	the name of the new sync point
  * @fence:	return the fd of the new sync_file with the created fence
-- 
1.9.1
