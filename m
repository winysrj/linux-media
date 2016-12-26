Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:58093 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751918AbcLZUvE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Dec 2016 15:51:04 -0500
Subject: [PATCH 5/8] [media] videobuf-dma-sg: Move two assignments for error
 codes in __videobuf_mmap_mapper()
To: linux-media@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jan Kara <jack@suse.cz>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <acfaf0af-0104-1b47-322e-452900318c0a@users.sourceforge.net>
Date: Mon, 26 Dec 2016 21:50:05 +0100
MIME-Version: 1.0
In-Reply-To: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 26 Dec 2016 20:48:50 +0100

Move two assignments for the local variable "retval" so that these statements
will only be executed if a previous action failed in this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 9ccdc11aa016..d09ddf2e56fe 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -596,8 +596,6 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	unsigned int first, last, size = 0, i;
 	int retval;
 
-	retval = -EINVAL;
-
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
@@ -613,16 +611,18 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	if (!size) {
 		dprintk(1, "mmap app bug: offset invalid [offset=0x%lx]\n",
 				(vma->vm_pgoff << PAGE_SHIFT));
+		retval = -EINVAL;
 		goto done;
 	}
 
 	last = first;
 
 	/* create mapping + update buffer list */
-	retval = -ENOMEM;
 	map = kmalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
-	if (!map)
+	if (!map) {
+		retval = -ENOMEM;
 		goto done;
+	}
 
 	size = 0;
 	for (i = first; i <= last; i++) {
-- 
2.11.0

