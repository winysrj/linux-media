Return-path: <linux-media-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:51424 "EHLO
        faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932080AbeFZVcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 17:32:06 -0400
From: Daniel Graefe <daniel.graefe@fau.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, daniel.graefe@fau.de,
        linux-kernel@i4.cs.fau.de, Roman Sommer <roman.sommer@fau.de>
Subject: [PATCH v2] staging: media: omap4iss: Added SPDX license identifiers
Date: Tue, 26 Jun 2018 23:30:56 +0200
Message-Id: <1530048656-4074-1-git-send-email-daniel.graefe@fau.de>
In-Reply-To: <1529932892-9036-1-git-send-email-daniel.graefe@fau.de>
References: <1529932892-9036-1-git-send-email-daniel.graefe@fau.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added missing SPDX license identifiers to all files of the omap4iss
driver.

Most files already have license texts which clearly state them to be
licensed under GPL 2.0 or later. SPDX identifiers were added accordingly.

Some files do not have any license text. SPDX identifiers for GPL 2.0
were added to them, in accordance with the default license of the
kernel.

Signed-off-by: Daniel Graefe <daniel.graefe@fau.de>
Signed-off-by: Roman Sommer <roman.sommer@fau.de>
---
Changes in v2:
- replaced "GPL-2.0-or-later" with "GPL-2.0+"
- removed boilerplate license texts

 drivers/staging/media/omap4iss/Kconfig       | 2 ++
 drivers/staging/media/omap4iss/Makefile      | 3 +++
 drivers/staging/media/omap4iss/iss.c         | 6 +-----
 drivers/staging/media/omap4iss/iss.h         | 6 +-----
 drivers/staging/media/omap4iss/iss_csi2.c    | 6 +-----
 drivers/staging/media/omap4iss/iss_csi2.h    | 6 +-----
 drivers/staging/media/omap4iss/iss_csiphy.c  | 6 +-----
 drivers/staging/media/omap4iss/iss_csiphy.h  | 6 +-----
 drivers/staging/media/omap4iss/iss_ipipe.c   | 6 +-----
 drivers/staging/media/omap4iss/iss_ipipe.h   | 6 +-----
 drivers/staging/media/omap4iss/iss_ipipeif.c | 6 +-----
 drivers/staging/media/omap4iss/iss_ipipeif.h | 6 +-----
 drivers/staging/media/omap4iss/iss_regs.h    | 6 +-----
 drivers/staging/media/omap4iss/iss_resizer.c | 6 +-----
 drivers/staging/media/omap4iss/iss_resizer.h | 6 +-----
 drivers/staging/media/omap4iss/iss_video.c   | 6 +-----
 drivers/staging/media/omap4iss/iss_video.h   | 6 +-----
 17 files changed, 20 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index dddd273..841cc0b 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 config VIDEO_OMAP4
 	tristate "OMAP 4 Camera support"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C
diff --git a/drivers/staging/media/omap4iss/Makefile b/drivers/staging/media/omap4iss/Makefile
index a716ce9..e64d489 100644
--- a/drivers/staging/media/omap4iss/Makefile
+++ b/drivers/staging/media/omap4iss/Makefile
@@ -1,4 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+#
 # Makefile for OMAP4 ISS driver
+#
 
 omap4-iss-objs += \
 	iss.o iss_csi2.o iss_csiphy.o iss_ipipeif.o iss_ipipe.o iss_resizer.o iss_video.o
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index b1036ba..f0cbcbf 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * TI OMAP4 ISS V4L2 Driver
  *
  * Copyright (C) 2012, Texas Instruments
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/clk.h>
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 760ee27..b88f952 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * TI OMAP4 ISS V4L2 Driver
  *
  * Copyright (C) 2012 Texas Instruments.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #ifndef _OMAP4_ISS_H_
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index f6acc54..059cf5b 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * TI OMAP4 ISS V4L2 Driver - CSI PHY module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/delay.h>
diff --git a/drivers/staging/media/omap4iss/iss_csi2.h b/drivers/staging/media/omap4iss/iss_csi2.h
index 24ab378..3f7fd9c 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.h
+++ b/drivers/staging/media/omap4iss/iss_csi2.h
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * TI OMAP4 ISS V4L2 Driver - CSI2 module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #ifndef OMAP4_ISS_CSI2_H
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
index 748607f..96f2ce0 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * TI OMAP4 ISS V4L2 Driver - CSI PHY module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/delay.h>
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.h b/drivers/staging/media/omap4iss/iss_csiphy.h
index a0f2d97..44408e4 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.h
+++ b/drivers/staging/media/omap4iss/iss_csiphy.h
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * TI OMAP4 ISS V4L2 Driver - CSI PHY module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #ifndef OMAP4_ISS_CSI_PHY_H
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index d86ef8a..03ec45e 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * TI OMAP4 ISS V4L2 Driver - ISP IPIPE module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.h b/drivers/staging/media/omap4iss/iss_ipipe.h
index d5b441d..53b42aa 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.h
+++ b/drivers/staging/media/omap4iss/iss_ipipe.h
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * TI OMAP4 ISS V4L2 Driver - ISP IPIPE module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #ifndef OMAP4_ISS_IPIPE_H
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index cb88b2b..bf64539 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * TI OMAP4 ISS V4L2 Driver - ISP IPIPEIF module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.h b/drivers/staging/media/omap4iss/iss_ipipeif.h
index bad32b1..6979233 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.h
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.h
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * TI OMAP4 ISS V4L2 Driver - ISP IPIPEIF module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #ifndef OMAP4_ISS_IPIPEIF_H
diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/media/omap4iss/iss_regs.h
index cb415e8..09a7375 100644
--- a/drivers/staging/media/omap4iss/iss_regs.h
+++ b/drivers/staging/media/omap4iss/iss_regs.h
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * TI OMAP4 ISS V4L2 Driver - Register defines
  *
  * Copyright (C) 2012 Texas Instruments.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #ifndef _OMAP4_ISS_REGS_H_
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 4bbfa20..f13e33c 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * TI OMAP4 ISS V4L2 Driver - ISP RESIZER module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/media/omap4iss/iss_resizer.h b/drivers/staging/media/omap4iss/iss_resizer.h
index 8b7c5fe..cb937fc 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.h
+++ b/drivers/staging/media/omap4iss/iss_resizer.h
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * TI OMAP4 ISS V4L2 Driver - ISP RESIZER module
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #ifndef OMAP4_ISS_RESIZER_H
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index a3a8342..b8e0ea3 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * TI OMAP4 ISS V4L2 Driver - Generic video node
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <asm/cacheflush.h>
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index d7e05d0..f22489e 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * TI OMAP4 ISS V4L2 Driver - Generic video node
  *
  * Copyright (C) 2012 Texas Instruments, Inc.
  *
  * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #ifndef OMAP4_ISS_VIDEO_H
-- 
2.7.4
