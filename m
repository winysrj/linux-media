Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49921 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952446AbdDYSVb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:31 -0400
From: Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, target-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dm-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Date: Tue, 25 Apr 2017 12:21:02 -0600
Message-Id: <1493144468-22493-16-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 15/21] xen-blkfront: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion to the new helper, except due to the lack
of error path, we have to use SG_MAP_MUST_NOT_FAIL which may BUG_ON in
certain cases in the future.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Roger Pau Monné" <roger.pau@citrix.com>
---
 drivers/block/xen-blkfront.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 3945963..ed62175 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -816,8 +816,9 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 		BUG_ON(sg->offset + sg->length > PAGE_SIZE);
 
 		if (setup.need_copy) {
-			setup.bvec_off = sg->offset;
-			setup.bvec_data = kmap_atomic(sg_page(sg));
+			setup.bvec_off = 0;
+			setup.bvec_data = sg_map(sg, 0, SG_KMAP_ATOMIC |
+						 SG_MAP_MUST_NOT_FAIL);
 		}
 
 		gnttab_foreach_grant_in_range(sg_page(sg),
@@ -827,7 +828,7 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 					      &setup);
 
 		if (setup.need_copy)
-			kunmap_atomic(setup.bvec_data);
+			sg_unmap(sg, setup.bvec_data, 0, SG_KMAP_ATOMIC);
 	}
 	if (setup.segments)
 		kunmap_atomic(setup.segments);
@@ -1053,7 +1054,7 @@ static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
 		case XEN_SCSI_DISK5_MAJOR:
 		case XEN_SCSI_DISK6_MAJOR:
 		case XEN_SCSI_DISK7_MAJOR:
-			*offset = (*minor / PARTS_PER_DISK) + 
+			*offset = (*minor / PARTS_PER_DISK) +
 				((major - XEN_SCSI_DISK1_MAJOR + 1) * 16) +
 				EMULATED_SD_DISK_NAME_OFFSET;
 			*minor = *minor +
@@ -1068,7 +1069,7 @@ static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
 		case XEN_SCSI_DISK13_MAJOR:
 		case XEN_SCSI_DISK14_MAJOR:
 		case XEN_SCSI_DISK15_MAJOR:
-			*offset = (*minor / PARTS_PER_DISK) + 
+			*offset = (*minor / PARTS_PER_DISK) +
 				((major - XEN_SCSI_DISK8_MAJOR + 8) * 16) +
 				EMULATED_SD_DISK_NAME_OFFSET;
 			*minor = *minor +
@@ -1119,7 +1120,7 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	if (!VDEV_IS_EXTENDED(info->vdevice)) {
 		err = xen_translate_vdev(info->vdevice, &minor, &offset);
 		if (err)
-			return err;		
+			return err;
  		nr_parts = PARTS_PER_DISK;
 	} else {
 		minor = BLKIF_MINOR_EXT(info->vdevice);
@@ -1483,8 +1484,9 @@ static bool blkif_completion(unsigned long *id,
 		for_each_sg(s->sg, sg, num_sg, i) {
 			BUG_ON(sg->offset + sg->length > PAGE_SIZE);
 
-			data.bvec_offset = sg->offset;
-			data.bvec_data = kmap_atomic(sg_page(sg));
+			data.bvec_offset = 0;
+			data.bvec_data = sg_map(sg, 0, SG_KMAP_ATOMIC |
+						SG_MAP_MUST_NOT_FAIL);
 
 			gnttab_foreach_grant_in_range(sg_page(sg),
 						      sg->offset,
@@ -1492,7 +1494,7 @@ static bool blkif_completion(unsigned long *id,
 						      blkif_copy_from_grant,
 						      &data);
 
-			kunmap_atomic(data.bvec_data);
+			sg_unmap(sg, data.bvec_data, 0, SG_KMAP_ATOMIC);
 		}
 	}
 	/* Add the persistent grant into the list of free grants */
-- 
2.1.4
