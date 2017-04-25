Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49845 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952432AbdDYSV2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
        Alex Dubov <oakad@yahoo.com>
Date: Tue, 25 Apr 2017 12:21:08 -0600
Message-Id: <1493144468-22493-22-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 21/21] memstick: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion, but we have to make use of
SG_MAP_MUST_NOT_FAIL which may BUG_ON in certain cases
in the future.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/host/jmb38x_ms.c | 11 ++++++-----
 drivers/memstick/host/tifm_ms.c   | 11 ++++++-----
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 48db922..9019e37 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -303,7 +303,6 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 	unsigned int off;
 	unsigned int t_size, p_cnt;
 	unsigned char *buf;
-	struct page *pg;
 	unsigned long flags = 0;
 
 	if (host->req->long_data) {
@@ -318,14 +317,14 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 		unsigned int uninitialized_var(p_off);
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg) + p_off;
+			buf = sg_map(&host->req->sg,
+				     off - host->req->sg.offset,
+				     SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -341,7 +340,9 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 				 : jmb38x_ms_read_reg_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off);
+			sg_unmap(&host->req->sg, buf,
+				 off - host->req->sg.offset,
+				 SG_KMAP_ATOMIC);
 			local_irq_restore(flags);
 		}
 
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 7bafa72..304985d 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -186,7 +186,6 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 	unsigned int off;
 	unsigned int t_size, p_cnt;
 	unsigned char *buf;
-	struct page *pg;
 	unsigned long flags = 0;
 
 	if (host->req->long_data) {
@@ -203,14 +202,14 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		unsigned int uninitialized_var(p_off);
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg) + p_off;
+			buf = sg_map(&host->req->sg,
+				     off - host->req->sg.offset,
+				     SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -221,7 +220,9 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 			 : tifm_ms_read_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off);
+			sg_unmap(&host->req->sg, buf,
+				 off - host->req->sg.offset,
+				 SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 			local_irq_restore(flags);
 		}
 
-- 
2.1.4
