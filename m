Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:7617 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753367AbdC0POe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 11:14:34 -0400
Subject: [PATCH 4/5] drivers/staging/media: atomisp: Removing redundant
 information from dev_err
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 27 Mar 2017 16:14:15 +0100
Message-ID: <149062765460.15399.17254406598757100342.stgit@rszulisx-mobl.ger.corp.intel.com>
In-Reply-To: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
References: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pushkar Jambhlekar <pushkar.iit@gmail.com>

Removing hardcoded function name as code is already using __func__

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index d1a609d2..a51a27b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -64,7 +64,7 @@ struct hmm_buffer_object *__bo_alloc(struct kmem_cache *bo_cache)
 
 	bo = kmem_cache_alloc(bo_cache, GFP_KERNEL);
 	if (!bo)
-		dev_err(atomisp_dev, "%s: __bo_alloc failed!\n", __func__);
+		dev_err(atomisp_dev, "%s: failed!\n", __func__);
 
 	return bo;
 }
