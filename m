Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49249 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757151AbbEVOAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:00:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/11] cobalt: fix sparse warnings
Date: Fri, 22 May 2015 15:59:38 +0200
Message-Id: <1432303184-8594-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cobalt/cobalt-flash.c:39:36: warning: incorrect type in initializer (different address spaces)
drivers/media/pci/cobalt/cobalt-flash.c:54:36: warning: incorrect type in initializer (different address spaces)
drivers/media/pci/cobalt/cobalt-flash.c:63:36: warning: incorrect type in initializer (different address spaces)
drivers/media/pci/cobalt/cobalt-flash.c:82:36: warning: incorrect type in initializer (different address spaces)
drivers/media/pci/cobalt/cobalt-flash.c:107:19: warning: incorrect type in assignment (different address spaces)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-cpld.c   |  4 ++--
 drivers/media/pci/cobalt/cobalt-driver.c |  4 ++--
 drivers/media/pci/cobalt/cobalt-driver.h | 12 ++++++------
 drivers/media/pci/cobalt/cobalt-flash.c  | 16 ++++++----------
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-cpld.c b/drivers/media/pci/cobalt/cobalt-cpld.c
index 77ed9e5..05df458 100644
--- a/drivers/media/pci/cobalt/cobalt-cpld.c
+++ b/drivers/media/pci/cobalt/cobalt-cpld.c
@@ -26,12 +26,12 @@
 
 static u16 cpld_read(struct cobalt *cobalt, u32 offset)
 {
-	return cobalt_bus_read32(cobalt, ADRS(offset));
+	return cobalt_bus_read32(cobalt->bar1, ADRS(offset));
 }
 
 static void cpld_write(struct cobalt *cobalt, u32 offset, u16 val)
 {
-	return cobalt_bus_write32(cobalt, ADRS(offset), val);
+	return cobalt_bus_write32(cobalt->bar1, ADRS(offset), val);
 }
 
 static void cpld_info_ver3(struct cobalt *cobalt)
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 0534d71..c2974e6 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -296,11 +296,11 @@ static void cobalt_pci_iounmap(struct cobalt *cobalt, struct pci_dev *pci_dev)
 {
 	if (cobalt->bar0) {
 		pci_iounmap(pci_dev, cobalt->bar0);
-		cobalt->bar0 = 0;
+		cobalt->bar0 = NULL;
 	}
 	if (cobalt->bar1) {
 		pci_iounmap(pci_dev, cobalt->bar1);
-		cobalt->bar1 = 0;
+		cobalt->bar1 = NULL;
 	}
 }
 
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index bb062ff..3d9a9ffb 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -342,17 +342,17 @@ static inline u32 cobalt_g_sysstat(struct cobalt *cobalt)
 	return cobalt_read_bar1(cobalt, COBALT_SYS_STAT_BASE);
 }
 
-#define ADRS_REG (cobalt->bar1 + COBALT_BUS_BAR1_BASE + 0)
-#define LOWER_DATA (cobalt->bar1 + COBALT_BUS_BAR1_BASE + 4)
-#define UPPER_DATA (cobalt->bar1 + COBALT_BUS_BAR1_BASE + 6)
+#define ADRS_REG (bar1 + COBALT_BUS_BAR1_BASE + 0)
+#define LOWER_DATA (bar1 + COBALT_BUS_BAR1_BASE + 4)
+#define UPPER_DATA (bar1 + COBALT_BUS_BAR1_BASE + 6)
 
-static inline u32 cobalt_bus_read32(struct cobalt *cobalt, u32 bus_adrs)
+static inline u32 cobalt_bus_read32(void __iomem *bar1, u32 bus_adrs)
 {
 	iowrite32(bus_adrs, ADRS_REG);
 	return ioread32(LOWER_DATA);
 }
 
-static inline void cobalt_bus_write16(struct cobalt *cobalt,
+static inline void cobalt_bus_write16(void __iomem *bar1,
 				      u32 bus_adrs, u16 data)
 {
 	iowrite32(bus_adrs, ADRS_REG);
@@ -362,7 +362,7 @@ static inline void cobalt_bus_write16(struct cobalt *cobalt,
 		iowrite16(data, LOWER_DATA);
 }
 
-static inline void cobalt_bus_write32(struct cobalt *cobalt,
+static inline void cobalt_bus_write32(void __iomem *bar1,
 				      u32 bus_adrs, u16 data)
 {
 	iowrite32(bus_adrs, ADRS_REG);
diff --git a/drivers/media/pci/cobalt/cobalt-flash.c b/drivers/media/pci/cobalt/cobalt-flash.c
index 129f48f..89fd667 100644
--- a/drivers/media/pci/cobalt/cobalt-flash.c
+++ b/drivers/media/pci/cobalt/cobalt-flash.c
@@ -36,10 +36,9 @@ static struct map_info cobalt_flash_map = {
 
 static map_word flash_read16(struct map_info *map, unsigned long offset)
 {
-	struct cobalt *cobalt = map->virt;
 	map_word r;
 
-	r.x[0] = cobalt_bus_read32(cobalt, ADRS(offset));
+	r.x[0] = cobalt_bus_read32(map->virt, ADRS(offset));
 	if (offset & 0x2)
 		r.x[0] >>= 16;
 	else
@@ -51,22 +50,20 @@ static map_word flash_read16(struct map_info *map, unsigned long offset)
 static void flash_write16(struct map_info *map, const map_word datum,
 			  unsigned long offset)
 {
-	struct cobalt *cobalt = map->virt;
 	u16 data = (u16)datum.x[0];
 
-	cobalt_bus_write16(cobalt, ADRS(offset), data);
+	cobalt_bus_write16(map->virt, ADRS(offset), data);
 }
 
 static void flash_copy_from(struct map_info *map, void *to,
 			    unsigned long from, ssize_t len)
 {
-	struct cobalt *cobalt = map->virt;
 	u32 src = from;
 	u8 *dest = to;
 	u32 data;
 
 	while (len) {
-		data = cobalt_bus_read32(cobalt, ADRS(src));
+		data = cobalt_bus_read32(map->virt, ADRS(src));
 		do {
 			*dest = data >> (8 * (src & 3));
 			src++;
@@ -79,11 +76,10 @@ static void flash_copy_from(struct map_info *map, void *to,
 static void flash_copy_to(struct map_info *map, unsigned long to,
 			  const void *from, ssize_t len)
 {
-	struct cobalt *cobalt = map->virt;
 	const u8 *src = from;
 	u32 dest = to;
 
-	cobalt_info("%s: offset 0x%x: length %zu\n", __func__, dest, len);
+	pr_info("%s: offset 0x%x: length %zu\n", __func__, dest, len);
 	while (len) {
 		u16 data = 0xffff;
 
@@ -94,7 +90,7 @@ static void flash_copy_to(struct map_info *map, unsigned long to,
 			len--;
 		} while (len && (dest % 2));
 
-		cobalt_bus_write16(cobalt, ADRS(dest - 2), data);
+		cobalt_bus_write16(map->virt, ADRS(dest - 2), data);
 	}
 }
 
@@ -104,7 +100,7 @@ int cobalt_flash_probe(struct cobalt *cobalt)
 	struct mtd_info *mtd;
 
 	BUG_ON(!map_bankwidth_supported(map->bankwidth));
-	map->virt = cobalt;
+	map->virt = cobalt->bar1;
 	map->read = flash_read16;
 	map->write = flash_write16;
 	map->copy_from = flash_copy_from;
-- 
2.1.4

