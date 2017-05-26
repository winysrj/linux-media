Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38430 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934021AbdEZP3u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:29:50 -0400
Subject: [PATCH 10/11] atomisp: remove sh_css_irq - it contains nothing
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:29:36 +0100
Message-ID: <149581257111.17585.17522902601608671868.stgit@builder>
In-Reply-To: <149581243155.17585.8164899156710160858.stgit@builder>
References: <149581243155.17585.8164899156710160858.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We won't be adding abstractions or moving them here so kill it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/Makefile    |    1 -
 .../atomisp/pci/atomisp2/css2400/sh_css_irq.c      |   16 ----------------
 2 files changed, 17 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_irq.c

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index f126a89..93f85d3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -108,7 +108,6 @@ atomisp-objs += \
 	css2400/sh_css_metadata.o \
 	css2400/base/refcount/src/refcount.o \
 	css2400/base/circbuf/src/circbuf.o \
-	css2400/sh_css_irq.o \
 	css2400/camera/pipe/src/pipe_binarydesc.o \
 	css2400/camera/pipe/src/pipe_util.o \
 	css2400/camera/pipe/src/pipe_stagedesc.o \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_irq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_irq.c
deleted file mode 100644
index 37e954a..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_irq.c
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-/* This file will contain the code to implement the functions declared in ia_css_irq.h
-   and associated helper functions */
