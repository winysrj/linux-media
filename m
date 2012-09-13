Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:46821
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab2IMClI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 22:41:08 -0400
From: Bob Liu <lliubbo@gmail.com>
To: <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <bhupesh.sharma@st.com>,
	<laurent.pinchart@ideasonboard.com>,
	<uclinux-dist-devel@blackfin.uclinux.org>,
	<linux-media@vger.kernel.org>, <dhowells@redhat.com>,
	<geert@linux-m68k.org>, <gerg@uclinux.org>, <stable@kernel.org>,
	<gregkh@linuxfoundation.org>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] nommu: remap_pfn_range: fix addr parameter check
Date: Thu, 13 Sep 2012 10:40:57 +0800
Message-ID: <1347504057-5612-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The addr parameter may not page aligned eg. when it's come from
vfb_mmap():vma->vm_start in video driver.

This patch fix the check in remap_pfn_range() else some driver like v4l2 will
fail in this function while calling mmap() on nommu arch like blackfin and st.

Reported-by: Bhupesh SHARMA <bhupesh.sharma@st.com>
Reported-by: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index d4b0c10..5d6068b 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1819,7 +1819,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
-	if (addr != (pfn << PAGE_SHIFT))
+	if ((addr & PAGE_MASK) != (pfn << PAGE_SHIFT))
 		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
-- 
1.7.9.5


