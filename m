Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33029 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932123AbcKPNBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 08:01:06 -0500
From: Geliang Tang <geliangtang@gmail.com>
To: Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] netup_unidvb: use module_pci_driver
Date: Wed, 16 Nov 2016 21:00:56 +0800
Message-Id: <3c6dc0c2b50e9ade60eb484a2e8e4e6234432ec0.1479278622.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use module_pci_driver() helper to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index b078ac2..191bd82 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -1030,15 +1030,4 @@ static struct pci_driver netup_unidvb_pci_driver = {
 	.resume   = NULL,
 };
 
-static int __init netup_unidvb_init(void)
-{
-	return pci_register_driver(&netup_unidvb_pci_driver);
-}
-
-static void __exit netup_unidvb_fini(void)
-{
-	pci_unregister_driver(&netup_unidvb_pci_driver);
-}
-
-module_init(netup_unidvb_init);
-module_exit(netup_unidvb_fini);
+module_pci_driver(netup_unidvb_pci_driver);
-- 
2.9.3

