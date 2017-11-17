Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47180 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752883AbdKQKVl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 05:21:41 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org
Subject: [PATCH 1/6] edac: adjust GPLv2 license and SPDX identifiers at the code I wrote
Date: Fri, 17 Nov 2017 08:21:28 -0200
Message-Id: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now using SPDX identifiers, on the several EDAC drivers
I wrote, add the proper SPDX, identifying the license I meant.

As we're now using the short license, it doesn't make sense to
keep the original license text.

Also, fix MODULE_LICENSE to properly identify GPL v2.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/edac/ghes_edac.c   | 4 +---
 drivers/edac/i5400_edac.c  | 3 ++-
 drivers/edac/i7300_edac.c  | 6 ++----
 drivers/edac/i7core_edac.c | 6 ++----
 drivers/edac/sb_edac.c     | 6 ++----
 5 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 6f80eb65c26c..050c4880d23a 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -1,9 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * GHES/EDAC Linux driver
  *
- * This file may be distributed under the terms of the GNU General Public
- * License version 2.
- *
  * Copyright (c) 2013 by Mauro Carvalho Chehab
  *
  * Red Hat Inc. http://www.redhat.com
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 6f8bcdb9256a..e08276673b92 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Intel 5400 class Memory Controllers kernel module (Seaburg)
  *
@@ -1467,7 +1468,7 @@ static void __exit i5400_exit(void)
 module_init(i5400_init);
 module_exit(i5400_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Ben Woodard <woodard@redhat.com>");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 6b5a554ba8e4..9cc117470718 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1,9 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Intel 7300 class Memory Controllers kernel module (Clarksboro)
  *
- * This file may be distributed under the terms of the
- * GNU General Public License version 2 only.
- *
  * Copyright (c) 2010 by:
  *	 Mauro Carvalho Chehab
  *
@@ -1207,7 +1205,7 @@ static void __exit i7300_exit(void)
 module_init(i7300_init);
 module_exit(i7300_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel I7300 memory controllers - "
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index c16c3b931b3d..735d8aaed458 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /* Intel i7 core/Nehalem Memory Controller kernel module
  *
  * This driver supports the memory controllers found on the Intel
@@ -5,9 +6,6 @@
  * Xeon 55xx and Xeon 56xx also known as Nehalem, Nehalem-EP, Lynnfield
  * and Westmere-EP.
  *
- * This file may be distributed under the terms of the
- * GNU General Public License version 2 only.
- *
  * Copyright (c) 2009-2010 by:
  *	 Mauro Carvalho Chehab
  *
@@ -2377,7 +2375,7 @@ static void __exit i7core_exit(void)
 module_init(i7core_init);
 module_exit(i7core_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel i7 Core memory controllers - "
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index dc0591654011..9b0209215f69 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1,11 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /* Intel Sandy Bridge -EN/-EP/-EX Memory Controller kernel module
  *
  * This driver supports the memory controllers found on the Intel
  * processor family Sandy Bridge.
  *
- * This file may be distributed under the terms of the
- * GNU General Public License version 2 only.
- *
  * Copyright (c) 2011 by:
  *	 Mauro Carvalho Chehab
  */
@@ -3445,7 +3443,7 @@ module_exit(sbridge_exit);
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel Sandy Bridge and Ivy Bridge memory controllers - "
-- 
2.14.3
