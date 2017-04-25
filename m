Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49705 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948288AbdDYSVV (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
        Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:20:49 -0600
Message-Id: <1493144468-22493-3-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 02/21] libiscsi: Add an internal error code
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a prep patch to add a new error code to libiscsi. We want to
rework some kmap calls to be able to fail. When we do, we'd like to
use this error code.

This patch simply introduces ISCSI_TCP_INTERNAL_ERR and prints
"Internal Error." when it gets hit.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 5 +++++
 include/scsi/libiscsi_tcp.h   | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bd7d39e..e38d0c1 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1556,6 +1556,11 @@ static inline int read_pdu_skb(struct iscsi_conn *conn,
 		 */
 		iscsi_conn_printk(KERN_ERR, conn, "Invalid pdu or skb.");
 		return -EFAULT;
+	case ISCSI_TCP_INTERNAL_ERR:
+		pr_info("skb 0x%p, off %u, %d, TCP_INTERNAL_ERR.\n",
+			skb, offset, offloaded);
+		iscsi_conn_printk(KERN_ERR, conn, "Internal error.");
+		return -EFAULT;
 	case ISCSI_TCP_SEGMENT_DONE:
 		log_debug(1 << CXGBI_DBG_PDU_RX,
 			"skb 0x%p, off %u, %d, TCP_SEG_DONE, rc %d.\n",
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 30520d5..90691ad 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -92,6 +92,7 @@ enum {
 	ISCSI_TCP_SKB_DONE,		/* skb is out of data */
 	ISCSI_TCP_CONN_ERR,		/* iscsi layer has fired a conn err */
 	ISCSI_TCP_SUSPENDED,		/* conn is suspended */
+	ISCSI_TCP_INTERNAL_ERR,         /* an internal error occurred */
 };
 
 extern void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn);
-- 
2.1.4
