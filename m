Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49152 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932494AbdLRURQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 15:17:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>, James Hogan <jhogan@kernel.org>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philippe Ombredanne <pombredanne@nexb.com>
Subject: [PATCH] media: fix SPDX comment on some header files
Date: Mon, 18 Dec 2017 15:17:07 -0500
Message-Id: <c3a3d1d6b8b363a02234e5564692db3647f183e6.1513628219.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The agreed format is to use /* */ comments inside header
files. Unfortunately, I ended by using // on a few ones.

Reported-by: Andi Shyti <andi.shyti@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/rc-core-priv.h            | 10 ++++++----
 drivers/media/usb/tm6000/tm6000-regs.h     | 10 ++++++----
 drivers/media/usb/tm6000/tm6000-usb-isoc.h | 10 ++++++----
 drivers/media/usb/tm6000/tm6000.h          | 16 +++++++++-------
 4 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 915434855a63..3c3d2620f0e8 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -1,7 +1,9 @@
-// SPDX-License-Identifier: GPL-2.0
-// Remote Controller core raw events header
-//
-// Copyright (C) 2010 by Mauro Carvalho Chehab
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * Remote Controller core raw events header
+ *
+ * Copyright (C) 2010 by Mauro Carvalho Chehab
+ */
 
 #ifndef _RC_CORE_PRIV
 #define _RC_CORE_PRIV
diff --git a/drivers/media/usb/tm6000/tm6000-regs.h b/drivers/media/usb/tm6000/tm6000-regs.h
index 6723e373fdc6..21587fcf11e3 100644
--- a/drivers/media/usb/tm6000/tm6000-regs.h
+++ b/drivers/media/usb/tm6000/tm6000-regs.h
@@ -1,7 +1,9 @@
-// SPDX-License-Identifier: GPL-2.0
-// tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
-//
-// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ */
 
 /*
  * Define TV Master TM5600/TM6000/TM6010 Request codes
diff --git a/drivers/media/usb/tm6000/tm6000-usb-isoc.h b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
index e69f5cf8fe9f..5c615b0a7a46 100644
--- a/drivers/media/usb/tm6000/tm6000-usb-isoc.h
+++ b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
@@ -1,7 +1,9 @@
-// SPDX-License-Identifier: GPL-2.0
-// tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
-//
-// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ */
 
 #include <linux/videodev2.h>
 
diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
index d53c8e1068e8..16d3c81e4eb9 100644
--- a/drivers/media/usb/tm6000/tm6000.h
+++ b/drivers/media/usb/tm6000/tm6000.h
@@ -1,10 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0
-// tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
-//
-// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-//
-// Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
-//	- DVB-T support
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ * Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+ *	- DVB-T support
+ */
 
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
-- 
2.14.3
