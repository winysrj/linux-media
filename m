Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49913 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952444AbdDYSVb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:31 -0400
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
        Achim Leubner <achim_leubner@adaptec.com>,
        John Garry <john.garry@huawei.com>
Date: Tue, 25 Apr 2017 12:20:59 -0600
Message-Id: <1493144468-22493-13-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 12/21] scsi: hisi_sas, mvsas, gdth: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Very straightforward conversion of three scsi drivers.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Achim Leubner <achim_leubner@adaptec.com>
Cc: John Garry <john.garry@huawei.com>
---
 drivers/scsi/gdth.c                    |  9 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 14 +++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 13 +++++++++----
 drivers/scsi/mvsas/mv_sas.c            | 10 +++++-----
 4 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index d020a13..c70248a2 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2301,10 +2301,15 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                 return;
             }
             local_irq_save(flags);
-            address = kmap_atomic(sg_page(sl)) + sl->offset;
+            address = sg_map(sl, 0, SG_KMAP_ATOMIC);
+            if (IS_ERR(address)) {
+                scp->result = DID_ERROR << 16;
+                return;
+	    }
+
             memcpy(address, buffer, cpnow);
             flush_dcache_page(sg_page(sl));
-            kunmap_atomic(address);
+            sg_unmap(sl, address, 0, SG_KMAP_ATOMIC);
             local_irq_restore(flags);
             if (cpsum == cpcount)
                 break;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fc1c1b2..b3953e3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1381,18 +1381,22 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		void *to;
 		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
 
-		ts->stat = SAM_STAT_GOOD;
-		to = kmap_atomic(sg_page(sg_resp));
+		to = sg_map(sg_resp, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(to)) {
+			dev_err(dev, "slot complete: error mapping memory");
+			ts->stat = SAS_SG_ERR;
+			break;
+		}
 
+		ts->stat = SAM_STAT_GOOD;
 		dma_unmap_sg(dev, &task->smp_task.smp_resp, 1,
 			     DMA_FROM_DEVICE);
 		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
 			     DMA_TO_DEVICE);
-		memcpy(to + sg_resp->offset,
-		       slot->status_buffer +
+		memcpy(to, slot->status_buffer +
 		       sizeof(struct hisi_sas_err_record),
 		       sg_dma_len(sg_resp));
-		kunmap_atomic(to);
+		sg_unmap(sg_resp, to, 0, SG_KMAP_ATOMIC);
 		break;
 	}
 	case SAS_PROTOCOL_SATA:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e241921..3e674a4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2307,18 +2307,23 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
 		void *to;
 
+		to = sg_map(sg_resp, 0, SG_KMAP_ATOMIC);
+		if (IS_ERR(to)) {
+			dev_err(dev, "slot complete: error mapping memory");
+			ts->stat = SAS_SG_ERR;
+			break;
+		}
+
 		ts->stat = SAM_STAT_GOOD;
-		to = kmap_atomic(sg_page(sg_resp));
 
 		dma_unmap_sg(dev, &task->smp_task.smp_resp, 1,
 			     DMA_FROM_DEVICE);
 		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
 			     DMA_TO_DEVICE);
-		memcpy(to + sg_resp->offset,
-		       slot->status_buffer +
+		memcpy(to, slot->status_buffer +
 		       sizeof(struct hisi_sas_err_record),
 		       sg_dma_len(sg_resp));
-		kunmap_atomic(to);
+		sg_unmap(sg_resp, to, 0, SG_KMAP_ATOMIC);
 		break;
 	}
 	case SAS_PROTOCOL_SATA:
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index c7cc803..a72e0ce 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1798,11 +1798,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	case SAS_PROTOCOL_SMP: {
 			struct scatterlist *sg_resp = &task->smp_task.smp_resp;
 			tstat->stat = SAM_STAT_GOOD;
-			to = kmap_atomic(sg_page(sg_resp));
-			memcpy(to + sg_resp->offset,
-				slot->response + sizeof(struct mvs_err_info),
-				sg_dma_len(sg_resp));
-			kunmap_atomic(to);
+			to = sg_map(sg_resp, 0, SG_KMAP_ATOMIC);
+			memcpy(to,
+			       slot->response + sizeof(struct mvs_err_info),
+			       sg_dma_len(sg_resp));
+			sg_unmap(sg_resp, to, 0, SG_KMAP_ATOMIC);
 			break;
 		}
 
-- 
2.1.4
