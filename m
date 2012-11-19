Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41670 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab2KSSiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:38:08 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 027/493] media: remove use of __devexit_p in bt878.c
Date: Mon, 19 Nov 2012 13:19:36 -0500
Message-Id: <1353349642-3677-27-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed, remove it.

Also fix the indentation for the initialization of the
bt878_pci_driver struct to make chkpatch happy.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: linux-media@vger.kernel.org 
---
 drivers/media/pci/bt8xx/bt878.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index b34fa95..4225a79 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -570,10 +570,10 @@ static void __devexit bt878_remove(struct pci_dev *pci_dev)
 }
 
 static struct pci_driver bt878_pci_driver = {
-      .name	= "bt878",
-      .id_table = bt878_pci_tbl,
-      .probe	= bt878_probe,
-      .remove	= __devexit_p(bt878_remove),
+	.name	  = "bt878",
+	.id_table = bt878_pci_tbl,
+	.probe	  = bt878_probe,
+	.remove   = bt878_remove,
 };
 
 /*******************************/
-- 
1.8.0

