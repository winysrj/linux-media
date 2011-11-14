Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60332 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab1KNPJh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 10:09:37 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2 5/5] davinci: delete individual platform header files and use a common header
Date: Mon, 14 Nov 2011 20:39:17 +0530
Message-ID: <1321283357-27698-6-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
References: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
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
 drivers/media/video/davinci/vpif_capture.h  |    1 +
 drivers/media/video/davinci/vpif_display.c  |    2 +-
 18 files changed, 14 insertions(+), 91 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm355.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm365.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm644x.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm646x.h

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 4e0e707..ab20bd7 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -26,7 +26,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm355.h>
+#include <mach/davinci_common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
 #include <mach/nand.h>
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index ff2d241..f2cffa1 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -23,7 +23,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm355.h>
+#include <mach/davinci_common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
 #include <mach/nand.h>
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 1918ae7..f338b64 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -32,7 +32,7 @@
 #include <asm/mach/arch.h>
 
 #include <mach/mux.h>
-#include <mach/dm365.h>
+#include <mach/davinci_common.h>
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 0cf8abf..c12a02e 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -30,7 +30,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm644x.h>
+#include <mach/davinci_common.h>
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index e574d7f..d7bfc63 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -36,7 +36,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm646x.h>
+#include <mach/davinci_common.h>
 #include <mach/common.h>
 #include <mach/serial.h>
 #include <mach/i2c.h>
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index e5f231a..be73ed5 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -30,7 +30,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dm644x.h>
+#include <mach/davinci_common.h>
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
index 5dd4da9..330c9f9 100644
--- a/arch/arm/mach-davinci/board-sffsdr.c
+++ b/arch/arm/mach-davinci/board-sffsdr.c
@@ -35,7 +35,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
 
-#include <mach/dm644x.h>
+#include <mach/davinci_common.h>
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index fe520d4..0929e0f 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -18,7 +18,7 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/dm355.h>
+#include <mach/davinci_common.h>
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/psc.h>
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 77edee8..34aac1b 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -21,7 +21,7 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/dm365.h>
+#include <mach/davinci_common.h>
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/psc.h>
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 1b4b911..c4ebee2 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -15,7 +15,7 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/dm644x.h>
+#include <mach/davinci_common.h>
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 0560e82..f543be3 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -16,7 +16,7 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/dm646x.h>
+#include <mach/davinci_common.h>
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-davinci/include/mach/dm355.h b/arch/arm/mach-davinci/include/mach/dm355.h
deleted file mode 100644
index 40c298b..0000000
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
-#include <mach/davinci_common.h>
-
-#endif /* __ASM_ARCH_DM355_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm365.h b/arch/arm/mach-davinci/include/mach/dm365.h
deleted file mode 100644
index 3c30934..0000000
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
-#include <mach/davinci_common.h>
-
-#endif /* __ASM_ARCH_DM365_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
deleted file mode 100644
index 186fabb..0000000
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
-#include <mach/davinci_common.h>
-
-#endif /* __ASM_ARCH_DM644X_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
deleted file mode 100644
index 216e7c5..0000000
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
-#include <mach/davinci_common.h>
-
-#endif /* __ASM_ARCH_DM646X_H */
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 25036cb..73b00bd 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -18,8 +18,7 @@
 
 #include <linux/io.h>
 #include <linux/videodev2.h>
-#include <mach/hardware.h>
-#include <mach/dm646x.h>
+#include <mach/davinci_common.h>
 #include <media/davinci/vpif_types.h>
 
 /* Maximum channel allowed */
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index a693d4e..c019d26 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -27,6 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
 #include <media/videobuf-dma-contig.h>
+#include <mach/davinci_common.h>
 #include <media/davinci/vpif_types.h>
 
 #include "vpif.h"
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 286f029..8921871 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -39,7 +39,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
 
-#include <mach/dm646x.h>
+#include <mach/davinci_common.h>
 
 #include "vpif_display.h"
 #include "vpif.h"
-- 
1.6.2.4

