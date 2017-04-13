Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38231 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753332AbdDMWGa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 18:06:30 -0400
From: Logan Gunthorpe <logang@deltatee.com>
To: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Ming Lin <ming.l@ssi.samsung.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org,
        open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Steve Wise <swise@opengridcomputing.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:29 -0600
Message-Id: <1492121135-4437-17-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 16/22] xen-blkfront: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion to the new helper, except due to
the lack of error path, we have to warn if unmapable memory
is ever present in the sgl.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/block/xen-blkfront.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 5067a0a..7dcf41d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -807,8 +807,19 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 		BUG_ON(sg->offset + sg->length > PAGE_SIZE);
 
 		if (setup.need_copy) {
-			setup.bvec_off = sg->offset;
-			setup.bvec_data = kmap_atomic(sg_page(sg));
+			setup.bvec_off = 0;
+			setup.bvec_data = sg_map(sg, SG_KMAP_ATOMIC);
+			if (IS_ERR(setup.bvec_data)) {
+				/*
+				 * This should really never happen unless
+				 * the code is changed to use memory that is
+				 * not mappable in the sg. Seeing there is a
+				 * questionable error path out of here,
+				 * we WARN.
+				 */
+				WARN(1, "Non-mappable memory used in sg!");
+				return 1;
+			}
 		}
 
 		gnttab_foreach_grant_in_range(sg_page(sg),
@@ -818,7 +829,7 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 					      &setup);
 
 		if (setup.need_copy)
-			kunmap_atomic(setup.bvec_data);
+			sg_unmap(sg, setup.bvec_data, SG_KMAP_ATOMIC);
 	}
 	if (setup.segments)
 		kunmap_atomic(setup.segments);
@@ -1468,8 +1479,18 @@ static bool blkif_completion(unsigned long *id,
 		for_each_sg(s->sg, sg, num_sg, i) {
 			BUG_ON(sg->offset + sg->length > PAGE_SIZE);
 
-			data.bvec_offset = sg->offset;
-			data.bvec_data = kmap_atomic(sg_page(sg));
+			data.bvec_offset = 0;
+			data.bvec_data = sg_map(sg, SG_KMAP_ATOMIC);
+			if (IS_ERR(data.bvec_data)) {
+				/*
+				 * This should really never happen unless
+				 * the code is changed to use memory that is
+				 * not mappable in the sg. Seeing there is no
+				 * clear error path, we WARN.
+				 */
+				WARN(1, "Non-mappable memory used in sg!");
+				return 1;
+			}
 
 			gnttab_foreach_grant_in_range(sg_page(sg),
 						      sg->offset,
@@ -1477,7 +1498,7 @@ static bool blkif_completion(unsigned long *id,
 						      blkif_copy_from_grant,
 						      &data);
 
-			kunmap_atomic(data.bvec_data);
+			sg_unmap(sg, data.bvec_data, SG_KMAP_ATOMIC);
 		}
 	}
 	/* Add the persistent grant into the list of free grants */
-- 
2.1.4
