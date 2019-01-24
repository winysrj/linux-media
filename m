Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53962C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AEEC2085A
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfAXJw5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:52:57 -0500
Received: from mail.bootlin.com ([62.4.15.54]:59119 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbfAXJw5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 04:52:57 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id CD6DC2084E; Thu, 24 Jan 2019 10:52:54 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 5C68520654;
        Thu, 24 Jan 2019 10:52:44 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
Cc:     Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>
Subject: [PATCH 1/2] media: vb2: Keep dma-buf buffers mapped until they are freed
Date:   Thu, 24 Jan 2019 10:51:55 +0100
Message-Id: <20190124095156.21898-1-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Pawel Osciak <posciak@chromium.org>

When using vb2 for video decoding, dequeued capture buffers may still
be accessed by the hardware: this is the case when they are used as
reference frames for decoding subsequent frames.

When the buffer is imported with dma-buf, it needs to be mapped before
access. Until now, it was mapped when queuing and unmapped when
dequeuing, which doesn't work for access as a reference frames.

One way to solve this would be to map the buffer again when it is
needed as a reference, but the mapping/unmapping operations can
seriously impact performance. As a result, map the buffer once (when it
is first needed when queued) and keep it mapped until it is freed.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Reviewed-on: https://chromium-review.googlesource.com/334103
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
[Paul: Updated for mainline and changed commit message]
---
 drivers/media/common/videobuf2/videobuf2-core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 70e8c3366f9c..ce9294a635cc 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1196,6 +1196,9 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
 	 * userspace knows sooner rather than later if the dma-buf map fails.
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
+		if (vb->planes[plane].dbuf_mapped)
+			continue;
+
 		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
 		if (ret) {
 			dprintk(1, "failed to map dmabuf for plane %d\n",
@@ -1758,14 +1761,6 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
-	/* unmap DMABUF buffer */
-	if (q->memory == VB2_MEMORY_DMABUF)
-		for (i = 0; i < vb->num_planes; ++i) {
-			if (!vb->planes[i].dbuf_mapped)
-				continue;
-			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
-			vb->planes[i].dbuf_mapped = 0;
-		}
 	call_void_bufop(q, init_buffer, vb);
 }
 
-- 
2.20.1

