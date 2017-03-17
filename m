Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:51947 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdCQUqe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 16:46:34 -0400
Date: Fri, 17 Mar 2017 23:42:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] Staging: atomisp: fix locking in alloc_user_pages()
Message-ID: <20170317204246.GB16505@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We call this function with the lock held and should also return with the
lock held as well.  This one error path is not-consistent because we
should return without the lock held.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index fd3bd5c48672..d1a609d25f18 100644
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
