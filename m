Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45776 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760149AbZJMPJg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 11:09:36 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9DF8vMF019051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 10:08:59 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 3/6] Davinci VPFE Capture: Take i2c adapter id through platform data
Date: Tue, 13 Oct 2009 20:38:54 +0530
Message-Id: <1255446534-16770-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

The I2C adapter ID is actually depends on Board and may vary, Davinci
uses id=1, but in case of AM3517 id=3.

So modified respective davinci board files.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c  |    1 +
 arch/arm/mach-davinci/board-dm644x-evm.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index f683559..4a9252a 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -372,6 +372,7 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
 
 static struct vpfe_config vpfe_cfg = {
 	.num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
+	.i2c_adapter_id = 1,
 	.sub_devs = vpfe_sub_devs,
 	.card_name = "DM355 EVM",
 	.ccdc = "DM355 CCDC",
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index cfd9afa..fed64e2 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -257,6 +257,7 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
 
 static struct vpfe_config vpfe_cfg = {
 	.num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
+	.i2c_adapter_id = 1,
 	.sub_devs = vpfe_sub_devs,
 	.card_name = "DM6446 EVM",
 	.ccdc = "DM6446 CCDC",
-- 
1.6.2.4

