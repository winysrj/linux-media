Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49893 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952443AbdDYSVb (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 25 Apr 2017 12:20:57 -0600
Message-Id: <1493144468-22493-11-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 10/21] RDS: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion except there's no error path, so we
make use of SG_MAP_MUST_NOT_FAIL which may BUG_ON in certain cases
in the future.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 net/rds/ib_recv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index e10624a..c665689 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -800,10 +800,10 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 
 		to_copy = min(RDS_FRAG_SIZE - frag_off, PAGE_SIZE - map_off);
 		BUG_ON(to_copy & 7); /* Must be 64bit aligned. */
+		addr = sg_map(&frag->f_sg, 0,
+			      SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 
-		addr = kmap_atomic(sg_page(&frag->f_sg));
-
-		src = addr + frag->f_sg.offset + frag_off;
+		src = addr + frag_off;
 		dst = (void *)map->m_page_addrs[map_page] + map_off;
 		for (k = 0; k < to_copy; k += 8) {
 			/* Record ports that became uncongested, ie
@@ -811,7 +811,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 			uncongested |= ~(*src) & *dst;
 			*dst++ = *src++;
 		}
-		kunmap_atomic(addr);
+		sg_unmap(&frag->f_sg, addr, 0, SG_KMAP_ATOMIC);
 
 		copied += to_copy;
 
-- 
2.1.4
