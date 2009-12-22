Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47156 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751933AbZLVIiS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 03:38:18 -0500
From: peterhuewe@gmx.de
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] media/dvb: add __init/__exit macros to drivers/media/dvb/bt8xx/bt878.c
Date: Tue, 22 Dec 2009 09:38:14 +0100
Message-Id: <1261471095-24272-1-git-send-email-peterhuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

drivers/media/dvb/bt8xx/bt878.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial
tree.

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/media/dvb/bt8xx/bt878.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/bt878.c b/drivers/media/dvb/bt8xx/bt878.c
index a24c125..2a0886a 100644
--- a/drivers/media/dvb/bt8xx/bt878.c
+++ b/drivers/media/dvb/bt8xx/bt878.c
@@ -582,7 +582,7 @@ static int bt878_pci_driver_registered;
 /* Module management functions */
 /*******************************/
 
-static int bt878_init_module(void)
+static int __init bt878_init_module(void)
 {
 	bt878_num = 0;
 	bt878_pci_driver_registered = 0;
@@ -600,7 +600,7 @@ static int bt878_init_module(void)
 	return pci_register_driver(&bt878_pci_driver);
 }
 
-static void bt878_cleanup_module(void)
+static void __exit bt878_cleanup_module(void)
 {
 	if (bt878_pci_driver_registered) {
 		bt878_pci_driver_registered = 0;
-- 
1.6.4.4

