Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:8964 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753269AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 10/24] Staging: atomisp: fix locking in alloc_user_pages()
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:40:32 +0000
Message-ID: <149002082825.17109.10471955862860977004.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

We call this function with the lock held and should also return with the
lock held as well.  This one error path is not-consistent because we
should return without the lock held.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index fd3bd5c..d1a609d2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -1012,6 +1012,7 @@ static int alloc_user_pages(struct hmm_buffer_object *bo,
 		dev_err(atomisp_dev, "find_vma failed\n");
 		atomisp_kernel_free(bo->page_obj);
 		atomisp_kernel_free(pages);
+		mutex_lock(&bo->mutex);
 		return -EFAULT;
 	}
 	mutex_lock(&bo->mutex);
