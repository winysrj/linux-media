Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752294AbeBECbG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 21:31:06 -0500
From: Masami Hiramatsu <mhiramat@kernel.org>
To: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: mhiramat@kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        orito.takao@socionext.com
Subject: [PATCH] [BUGFIX] media: vb2: Fix videobuf2 to map correct area
Date: Mon,  5 Feb 2018 11:30:41 +0900
Message-Id: <151779784111.20697.5012233804870630070.stgit@devbox>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes vb2_vmalloc_get_userptr() to ioremap correct area.
Since the current code does ioremap the page address, if the offset > 0,
it does not do ioremap the last page and results in kernel panic.

This fixes to pass the page address + offset to ioremap so that ioremap
can map correct area. Also, this uses __pfn_to_phys() to get the physical
address of given PFN.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reported-by: Takao Orito <orito.takao@socionext.com>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 3a7c80cd1a17..896f2f378b40 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -106,7 +106,7 @@ static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
 			if (nums[i-1] + 1 != nums[i])
 				goto fail_map;
 		buf->vaddr = (__force void *)
-				ioremap_nocache(nums[0] << PAGE_SHIFT, size);
+			ioremap_nocache(__pfn_to_phys(nums[0]) + offset, size);
 	} else {
 		buf->vaddr = vm_map_ram(frame_vector_pages(vec), n_pages, -1,
 					PAGE_KERNEL);
