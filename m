Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36177 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbdHBRPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 13:15:23 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] [media] ttpci: budget-patch: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:44:51 +0530
Message-Id: <1501694097-16207-4-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501694097-16207-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501694097-16207-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <media/drv-intf/saa7146.h>
and <linux/pci.h> work with const pci_device_id. So mark the non-const
structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/ttpci/budget-patch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ttpci/budget-patch.c b/drivers/media/pci/ttpci/budget-patch.c
index 4429923..a738018 100644
--- a/drivers/media/pci/ttpci/budget-patch.c
+++ b/drivers/media/pci/ttpci/budget-patch.c
@@ -45,7 +45,7 @@ static struct saa7146_extension budget_extension;
 MAKE_BUDGET_INFO(ttbp, "TT-Budget/Patch DVB-S 1.x PCI", BUDGET_PATCH);
 //MAKE_BUDGET_INFO(satel,"TT-Budget/Patch SATELCO PCI", BUDGET_TT_HW_DISEQC);
 
-static struct pci_device_id pci_tbl[] = {
+static const struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(ttbp,0x13c2, 0x0000),
 //        MAKE_EXTENSION_PCI(satel, 0x13c2, 0x1013),
 	{
-- 
2.7.4
