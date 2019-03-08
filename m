Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0689C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 10:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AADAE20811
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 10:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfCHKFE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:05:04 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:53226 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfCHKFE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 05:05:04 -0500
Received: from randy.li?rock-chips.com (unknown [192.168.167.205])
        by regular1.263xmail.com (Postfix) with ESMTP id 0CA6329E;
        Fri,  8 Mar 2019 18:04:51 +0800 (CST)
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
Received: from randy-pc.lan (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P4577T140460028839680S1552039482412209_;
        Fri, 08 Mar 2019 18:04:50 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <3592bafda1430e3d55e003cbbd907b7a>
X-RL-SENDER: randy.li@rock-chips.com
X-SENDER: randy.li@rock-chips.com
X-LOGIN-NAME: randy.li@rock-chips.com
X-FST-TO: linux-media@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   Randy Li <randy.li@rock-chips.com>
To:     linux-media@vger.kernel.org
Cc:     Randy Li <randy.li@rock-chips.com>, ayaka@soulik.info,
        joro@8bytes.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        mchehab@kernel.org, hverkuil@xs4all.nl, nicolas@ndufresne.ca,
        ezequiel@collabora.com, posciak@chromium.org, groeck@chromium.org,
        paul.kocialkowski@bootlin.com, linux-rockchip@lists.infradead.org
Subject: [PATCH] [TEST]: media: vb2: reverse DMA addr of each plane
Date:   Fri,  8 Mar 2019 18:04:40 +0800
Message-Id: <20190308100440.14601-1-randy.li@rock-chips.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

With the default iova and dma-iommu driver, the starting
address of a new buffer would be at lower address than
the previous one.

This patch can solve this problem simply, but I want
a way to control the address direction of the IOMMU/IOVA.

The reason why we(ayaka and I) need to do this is simple,
some devices want a contiguous memory for its pixel data.
But with the single plane buffer, there is not a properly way
to export its buffer offsets with the userspace,
since their bytesperline and offset are not full related
to the picture width or height. You can find more detail
in the previous mail.

Besides, this patch won't solve all the problem, if you
don't disable the size_aligned of the iova driver or
there would be a gap between the plane 0 and plane 1.

This patch is used for showing the problem we met not
for merging.

Signed-off-by: Randy Li <randy.li@rock-chips.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 15b6b9c0a2e4..6762d1547e49 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -204,11 +204,11 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	 * Allocate memory for all planes in this buffer
 	 * NOTE: mmapped areas should be page aligned
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
+	for (plane = vb->num_planes; plane > 0; --plane) {
+		unsigned long size = PAGE_ALIGN(vb->planes[plane - 1].length);
 
 		mem_priv = call_ptr_memop(vb, alloc,
-				q->alloc_devs[plane] ? : q->dev,
+				q->alloc_devs[plane - 1] ? : q->dev,
 				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv)) {
 			if (mem_priv)
@@ -217,15 +217,15 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		}
 
 		/* Associate allocator private data with this plane */
-		vb->planes[plane].mem_priv = mem_priv;
+		vb->planes[plane - 1].mem_priv = mem_priv;
 	}
 
 	return 0;
 free:
 	/* Free already allocated memory if one of the allocations failed */
-	for (; plane > 0; --plane) {
-		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
-		vb->planes[plane - 1].mem_priv = NULL;
+	for (; plane < vb->num_planes; plane++) {
+		call_void_memop(vb, put, vb->planes[plane].mem_priv);
+		vb->planes[plane].mem_priv = NULL;
 	}
 
 	return ret;
-- 
2.20.1



