Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34977 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbdILOZO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 10:25:14 -0400
From: Srishti Sharma <srishtishar@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: media: atomisp: Merge assignment with return
Date: Tue, 12 Sep 2017 19:55:07 +0530
Message-Id: <1505226307-5119-1-git-send-email-srishtishar@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Merge the assignment and the return statements to return the value
directly. Done using the following semantic patch by coccinelle.

@@
local idexpression ret;
expression e;
@@

-ret =
+return
     e;
-return ret;

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index 11162f5..e6ddfbf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -1168,13 +1168,9 @@ void hmm_bo_free_pages(struct hmm_buffer_object *bo)
 
 int hmm_bo_page_allocated(struct hmm_buffer_object *bo)
 {
-	int ret;
-
 	check_bo_null_return(bo, 0);
 
-	ret = bo->status & HMM_BO_PAGE_ALLOCED;
-
-	return ret;
+	return bo->status & HMM_BO_PAGE_ALLOCED;
 }
 
 /*
-- 
2.7.4
