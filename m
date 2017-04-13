Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38158 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752422AbdDMWG0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 18:06:26 -0400
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
Date: Thu, 13 Apr 2017 16:05:15 -0600
Message-Id: <1492121135-4437-3-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 02/22] nvmet: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a straight forward conversion in two places. Should kmap fail,
the code will return an INVALD_DATA error in the completion.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/target/fabrics-cmd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 8bd022af..f62a634 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -122,7 +122,11 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 	struct nvmet_ctrl *ctrl = NULL;
 	u16 status = 0;
 
-	d = kmap(sg_page(req->sg)) + req->sg->offset;
+	d = sg_map(req->sg, SG_KMAP);
+	if (IS_ERR(d)) {
+		status = NVME_SC_SGL_INVALID_DATA;
+		goto out;
+	}
 
 	/* zero out initial completion result, assign values as needed */
 	req->rsp->result.u32 = 0;
@@ -158,7 +162,7 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 	req->rsp->result.u16 = cpu_to_le16(ctrl->cntlid);
 
 out:
-	kunmap(sg_page(req->sg));
+	sg_unmap(req->sg, d, SG_KMAP);
 	nvmet_req_complete(req, status);
 }
 
@@ -170,7 +174,11 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 	u16 qid = le16_to_cpu(c->qid);
 	u16 status = 0;
 
-	d = kmap(sg_page(req->sg)) + req->sg->offset;
+	d = sg_map(req->sg, SG_KMAP);
+	if (IS_ERR(d)) {
+		status = NVME_SC_SGL_INVALID_DATA;
+		goto out;
+	}
 
 	/* zero out initial completion result, assign values as needed */
 	req->rsp->result.u32 = 0;
@@ -205,7 +213,7 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 	pr_info("adding queue %d to ctrl %d.\n", qid, ctrl->cntlid);
 
 out:
-	kunmap(sg_page(req->sg));
+	sg_unmap(req->sg, d, SG_KMAP);
 	nvmet_req_complete(req, status);
 	return;
 
-- 
2.1.4
