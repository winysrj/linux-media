Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:51497 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbdJSVhk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 17:37:40 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] ARM: defconfig: tegra: Enable Video Decoder driver
Date: Fri, 20 Oct 2017 00:34:25 +0300
Message-Id: <0d1f231d98019ac0a4a58691e0dcd12b38d9db3c.1508448293.git.digetx@gmail.com>
In-Reply-To: <cover.1508448293.git.digetx@gmail.com>
References: <cover.1508448293.git.digetx@gmail.com>
In-Reply-To: <cover.1508448293.git.digetx@gmail.com>
References: <cover.1508448293.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compile Tegra VDE driver as a module.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 arch/arm/configs/tegra_defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 6678f2929356..c931bd48f7fd 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -29,7 +29,6 @@ CONFIG_PCI_MSI=y
 CONFIG_PCI_TEGRA=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
-CONFIG_AEABI=y
 CONFIG_HIGHMEM=y
 CONFIG_CMA=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
@@ -256,6 +255,7 @@ CONFIG_KEYBOARD_NVEC=y
 CONFIG_SERIO_NVEC_PS2=y
 CONFIG_NVEC_POWER=y
 CONFIG_NVEC_PAZ00=y
+CONFIG_TEGRA_VDE=m
 CONFIG_TEGRA_IOMMU_GART=y
 CONFIG_TEGRA_IOMMU_SMMU=y
 CONFIG_ARCH_TEGRA_2x_SOC=y
-- 
2.14.2
