Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34835 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbdF2Xcx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 19:32:53 -0400
Date: Thu, 29 Jun 2017 19:32:50 -0400
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: Remove unnecessary return statement
 in void function
Message-ID: <20170629233250.GA16135@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return statement at the end of a void function is useless.

The Coccinelle semantic patch used to make this change is as follows:
//<smpl>
@@
identifier f;
expression e;
@@
void f(...) {
<...
- return
  e;
  ...>
  }
//</smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 5729539..22c0342 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -636,7 +636,7 @@ void hmm_vunmap(ia_css_ptr virt)
 		return;
 	}
 
-	return hmm_bo_vunmap(bo);
+	hmm_bo_vunmap(bo);
 }
 
 int hmm_pool_register(unsigned int pool_size,
-- 
2.7.4
