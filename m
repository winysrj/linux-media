Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38139 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbdDMWGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 18:06:25 -0400
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
Date: Thu, 13 Apr 2017 16:05:19 -0600
Message-Id: <1492121135-4437-7-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 06/22] crypto: hifn_795x: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Conversion of a couple kmap_atomic instances to the sg_map helper
function.

However, it looks like there was a bug in the original code: the source
scatter lists offset (t->offset) was passed to ablkcipher_get which
added it to the destination address. This doesn't make a lot of
sense, but t->offset is likely always zero anyway. So, this patch cleans
that brokeness up.

Also, a change to the error path: if ablkcipher_get failed, everything
seemed to proceed as if it hadn't. Setting 'error' should hopefully
clear that up.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/crypto/hifn_795x.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index e09d405..8e2c6a9 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1619,7 +1619,7 @@ static int hifn_start_device(struct hifn_device *dev)
 	return 0;
 }
 
-static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset,
+static int ablkcipher_get(void *saddr, unsigned int *srestp,
 		struct scatterlist *dst, unsigned int size, unsigned int *nbytesp)
 {
 	unsigned int srest = *srestp, nbytes = *nbytesp, copy;
@@ -1632,15 +1632,17 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 	while (size) {
 		copy = min3(srest, dst->length, size);
 
-		daddr = kmap_atomic(sg_page(dst));
-		memcpy(daddr + dst->offset + offset, saddr, copy);
-		kunmap_atomic(daddr);
+		daddr = sg_map(dst, SG_KMAP_ATOMIC);
+		if (IS_ERR(daddr))
+			return PTR_ERR(daddr);
+
+		memcpy(daddr, saddr, copy);
+		sg_unmap(dst, daddr, SG_KMAP_ATOMIC);
 
 		nbytes -= copy;
 		size -= copy;
 		srest -= copy;
 		saddr += copy;
-		offset = 0;
 
 		pr_debug("%s: copy: %u, size: %u, srest: %u, nbytes: %u.\n",
 			 __func__, copy, size, srest, nbytes);
@@ -1671,11 +1673,12 @@ static inline void hifn_complete_sa(struct hifn_device *dev, int i)
 
 static void hifn_process_ready(struct ablkcipher_request *req, int error)
 {
+	int err;
 	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
 
 	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
 		unsigned int nbytes = req->nbytes;
-		int idx = 0, err;
+		int idx = 0;
 		struct scatterlist *dst, *t;
 		void *saddr;
 
@@ -1695,17 +1698,24 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 				continue;
 			}
 
-			saddr = kmap_atomic(sg_page(t));
+			saddr = sg_map(t, SG_KMAP_ATOMIC);
+			if (IS_ERR(saddr)) {
+				if (!error)
+					error = PTR_ERR(saddr);
+				break;
+			}
+
+			err = ablkcipher_get(saddr, &t->length,
+					     dst, nbytes, &nbytes);
+			sg_unmap(t, saddr, SG_KMAP_ATOMIC);
 
-			err = ablkcipher_get(saddr, &t->length, t->offset,
-					dst, nbytes, &nbytes);
 			if (err < 0) {
-				kunmap_atomic(saddr);
+				if (!error)
+					error = err;
 				break;
 			}
 
 			idx += err;
-			kunmap_atomic(saddr);
 		}
 
 		hifn_cipher_walk_exit(&rctx->walk);
-- 
2.1.4
