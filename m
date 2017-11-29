Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27463 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753050AbdK2SOB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 13:14:01 -0500
Subject: [PATCH v3 3/4] [media] v4l2: disable filesystem-dax mapping support
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        hch@lst.de, linux-media@vger.kernel.org
Date: Wed, 29 Nov 2017 10:05:46 -0800
Message-ID: <151197874598.26211.6120423884702550000.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 memory registrations are incompatible with filesystem-dax that
needs the ability to revoke dma access to a mapping at will, or
otherwise allow the kernel to wait for completion of DMA. The
filesystem-dax implementation breaks the traditional solution of
truncate of active file backed mappings since there is no page-cache
page we can orphan to sustain ongoing DMA.

If v4l2 wants to support long lived DMA mappings it needs to arrange to
hold a file lease or use some other mechanism so that the kernel can
coordinate revoking DMA access when the filesystem needs to truncate
mappings.

Reported-by: Jan Kara <jack@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: <stable@vger.kernel.org>
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 0b5c43f7e020..f412429cf5ba 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -185,12 +185,13 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
 		data, size, dma->nr_pages);
 
-	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
+	err = get_user_pages_longterm(data & PAGE_MASK, dma->nr_pages,
 			     flags, dma->pages, NULL);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;
-		dprintk(1, "get_user_pages: err=%d [%d]\n", err, dma->nr_pages);
+		dprintk(1, "get_user_pages_longterm: err=%d [%d]\n", err,
+			dma->nr_pages);
 		return err < 0 ? err : -EINVAL;
 	}
 	return 0;
