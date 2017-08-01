Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34251 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752136AbdHAR54 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:57:56 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: corbet@lwn.net, mchehab@kernel.org, awalls@md.metrocast.net,
        hverkuil@xs4all.nl, serjk@netup.ru, aospan@netup.ru,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] [media] b2c2: constify pci_device_id.
Date: Tue,  1 Aug 2017 23:26:28 +0530
Message-Id: <1501610194-8231-13-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/b2c2/flexcop-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
index 6e60dec..cc6527e 100644
--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -415,7 +415,7 @@ static void flexcop_pci_remove(struct pci_dev *pdev)
 	flexcop_device_kfree(fc_pci->fc_dev);
 }
 
-static struct pci_device_id flexcop_pci_tbl[] = {
+static const struct pci_device_id flexcop_pci_tbl[] = {
 	{ PCI_DEVICE(0x13d0, 0x2103) },
 	{ },
 };
-- 
2.7.4
