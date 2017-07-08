Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34986 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdGHAkn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 20:40:43 -0400
Date: Fri, 7 Jul 2017 20:40:54 -0400
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: media: atomisp2: css2400: Replace
 kfree()/vfree() with kvfree()
Message-ID: <20170708004054.GA27142@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Conditionally calling kfree()/vfree() can be replaced by a call to 
kvfree() which handles both kmalloced memory and vmalloced memory.

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
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 73c7658..1b0708f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -2029,10 +2029,7 @@ void *sh_css_calloc(size_t N, size_t size)
 
 void sh_css_free(void *ptr)
 {
-	if (is_vmalloc_addr(ptr))
-		vfree(ptr);
-	else
-		kfree(ptr);
+	kvfree(ptr);
 }
 
 /* For Acceleration API: Flush FW (shared buffer pointer) arguments */
-- 
2.7.4
