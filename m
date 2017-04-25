Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49745 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952025AbdDYSVX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:23 -0400
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
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Date: Tue, 25 Apr 2017 12:20:50 -0600
Message-Id: <1493144468-22493-4-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 03/21] libiscsi: Make use of new the sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the kmap and kmap_atomic uses to the sg_map function. We now
store the flags for the kmap instead of a boolean to indicate
atomicitiy. We use ISCSI_TCP_INTERNAL_ERR error type that was prepared
earlier for this.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/libiscsi_tcp.c | 32 ++++++++++++++++++++------------
 include/scsi/libiscsi_tcp.h |  2 +-
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 63a1d69..a34e25c 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -133,25 +133,23 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 	if (page_count(sg_page(sg)) >= 1 && !recv)
 		return;
 
-	if (recv) {
-		segment->atomic_mapped = true;
-		segment->sg_mapped = kmap_atomic(sg_page(sg));
-	} else {
-		segment->atomic_mapped = false;
-		/* the xmit path can sleep with the page mapped so use kmap */
-		segment->sg_mapped = kmap(sg_page(sg));
+	/* the xmit path can sleep with the page mapped so don't use atomic */
+	segment->sg_map_flags = recv ? SG_KMAP_ATOMIC : SG_KMAP;
+	segment->sg_mapped = sg_map(sg, 0, segment->sg_map_flags);
+
+	if (IS_ERR(segment->sg_mapped)) {
+		segment->sg_mapped = NULL;
+		return;
 	}
 
-	segment->data = segment->sg_mapped + sg->offset + segment->sg_offset;
+	segment->data = segment->sg_mapped + segment->sg_offset;
 }
 
 void iscsi_tcp_segment_unmap(struct iscsi_segment *segment)
 {
 	if (segment->sg_mapped) {
-		if (segment->atomic_mapped)
-			kunmap_atomic(segment->sg_mapped);
-		else
-			kunmap(sg_page(segment->sg));
+		sg_unmap(segment->sg, segment->sg_mapped, 0,
+			 segment->sg_map_flags);
 		segment->sg_mapped = NULL;
 		segment->data = NULL;
 	}
@@ -304,6 +302,9 @@ iscsi_tcp_segment_recv(struct iscsi_tcp_conn *tcp_conn,
 			break;
 		}
 
+		if (segment->data)
+			return -EFAULT;
+
 		copy = min(len - copied, segment->size - segment->copied);
 		ISCSI_DBG_TCP(tcp_conn->iscsi_conn, "copying %d\n", copy);
 		memcpy(segment->data + segment->copied, ptr + copied, copy);
@@ -927,6 +928,13 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 			      avail);
 		rc = iscsi_tcp_segment_recv(tcp_conn, segment, ptr, avail);
 		BUG_ON(rc == 0);
+		if (rc < 0) {
+			ISCSI_DBG_TCP(conn, "memory fault. Consumed %d\n",
+				      consumed);
+			*status = ISCSI_TCP_INTERNAL_ERR;
+			goto skb_done;
+		}
+
 		consumed += rc;
 
 		if (segment->total_copied >= segment->total_size) {
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 90691ad..58c79af 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -47,7 +47,7 @@ struct iscsi_segment {
 	struct scatterlist	*sg;
 	void			*sg_mapped;
 	unsigned int		sg_offset;
-	bool			atomic_mapped;
+	int			sg_map_flags;
 
 	iscsi_segment_done_fn_t	*done;
 };
-- 
2.1.4
