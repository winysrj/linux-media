Return-path: <mchehab@gaivota>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44901 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0KFVdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Nov 2010 17:33:43 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michal Marek <mmarek@suse.cz>,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 3/5] Revert "i2c: Fix Kconfig dependencies"
Date: Sat,  6 Nov 2010 17:30:25 -0400
Message-Id: <1289079027-3037-4-git-send-email-lacombar@gmail.com>
In-Reply-To: <4CD300AC.3010708@redhat.com>
References: <4CD300AC.3010708@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This reverts commit 0a57274ea026c2b7670683947b6cc08b195148cf.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 drivers/i2c/Kconfig       |    3 +--
 drivers/i2c/algos/Kconfig |   12 ------------
 2 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index b923074..30f06e9 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -75,8 +75,7 @@ config I2C_HELPER_AUTO
 	  In doubt, say Y.
 
 config I2C_SMBUS
-	tristate
-	prompt "SMBus-specific protocols" if !I2C_HELPER_AUTO
+	tristate "SMBus-specific protocols" if !I2C_HELPER_AUTO
 	help
 	  Say Y here if you want support for SMBus extensions to the I2C
 	  specification. At the moment, the only supported extension is
diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
index 3998dd6..7b2ce4a 100644
--- a/drivers/i2c/algos/Kconfig
+++ b/drivers/i2c/algos/Kconfig
@@ -15,15 +15,3 @@ config I2C_ALGOPCA
 	tristate "I2C PCA 9564 interfaces"
 
 endmenu
-
-# In automatic configuration mode, we still have to define the
-# symbols to avoid unmet dependencies.
-
-if I2C_HELPER_AUTO
-config I2C_ALGOBIT
-	tristate
-config I2C_ALGOPCF
-	tristate
-config I2C_ALGOPCA
-	tristate
-endif
-- 
1.7.2.30.gc37d7.dirty

