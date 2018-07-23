Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35014 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388060AbeGWQBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 12:01:20 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH -next v2] regmap: sccb: fix typo and sort headers alphabetically
Date: Mon, 23 Jul 2018 23:59:29 +0900
Message-Id: <1532357969-10612-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix typos 's/wit/with/' in the comments and sort headers alphabetically
in order to avoid duplicate includes in future.

Fixes: bcf7eac3d97f ("regmap: add SCCB support")
Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Brown <broonie@kernel.org>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Replace Wolfram's address for Reported-by tag
- Add Reviewed-by tag

 drivers/base/regmap/regmap-sccb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-sccb.c b/drivers/base/regmap/regmap-sccb.c
index b6eb876..597042e2 100644
--- a/drivers/base/regmap/regmap-sccb.c
+++ b/drivers/base/regmap/regmap-sccb.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 // Register map access API - SCCB support
 
-#include <linux/regmap.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
+#include <linux/regmap.h>
 
 #include "internal.h"
 
@@ -29,7 +29,7 @@ static bool sccb_is_available(struct i2c_adapter *adap)
 
 /**
  * regmap_sccb_read - Read data from SCCB slave device
- * @context: Device that will be interacted wit
+ * @context: Device that will be interacted with
  * @reg: Register to be read from
  * @val: Pointer to store read value
  *
@@ -65,7 +65,7 @@ static int regmap_sccb_read(void *context, unsigned int reg, unsigned int *val)
 
 /**
  * regmap_sccb_write - Write data to SCCB slave device
- * @context: Device that will be interacted wit
+ * @context: Device that will be interacted with
  * @reg: Register to write to
  * @val: Value to be written
  *
-- 
2.7.4
