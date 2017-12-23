Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2766 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752080AbdLWLLz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Dec 2017 06:11:55 -0500
From: Yisheng Xie <xieyisheng1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <ysxie@foxmail.com>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>, <boris.brezillon@free-electrons.com>,
        <richard@nod.at>, <marek.vasut@gmail.com>,
        <cyrille.pitchen@wedev4u.fr>, <linux-mtd@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <wim@iguana.be>,
        <linux@roeck-us.net>, <linux-watchdog@vger.kernel.org>,
        <b.zolnierkie@samsung.com>, <linux-fbdev@vger.kernel.org>,
        <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <ralf@linux-mips.org>, <linux-mips@linux-mips.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <marc.zyngier@arm.com>, <arnd@arndb.de>,
        <andriy.shevchenko@linux.intel.com>,
        <industrypack-devel@lists.sourceforge.net>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <a.zummo@towertech.it>, <alexandre.belloni@free-electrons.com>,
        <linux-rtc@vger.kernel.org>, <daniel.vetter@intel.com>,
        <jani.nikula@linux.intel.com>, <seanpaul@chromium.org>,
        <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>,
        <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <tj@kernel.org>,
        <linux-ide@vger.kernel.org>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <dvhart@infradead.org>, <andy@infradead.org>,
        <platform-driver-x86@vger.kernel.org>,
        <jakub.kicinski@netronome.com>, <davem@davemloft.net>,
        <nios2-dev@lists.rocketboards.org>, <netdev@vger.kernel.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <jslaby@suse.com>,
        Yisheng Xie <xieyisheng1@huawei.com>
Subject: [PATCH v3 27/27] devres: kill devm_ioremap_nocache
Date: Sat, 23 Dec 2017 19:02:59 +0800
Message-ID: <1514026979-33838-1-git-send-email-xieyisheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now, nobody use devm_ioremap_nocache anymore, can it can just be
removed. After this patch the size of devres.o will be reduced from
20304 bytes to 18992 bytes.

Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
---
 Documentation/driver-model/devres.txt   |  1 -
 include/linux/io.h                      |  2 --
 lib/devres.c                            | 29 -----------------------------
 scripts/coccinelle/free/devm_free.cocci |  2 --
 4 files changed, 34 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index c180045..c3fddb5 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -292,7 +292,6 @@ IOMAP
   devm_ioport_map()
   devm_ioport_unmap()
   devm_ioremap()
-  devm_ioremap_nocache()
   devm_ioremap_wc()
   devm_ioremap_resource() : checks resource, requests memory region, ioremaps
   devm_iounmap()
diff --git a/include/linux/io.h b/include/linux/io.h
index 32e30e8..a9c7270 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -75,8 +75,6 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 
 void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			   resource_size_t size);
-void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
-				   resource_size_t size);
 void __iomem *devm_ioremap_wc(struct device *dev, resource_size_t offset,
 				   resource_size_t size);
 void devm_iounmap(struct device *dev, void __iomem *addr);
diff --git a/lib/devres.c b/lib/devres.c
index 5f2aedd..f818fcf 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -44,35 +44,6 @@ void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 EXPORT_SYMBOL(devm_ioremap);
 
 /**
- * devm_ioremap_nocache - Managed ioremap_nocache()
- * @dev: Generic device to remap IO address for
- * @offset: Resource address to map
- * @size: Size of map
- *
- * Managed ioremap_nocache().  Map is automatically unmapped on driver
- * detach.
- */
-void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
-				   resource_size_t size)
-{
-	void __iomem **ptr, *addr;
-
-	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return NULL;
-
-	addr = ioremap_nocache(offset, size);
-	if (addr) {
-		*ptr = addr;
-		devres_add(dev, ptr);
-	} else
-		devres_free(ptr);
-
-	return addr;
-}
-EXPORT_SYMBOL(devm_ioremap_nocache);
-
-/**
  * devm_ioremap_wc - Managed ioremap_wc()
  * @dev: Generic device to remap IO address for
  * @offset: Resource address to map
diff --git a/scripts/coccinelle/free/devm_free.cocci b/scripts/coccinelle/free/devm_free.cocci
index c990d2c..36b8752 100644
--- a/scripts/coccinelle/free/devm_free.cocci
+++ b/scripts/coccinelle/free/devm_free.cocci
@@ -51,8 +51,6 @@ expression x;
 |
  x = devm_ioremap(...)
 |
- x = devm_ioremap_nocache(...)
-|
  x = devm_ioport_map(...)
 )
 
-- 
1.8.3.1
