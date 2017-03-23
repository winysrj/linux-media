Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32826 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934688AbdCWNM5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 09:12:57 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        simran singhal <singhalsimran0@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: use kvmalloc and kvfree
Date: Thu, 23 Mar 2017 21:12:39 +0800
Message-Id: <7ac949fbedccaa86c27db0dd045f10be97ec74b1.1490261637.git.geliangtang@gmail.com>
In-Reply-To: <328d0eb3da461aaaa6140b1409ee7550bcec87bb.1490261279.git.geliangtang@gmail.com>
References: <328d0eb3da461aaaa6140b1409ee7550bcec87bb.1490261279.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kvmalloc() and kvfree() instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 94bc793..c7b9320 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -90,10 +90,7 @@ union host {
 void *atomisp_kernel_malloc(size_t bytes)
 {
 	/* vmalloc() is preferable if allocating more than 1 page */
-	if (bytes > PAGE_SIZE)
-		return vmalloc(bytes);
-
-	return kmalloc(bytes, GFP_KERNEL);
+	return kvmalloc(bytes, GFP_KERNEL);
 }
 
 /*
@@ -118,10 +115,7 @@ void *atomisp_kernel_zalloc(size_t bytes, bool zero_mem)
 void atomisp_kernel_free(void *ptr)
 {
 	/* Verify if buffer was allocated by vmalloc() or kmalloc() */
-	if (is_vmalloc_addr(ptr))
-		vfree(ptr);
-	else
-		kfree(ptr);
+	kvfree(ptr);
 }
 
 /*
-- 
2.9.3
