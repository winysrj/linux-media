Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34638 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbcHKKsV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 06:48:21 -0400
Received: by mail-pa0-f49.google.com with SMTP id fi15so25156580pac.1
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2016 03:48:21 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFC 1/4] dma-buf/fence: kerneldoc: remove unused struct members
Date: Thu, 11 Aug 2016 16:17:57 +0530
Message-Id: <1470912480-32304-2-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0431b9065f28ecf6c320fefebe0241620049984f ("staging/android: bring
struct sync_pt back") removed child_list and active_list from struct fence,
but left it in kernel doc. Delete them.

Fixes: 0431b9065f28 ("staging/android: bring struct sync_pt back")

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 include/linux/fence.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/fence.h b/include/linux/fence.h
index 1de1b3f6fb76..5aa95eb886f7 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -49,8 +49,6 @@ struct fence_cb;
  * @timestamp: Timestamp when the fence was signaled.
  * @status: Optional, only valid if < 0, must be set before calling
  * fence_signal, indicates that the fence has completed with an error.
- * @child_list: list of children fences
- * @active_list: list of active fences
  *
  * the flags member must be manipulated and read using the appropriate
  * atomic ops (bit_*), so taking the spinlock will not be needed most
-- 
2.7.4

