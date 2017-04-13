Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38226 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753284AbdDMWGa (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Date: Thu, 13 Apr 2017 16:05:35 -0600
Message-Id: <1492121135-4437-23-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 22/22] memstick: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion, but we have to WARN if unmappable
memory finds its way into the sgl.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/memstick/host/jmb38x_ms.c | 23 ++++++++++++++++++-----
 drivers/memstick/host/tifm_ms.c   | 22 +++++++++++++++++-----
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 48db922..256cf41 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -303,7 +303,6 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 	unsigned int off;
 	unsigned int t_size, p_cnt;
 	unsigned char *buf;
-	struct page *pg;
 	unsigned long flags = 0;
 
 	if (host->req->long_data) {
@@ -318,14 +317,26 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 		unsigned int uninitialized_var(p_off);
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg) + p_off;
+			buf = sg_map_offset(&host->req->sg,
+					     off - host->req->sg.offset,
+					     SG_KMAP_ATOMIC);
+			if (IS_ERR(buf)) {
+				/*
+				 * This should really never happen unless
+				 * the code is changed to use memory that is
+				 * not mappable in the sg. Seeing there doesn't
+				 * seem to be any error path out of here,
+				 * we can only WARN.
+				 */
+				WARN(1, "Non-mappable memory used in sg!");
+				break;
+			}
+
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -341,7 +352,9 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 				 : jmb38x_ms_read_reg_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off);
+			sg_unmap_offset(&host->req->sg, buf,
+					 off - host->req->sg.offset,
+					 SG_KMAP_ATOMIC);
 			local_irq_restore(flags);
 		}
 
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 7bafa72..c0bc40e 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -186,7 +186,6 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 	unsigned int off;
 	unsigned int t_size, p_cnt;
 	unsigned char *buf;
-	struct page *pg;
 	unsigned long flags = 0;
 
 	if (host->req->long_data) {
@@ -203,14 +202,25 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		unsigned int uninitialized_var(p_off);
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg) + p_off;
+			buf = sg_map_offset(&host->req->sg,
+					     off - host->req->sg.offset,
+					     SG_KMAP_ATOMIC);
+			if (IS_ERR(buf)) {
+				/*
+				 * This should really never happen unless
+				 * the code is changed to use memory that is
+				 * not mappable in the sg. Seeing there doesn't
+				 * seem to be any error path out of here,
+				 * we can only WARN.
+				 */
+				WARN(1, "Non-mappable memory used in sg!");
+				break;
+			}
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -221,7 +231,9 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 			 : tifm_ms_read_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off);
+			sg_unmap_offset(&host->req->sg, buf,
+					 off - host->req->sg.offset,
+					 SG_KMAP_ATOMIC);
 			local_irq_restore(flags);
 		}
 
-- 
2.1.4
