Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39999 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755465AbdKNUEz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Nov 2017 15:04:55 -0500
Subject: [PATCH v2 2/4] mm: fail get_vaddr_frames() for filesystem-dax
 mappings
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Jan Kara <jack@suse.cz>, Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-nvdimm@lists.01.org, Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-media@vger.kernel.org
Date: Tue, 14 Nov 2017 11:56:39 -0800
Message-ID: <151068939985.7446.15684639617389154187.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151068938905.7446.12333914805308312313.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151068938905.7446.12333914805308312313.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/frame_vector.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index 72ebec18629c..d2fdbeaadc8b 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -52,6 +52,10 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		ret = -EFAULT;
 		goto out;
 	}
+
+	if (vma_is_fsdax(vma))
+		return -EOPNOTSUPP;
+
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
 		vec->got_ref = true;
 		vec->is_pfns = false;
