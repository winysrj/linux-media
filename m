Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6141 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752685AbdCFMED (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 07:04:03 -0500
Subject: [PATCH] staging/atomisp:fix build issue verus 4.11-rc1
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 06 Mar 2017 11:21:28 +0000
Message-ID: <148879927534.10796.6582496815100213383.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: xingzhen <zhengjun.xing@intel.com>

commit:2a1f062a4acf move sigpending method fatal_signal_pending from
<linux/sched.h> into <linux/sched/signal.h> cause the build issue,fix it.

Signed-off-by: xingzhen <zhengjun.xing@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index 05ff912..e2aa949 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -39,7 +39,7 @@
 #include <asm/cacheflush.h>
 #include <linux/io.h>
 #include <asm/current.h>
-#include <linux/sched.h>
+#include <linux/sched/signal.h>
 #include <linux/file.h>
 
 #include "atomisp_internal.h"
