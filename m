Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38203 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752890AbdDMWG2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 18:06:28 -0400
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
Date: Thu, 13 Apr 2017 16:05:23 -0600
Message-Id: <1492121135-4437-11-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 10/22] staging: unisys: visorbus: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion to the new function.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/staging/unisys/visorhba/visorhba_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 0ce92c8..2d8c8bc 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -842,7 +842,6 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 	struct scatterlist *sg;
 	unsigned int i;
 	char *this_page;
-	char *this_page_orig;
 	int bufind = 0;
 	struct visordisk_info *vdisk;
 	struct visorhba_devdata *devdata;
@@ -869,11 +868,14 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 
 		sg = scsi_sglist(scsicmd);
 		for (i = 0; i < scsi_sg_count(scsicmd); i++) {
-			this_page_orig = kmap_atomic(sg_page(sg + i));
-			this_page = (void *)((unsigned long)this_page_orig |
-					     sg[i].offset);
+			this_page = sg_map(sg + i, SG_KMAP_ATOMIC);
+			if (IS_ERR(this_page)) {
+				scsicmd->result = DID_ERROR << 16;
+				return;
+			}
+
 			memcpy(this_page, buf + bufind, sg[i].length);
-			kunmap_atomic(this_page_orig);
+			sg_unmap(sg + i, this_page, SG_KMAP_ATOMIC);
 		}
 	} else {
 		devdata = (struct visorhba_devdata *)scsidev->host->hostdata;
-- 
2.1.4
