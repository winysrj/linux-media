Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51719 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752647AbdLANr0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 08:47:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        linux-edac@vger.kernel.org
Subject: [PATCH v2 1/7] edac: adjust GPLv2 license and SPDX identifiers at the code I wrote
Date: Fri,  1 Dec 2017 11:47:07 -0200
Message-Id: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now using SPDX identifiers, on the several EDAC drivers
I wrote, add the proper SPDX, identifying the license I meant.

As we're now using the short license, it doesn't make sense to
keep the original license text.

Also, fix MODULE_LICENSE to properly identify GPL v2.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>
---
 drivers/edac/ghes_edac.c   | 16 ++++++---------
 drivers/edac/i5400_edac.c  | 50 ++++++++++++++++++++++-----------------------
 drivers/edac/i7300_edac.c  | 36 +++++++++++++++-----------------
 drivers/edac/i7core_edac.c | 51 ++++++++++++++++++++++------------------------
 drivers/edac/sb_edac.c     | 21 ++++++++-----------
 5 files changed, 79 insertions(+), 95 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 68b6ee18bea6..7b722f3f4cdd 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -1,13 +1,9 @@
-/*
- * GHES/EDAC Linux driver
- *
- * This file may be distributed under the terms of the GNU General Public
- * License version 2.
- *
- * Copyright (c) 2013 by Mauro Carvalho Chehab
- *
- * Red Hat Inc. http://www.redhat.com
- */
+// SPDX-License-Identifier: GPL-2.0
+// GHES/EDAC Linux driver
+//
+// Copyright (c) 2013 by Mauro Carvalho Chehab
+//
+// Red Hat Inc. http://www.redhat.com
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 6f8bcdb9256a..9ab6965874ae 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1,28 +1,26 @@
-/*
- * Intel 5400 class Memory Controllers kernel module (Seaburg)
- *
- * This file may be distributed under the terms of the
- * GNU General Public License.
- *
- * Copyright (c) 2008 by:
- *	 Ben Woodard <woodard@redhat.com>
- *	 Mauro Carvalho Chehab
- *
- * Red Hat Inc. http://www.redhat.com
- *
- * Forked and adapted from the i5000_edac driver which was
- * written by Douglas Thompson Linux Networx <norsk5@xmission.com>
- *
- * This module is based on the following document:
- *
- * Intel 5400 Chipset Memory Controller Hub (MCH) - Datasheet
- * 	http://developer.intel.com/design/chipsets/datashts/313070.htm
- *
- * This Memory Controller manages DDR2 FB-DIMMs. It has 2 branches, each with
- * 2 channels operating in lockstep no-mirror mode. Each channel can have up to
- * 4 dimm's, each with up to 8GB.
- *
- */
+// SPDX-License-Identifier: GPL-2.0
+// Intel 5400 class Memory Controllers kernel module (Seaburg)
+//
+// This file may be distributed under the terms of the
+// GNU General Public License.
+//
+// Copyright (c) 2008 by:
+//	 Ben Woodard <woodard@redhat.com>
+//	 Mauro Carvalho Chehab
+//
+// Red Hat Inc. http://www.redhat.com
+//
+// Forked and adapted from the i5000_edac driver which was
+// written by Douglas Thompson Linux Networx <norsk5@xmission.com>
+//
+// This module is based on the following document:
+//
+// Intel 5400 Chipset Memory Controller Hub (MCH) - Datasheet
+// 	http://developer.intel.com/design/chipsets/datashts/313070.htm
+//
+// This Memory Controller manages DDR2 FB-DIMMs. It has 2 branches, each with
+// 2 channels operating in lockstep no-mirror mode. Each channel can have up to
+// 4 dimm's, each with up to 8GB.
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -1467,7 +1465,7 @@ static void __exit i5400_exit(void)
 module_init(i5400_init);
 module_exit(i5400_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Ben Woodard <woodard@redhat.com>");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 6b5a554ba8e4..36d1ef559ab6 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1,22 +1,18 @@
-/*
- * Intel 7300 class Memory Controllers kernel module (Clarksboro)
- *
- * This file may be distributed under the terms of the
- * GNU General Public License version 2 only.
- *
- * Copyright (c) 2010 by:
- *	 Mauro Carvalho Chehab
- *
- * Red Hat Inc. http://www.redhat.com
- *
- * Intel 7300 Chipset Memory Controller Hub (MCH) - Datasheet
- *	http://www.intel.com/Assets/PDF/datasheet/318082.pdf
- *
- * TODO: The chipset allow checking for PCI Express errors also. Currently,
- *	 the driver covers only memory error errors
- *
- * This driver uses "csrows" EDAC attribute to represent DIMM slot#
- */
+// SPDX-License-Identifier: GPL-2.0
+// Intel 7300 class Memory Controllers kernel module (Clarksboro)
+//
+// Copyright (c) 2010 by:
+//	 Mauro Carvalho Chehab
+//
+// Red Hat Inc. http://www.redhat.com
+//
+// Intel 7300 Chipset Memory Controller Hub (MCH) - Datasheet
+//	http://www.intel.com/Assets/PDF/datasheet/318082.pdf
+//
+// TODO: The chipset allow checking for PCI Express errors also. Currently,
+//	 the driver covers only memory error errors
+//
+// This driver uses "csrows" EDAC attribute to represent DIMM slot#
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -1207,7 +1203,7 @@ static void __exit i7300_exit(void)
 module_init(i7300_init);
 module_exit(i7300_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel I7300 memory controllers - "
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 8c5540160a23..aa27ebcbd143 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1,29 +1,26 @@
-/* Intel i7 core/Nehalem Memory Controller kernel module
- *
- * This driver supports the memory controllers found on the Intel
- * processor families i7core, i7core 7xx/8xx, i5core, Xeon 35xx,
- * Xeon 55xx and Xeon 56xx also known as Nehalem, Nehalem-EP, Lynnfield
- * and Westmere-EP.
- *
- * This file may be distributed under the terms of the
- * GNU General Public License version 2 only.
- *
- * Copyright (c) 2009-2010 by:
- *	 Mauro Carvalho Chehab
- *
- * Red Hat Inc. http://www.redhat.com
- *
- * Forked and adapted from the i5400_edac driver
- *
- * Based on the following public Intel datasheets:
- * Intel Core i7 Processor Extreme Edition and Intel Core i7 Processor
- * Datasheet, Volume 2:
- *	http://download.intel.com/design/processor/datashts/320835.pdf
- * Intel Xeon Processor 5500 Series Datasheet Volume 2
- *	http://www.intel.com/Assets/PDF/datasheet/321322.pdf
- * also available at:
- * 	http://www.arrownac.com/manufacturers/intel/s/nehalem/5500-datasheet-v2.pdf
- */
+// SPDX-License-Identifier: GPL-2.0
+// Intel i7 core/Nehalem Memory Controller kernel module
+//
+// This driver supports the memory controllers found on the Intel
+// processor families i7core, i7core 7xx/8xx, i5core, Xeon 35xx,
+// Xeon 55xx and Xeon 56xx also known as Nehalem, Nehalem-EP, Lynnfield
+// and Westmere-EP.
+//
+// Copyright (c) 2009-2010 by:
+//	 Mauro Carvalho Chehab
+//
+// Red Hat Inc. http://www.redhat.com
+//
+// Forked and adapted from the i5400_edac driver
+//
+// Based on the following public Intel datasheets:
+// Intel Core i7 Processor Extreme Edition and Intel Core i7 Processor
+// Datasheet, Volume 2:
+//	http://download.intel.com/design/processor/datashts/320835.pdf
+// Intel Xeon Processor 5500 Series Datasheet Volume 2
+//	http://www.intel.com/Assets/PDF/datasheet/321322.pdf
+// also available at:
+// 	http://www.arrownac.com/manufacturers/intel/s/nehalem/5500-datasheet-v2.pdf
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -2384,7 +2381,7 @@ static void __exit i7core_exit(void)
 module_init(i7core_init);
 module_exit(i7core_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel i7 Core memory controllers - "
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index f34430f99fd8..ef2fc6a82e70 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1,14 +1,11 @@
-/* Intel Sandy Bridge -EN/-EP/-EX Memory Controller kernel module
- *
- * This driver supports the memory controllers found on the Intel
- * processor family Sandy Bridge.
- *
- * This file may be distributed under the terms of the
- * GNU General Public License version 2 only.
- *
- * Copyright (c) 2011 by:
- *	 Mauro Carvalho Chehab
- */
+// SPDX-License-Identifier: GPL-2.0
+// Intel Sandy Bridge -EN/-EP/-EX Memory Controller kernel module
+//
+// This driver supports the memory controllers found on the Intel
+// processor family Sandy Bridge.
+//
+// Copyright (c) 2011 by:
+//	 Mauro Carvalho Chehab
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -3450,7 +3447,7 @@ module_exit(sbridge_exit);
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel Sandy Bridge and Ivy Bridge memory controllers - "
-- 
2.14.3
