Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46176 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab1KQKTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:19:12 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v3 5/5] ARM: davinci: delete individual platform header files and use a common header
Date: Thu, 17 Nov 2011 15:48:58 +0530
Message-ID: <1321525138-3928-6-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
References: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

include davinci_common.h file in files using the platform
header file for dm355, dm365, dm644x and dm646x and delete the
individual platform header files.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c     |    2 +-
 arch/arm/mach-davinci/board-dm355-leopard.c |    2 +-
 arch/arm/mach-davinci/board-dm365-evm.c     |    2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c    |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c    |    2 +-
 arch/arm/mach-davinci/board-neuros-osd2.c   |    2 +-
 arch/arm/mach-davinci/board-sffsdr.c        |    2 +-
 arch/arm/mach-davinci/dm355.c               |    2 +-
 arch/arm/mach-davinci/dm365.c               |    2 +-
 arch/arm/mach-davinci/dm644x.c              |    2 +-
 arch/arm/mach-davinci/dm646x.c              |    2 +-
 arch/arm/mach-davinci/include/mach/dm355.h  |   16 ----------------
 arch/arm/mach-davinci/include/mach/dm365.h  |   18 ------------------
 arch/arm/mach-davinci/include/mach/dm644x.h |   27 ---------------------------
 arch/arm/mach-davinci/include/mach/dm646x.h |   16 ----------------
 drivers/media/video/davinci/vpif.h          |    3 +--
 drivers/media/video/davinci/vpif_display.c  |    2 +-
 17 files changed, 13 insertions(+), 91 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm355.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm365.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm644x.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm646x.h

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 4e0e707..7b98160 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -26,7 +26,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm355.h>
+#include <mach/davinci.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
 #include <mach/nand.h>
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index ff2d241..b4f9558 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -23,7 +23,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm355.h>
+#include <mach/davinci.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
 #include <mach/nand.h>
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 1918ae7..7aec2ab 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -32,7 +32,7 @@
 #include <asm/mach/arch.h>
 
 #include <mach/mux.h>
-#include <mach/dm365.h>
+#include <mach/davinci.h>
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 0cf8abf..880aa0c 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -30,7 +30,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm644x.h>
+#include <mach/davinci.h>
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index e574d7f..383acdf 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -36,7 +36,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm646x.h>
+#include <mach/davinci.h>
 #include <mach/common.h>
 #include <mach/serial.h>
 #include <mach/i2c.h>
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index e5f231a..a4608cf 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -30,7 +30,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm644x.h>
+#include <mach/davinci.h>
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
index 5dd4da9..b993ac6 100644
--- a/arch/arm/mach-davinci/board-sffsdr.c
+++ b/arch/arm/mach-davinci/board-sffsdr.c
@@ -35,7 +35,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
 
-#include <mach/dm644x.h>
+#include <mach/davinci.h>
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index fe520d4..2e29ed0 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -18,7 +18,7 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/dm355.h>
+#include <mach/davinci.h>
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/psc.h>
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 77edee8..6b8ce8c 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -21,7 +21,7 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/dm365.h>
+#include <mach/davinci.h>
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/psc.h>
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 27d1371..401f916 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -15,7 +15,7 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/dm644x.h>
+#include <mach/davinci.h>
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 0560e82..850ad3c 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -16,7 +16,7 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/dm646x.h>
+#include <mach/davinci.h>
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-davinci/include/mach/dm355.h b/arch/arm/mach-davinci/include/mach/dm355.h
deleted file mode 100644
index 14e7766..0000000
--- a/arch/arm/mach-davinci/include/mach/dm355.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Chip specific defines for DM355 SoC
- *
- * Author: Kevin Hilman, Deep Root Systems, LLC
- *
- * 2007 (c) Deep Root Systems, LLC. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-#ifndef __ASM_ARCH_DM355_H
-#define __ASM_ARCH_DM355_H
-
-#include <mach/davinci.h>
-
-#endif /* __ASM_ARCH_DM355_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm365.h b/arch/arm/mach-davinci/include/mach/dm365.h
deleted file mode 100644
index 3433d72..0000000
--- a/arch/arm/mach-davinci/include/mach/dm365.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Copyright (C) 2009 Texas Instruments Incorporated
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#ifndef __ASM_ARCH_DM365_H
-#define __ASM_ARCH_DM665_H
-
-#include <mach/davinci.h>
-
-#endif /* __ASM_ARCH_DM365_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
deleted file mode 100644
index 99e9525..0000000
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * This file contains the processor specific definitions
- * of the TI DM644x.
- *
- * Copyright (C) 2008 Texas Instruments.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- */
-#ifndef __ASM_ARCH_DM644X_H
-#define __ASM_ARCH_DM644X_H
-
-#include <mach/davinci.h>
-
-#endif /* __ASM_ARCH_DM644X_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
deleted file mode 100644
index 8bdea80..0000000
--- a/arch/arm/mach-davinci/include/mach/dm646x.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Chip specific defines for DM646x SoC
- *
- * Author: Kevin Hilman, Deep Root Systems, LLC
- *
- * 2007 (c) Deep Root Systems, LLC. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-#ifndef __ASM_ARCH_DM646X_H
-#define __ASM_ARCH_DM646X_H
-
-#include <mach/davinci.h>
-
-#endif /* __ASM_ARCH_DM646X_H */
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 25036cb..1e0fef9 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -18,8 +18,7 @@
 
 #include <linux/io.h>
 #include <linux/videodev2.h>
-#include <mach/hardware.h>
-#include <mach/dm646x.h>
+#include <mach/davinci.h>
 #include <media/davinci/vpif_types.h>
 
 /* Maximum channel allowed */
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 286f029..4766d41 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -39,7 +39,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
 
-#include <mach/dm646x.h>
+#include <mach/davinci.h>
 
 #include "vpif_display.h"
 #include "vpif.h"
-- 
1.6.2.4

