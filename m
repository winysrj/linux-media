Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34078 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbdGHAlB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 20:41:01 -0400
Date: Fri, 7 Jul 2017 20:41:02 -0400
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: media: atomisp2: Replace kfree()/vfree() with
 kvfree()
Message-ID: <20170708004102.GA27161@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Conditionally calling kfree()/vfree() can be replaced by a call to 
kvfree() which handles both kmalloced memory and vmalloced memory. 
Consequently removed an unnecessary comment.

The Coccinelle semantic patch used to make the change is as follows:
//<smpl>
@@
expression a;
@@
- if(...) { vfree(a); }	
- else { kfree(a); }
+ kvfree(a);
@@
expression a;
@@
- if(...) { kfree(a); }	
- else { vfree(a); }
+ kvfree(a);
// </smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 97093ba..a156dd424 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -117,11 +117,7 @@ void *atomisp_kernel_zalloc(size_t bytes, bool zero_mem)
  */
 void atomisp_kernel_free(void *ptr)
 {
-	/* Verify if buffer was allocated by vmalloc() or kmalloc() */
-	if (is_vmalloc_addr(ptr))
-		vfree(ptr);
-	else
-		kfree(ptr);
+	kvfree(ptr);
 }
 
 /*
-- 
2.7.4
