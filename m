Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23428 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbeBUBD1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 20:03:27 -0500
From: Rajmohan Mani <rajmohan.mani@intel.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>
Subject: [PATCH] media: dw9714: Update to SPDX license identifier
Date: Tue, 20 Feb 2018 16:54:05 -0800
Message-Id: <1519174445-6114-1-git-send-email-rajmohan.mani@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the GPL v2 license boilerplate and update with the SPDX license
identifier.

Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
---
 drivers/media/i2c/dw9714.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 8dbbf0f..91fae01 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -1,15 +1,5 @@
-/*
- * Copyright (c) 2015--2017 Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2015--2017 Intel Corporation.
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
-- 
1.9.1
