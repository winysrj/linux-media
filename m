Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49971 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952457AbdDYSVd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:33 -0400
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
        Sascha Sommer <saschasommer@freenet.de>,
        Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 25 Apr 2017 12:21:06 -0600
Message-Id: <1493144468-22493-20-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 19/21] mmc: sdricoh_cs: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a straightforward conversion to the new function.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Sascha Sommer <saschasommer@freenet.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdricoh_cs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 5ff26ab..03225c3 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -319,16 +319,20 @@ static void sdricoh_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		for (i = 0; i < data->blocks; i++) {
 			size_t len = data->blksz;
 			u8 *buf;
-			struct page *page;
 			int result;
-			page = sg_page(data->sg);
 
-			buf = kmap(page) + data->sg->offset + (len * i);
+			buf = sg_map(data->sg, (len * i), SG_KMAP);
+			if (IS_ERR(buf)) {
+				cmd->error = PTR_ERR(buf);
+				break;
+			}
+
 			result =
 				sdricoh_blockio(host,
 					data->flags & MMC_DATA_READ, buf, len);
-			kunmap(page);
-			flush_dcache_page(page);
+			sg_unmap(data->sg, buf, (len * i), SG_KMAP);
+
+			flush_dcache_page(sg_page(data->sg));
 			if (result) {
 				dev_err(dev, "sdricoh_request: cmd %i "
 					"block transfer failed\n", cmd->opcode);
-- 
2.1.4
