Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37695 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933333AbdKAVGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2 15/26] media: pt1: fix logic when pt1_nr_tables is zero or negative
Date: Wed,  1 Nov 2017 17:05:52 -0400
Message-Id: <0fb02c4a7a0f7d98a5c97a8f1fe125445e1a6b2c.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pt1_nr_tables is a modprobe parameter. The way the logic
handles it, it can't be negative. However, user can
set it to zero.

If set to zero, however, it will cause troubles at
pt1_init_tables(), as reported by smatch:
	drivers/media/pci/pt1/pt1.c:468 pt1_init_tables() error: uninitialized symbol 'first_pfn'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/pt1/pt1.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index b6b1a8d20d86..acc3afeb6224 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -116,8 +116,8 @@ static u32 pt1_read_reg(struct pt1 *pt1, int reg)
 	return readl(pt1->regs + reg * 4);
 }
 
-static int pt1_nr_tables = 8;
-module_param_named(nr_tables, pt1_nr_tables, int, 0);
+static unsigned int pt1_nr_tables = 8;
+module_param_named(nr_tables, pt1_nr_tables, uint, 0);
 
 static void pt1_increment_table_count(struct pt1 *pt1)
 {
@@ -443,6 +443,9 @@ static int pt1_init_tables(struct pt1 *pt1)
 	int i, ret;
 	u32 first_pfn, pfn;
 
+	if (!pt1_nr_tables)
+		return 0;
+
 	tables = vmalloc(sizeof(struct pt1_table) * pt1_nr_tables);
 	if (tables == NULL)
 		return -ENOMEM;
@@ -450,12 +453,10 @@ static int pt1_init_tables(struct pt1 *pt1)
 	pt1_init_table_count(pt1);
 
 	i = 0;
-	if (pt1_nr_tables) {
-		ret = pt1_init_table(pt1, &tables[0], &first_pfn);
-		if (ret)
-			goto err;
-		i++;
-	}
+	ret = pt1_init_table(pt1, &tables[0], &first_pfn);
+	if (ret)
+		goto err;
+	i++;
 
 	while (i < pt1_nr_tables) {
 		ret = pt1_init_table(pt1, &tables[i], &pfn);
-- 
2.13.6
