Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35829 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbeCYLAE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 07:00:04 -0400
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Date: Sun, 25 Mar 2018 12:59:54 +0200
Message-Id: <20180325110000.2238-2-christian.koenig@amd.com>
In-Reply-To: <20180325110000.2238-1-christian.koenig@amd.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "wdavis@nvidia.com" <wdavis@nvidia.com>

Add an interface to find the first device which is upstream of both
devices.

Signed-off-by: Will Davis <wdavis@nvidia.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/pci/search.c | 24 ++++++++++++++++++++++++
 include/linux/pci.h  |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index bc1e023f1353..446648f4238b 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -393,3 +393,27 @@ int pci_dev_present(const struct pci_device_id *ids)
 	return 0;
 }
 EXPORT_SYMBOL(pci_dev_present);
+
+/**
+ * pci_find_common_upstream_dev - Returns the first common upstream device
+ * @dev: the PCI device from which the bus hierarchy walk will start
+ * @other: the PCI device whose bus number will be used for the search
+ *
+ * Walks up the bus hierarchy from the @dev device, looking for the first bus
+ * which the @other device is downstream of. Returns %NULL if the devices do
+ * not share any upstream devices.
+ */
+struct pci_dev *pci_find_common_upstream_dev(struct pci_dev *dev,
+					     struct pci_dev *other)
+{
+	struct pci_dev *pdev = dev;
+
+	while (pdev != NULL) {
+		if ((other->bus->number >= pdev->bus->busn_res.start) &&
+		    (other->bus->number <= pdev->bus->busn_res.end))
+			return pdev;
+		pdev = pci_upstream_bridge(pdev);
+	}
+
+	return NULL;
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 024a1beda008..0d29f5cdcb04 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -956,6 +956,8 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
 }
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 int pci_dev_present(const struct pci_device_id *ids);
+struct pci_dev *pci_find_common_upstream_dev(struct pci_dev *from,
+					     struct pci_dev *to);
 
 int pci_bus_read_config_byte(struct pci_bus *bus, unsigned int devfn,
 			     int where, u8 *val);
-- 
2.14.1
