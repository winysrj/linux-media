Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF499C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A10FD218AC
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:51:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Y3HAp215"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfBAOvs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 09:51:48 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:39580 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbfBAOvs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 09:51:48 -0500
Received: from pendragon.ideasonboard.com (85-76-34-136-nat.elisa-mobile.fi [85.76.34.136])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2D6E14F7;
        Fri,  1 Feb 2019 15:51:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549032706;
        bh=vIaMhbzoONy+NNtlIbtYf+m1v246FO+DiU/X3V2klEo=;
        h=From:To:Cc:Subject:Date:From;
        b=Y3HAp21581nwmBBuB97bASlrRwkXFrzLfYGvFFbt7D6ggYj3014kzwugsz+7mrf6+
         7T5r1qZc9QHnxqSOT7qWcSUwVoqrjNZed1KDsYZ/YpPb513OTxwEtWxIFg5i8UPQMb
         IOrpnH09UMwDTR+3xCpSn4dvrqqg2SvhseZvNUQ4=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] media: vb2: Fix compilation warning
Date:   Fri,  1 Feb 2019 16:51:35 +0200
Message-Id: <20190201145135.20038-1-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 2cc1802f62e5 removed code without removing a local variable that
ended up being unused. This results in a compilation warning, fix it.

Fixes: 2cc1802f62e5 ("media: vb2: Keep dma-buf buffers mapped until they are freed")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 1 -
 1 file changed, 1 deletion(-)

I wonder how the offending commit got merged without the warning being
noticed. Sakari, as a useful exercise, could you check whether this
would have been caught by the automatic build system you're
experimenting with ?

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index e07b6bdb6982..34cc87ca8d59 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1769,7 +1769,6 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 static void __vb2_dqbuf(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int i;
 
 	/* nothing to do if the buffer is already dequeued */
 	if (vb->state == VB2_BUF_STATE_DEQUEUED)
-- 
Regards,

Laurent Pinchart

