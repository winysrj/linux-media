Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36845 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbdCJFNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 00:13:20 -0500
Received: by mail-pg0-f66.google.com with SMTP id 25so9030392pgy.3
        for <linux-media@vger.kernel.org>; Thu, 09 Mar 2017 21:13:20 -0800 (PST)
From: simran singhal <singhalsimran0@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, jarod@wilsonet.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 1/3] staging: atomisp_fops: Clean up tests if NULL returned on failure
Date: Fri, 10 Mar 2017 10:43:10 +0530
Message-Id: <1489122792-8081-2-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1489122792-8081-1-git-send-email-singhalsimran0@gmail.com>
References: <1489122792-8081-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some functions like kmalloc/kzalloc return NULL on failure.
When NULL represents failure, !x is commonly used.

This was done using Coccinelle:
@@
expression *e;
identifier l1;
@@

e = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\)(...);
...
- e == NULL
+ !e

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index 20e581e..e5a7407 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -1100,7 +1100,7 @@ int atomisp_videobuf_mmap_mapper(struct videobuf_queue *q,
 			continue;
 
 		map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
-		if (map == NULL) {
+		if (!map) {
 			mutex_unlock(&q->vb_lock);
 			return -ENOMEM;
 		}
-- 
2.7.4
