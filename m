Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37889 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbdHBRPf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 13:15:35 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] [media] saa7146: hexium_orion: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:44:56 +0530
Message-Id: <1501694097-16207-9-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/media/pci/saa7146/hexium_orion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index c306a92..01f0158 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -427,7 +427,7 @@ static struct saa7146_pci_extension_data hexium_orion_4bnc = {
 	.ext = &extension,
 };
 
-static struct pci_device_id pci_tbl[] = {
+static const struct pci_device_id pci_tbl[] = {
 	{
 	 .vendor = PCI_VENDOR_ID_PHILIPS,
 	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
-- 
2.7.4
