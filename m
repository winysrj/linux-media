Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61843 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752924AbdKQKVq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 05:21:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>
Subject: [PATCH 6/6] media: usb: add SPDX identifiers to some code I wrote
Date: Fri, 17 Nov 2017 08:21:33 -0200
Message-Id: <fd92263a2c04a10d58ce465058391e6e8703dc90.1510913595.git.mchehab@s-opensource.com>
In-Reply-To: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
In-Reply-To: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now using SPDX identifiers, on several
media drivers I wrote, add the proper SPDX, identifying
the license I meant.

As we're now using the short license, it doesn't make sense to
keep the original license text.

Also, fix MODULE_LICENSE to properly identify GPL v2.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/au0828/au0828-input.c    | 23 +++++++----------------
 drivers/media/usb/cx231xx/cx231xx-input.c  | 10 +---------
 drivers/media/usb/tm6000/tm6000-alsa.c     |  7 ++-----
 drivers/media/usb/tm6000/tm6000-cards.c    | 12 ++----------
 drivers/media/usb/tm6000/tm6000-core.c     | 10 +---------
 drivers/media/usb/tm6000/tm6000-i2c.c      | 10 +---------
 drivers/media/usb/tm6000/tm6000-regs.h     | 10 +---------
 drivers/media/usb/tm6000/tm6000-stds.c     | 10 +---------
 drivers/media/usb/tm6000/tm6000-usb-isoc.h | 10 +---------
 drivers/media/usb/tm6000/tm6000-video.c    | 10 +---------
 drivers/media/usb/tm6000/tm6000.h          | 10 +---------
 11 files changed, 19 insertions(+), 103 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 7996eb83a54e..f254657dd844 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -1,20 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
-  handle au0828 IR remotes via linux kernel input layer.
-
-   Copyright (C) 2014 Mauro Carvalho Chehab <mchehab@samsung.com>
-   Copyright (c) 2014 Samsung Electronics Co., Ltd.
-
-  Based on em28xx-input.c.
-
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
+ * handle au0828 IR remotes via linux kernel input layer.
+ *
+ * Copyright (C) 2014 Mauro Carvalho Chehab <mchehab@samsung.com>
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * Based on em28xx-input.c.
  */
 
 #include "au0828.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 02ebeb16055f..62bbd52bad95 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *   cx231xx IR glue driver
  *
@@ -7,15 +8,6 @@
  *   however, a few designs are using an external I2C chip for IR, instead
  *   of using the one provided by the chip.
  *   This driver provides support for those extra devices
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License as
- *   published by the Free Software Foundation version 2.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- *   General Public License for more details.
  */
 
 #include "cx231xx.h"
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index 3717a6844ea8..3a76d1742f71 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -1,13 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *
  *  Support for audio capture for tm5600/6000/6010
  *    (c) 2007-2008 Mauro Carvalho Chehab
  *
  *  Based on cx88-alsa.c
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
@@ -57,7 +54,7 @@ MODULE_PARM_DESC(index, "Index value for tm6000x capture interface(s).");
 
 MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 based TV cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},{{Trident,tm6000},{{Trident,tm6010}");
 static unsigned int debug;
 module_param(debug, int, 0644);
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 2537643a1808..27496f085c72 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1,16 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  tm6000-cards.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
  *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/init.h>
@@ -1406,4 +1398,4 @@ module_usb_driver(tm6000_usb_driver);
 
 MODULE_DESCRIPTION("Trident TVMaster TM5600/TM6000/TM6010 USB2 adapter");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/usb/tm6000/tm6000-core.c b/drivers/media/usb/tm6000/tm6000-core.c
index 8c265bd80faa..fc7129e49839 100644
--- a/drivers/media/usb/tm6000/tm6000-core.c
+++ b/drivers/media/usb/tm6000/tm6000-core.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  tm6000-core.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
@@ -5,15 +6,6 @@
  *
  *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
  *      - DVB-T support
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/usb/tm6000/tm6000-i2c.c b/drivers/media/usb/tm6000/tm6000-i2c.c
index cbcc1472f1c7..5959adb56783 100644
--- a/drivers/media/usb/tm6000/tm6000-i2c.c
+++ b/drivers/media/usb/tm6000/tm6000-i2c.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  tm6000-i2c.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
@@ -5,15 +6,6 @@
  *
  *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
  *	- Fix SMBus Read Byte command
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/usb/tm6000/tm6000-regs.h b/drivers/media/usb/tm6000/tm6000-regs.h
index ab3fb74c476c..b88adecb7717 100644
--- a/drivers/media/usb/tm6000/tm6000-regs.h
+++ b/drivers/media/usb/tm6000/tm6000-regs.h
@@ -1,16 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
  *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 /*
diff --git a/drivers/media/usb/tm6000/tm6000-stds.c b/drivers/media/usb/tm6000/tm6000-stds.c
index aa43810d17f9..47cf58b3b83b 100644
--- a/drivers/media/usb/tm6000/tm6000-stds.c
+++ b/drivers/media/usb/tm6000/tm6000-stds.c
@@ -1,16 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
  *  Copyright (C) 2007 Mauro Carvalho Chehab
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/usb/tm6000/tm6000-usb-isoc.h b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
index 6a13a27c55d7..346b70745f75 100644
--- a/drivers/media/usb/tm6000/tm6000-usb-isoc.h
+++ b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
@@ -1,16 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
  *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/videodev2.h>
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index ec8c4d2534dc..d7fab36cd24b 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *   tm6000-video.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
@@ -5,15 +6,6 @@
  *
  *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
  *	- Fixed module load/unload
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
index 7ec478d75f55..47a7b7edf22b 100644
--- a/drivers/media/usb/tm6000/tm6000.h
+++ b/drivers/media/usb/tm6000/tm6000.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
@@ -5,15 +6,6 @@
  *
  *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
  *	- DVB-T support
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/videodev2.h>
-- 
2.14.3
