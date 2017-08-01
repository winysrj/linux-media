Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37687 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdHAR5q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:57:46 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: corbet@lwn.net, mchehab@kernel.org, awalls@md.metrocast.net,
        hverkuil@xs4all.nl, serjk@netup.ru, aospan@netup.ru,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] [media] bt8xx: bttv: constify pci_device_id.
Date: Tue,  1 Aug 2017 23:26:25 +0530
Message-Id: <1501610194-8231-10-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index ed319f1..40110be 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4388,7 +4388,7 @@ static int bttv_resume(struct pci_dev *pci_dev)
 }
 #endif
 
-static struct pci_device_id bttv_pci_tbl[] = {
+static const struct pci_device_id bttv_pci_tbl[] = {
 	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT848), 0},
 	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT849), 0},
 	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT878), 0},
-- 
2.7.4
