Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36734 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbcHKKsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 06:48:24 -0400
Received: by mail-pa0-f44.google.com with SMTP id pp5so25078652pac.3
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2016 03:48:24 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFC 2/4] dma-buf/fence: kerneldoc: remove spurious section header
Date: Thu, 11 Aug 2016 16:17:58 +0530
Message-Id: <1470912480-32304-3-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit e941759c74a44d6ac2eed21bb0a38b21fe4559e2 ("fence: dma-buf
cross-device synchronization (v18)") had a spurious kerneldoc section
header that caused Sphinx to complain. Fix it.

Fixes: e941759c74a4 ("fence: dma-buf cross-device synchronization (v18)")

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 include/linux/fence.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fence.h b/include/linux/fence.h
index 5aa95eb886f7..5de89dab0013 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -60,7 +60,7 @@ struct fence_cb;
  * implementer of the fence for its own purposes. Can be used in different
  * ways by different fence implementers, so do not rely on this.
  *
- * *) Since atomic bitops are used, this is not guaranteed to be the case.
+ * Since atomic bitops are used, this is not guaranteed to be the case.
  * Particularly, if the bit was set, but fence_signal was called right
  * before this bit was set, it would have been able to set the
  * FENCE_FLAG_SIGNALED_BIT, before enable_signaling was called.
-- 
2.7.4

