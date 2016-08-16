Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34912 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbcHPXbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 19:31:18 -0400
To: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] dma-buf: fix kernel-doc warning and typos
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <224865a5-947d-9a28-c60a-18fa86bc9329@infradead.org>
Date: Tue, 16 Aug 2016 16:31:00 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix dma-buf kernel-doc warning and 2 minor typos in
fence_array_create().

Fixes this warning:
..//drivers/dma-buf/fence-array.c:124: warning: No description found for parameter 'signal_on_any'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Sumit Semwal <sumit.semwal@linaro.org>
Cc:	linux-media@vger.kernel.org
Cc:	dri-devel@lists.freedesktop.org
Cc:	linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/fence-array.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lnx-48-rc2.orig/drivers/dma-buf/fence-array.c
+++ lnx-48-rc2/drivers/dma-buf/fence-array.c
@@ -106,14 +106,14 @@ const struct fence_ops fence_array_ops =
  * @fences:		[in]	array containing the fences
  * @context:		[in]	fence context to use
  * @seqno:		[in]	sequence number to use
- * @signal_on_any	[in]	signal on any fence in the array
+ * @signal_on_any:	[in]	signal on any fence in the array
  *
  * Allocate a fence_array object and initialize the base fence with fence_init().
  * In case of error it returns NULL.
  *
- * The caller should allocte the fences array with num_fences size
+ * The caller should allocate the fences array with num_fences size
  * and fill it with the fences it wants to add to the object. Ownership of this
- * array is take and fence_put() is used on each fence on release.
+ * array is taken and fence_put() is used on each fence on release.
  *
  * If @signal_on_any is true the fence array signals if any fence in the array
  * signals, otherwise it signals when all fences in the array signal.
