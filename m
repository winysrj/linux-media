Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaHPVPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 17:15:32 -0400
Message-ID: <53EFC9F1.9040307@infradead.org>
Date: Sat, 16 Aug 2014 14:15:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-media <linux-media@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linaro-mm-sig@lists.linaro.org, Rob Clark <robdclark@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [PATCH] dma-buf: fix <linux/seqno-fence.h> kernel-doc warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warning, missing parameter description:

Warning(..//include/linux/seqno-fence.h:99): No description found for parameter 'cond'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 include/linux/seqno-fence.h |    1 +
 1 file changed, 1 insertion(+)

Index: lnx-317-rc1/include/linux/seqno-fence.h
===================================================================
--- lnx-317-rc1.orig/include/linux/seqno-fence.h
+++ lnx-317-rc1/include/linux/seqno-fence.h
@@ -62,6 +62,7 @@ to_seqno_fence(struct fence *fence)
  * @context: the execution context this fence is a part of
  * @seqno_ofs: the offset within @sync_buf
  * @seqno: the sequence # to signal on
+ * @cond: the fence condition to check
  * @ops: the fence_ops for operations on this seqno fence
  *
  * This function initializes a struct seqno_fence with passed parameters,
