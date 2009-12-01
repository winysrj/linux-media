Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:44548 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZLARTF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 12:19:05 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com
Cc: davinci-linux-open-source@linux.davincidsp.com, hvaibhav@ti.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v0 2/2] DaVinci - vpfe capture - Make clocks configurable
Date: Tue,  1 Dec 2009 12:19:00 -0500
Message-Id: <1259687940-31435-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Adding the clocks in vpfe capture configuration

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c  |    2 ++
 arch/arm/mach-davinci/board-dm644x-evm.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index a9b650d..a28985c 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -239,6 +239,8 @@ static struct vpfe_config vpfe_cfg = {
 	.sub_devs = vpfe_sub_devs,
 	.card_name = "DM355 EVM",
 	.ccdc = "DM355 CCDC",
+	.num_clocks = 2,
+	.clocks = {"vpss_master", "vpss_slave"},
 };
 
 static struct platform_device *davinci_evm_devices[] __initdata = {
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index fd0398b..45beb99 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -250,6 +250,8 @@ static struct vpfe_config vpfe_cfg = {
 	.sub_devs = vpfe_sub_devs,
 	.card_name = "DM6446 EVM",
 	.ccdc = "DM6446 CCDC",
+	.num_clocks = 2,
+	.clocks = {"vpss_master", "vpss_slave"},
 };
 
 static struct platform_device rtc_dev = {
-- 
1.6.0.4

