Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38200 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752864AbdDMWG2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Date: Thu, 13 Apr 2017 16:05:20 -0600
Message-Id: <1492121135-4437-8-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 07/22] crypto: shash, caam: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Very straightforward conversion to the new function in two crypto
drivers.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 crypto/shash.c                | 9 ++++++---
 drivers/crypto/caam/caamalg.c | 8 +++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 5e31c8d..2b7de94 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -283,10 +283,13 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
 		void *data;
 
-		data = kmap_atomic(sg_page(sg));
-		err = crypto_shash_digest(desc, data + offset, nbytes,
+		data = sg_map(sg, SG_KMAP_ATOMIC);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+
+		err = crypto_shash_digest(desc, data, nbytes,
 					  req->result);
-		kunmap_atomic(data);
+		sg_unmap(sg, data, SG_KMAP_ATOMIC);
 		crypto_yield(desc->flags);
 	} else
 		err = crypto_shash_init(desc) ?:
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 9bc80eb..76b97de 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -89,7 +89,6 @@ static void dbg_dump_sg(const char *level, const char *prefix_str,
 			struct scatterlist *sg, size_t tlen, bool ascii)
 {
 	struct scatterlist *it;
-	void *it_page;
 	size_t len;
 	void *buf;
 
@@ -98,19 +97,18 @@ static void dbg_dump_sg(const char *level, const char *prefix_str,
 		 * make sure the scatterlist's page
 		 * has a valid virtual memory mapping
 		 */
-		it_page = kmap_atomic(sg_page(it));
-		if (unlikely(!it_page)) {
+		buf = sg_map(it, SG_KMAP_ATOMIC);
+		if (IS_ERR(buf)) {
 			printk(KERN_ERR "dbg_dump_sg: kmap failed\n");
 			return;
 		}
 
-		buf = it_page + it->offset;
 		len = min_t(size_t, tlen, it->length);
 		print_hex_dump(level, prefix_str, prefix_type, rowsize,
 			       groupsize, buf, len, ascii);
 		tlen -= len;
 
-		kunmap_atomic(it_page);
+		sg_unmap(it, buf, SG_KMAP_ATOMIC);
 	}
 }
 #endif
-- 
2.1.4
