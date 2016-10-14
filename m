Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59251 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757077AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 13/57] [media] dm1105: don't break long lines
Date: Fri, 14 Oct 2016 17:20:01 -0300
Message-Id: <3e6fd01ab1c2133dc0347be5b6b0f920d41971d5.1476475771.git.mchehab@s-opensource.com>
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
 drivers/media/pci/dm1105/dm1105.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 5dd504741b12..a589aa78d1d9 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -315,8 +315,7 @@ static void dm1105_card_list(struct pci_dev *pci)
 			"dm1105: Updating to the latest version might help\n"
 			"dm1105: as well.\n");
 	}
-	printk(KERN_ERR "Here is a list of valid choices for the card=<n> "
-		   "insmod option:\n");
+	printk(KERN_ERR "Here is a list of valid choices for the card=<n> insmod option:\n");
 	for (i = 0; i < ARRAY_SIZE(dm1105_boards); i++)
 		printk(KERN_ERR "dm1105:    card=%d -> %s\n",
 				i, dm1105_boards[i].name);
-- 
2.7.4


