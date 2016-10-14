Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59066 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756480AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 12/57] [media] ddbridge: don't break long lines
Date: Fri, 14 Oct 2016 17:20:00 -0300
Message-Id: <57193cad7b0a246d769536e14525c077fde55312.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 18e3a4deee64..a6c9fe235974 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -824,8 +824,7 @@ static int dvb_input_attach(struct ddb_input *input)
 				   &input->port->dev->pdev->dev,
 				   adapter_nr);
 	if (ret < 0) {
-		printk(KERN_ERR "ddbridge: Could not register adapter."
-		       "Check if you enabled enough adapters in dvb-core!\n");
+		printk(KERN_ERR "ddbridge: Could not register adapter.Check if you enabled enough adapters in dvb-core!\n");
 		return ret;
 	}
 	input->attached = 1;
@@ -1730,8 +1729,7 @@ static __init int module_init_ddbridge(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Digital Devices PCIE bridge driver, "
-	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
+	printk(KERN_INFO "Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH\n");
 
 	ret = ddb_class_create();
 	if (ret < 0)
-- 
2.7.4


