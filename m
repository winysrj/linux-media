Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:38624 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbeDQOlN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 10:41:13 -0400
Date: Tue, 17 Apr 2018 20:13:06 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: mchehab@kernel.org, jack@suse.cz, dan.j.williams@intel.com,
        akpm@linux-foundation.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        willy@infradead.org
Subject: [PATCH] media: v4l2-core: Change return type to vm_fault_t
Message-ID: <20180417144305.GA31337@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use new return type vm_fault_t for fault handler. For
now, this is just documenting that the function returns
a VM_FAULT value rather than an errno. Once all instances
are converted, vm_fault_t will become a distinct type.

Reference id -> 1c8f422059ae ("mm: change return type to
vm_fault_t")

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index f412429..54257ea 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -435,7 +435,7 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
  * now ...).  Bounce buffers don't work very well for the data rates
  * video capture has.
  */
-static int videobuf_vm_fault(struct vm_fault *vmf)
+static vm_fault_t videobuf_vm_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
--
1.9.1
