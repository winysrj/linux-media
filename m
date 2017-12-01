Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38031 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753182AbdLANrS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 08:47:18 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org, Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 7/7] media: siano: add SPDX markups
Date: Fri,  1 Dec 2017 11:47:13 -0200
Message-Id: <4124abdb1e9ec40014aa8c9bcfb10687dcee72c8.1512135871.git.mchehab@s-opensource.com>
In-Reply-To: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
In-Reply-To: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now using SPDX identifiers, add the proper SPDX,
better identifying the licenses whith apply to the source code.

As we're now using the short license, it doesn't make sense to
keep the original license text.

Also, fix MODULE_LICENSE to properly identify GPL v2
at the Siano's common driver. Some codes there are licensed
on GPL v2 or latter, while others are GPL v2 only. So,
in order to reflect the common license that applies to
everything, the module itself should be GPLv2 only.

While here, use the Kernel's coding style for the comments
with copyright info.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/siano/smsdvb-debugfs.c | 21 +++-------------
 drivers/media/common/siano/smsir.c          | 35 ++++++++-------------------
 drivers/media/common/siano/smsir.h          | 37 ++++++++++-------------------
 3 files changed, 25 insertions(+), 68 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 1a8677ade391..e06aec0ed18e 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -1,21 +1,6 @@
-/***********************************************************************
- *
- * Copyright(c) 2013 Mauro Carvalho Chehab
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
-
- *  This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
- ***********************************************************************/
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright(c) 2013 Mauro Carvalho Chehab
 
 #include "smscoreapi.h"
 
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index e77bb0c95e69..56db0a944421 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -1,28 +1,13 @@
-/****************************************************************
-
- Siano Mobile Silicon, Inc.
- MDTV receiver kernel modules.
- Copyright (C) 2006-2009, Uri Shkolnik
-
- Copyright (c) 2010 - Mauro Carvalho Chehab
-	- Ported the driver to use rc-core
-	- IR raw event decoding is now done at rc-core
-	- Code almost re-written
-
- This program is free software: you can redistribute it and/or modify
- it under the terms of the GNU General Public License as published by
- the Free Software Foundation, either version 2 of the License, or
- (at your option) any later version.
-
- This program is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU General Public License
- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-
- ****************************************************************/
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Siano Mobile Silicon, Inc.
+// MDTV receiver kernel modules.
+// Copyright (C) 2006-2009, Uri Shkolnik
+//
+// Copyright (c) 2010 - Mauro Carvalho Chehab
+//	- Ported the driver to use rc-core
+//	- IR raw event decoding is now done at rc-core
+//	- Code almost re-written
 
 
 #include "smscoreapi.h"
diff --git a/drivers/media/common/siano/smsir.h b/drivers/media/common/siano/smsir.h
index d9abd96ef48b..b2c54c256e86 100644
--- a/drivers/media/common/siano/smsir.h
+++ b/drivers/media/common/siano/smsir.h
@@ -1,28 +1,15 @@
-/****************************************************************
-
-Siano Mobile Silicon, Inc.
-MDTV receiver kernel modules.
-Copyright (C) 2006-2009, Uri Shkolnik
-
- Copyright (c) 2010 - Mauro Carvalho Chehab
-	- Ported the driver to use rc-core
-	- IR raw event decoding is now done at rc-core
-	- Code almost re-written
-
-This program is free software: you can redistribute it and/or modify
-it under the terms of the GNU General Public License as published by
-the Free Software Foundation, either version 2 of the License, or
-(at your option) any later version.
-
- This program is distributed in the hope that it will be useful,
-but WITHOUT ANY WARRANTY; without even the implied warranty of
-MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-GNU General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with this program.  If not, see <http://www.gnu.org/licenses/>.
-
-****************************************************************/
+/*
+ * SPDX-License-Identifier: GPL-2.0+
+ *
+ * Siano Mobile Silicon, Inc.
+ * MDTV receiver kernel modules.
+ * Copyright (C) 2006-2009, Uri Shkolnik
+ *
+ * Copyright (c) 2010 - Mauro Carvalho Chehab
+ *	- Ported the driver to use rc-core
+ *	- IR raw event decoding is now done at rc-core
+ *	- Code almost re-written
+ */
 
 #ifndef __SMS_IR_H__
 #define __SMS_IR_H__
-- 
2.14.3
