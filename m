Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33034 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdHRQHz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 12:07:55 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, vz@mleia.com, slemieux.tyco@gmail.com,
        wsa@the-dreams.de, gxt@mprc.pku.edu.cn, mchehab@kernel.org,
        isely@pobox.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 1/2] i2c: busses: make i2c_algorithm const
Date: Fri, 18 Aug 2017 21:36:57 +0530
Message-Id: <1503072418-6887-2-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503072418-6887-1-git-send-email-bhumirks@gmail.com>
References: <1503072418-6887-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only stored in the algo field of
i2c_adapter structure, which is const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/i2c/busses/i2c-pnx.c  | 2 +-
 drivers/i2c/busses/i2c-puv3.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index fd5f9d2..42d6b3a 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -590,7 +590,7 @@ static u32 i2c_pnx_func(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
-static struct i2c_algorithm pnx_algorithm = {
+static const struct i2c_algorithm pnx_algorithm = {
 	.master_xfer = i2c_pnx_xfer,
 	.functionality = i2c_pnx_func,
 };
diff --git a/drivers/i2c/busses/i2c-puv3.c b/drivers/i2c/busses/i2c-puv3.c
index 0c8b157..287088b 100644
--- a/drivers/i2c/busses/i2c-puv3.c
+++ b/drivers/i2c/busses/i2c-puv3.c
@@ -175,7 +175,7 @@ static u32 puv3_i2c_func(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
-static struct i2c_algorithm puv3_i2c_algorithm = {
+static const struct i2c_algorithm puv3_i2c_algorithm = {
 	.master_xfer	= puv3_i2c_xfer,
 	.functionality	= puv3_i2c_func,
 };
-- 
1.9.1
