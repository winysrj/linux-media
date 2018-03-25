Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52971 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752115AbeCYLAF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 07:00:05 -0400
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] PCI: Add pci_peer_traffic_supported()
Date: Sun, 25 Mar 2018 12:59:55 +0200
Message-Id: <20180325110000.2238-3-christian.koenig@amd.com>
In-Reply-To: <20180325110000.2238-1-christian.koenig@amd.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "wdavis@nvidia.com" <wdavis@nvidia.com>

Add checks for topology and ACS configuration to determine whether or not
peer traffic should be supported between two PCI devices.

Signed-off-by: Will Davis <wdavis@nvidia.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/pci/pci.c   | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |   1 +
 2 files changed, 113 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f6a4dd10d9b0..efdca3c9dad1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -28,6 +28,7 @@
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
 #include <linux/pci_hotplug.h>
+#include <linux/iommu.h>
 #include <linux/vmalloc.h>
 #include <linux/pci-ats.h>
 #include <asm/setup.h>
@@ -5285,6 +5286,117 @@ void pci_ignore_hotplug(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_ignore_hotplug);
 
+static bool pci_peer_host_traffic_supported(struct pci_host_bridge *host)
+{
+	struct pci_dev *bridge = pci_get_slot(host->bus, PCI_DEVFN(0, 0));
+	unsigned short vendor, device;
+
+	if (!bridge)
+		return false;
+
+	vendor = bridge->vendor;
+	device = bridge->device;
+	pci_dev_put(bridge);
+
+	/* AMD ZEN host bridges can do peer to peer */
+	if (vendor == PCI_VENDOR_ID_AMD && device == 0x1450)
+		return true;
+
+	/* TODO: Extend that to a proper whitelist */
+	return false;
+}
+
+bool pci_peer_traffic_supported(struct pci_dev *dev, struct pci_dev *peer)
+{
+	struct pci_dev *rp_dev, *rp_peer, *common_upstream;
+	struct pci_host_bridge *peer_host_bridge;
+	struct pci_host_bridge *dev_host_bridge;
+	int pos;
+	u16 cap;
+
+	/* This is tricky enough, focus on PCIe for now */
+	if (!pci_is_pcie(dev) || !pci_is_pcie(peer))
+		return false;
+
+	/*
+	 * Disallow the peer-to-peer traffic if the devices do not share a
+	 * host bridge. The PCI specifications does not make any guarantees
+	 * about P2P capabilities between devices under separate domains.
+	 *
+	 * PCI Local Bus Specification Revision 3.0, section 3.10:
+	 *    "Peer-to-peer transactions crossing multiple host bridges
+	 *     PCI host bridges may, but are not required to, support PCI
+	 *     peer-to-peer transactions that traverse multiple PCI host
+	 *     bridges."
+	 */
+	dev_host_bridge = pci_find_host_bridge(dev->bus);
+	peer_host_bridge = pci_find_host_bridge(peer->bus);
+	if (dev_host_bridge != peer_host_bridge)
+		return pci_peer_host_traffic_supported(dev_host_bridge);
+
+	rp_dev = pcie_find_root_port(dev);
+	rp_peer = pcie_find_root_port(peer);
+	common_upstream = pci_find_common_upstream_dev(dev, peer);
+
+	/*
+	 * Access Control Services (ACS) Checks
+	 *
+	 * ACS has a capability bit for P2P Request Redirects (RR),
+	 * but unfortunately it doesn't tell us much about the real
+	 * capabilities of the hardware.
+	 *
+	 * PCI Express Base Specification Revision 3.0, section
+	 * 6.12.1.1:
+	 *    "ACS P2P Request Redirect: must be implemented by Root
+	 *     Ports that support peer-to-peer traffic with other
+	 *     Root Ports; [80]"
+	 * but
+	 *    "[80] Root Port indication of ACS P2P Request Redirect
+	 *     or ACS P2P Completion Redirect support does not imply
+	 *     any particular level of peer-to-peer support by the
+	 *     Root Complex, or that peer-to-peer traffic is
+	 *     supported at all"
+	 */
+
+	/*
+	 * If ACS is not implemented, we have no idea about P2P
+	 * support. Optimistically allow this if there is a common
+	 * upstream device.
+	 */
+	pos = pci_find_ext_capability(rp_dev, PCI_EXT_CAP_ID_ACS);
+	if (!pos)
+		return common_upstream != NULL;
+
+	/*
+	 * If the devices are under the same root port and have a common
+	 * upstream device, allow if the root port is further upstream
+	 * from the common upstream device and the common upstream
+	 * device has Upstream Forwarding disabled, or if the root port
+	 * is the common upstream device and ACS is not implemented.
+	 */
+	pci_read_config_word(rp_dev, pos + PCI_ACS_CAP, &cap);
+	if ((rp_dev == rp_peer && common_upstream) &&
+	    (((common_upstream != rp_dev) &&
+	      !pci_acs_enabled(common_upstream, PCI_ACS_UF)) ||
+	     ((common_upstream == rp_dev) && ((cap & PCI_ACS_RR) == 0))))
+		return true;
+
+	/*
+	 * If ACS RR is implemented and disabled, allow only if the
+	 * devices are under the same root port.
+	 */
+	if (cap & PCI_ACS_RR && !pci_acs_enabled(rp_dev, PCI_ACS_RR))
+		return rp_dev == rp_peer;
+
+	/*
+	 * If ACS RR is not implemented, or is implemented and enabled,
+	 * only allow if there's a translation agent enabled to do the
+	 * redirect.
+	 */
+	return iommu_present(&pci_bus_type);
+}
+EXPORT_SYMBOL(pci_peer_traffic_supported);
+
 resource_size_t __weak pcibios_default_alignment(void)
 {
 	return 0;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0d29f5cdcb04..3c8eaa505991 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -921,6 +921,7 @@ void pci_remove_root_bus(struct pci_bus *bus);
 void pci_setup_cardbus(struct pci_bus *bus);
 void pcibios_setup_bridge(struct pci_bus *bus, unsigned long type);
 void pci_sort_breadthfirst(void);
+bool pci_peer_traffic_supported(struct pci_dev *dev, struct pci_dev *peer);
 #define dev_is_pci(d) ((d)->bus == &pci_bus_type)
 #define dev_is_pf(d) ((dev_is_pci(d) ? to_pci_dev(d)->is_physfn : false))
 
-- 
2.14.1
