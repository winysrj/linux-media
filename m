Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:36155 "EHLO m50-135.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1045244AbdDWMSo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 08:18:44 -0400
From: Pan Bian <bianpan201602@163.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] [media] cobalt: fix unchecked return values
Date: Sun, 23 Apr 2017 20:18:29 +0800
Message-Id: <1492949909-893-1-git-send-email-bianpan201602@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pan Bian <bianpan2016@163.com>

Function pci_find_ext_capability() may return 0, which is an invalid
address. In function cobalt_pcie_status_show(), its return value is used
without validation. This patch adds checks to validate the return
address.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/media/pci/cobalt/cobalt-driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index d5c911c..f8e173f 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -205,6 +205,8 @@ void cobalt_pcie_status_show(struct cobalt *cobalt)
 
 	offset = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
 	bus_offset = pci_find_capability(pci_bus_dev, PCI_CAP_ID_EXP);
+	if (!offset || !bus_offset)
+		return;
 
 	/* Device */
 	pci_read_config_dword(pci_dev, offset + PCI_EXP_DEVCAP, &capa);
-- 
1.9.1
