Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:41898 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab3E0Cdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 22:33:41 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lizefan@huawei.com>, <libo.chen@huawei.com>,
	<gregkh@linuxfoundation.org>
Subject: [PATCH 18/24] drivers/media/pci/mantis/hopper_cards: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:46 +0800
Message-ID: <1369621906-21268-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/media/pci/mantis/hopper_cards.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/mantis/hopper_cards.c b/drivers/media/pci/mantis/hopper_cards.c
index 6fe9fe5..104914a 100644
--- a/drivers/media/pci/mantis/hopper_cards.c
+++ b/drivers/media/pci/mantis/hopper_cards.c
@@ -260,18 +260,7 @@ static struct pci_driver hopper_pci_driver = {
 	.remove		= hopper_pci_remove,
 };
 
-static int hopper_init(void)
-{
-	return pci_register_driver(&hopper_pci_driver);
-}
-
-static void hopper_exit(void)
-{
-	return pci_unregister_driver(&hopper_pci_driver);
-}
-
-module_init(hopper_init);
-module_exit(hopper_exit);
+module_pci_driver(hopper_pci_driver);
 
 MODULE_DESCRIPTION("HOPPER driver");
 MODULE_AUTHOR("Manu Abraham");
-- 
1.7.1


