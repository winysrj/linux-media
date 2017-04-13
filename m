Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38152 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751808AbdDMWGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Date: Thu, 13 Apr 2017 16:05:21 -0600
Message-Id: <1492121135-4437-9-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 08/22] crypto: chcr: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The get_page in this area looks *highly* suspect due to there being no
corresponding put_page. However, I've left that as is to avoid breaking
things.

I've also removed the KMAP_ATOMIC_ARGS check as it appears to be dead
code that dates back to when it was first committed...

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 41bc7f4..a993d1d 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1489,22 +1489,21 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 	return ERR_PTR(-EINVAL);
 }
 
-static void aes_gcm_empty_pld_pad(struct scatterlist *sg,
-				  unsigned short offset)
+static int aes_gcm_empty_pld_pad(struct scatterlist *sg,
+				 unsigned short offset)
 {
-	struct page *spage;
 	unsigned char *addr;
 
-	spage = sg_page(sg);
-	get_page(spage); /* so that it is not freed by NIC */
-#ifdef KMAP_ATOMIC_ARGS
-	addr = kmap_atomic(spage, KM_SOFTIRQ0);
-#else
-	addr = kmap_atomic(spage);
-#endif
-	memset(addr + sg->offset, 0, offset + 1);
+	get_page(sg_page(sg)); /* so that it is not freed by NIC */
+
+	addr = sg_map(sg, SG_KMAP_ATOMIC);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+
+	memset(addr, 0, offset + 1);
+	sg_unmap(sg, addr, SG_KMAP_ATOMIC);
 
-	kunmap_atomic(addr);
+	return 0;
 }
 
 static int set_msg_len(u8 *block, unsigned int msglen, int csize)
@@ -1940,7 +1939,10 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 	if (req->cryptlen) {
 		write_sg_to_skb(skb, &frags, src, req->cryptlen);
 	} else {
-		aes_gcm_empty_pld_pad(req->dst, authsize - 1);
+		err = aes_gcm_empty_pld_pad(req->dst, authsize - 1);
+		if (err)
+			goto dstmap_fail;
+
 		write_sg_to_skb(skb, &frags, reqctx->dst, crypt_len);
 
 	}
-- 
2.1.4
