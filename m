Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:32399 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3E0Cbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 22:31:55 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lizefan@huawei.com>, <libo.chen@huawei.com>,
	<gregkh@linuxfoundation.org>
Subject: [PATCH 16/24] drivers/media/pci/mantis/mantis_cards: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:39 +0800
Message-ID: <1369621899-22700-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

use module_pci_driver instead of init/exit, make code clean

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/media/pci/mantis/mantis_cards.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 932a0d7..801fc55 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -290,18 +290,7 @@ static struct pci_driver mantis_pci_driver = {
 	.remove		= mantis_pci_remove,
 };
 
-static int mantis_init(void)
-{
-	return pci_register_driver(&mantis_pci_driver);
-}
-
-static void mantis_exit(void)
-{
-	return pci_unregister_driver(&mantis_pci_driver);
-}
-
-module_init(mantis_init);
-module_exit(mantis_exit);
+module_pci_driver(mantis_pci_driver);
 
 MODULE_DESCRIPTION("MANTIS driver");
 MODULE_AUTHOR("Manu Abraham");
-- 
1.7.1


