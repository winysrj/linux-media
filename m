Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39683 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752901AbdLANrf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 08:47:35 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org, Sean Young <sean@mess.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>
Subject: [PATCH v2 4/7] media: usb: add SPDX identifiers to some code I wrote
Date: Fri,  1 Dec 2017 11:47:10 -0200
Message-Id: <e3c101aab92fa400f6ac532b39cdf82b39be6784.1512135871.git.mchehab@s-opensource.com>
In-Reply-To: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
In-Reply-To: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now using SPDX identifiers, on several
media drivers I wrote, add the proper SPDX, identifying
the license I meant.

As we're now using the short license, it doesn't make sense to
keep the original license text.

Also, fix MODULE_LICENSE to properly identify GPL v2.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>
---
 drivers/media/usb/au0828/au0828-input.c    | 25 +++++++------------------
 drivers/media/usb/cx231xx/cx231xx-input.c  | 28 +++++++++-------------------
 drivers/media/usb/tm6000/tm6000-alsa.c     | 18 ++++++------------
 drivers/media/usb/tm6000/tm6000-cards.c    | 20 +++++---------------
 drivers/media/usb/tm6000/tm6000-core.c     | 24 +++++++-----------------
 drivers/media/usb/tm6000/tm6000-i2c.c      | 24 +++++++-----------------
 drivers/media/usb/tm6000/tm6000-regs.h     | 18 ++++--------------
 drivers/media/usb/tm6000/tm6000-stds.c     | 18 ++++--------------
 drivers/media/usb/tm6000/tm6000-usb-isoc.h | 18 ++++--------------
 drivers/media/usb/tm6000/tm6000-video.c    | 24 +++++++-----------------
 drivers/media/usb/tm6000/tm6000.h          | 24 +++++++-----------------
 11 files changed, 67 insertions(+), 174 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index af68afe085b5..832ed9f25784 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -1,21 +1,10 @@
-/*
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
- */
+// SPDX-License-Identifier: GPL-2.0+
+// handle au0828 IR remotes via linux kernel input layer.
+//
+// Copyright (c) 2014 Mauro Carvalho Chehab <mchehab@samsung.com>
+// Copyright (c) 2014 Samsung Electronics Co., Ltd.
+//
+// Based on em28xx-input.c.
 
 #include "au0828.h"
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 02ebeb16055f..3e9b73a6b7c9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -1,22 +1,12 @@
-/*
- *   cx231xx IR glue driver
- *
- *   Copyright (C) 2010 Mauro Carvalho Chehab
- *
- *   Polaris (cx231xx) has its support for IR's with a design close to MCE.
- *   however, a few designs are using an external I2C chip for IR, instead
- *   of using the one provided by the chip.
- *   This driver provides support for those extra devices
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License as
- *   published by the Free Software Foundation version 2.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- *   General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// cx231xx IR glue driver
+//
+// Copyright (c) 2010 Mauro Carvalho Chehab <mchehab@kernel.org>
+//
+// Polaris (cx231xx) has its support for IR's with a design close to MCE.
+// however, a few designs are using an external I2C chip for IR, instead
+// of using the one provided by the chip.
+// This driver provides support for those extra devices
 
 #include "cx231xx.h"
 #include <linux/slab.h>
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index 3717a6844ea8..f18cffae4c85 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -1,14 +1,8 @@
-/*
- *
- *  Support for audio capture for tm5600/6000/6010
- *    (c) 2007-2008 Mauro Carvalho Chehab
- *
- *  Based on cx88-alsa.c
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- */
+// SPDX-License-Identifier: GPL-2.0
+// Support for audio capture for tm5600/6000/6010
+// Copyright (c) 2007-2008 Mauro Carvalho Chehab <mchehab@kernel.org>
+//
+// Based on cx88-alsa.c
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -57,7 +51,7 @@ MODULE_PARM_DESC(index, "Index value for tm6000x capture interface(s).");
 
 MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 based TV cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},{{Trident,tm6000},{{Trident,tm6010}");
 static unsigned int debug;
 module_param(debug, int, 0644);
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 77347541904d..8d2aa63f9b94 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1,17 +1,7 @@
-/*
- *  tm6000-cards.c - driver for TM5600/TM6000/TM6010 USB video capture devices
- *
- *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// tm6000-cards.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+//
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -1405,4 +1395,4 @@ module_usb_driver(tm6000_usb_driver);
 
 MODULE_DESCRIPTION("Trident TVMaster TM5600/TM6000/TM6010 USB2 adapter");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/usb/tm6000/tm6000-core.c b/drivers/media/usb/tm6000/tm6000-core.c
index 8c265bd80faa..23a1332d98e6 100644
--- a/drivers/media/usb/tm6000/tm6000-core.c
+++ b/drivers/media/usb/tm6000/tm6000-core.c
@@ -1,20 +1,10 @@
-/*
- *  tm6000-core.c - driver for TM5600/TM6000/TM6010 USB video capture devices
- *
- *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
- *      - DVB-T support
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// tm6000-core.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+//
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+//
+// Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+//     - DVB-T support
 
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/tm6000/tm6000-i2c.c b/drivers/media/usb/tm6000/tm6000-i2c.c
index cbcc1472f1c7..c9a62bbff27a 100644
--- a/drivers/media/usb/tm6000/tm6000-i2c.c
+++ b/drivers/media/usb/tm6000/tm6000-i2c.c
@@ -1,20 +1,10 @@
-/*
- *  tm6000-i2c.c - driver for TM5600/TM6000/TM6010 USB video capture devices
- *
- *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
- *	- Fix SMBus Read Byte command
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// tm6000-i2c.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+//
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+//
+// Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+//	- Fix SMBus Read Byte command
 
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/tm6000/tm6000-regs.h b/drivers/media/usb/tm6000/tm6000-regs.h
index ab3fb74c476c..6723e373fdc6 100644
--- a/drivers/media/usb/tm6000/tm6000-regs.h
+++ b/drivers/media/usb/tm6000/tm6000-regs.h
@@ -1,17 +1,7 @@
-/*
- *  tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
- *
- *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
+//
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
 /*
  * Define TV Master TM5600/TM6000/TM6010 Request codes
diff --git a/drivers/media/usb/tm6000/tm6000-stds.c b/drivers/media/usb/tm6000/tm6000-stds.c
index aa43810d17f9..c0c75951246b 100644
--- a/drivers/media/usb/tm6000/tm6000-stds.c
+++ b/drivers/media/usb/tm6000/tm6000-stds.c
@@ -1,17 +1,7 @@
-/*
- *  tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
- *
- *  Copyright (C) 2007 Mauro Carvalho Chehab
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+//
+// Copyright (c) 2007 Mauro Carvalho Chehab <mchehab@kernel.org>
 
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/tm6000/tm6000-usb-isoc.h b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
index 6a13a27c55d7..e69f5cf8fe9f 100644
--- a/drivers/media/usb/tm6000/tm6000-usb-isoc.h
+++ b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
@@ -1,17 +1,7 @@
-/*
- *  tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
- *
- *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+//
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
 #include <linux/videodev2.h>
 
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 9fa25de6b5a9..a95ea629b203 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1,20 +1,10 @@
-/*
- *   tm6000-video.c - driver for TM5600/TM6000/TM6010 USB video capture devices
- *
- *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
- *	- Fixed module load/unload
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// tm6000-video.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+//
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+//
+// Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+//	- Fixed module load/unload
 
 #include <linux/module.h>
 #include <linux/delay.h>
diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
index 7ec478d75f55..d53c8e1068e8 100644
--- a/drivers/media/usb/tm6000/tm6000.h
+++ b/drivers/media/usb/tm6000/tm6000.h
@@ -1,20 +1,10 @@
-/*
- *  tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
- *
- *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
- *	- DVB-T support
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
+//
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+//
+// Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+//	- DVB-T support
 
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
-- 
2.14.3
