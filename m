Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49713 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1951844AbdDYSVV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:21 -0400
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
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Date: Tue, 25 Apr 2017 12:20:55 -0600
Message-Id: <1493144468-22493-9-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 08/21] dm-crypt: Make use of the new sg_map helper in 4 call sites
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Very straightforward conversion to the new function in all four spots.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8dbecf1..841f1fc 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -635,9 +635,12 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
 		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
-		r = crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
-		kunmap_atomic(src);
+		src = sg_map(sg, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+
+		r = crypt_iv_lmk_one(cc, iv, dmreq, src);
+		sg_unmap(sg, src, 0, SG_KMAP_ATOMIC);
 	} else
 		memset(iv, 0, cc->iv_size);
 
@@ -655,14 +658,18 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 		return 0;
 
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
-	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
+	dst = sg_map(sg, 0, SG_KMAP_ATOMIC);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	r = crypt_iv_lmk_one(cc, iv, dmreq, dst);
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
-		crypto_xor(dst + sg->offset, iv, cc->iv_size);
+		crypto_xor(dst, iv, cc->iv_size);
+
+	sg_unmap(sg, dst, 0, SG_KMAP_ATOMIC);
 
-	kunmap_atomic(dst);
 	return r;
 }
 
@@ -786,9 +793,12 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 	/* Remove whitening from ciphertext */
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
 		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
-		kunmap_atomic(src);
+		src = sg_map(sg, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+
+		r = crypt_iv_tcw_whitening(cc, dmreq, src);
+		sg_unmap(sg, src, 0, SG_KMAP_ATOMIC);
 	}
 
 	/* Calculate IV */
@@ -812,9 +822,12 @@ static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
 
 	/* Apply whitening on ciphertext */
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
-	kunmap_atomic(dst);
+	dst = sg_map(sg, 0, SG_KMAP_ATOMIC);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	r = crypt_iv_tcw_whitening(cc, dmreq, dst);
+	sg_unmap(sg, dst, 0, SG_KMAP_ATOMIC);
 
 	return r;
 }
-- 
2.1.4
