Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49846 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952433AbdDYSV2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 25 Apr 2017 12:20:53 -0600
Message-Id: <1493144468-22493-7-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 06/21] crypto: hifn_795x: Make use of the new sg_map helper function
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/crypto/hifn_795x.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index e09d405..34b1870 100644
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
+		daddr = sg_map(dst, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(daddr))
+			return PTR_ERR(daddr);
+
+		memcpy(daddr, saddr, copy);
+		sg_unmap(dst, daddr, 0, SG_KMAP_ATOMIC);
 
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
+			saddr = sg_map(t, 0, SG_KMAP_ATOMIC);
+			if (IS_ERR(saddr)) {
+				if (!error)
+					error = PTR_ERR(saddr);
+				break;
+			}
+
+			err = ablkcipher_get(saddr, &t->length,
+					     dst, nbytes, &nbytes);
+			sg_unmap(t, saddr, 0, SG_KMAP_ATOMIC);
 
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
