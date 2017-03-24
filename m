Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35542 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752196AbdCXFst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 01:48:49 -0400
From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pushkar Jambhlekar <pushkar.iit@gmail.com>
Cc: linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drivers/staging/media: atomisp:  Removing redundant information from dev_err
Date: Fri, 24 Mar 2017 11:18:33 +0530
Message-Id: <1490334513-7721-1-git-send-email-pushkar.iit@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removing hardcoded function name as code is already using __func__

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c | 2 +-
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
-- 
2.7.4
