Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34950 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdHAR5h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:57:37 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: corbet@lwn.net, mchehab@kernel.org, awalls@md.metrocast.net,
        hverkuil@xs4all.nl, serjk@netup.ru, aospan@netup.ru,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] [media] dm1105: constify pci_device_id.
Date: Tue,  1 Aug 2017 23:26:22 +0530
Message-Id: <1501610194-8231-7-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/dm1105/dm1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 1d41934..0cd854f 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1208,7 +1208,7 @@ static void dm1105_remove(struct pci_dev *pdev)
 	kfree(dev);
 }
 
-static struct pci_device_id dm1105_id_table[] = {
+static const struct pci_device_id dm1105_id_table[] = {
 	{
 		.vendor = PCI_VENDOR_ID_TRIGEM,
 		.device = PCI_DEVICE_ID_DM1105,
-- 
2.7.4
