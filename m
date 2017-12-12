Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:32130 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbdLLHrb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 02:47:31 -0500
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH] [media] ir-spi: add SPDX identifier
Date: Tue, 12 Dec 2017 16:47:20 +0900
Message-id: <20171212074720.8144-1-andi.shyti@samsung.com>
References: <CGME20171212074728epcas1p2f8badcbbd67a4ce3b1bdd0ff2c257106@epcas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the original license statement with the SPDX identifier.

Update also the copyright owner adding myself as co-owner of the
copyright.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
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
2.15.1
