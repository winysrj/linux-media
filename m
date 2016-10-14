Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757071AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 16/57] [media] pt1: don't break long lines
Date: Fri, 14 Oct 2016 17:20:04 -0300
Message-Id: <059df061f27e313ded63b230bb849e3c792bd226.1476475771.git.mchehab@s-opensource.com>
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
 drivers/media/pci/pt1/pt1.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index e7e4428109c3..aad2acf90177 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -282,13 +282,11 @@ static int pt1_filter(struct pt1 *pt1, struct pt1_buffer_page *page)
 			continue;
 
 		if (upacket >> 24 & 1)
-			printk_ratelimited(KERN_INFO "earth-pt1: device "
-				"buffer overflowing. table[%d] buf[%d]\n",
+			printk_ratelimited(KERN_INFO "earth-pt1: device buffer overflowing. table[%d] buf[%d]\n",
 				pt1->table_index, pt1->buf_index);
 		sc = upacket >> 26 & 0x7;
 		if (adap->st_count != -1 && sc != ((adap->st_count + 1) & 0x7))
-			printk_ratelimited(KERN_INFO "earth-pt1: data loss"
-				" in streamID(adapter)[%d]\n", index);
+			printk_ratelimited(KERN_INFO "earth-pt1: data loss in streamID(adapter)[%d]\n", index);
 		adap->st_count = sc;
 
 		buf = adap->buf;
-- 
2.7.4


