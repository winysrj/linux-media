Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:36416 "EHLO
        homiemail-a44.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752560AbeEROGd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:06:33 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] atomisp driver has been removed from staging
Date: Fri, 18 May 2018 09:06:30 -0500
Message-Id: <1526652391-18898-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nuked completely, no backport required now.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 backports/v4.10_sched_signal.patch | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/backports/v4.10_sched_signal.patch b/backports/v4.10_sched_signal.patch
index d32b2f4..c9876c2 100644
--- a/backports/v4.10_sched_signal.patch
+++ b/backports/v4.10_sched_signal.patch
@@ -257,19 +257,6 @@ index add2edb..8eb0f49 100644
  #include <linux/slab.h>
  #include <linux/interrupt.h>
  
-diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
-index a6620d2..887f147 100644
---- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
-+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
-@@ -34,7 +34,7 @@
- #include <linux/errno.h>
- #include <linux/io.h>
- #include <asm/current.h>
--#include <linux/sched/signal.h>
-+#include <linux/sched.h>
- #include <linux/file.h>
- 
- #include <asm/set_memory.h>
 diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
 index a7b3f7c..a63034b 100644
 --- a/include/media/v4l2-ioctl.h
-- 
2.7.4
