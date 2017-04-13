Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38245 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753505AbdDMWGe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 18:06:34 -0400
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
Date: Thu, 13 Apr 2017 16:05:24 -0600
Message-Id: <1492121135-4437-12-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 11/22] RDS: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Straightforward conversion except there's no error path, so we WARN if
the sg_map fails.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 net/rds/ib_recv.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index e10624a..7f8fa99 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -801,9 +801,20 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 		to_copy = min(RDS_FRAG_SIZE - frag_off, PAGE_SIZE - map_off);
 		BUG_ON(to_copy & 7); /* Must be 64bit aligned. */
 
-		addr = kmap_atomic(sg_page(&frag->f_sg));
+		addr = sg_map(&frag->f_sg, SG_KMAP_ATOMIC);
+		if (IS_ERR(addr)) {
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
 
-		src = addr + frag->f_sg.offset + frag_off;
+		src = addr + frag_off;
 		dst = (void *)map->m_page_addrs[map_page] + map_off;
 		for (k = 0; k < to_copy; k += 8) {
 			/* Record ports that became uncongested, ie
@@ -811,7 +822,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 			uncongested |= ~(*src) & *dst;
 			*dst++ = *src++;
 		}
-		kunmap_atomic(addr);
+		sg_unmap(&frag->f_sg, addr, SG_KMAP_ATOMIC);
 
 		copied += to_copy;
 
-- 
2.1.4
