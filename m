Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36817 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbdHBRP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 13:15:28 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] [media] ttpci: budget-av: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:44:53 +0530
Message-Id: <1501694097-16207-6-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/media/pci/ttpci/budget-av.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index dc7be8f..ac83fff 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -1567,7 +1567,7 @@ MAKE_BUDGET_INFO(cin1200c, "Terratec Cinergy 1200 DVB-C", BUDGET_CIN1200C);
 MAKE_BUDGET_INFO(cin1200cmk3, "Terratec Cinergy 1200 DVB-C MK3", BUDGET_CIN1200C_MK3);
 MAKE_BUDGET_INFO(cin1200t, "Terratec Cinergy 1200 DVB-T", BUDGET_CIN1200T);
 
-static struct pci_device_id pci_tbl[] = {
+static const struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(knc1s, 0x1131, 0x4f56),
 	MAKE_EXTENSION_PCI(knc1s, 0x1131, 0x0010),
 	MAKE_EXTENSION_PCI(knc1s, 0x1894, 0x0010),
-- 
2.7.4
