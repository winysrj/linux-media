Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:48797 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752062AbdK2SNz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 13:13:55 -0500
Subject: [PATCH v3 2/4] mm: fail get_vaddr_frames() for filesystem-dax
 mappings
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Jan Kara <jack@suse.cz>, Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-nvdimm@lists.01.org, Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, hch@lst.de,
        Vlastimil Babka <vbabka@suse.cz>, linux-media@vger.kernel.org
Date: Wed, 29 Nov 2017 10:05:40 -0800
Message-ID: <151197874035.26211.4061781453123083667.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Until there is a solution to the dma-to-dax vs truncate problem it is
not safe to allow V4L2, Exynos, and other frame vector users to create
long standing / irrevocable memory registrations against filesytem-dax
vmas.

Cc: Inki Dae <inki.dae@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/frame_vector.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index 2f98df0d460e..297c7238f7d4 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -53,6 +53,18 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		ret = -EFAULT;
 		goto out;
 	}
+
+	/*
+	 * While get_vaddr_frames() could be used for transient (kernel
+	 * controlled lifetime) pinning of memory pages all current
+	 * users establish long term (userspace controlled lifetime)
+	 * page pinning. Treat get_vaddr_frames() like
+	 * get_user_pages_longterm() and disallow it for filesystem-dax
+	 * mappings.
+	 */
+	if (vma_is_fsdax(vma))
+		return -EOPNOTSUPP;
+
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
 		vec->got_ref = true;
 		vec->is_pfns = false;
