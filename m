Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:39398 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbeC0RIj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 13:08:39 -0400
Received: by mail-pg0-f65.google.com with SMTP id b9so1650992pgf.6
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 10:08:39 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 2/4] dvb/pci/pt3: use SPDX License Identifier
Date: Wed, 28 Mar 2018 02:08:20 +0900
Message-Id: <20180327170822.21921-3-tskd08@gmail.com>
In-Reply-To: <20180327170822.21921-1-tskd08@gmail.com>
References: <20180327170822.21921-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/pci/pt3/pt3.c     | 11 +----------
 drivers/media/pci/pt3/pt3.h     | 11 +----------
 drivers/media/pci/pt3/pt3_dma.c | 11 +----------
 drivers/media/pci/pt3/pt3_i2c.c | 11 +----------
 4 files changed, 4 insertions(+), 40 deletions(-)

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index b2d9fb976c9..a45cf06ae4f 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -1,17 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Earthsoft PT3 driver
  *
  * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 #include <linux/freezer.h>
diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
index fbe8d9b847b..495891a4ee1 100644
--- a/drivers/media/pci/pt3/pt3.h
+++ b/drivers/media/pci/pt3/pt3.h
@@ -1,17 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Earthsoft PT3 driver
  *
  * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 #ifndef PT3_H
diff --git a/drivers/media/pci/pt3/pt3_dma.c b/drivers/media/pci/pt3/pt3_dma.c
index f0ce90437fa..de677b90ea5 100644
--- a/drivers/media/pci/pt3/pt3_dma.c
+++ b/drivers/media/pci/pt3/pt3_dma.c
@@ -1,17 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Earthsoft PT3 driver
  *
  * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/pt3/pt3_i2c.c b/drivers/media/pci/pt3/pt3_i2c.c
index b66138c7b36..b02be789a8c 100644
--- a/drivers/media/pci/pt3/pt3_i2c.c
+++ b/drivers/media/pci/pt3/pt3_i2c.c
@@ -1,17 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Earthsoft PT3 driver
  *
  * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #include <linux/delay.h>
 #include <linux/device.h>
-- 
2.16.3
