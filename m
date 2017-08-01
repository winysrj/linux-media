Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35838 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752161AbdHAR6D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:58:03 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: corbet@lwn.net, mchehab@kernel.org, awalls@md.metrocast.net,
        hverkuil@xs4all.nl, serjk@netup.ru, aospan@netup.ru,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] [media] pt1: constify pci_device_id.
Date: Tue,  1 Aug 2017 23:26:30 +0530
Message-Id: <1501610194-8231-15-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/pt1/pt1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 3219d2f..b6b1a8d 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1202,7 +1202,7 @@ static int pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 }
 
-static struct pci_device_id pt1_id_table[] = {
+static const struct pci_device_id pt1_id_table[] = {
 	{ PCI_DEVICE(0x10ee, 0x211a) },
 	{ PCI_DEVICE(0x10ee, 0x222a) },
 	{ },
-- 
2.7.4
