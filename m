Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36836 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbdHBRPc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 13:15:32 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] [media] saa7146: mxb: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:44:55 +0530
Message-Id: <1501694097-16207-8-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/media/pci/saa7146/mxb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 504d788..930218c 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -819,7 +819,7 @@ static struct saa7146_pci_extension_data mxb = {
 	.ext = &extension,
 };
 
-static struct pci_device_id pci_tbl[] = {
+static const struct pci_device_id pci_tbl[] = {
 	{
 		.vendor    = PCI_VENDOR_ID_PHILIPS,
 		.device	   = PCI_DEVICE_ID_PHILIPS_SAA7146,
-- 
2.7.4
