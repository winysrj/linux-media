Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38571 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753505AbdLNRWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:02 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 10/10] media: ir-spi: add SPDX identifier
Date: Thu, 14 Dec 2017 17:21:59 +0000
Message-Id: <f15d723b0fe58c70bd35f1d793172acfbc7211b7.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andi Shyti <andi.shyti@samsung.com>

Replace the original license statement with the SPDX identifier.

Update also the copyright owner adding myself as co-owner of the
copyright.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-spi.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
index 29ed0638cb74..a32a84ae2d0b 100644
--- a/drivers/media/rc/ir-spi.c
+++ b/drivers/media/rc/ir-spi.c
@@ -1,13 +1,8 @@
-/*
- * Copyright (c) 2016 Samsung Electronics Co., Ltd.
- * Author: Andi Shyti <andi.shyti@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * SPI driven IR LED device driver
- */
+// SPDX-License-Identifier: GPL-2.0
+// SPI driven IR LED device driver
+//
+// Copyright (c) 2016 Samsung Electronics Co., Ltd.
+// Copyright (c) Andi Shyti <andi.shyti@samsung.com>
 
 #include <linux/delay.h>
 #include <linux/fs.h>
-- 
2.14.3
