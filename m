Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34773 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdHSKej (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 06:34:39 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, wsa@the-dreams.de, jacmet@sunsite.dk,
        jglauber@cavium.com, david.daney@cavium.com,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 1/4] i2c: busses: make i2c_adapter const
Date: Sat, 19 Aug 2017 16:04:12 +0530
Message-Id: <1503138855-585-2-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used in a copy operation.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/i2c/busses/i2c-kempld.c          | 2 +-
 drivers/i2c/busses/i2c-ocores.c          | 2 +-
 drivers/i2c/busses/i2c-octeon-platdrv.c  | 2 +-
 drivers/i2c/busses/i2c-thunderx-pcidrv.c | 2 +-
 drivers/i2c/busses/i2c-xiic.c            | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-kempld.c b/drivers/i2c/busses/i2c-kempld.c
index 25993d2..e879190 100644
--- a/drivers/i2c/busses/i2c-kempld.c
+++ b/drivers/i2c/busses/i2c-kempld.c
@@ -289,7 +289,7 @@ static u32 kempld_i2c_func(struct i2c_adapter *adap)
 	.functionality	= kempld_i2c_func,
 };
 
-static struct i2c_adapter kempld_i2c_adapter = {
+static const struct i2c_adapter kempld_i2c_adapter = {
 	.owner		= THIS_MODULE,
 	.name		= "i2c-kempld",
 	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 34f1889..8c42ca7 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -276,7 +276,7 @@ static u32 ocores_func(struct i2c_adapter *adap)
 	.functionality = ocores_func,
 };
 
-static struct i2c_adapter ocores_adapter = {
+static const struct i2c_adapter ocores_adapter = {
 	.owner = THIS_MODULE,
 	.name = "i2c-ocores",
 	.class = I2C_CLASS_DEPRECATED,
diff --git a/drivers/i2c/busses/i2c-octeon-platdrv.c b/drivers/i2c/busses/i2c-octeon-platdrv.c
index 917524c..64bda83 100644
--- a/drivers/i2c/busses/i2c-octeon-platdrv.c
+++ b/drivers/i2c/busses/i2c-octeon-platdrv.c
@@ -126,7 +126,7 @@ static u32 octeon_i2c_functionality(struct i2c_adapter *adap)
 	.functionality = octeon_i2c_functionality,
 };
 
-static struct i2c_adapter octeon_i2c_ops = {
+static const struct i2c_adapter octeon_i2c_ops = {
 	.owner = THIS_MODULE,
 	.name = "OCTEON adapter",
 	.algo = &octeon_i2c_algo,
diff --git a/drivers/i2c/busses/i2c-thunderx-pcidrv.c b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
index ea35a895..df0976f 100644
--- a/drivers/i2c/busses/i2c-thunderx-pcidrv.c
+++ b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
@@ -75,7 +75,7 @@ static u32 thunderx_i2c_functionality(struct i2c_adapter *adap)
 	.functionality = thunderx_i2c_functionality,
 };
 
-static struct i2c_adapter thunderx_i2c_ops = {
+static const struct i2c_adapter thunderx_i2c_ops = {
 	.owner	= THIS_MODULE,
 	.name	= "ThunderX adapter",
 	.algo	= &thunderx_i2c_algo,
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 34b27bf..ae6ed25 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -721,7 +721,7 @@ static u32 xiic_func(struct i2c_adapter *adap)
 	.functionality = xiic_func,
 };
 
-static struct i2c_adapter xiic_adapter = {
+static const struct i2c_adapter xiic_adapter = {
 	.owner = THIS_MODULE,
 	.name = DRIVER_NAME,
 	.class = I2C_CLASS_DEPRECATED,
-- 
1.9.1
