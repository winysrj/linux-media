Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33513 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752613AbdHBRPS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 13:15:18 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] [media] drv-intf: saa7146: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:44:49 +0530
Message-Id: <1501694097-16207-2-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501694097-16207-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501694097-16207-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.
So making 'pci_tbl' as const member of 'struct saa7146_extension'.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 include/media/drv-intf/saa7146.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/drv-intf/saa7146.h b/include/media/drv-intf/saa7146.h
index 96058a5..4529432 100644
--- a/include/media/drv-intf/saa7146.h
+++ b/include/media/drv-intf/saa7146.h
@@ -96,7 +96,7 @@ struct saa7146_extension
 	   supported devices, last entry 0xffff, 0xfff */
 	struct module *module;
 	struct pci_driver driver;
-	struct pci_device_id *pci_tbl;
+	const struct pci_device_id *pci_tbl;
 
 	/* extension functions */
 	int (*probe)(struct saa7146_dev *);
-- 
2.7.4
