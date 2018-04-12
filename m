Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56569 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753413AbeDLPY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Georgiana Chelu <georgiana.chelu93@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Aishwarya Pant <aishpant@gmail.com>,
        Muhammad Falak R Wani <falakreyaz@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Srishti Sharma <srishtishar@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 14/17] media: atomisp: get rid of a warning
Date: Thu, 12 Apr 2018 11:24:06 -0400
Message-Id: <643710ab5b482f68908fdf90bb6f20c534ec1b5f.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On smatch, this warning is trigged:

	drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c:324 __bo_take_off_handling() error: we previously assumed 'bo->prev' could be null (see line 314)

Because it can't properly analize the truth table for the above
function. So, add an explicit check for the final condition there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index c888f9c809f9..a6620d2c9f50 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -319,7 +319,7 @@ static void __bo_take_off_handling(struct hmm_buffer_object *bo)
 	 *	to take off this bo, we just set take the "prev/next" pointers
 	 *	to NULL, the free rbtree stays unchaged
 	 */
-	} else {
+	} else if (bo->prev != NULL && bo->next != NULL) {
 		bo->next->prev = bo->prev;
 		bo->prev->next = bo->next;
 		bo->next = NULL;
-- 
2.14.3
