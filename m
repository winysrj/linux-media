Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38886 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752442AbdHBRPa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 13:15:30 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] [media] ttpci: av7110: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:44:54 +0530
Message-Id: <1501694097-16207-7-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/media/pci/ttpci/av7110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index f2905bd..f46947d 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -2872,7 +2872,7 @@ MAKE_AV7110_INFO(fsc,        "Fujitsu Siemens DVB-C");
 MAKE_AV7110_INFO(fss,        "Fujitsu Siemens DVB-S rev1.6");
 MAKE_AV7110_INFO(gxs_1_3,    "Galaxis DVB-S rev1.3");
 
-static struct pci_device_id pci_tbl[] = {
+static const struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(fsc,         0x110a, 0x0000),
 	MAKE_EXTENSION_PCI(tts_1_X_fsc, 0x13c2, 0x0000),
 	MAKE_EXTENSION_PCI(ttt_1_X,     0x13c2, 0x0001),
-- 
2.7.4
