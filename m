Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbdKVFcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 00:32:31 -0500
From: Sinan Kaya <okaya@codeaurora.org>
To: linux-pci@vger.kernel.org, timur@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sinan Kaya <okaya@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Valentin Vidic <Valentin.Vidic@CARNet.hr>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 23/30] [media] atomisp: deprecate pci_get_bus_and_slot()
Date: Wed, 22 Nov 2017 00:31:08 -0500
Message-Id: <1511328675-21981-24-git-send-email-okaya@codeaurora.org>
In-Reply-To: <1511328675-21981-1-git-send-email-okaya@codeaurora.org>
References: <1511328675-21981-1-git-send-email-okaya@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_get_bus_and_slot() is restrictive such that it assumes domain=0 as
where a PCI device is present. This restricts the device drivers to be
reused for other domain numbers.

Use pci_get_domain_bus_and_slot() with a domain number of 0 where we can't
extract the domain number. Other places, use the actual domain number from
the device.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c               | 2 +-
 drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 663aa91..95b9c7a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1233,7 +1233,7 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	isp->pdev = dev;
 	isp->dev = &dev->dev;
 	isp->sw_contex.power_state = ATOM_ISP_POWER_UP;
-	isp->pci_root = pci_get_bus_and_slot(0, 0);
+	isp->pci_root = pci_get_domain_bus_and_slot(0, 0, 0);
 	if (!isp->pci_root) {
 		dev_err(&dev->dev, "Unable to find PCI host\n");
 		return -ENODEV;
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index 4631b1d..51dcef57 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -39,7 +39,7 @@ static inline int platform_is(u8 model)
 
 static int intel_mid_msgbus_init(void)
 {
-	pci_root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+	pci_root = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
 	if (!pci_root) {
 		pr_err("%s: Error: msgbus PCI handle NULL\n", __func__);
 		return -ENODEV;
-- 
1.9.1
