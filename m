Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49787 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952424AbdDYSV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:26 -0400
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
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 25 Apr 2017 12:21:05 -0600
Message-Id: <1493144468-22493-19-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 18/21] mmc: tmio: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion to sg_map helper. Seeing there is no
cleare error path, SG_MAP_MUST_NOT_FAIL which may BUG_ON in certain
cases in the future.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tmio_mmc.h     |  7 +++++--
 drivers/mmc/host/tmio_mmc_pio.c | 12 ++++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index d0edb57..bc43eb0 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -202,17 +202,20 @@ void tmio_mmc_enable_mmc_irqs(struct tmio_mmc_host *host, u32 i);
 void tmio_mmc_disable_mmc_irqs(struct tmio_mmc_host *host, u32 i);
 irqreturn_t tmio_mmc_irq(int irq, void *devid);
 
+/* Note: this function may return PTR_ERR and must be checked! */
 static inline char *tmio_mmc_kmap_atomic(struct scatterlist *sg,
 					 unsigned long *flags)
 {
+	void *ret;
+
 	local_irq_save(*flags);
-	return kmap_atomic(sg_page(sg)) + sg->offset;
+	return sg_map(sg, 0, SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 }
 
 static inline void tmio_mmc_kunmap_atomic(struct scatterlist *sg,
 					  unsigned long *flags, void *virt)
 {
-	kunmap_atomic(virt - sg->offset);
+	sg_unmap(sg, virt, 0, SG_KMAP_ATOMIC);
 	local_irq_restore(*flags);
 }
 
diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index a2d92f1..bbb4f19 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -506,6 +506,18 @@ static void tmio_mmc_check_bounce_buffer(struct tmio_mmc_host *host)
 	if (host->sg_ptr == &host->bounce_sg) {
 		unsigned long flags;
 		void *sg_vaddr = tmio_mmc_kmap_atomic(host->sg_orig, &flags);
+		if (IS_ERR(sg_vaddr)) {
+			/*
+			 * This should really never happen unless
+			 * the code is changed to use memory that is
+			 * not mappable in the sg. Seeing there doesn't
+			 * seem to be any error path out of here,
+			 * we can only WARN.
+			 */
+			WARN(1, "Non-mappable memory used in sg!");
+			return;
+		}
+
 		memcpy(sg_vaddr, host->bounce_buf, host->bounce_sg.length);
 		tmio_mmc_kunmap_atomic(host->sg_orig, &flags, sg_vaddr);
 	}
-- 
2.1.4
