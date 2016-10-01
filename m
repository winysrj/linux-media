Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:14241
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750949AbcJAUFR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Oct 2016 16:05:17 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] dma-buf/sw_sync: improve function-level documentation
Date: Sat,  1 Oct 2016 21:46:22 +0200
Message-Id: <1475351192-27079-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1475351192-27079-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1475351192-27079-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust the documentation to use the names that appear in the function
parameter list.

Issue detected using Coccinelle (http://coccinelle.lip6.fr/)

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/dma-buf/sw_sync.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 62e8e6d..5d2b1b6 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -155,11 +155,11 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 
 /**
  * sync_pt_create() - creates a sync pt
- * @parent:	fence's parent sync_timeline
+ * @obj:	fence's parent sync_timeline
  * @size:	size to allocate for this pt
- * @inc:	value of the fence
+ * @value:	value of the fence
  *
- * Creates a new sync_pt as a child of @parent.  @size bytes will be
+ * Creates a new sync_pt as a child of @obj.  @size bytes will be
  * allocated allowing for implementation specific data to be kept after
  * the generic sync_timeline struct. Returns the sync_pt object or
  * NULL in case of error.

