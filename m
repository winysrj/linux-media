Return-path: <mchehab@gaivota>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37974 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab0KFVdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Nov 2010 17:33:51 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michal Marek <mmarek@suse.cz>,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 5/5] i2c/algos: convert Kconfig to use the menu's `visible' keyword
Date: Sat,  6 Nov 2010 17:30:27 -0400
Message-Id: <1289079027-3037-6-git-send-email-lacombar@gmail.com>
In-Reply-To: <4CD300AC.3010708@redhat.com>
References: <4CD300AC.3010708@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 drivers/i2c/algos/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
index 7b2ce4a..f1cfe7e 100644
--- a/drivers/i2c/algos/Kconfig
+++ b/drivers/i2c/algos/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "I2C Algorithms"
-	depends on !I2C_HELPER_AUTO
+	visible if !I2C_HELPER_AUTO
 
 config I2C_ALGOBIT
 	tristate "I2C bit-banging interfaces"
-- 
1.7.2.30.gc37d7.dirty

