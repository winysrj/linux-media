Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49794 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952427AbdDYSV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:26 -0400
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
        Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:20:56 -0600
Message-Id: <1493144468-22493-10-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 09/21] staging: unisys: visorbus: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion to the new function.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: David Kershner <david.kershner@unisys.com>
---
 drivers/staging/unisys/visorhba/visorhba_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index d372115..c77426c 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -843,7 +843,6 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 	struct scatterlist *sg;
 	unsigned int i;
 	char *this_page;
-	char *this_page_orig;
 	int bufind = 0;
 	struct visordisk_info *vdisk;
 	struct visorhba_devdata *devdata;
@@ -870,11 +869,14 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 
 		sg = scsi_sglist(scsicmd);
 		for (i = 0; i < scsi_sg_count(scsicmd); i++) {
-			this_page_orig = kmap_atomic(sg_page(sg + i));
-			this_page = (void *)((unsigned long)this_page_orig |
-					     sg[i].offset);
+			this_page = sg_map(sg + i, 0, SG_KMAP_ATOMIC);
+			if (IS_ERR(this_page)) {
+				scsicmd->result = DID_ERROR << 16;
+				return;
+			}
+
 			memcpy(this_page, buf + bufind, sg[i].length);
-			kunmap_atomic(this_page_orig);
+			sg_unmap(sg + i, this_page, 0, SG_KMAP_ATOMIC);
 		}
 	} else {
 		devdata = (struct visorhba_devdata *)scsidev->host->hostdata;
-- 
2.1.4
