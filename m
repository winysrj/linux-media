Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33893 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752206AbdHAR6N (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:58:13 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: corbet@lwn.net, mchehab@kernel.org, awalls@md.metrocast.net,
        hverkuil@xs4all.nl, serjk@netup.ru, aospan@netup.ru,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] [media] cx18: constify pci_device_id.
Date: Tue,  1 Aug 2017 23:26:33 +0530
Message-Id: <1501610194-8231-18-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/cx18/cx18-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 8bce49c..8654710 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -48,7 +48,7 @@ int (*cx18_ext_init)(struct cx18 *);
 EXPORT_SYMBOL(cx18_ext_init);
 
 /* add your revision and whatnot here */
-static struct pci_device_id cx18_pci_tbl[] = {
+static const struct pci_device_id cx18_pci_tbl[] = {
 	{PCI_VENDOR_ID_CX, PCI_DEVICE_ID_CX23418,
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
-- 
2.7.4
