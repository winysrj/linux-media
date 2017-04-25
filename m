Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49836 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952430AbdDYSV2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:28 -0400
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
        Brian King <brking@us.ibm.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Date: Tue, 25 Apr 2017 12:20:58 -0600
Message-Id: <1493144468-22493-12-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 11/21] scsi: ipr, pmcraid, isci: Make use of the new sg_map helper
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Very straightforward conversion of three scsi drivers.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Brian King <brking@us.ibm.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/scsi/ipr.c          | 27 ++++++++++++++-------------
 drivers/scsi/isci/request.c | 42 +++++++++++++++++++++++++-----------------
 drivers/scsi/pmcraid.c      | 19 ++++++++++++-------
 3 files changed, 51 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b0c68d2..b2324e1 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3895,7 +3895,7 @@ static void ipr_free_ucode_buffer(struct ipr_sglist *sglist)
 static int ipr_copy_ucode_buffer(struct ipr_sglist *sglist,
 				 u8 *buffer, u32 len)
 {
-	int bsize_elem, i, result = 0;
+	int bsize_elem, i;
 	struct scatterlist *scatterlist;
 	void *kaddr;
 
@@ -3905,32 +3905,33 @@ static int ipr_copy_ucode_buffer(struct ipr_sglist *sglist,
 	scatterlist = sglist->scatterlist;
 
 	for (i = 0; i < (len / bsize_elem); i++, buffer += bsize_elem) {
-		struct page *page = sg_page(&scatterlist[i]);
+		kaddr = sg_map(&scatterlist[i], 0, SG_KMAP);
+		if (IS_ERR(kaddr)) {
+			ipr_trace;
+			return PTR_ERR(kaddr);
+		}
 
-		kaddr = kmap(page);
 		memcpy(kaddr, buffer, bsize_elem);
-		kunmap(page);
+		sg_unmap(&scatterlist[i], kaddr, 0, SG_KMAP);
 
 		scatterlist[i].length = bsize_elem;
-
-		if (result != 0) {
-			ipr_trace;
-			return result;
-		}
 	}
 
 	if (len % bsize_elem) {
-		struct page *page = sg_page(&scatterlist[i]);
+		kaddr = sg_map(&scatterlist[i], 0, SG_KMAP);
+		if (IS_ERR(kaddr)) {
+			ipr_trace;
+			return PTR_ERR(kaddr);
+		}
 
-		kaddr = kmap(page);
 		memcpy(kaddr, buffer, len % bsize_elem);
-		kunmap(page);
+		sg_unmap(&scatterlist[i], kaddr, 0, SG_KMAP);
 
 		scatterlist[i].length = len % bsize_elem;
 	}
 
 	sglist->buffer_len = len;
-	return result;
+	return 0;
 }
 
 /**
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 47f66e9..6f5521b 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1424,12 +1424,14 @@ sci_stp_request_pio_data_in_copy_data_buffer(struct isci_stp_request *stp_req,
 		sg = task->scatter;
 
 		while (total_len > 0) {
-			struct page *page = sg_page(sg);
-
 			copy_len = min_t(int, total_len, sg_dma_len(sg));
-			kaddr = kmap_atomic(page);
-			memcpy(kaddr + sg->offset, src_addr, copy_len);
-			kunmap_atomic(kaddr);
+			kaddr = sg_map(sg, 0, SG_KMAP_ATOMIC);
+			if (IS_ERR(kaddr))
+				return SCI_FAILURE;
+
+			memcpy(kaddr, src_addr, copy_len);
+			sg_unmap(sg, kaddr, 0, SG_KMAP_ATOMIC);
+
 			total_len -= copy_len;
 			src_addr += copy_len;
 			sg = sg_next(sg);
@@ -1771,14 +1773,16 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 	case SCI_REQ_SMP_WAIT_RESP: {
 		struct sas_task *task = isci_request_access_task(ireq);
 		struct scatterlist *sg = &task->smp_task.smp_resp;
-		void *frame_header, *kaddr;
+		void *frame_header;
 		u8 *rsp;
 
 		sci_unsolicited_frame_control_get_header(&ihost->uf_control,
 							 frame_index,
 							 &frame_header);
-		kaddr = kmap_atomic(sg_page(sg));
-		rsp = kaddr + sg->offset;
+		rsp = sg_map(sg, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(rsp))
+			return SCI_FAILURE;
+
 		sci_swab32_cpy(rsp, frame_header, 1);
 
 		if (rsp[0] == SMP_RESPONSE) {
@@ -1814,7 +1818,7 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 			ireq->sci_status = SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR;
 			sci_change_state(&ireq->sm, SCI_REQ_COMPLETED);
 		}
-		kunmap_atomic(kaddr);
+		sg_unmap(sg, rsp, 0, SG_KMAP_ATOMIC);
 
 		sci_controller_release_frame(ihost, frame_index);
 
@@ -2919,15 +2923,18 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 	case SAS_PROTOCOL_SMP: {
 		struct scatterlist *sg = &task->smp_task.smp_req;
 		struct smp_req *smp_req;
-		void *kaddr;
 
 		dma_unmap_sg(&ihost->pdev->dev, sg, 1, DMA_TO_DEVICE);
 
 		/* need to swab it back in case the command buffer is re-used */
-		kaddr = kmap_atomic(sg_page(sg));
-		smp_req = kaddr + sg->offset;
+		smp_req = sg_map(sg, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(smp_req)) {
+			status = SAS_ABORTED_TASK;
+			break;
+		}
+
 		sci_swab32_cpy(smp_req, smp_req, sg->length / sizeof(u32));
-		kunmap_atomic(kaddr);
+		sg_unmap(sg, smp_req, 0, SG_KMAP_ATOMIC);
 		break;
 	}
 	default:
@@ -3190,12 +3197,13 @@ sci_io_request_construct_smp(struct device *dev,
 	struct scu_task_context *task_context;
 	struct isci_port *iport;
 	struct smp_req *smp_req;
-	void *kaddr;
 	u8 req_len;
 	u32 cmd;
 
-	kaddr = kmap_atomic(sg_page(sg));
-	smp_req = kaddr + sg->offset;
+	smp_req = sg_map(sg, 0, SG_KMAP_ATOMIC);
+	if (IS_ERR(smp_req))
+		return SCI_FAILURE;
+
 	/*
 	 * Look at the SMP requests' header fields; for certain SAS 1.x SMP
 	 * functions under SAS 2.0, a zero request length really indicates
@@ -3220,7 +3228,7 @@ sci_io_request_construct_smp(struct device *dev,
 	req_len = smp_req->req_len;
 	sci_swab32_cpy(smp_req, smp_req, sg->length / sizeof(u32));
 	cmd = *(u32 *) smp_req;
-	kunmap_atomic(kaddr);
+	sg_unmap(sg, smp_req, 0, SG_KMAP_ATOMIC);
 
 	if (!dma_map_sg(dev, sg, 1, DMA_TO_DEVICE))
 		return SCI_FAILURE;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 49e70a3..e0d041a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3342,9 +3342,12 @@ static int pmcraid_copy_sglist(
 	scatterlist = sglist->scatterlist;
 
 	for (i = 0; i < (len / bsize_elem); i++, buffer += bsize_elem) {
-		struct page *page = sg_page(&scatterlist[i]);
+		kaddr = sg_map(&scatterlist[i], 0, SG_KMAP);
+		if (IS_ERR(kaddr)) {
+			pmcraid_err("failed to copy user data into sg list\n");
+			return PTR_ERR(kaddr);
+		}
 
-		kaddr = kmap(page);
 		if (direction == DMA_TO_DEVICE)
 			rc = __copy_from_user(kaddr,
 					      (void *)buffer,
@@ -3352,7 +3355,7 @@ static int pmcraid_copy_sglist(
 		else
 			rc = __copy_to_user((void *)buffer, kaddr, bsize_elem);
 
-		kunmap(page);
+		sg_unmap(&scatterlist[i], kaddr, 0, SG_KMAP);
 
 		if (rc) {
 			pmcraid_err("failed to copy user data into sg list\n");
@@ -3363,9 +3366,11 @@ static int pmcraid_copy_sglist(
 	}
 
 	if (len % bsize_elem) {
-		struct page *page = sg_page(&scatterlist[i]);
-
-		kaddr = kmap(page);
+		kaddr = sg_map(&scatterlist[i], 0, SG_KMAP);
+		if (IS_ERR(kaddr)) {
+			pmcraid_err("failed to copy user data into sg list\n");
+			return PTR_ERR(kaddr);
+		}
 
 		if (direction == DMA_TO_DEVICE)
 			rc = __copy_from_user(kaddr,
@@ -3376,7 +3381,7 @@ static int pmcraid_copy_sglist(
 					    kaddr,
 					    len % bsize_elem);
 
-		kunmap(page);
+		sg_unmap(&scatterlist[i], kaddr, 0, SG_KMAP);
 
 		scatterlist[i].length = len % bsize_elem;
 	}
-- 
2.1.4
