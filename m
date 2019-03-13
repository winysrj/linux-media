Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4037AC10F0C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB8A2177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Q52Culk4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfCMAFq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:05:46 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42042 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfCMAFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:45 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 30E5233C;
        Wed, 13 Mar 2019 01:05:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435543;
        bh=K3r1wGRCh3bd5e+FnMgwCsu0+3QdMT9xH+Cykav81xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q52Culk4tQt1Ke6o/dcTPU2IVOyLbKocWIIiQd7t7o+/Gn9EgvERJaxzxpPH75cFb
         4A+JZ0gBaFnBDrlrUZVsd2n060h1GsCyjA51KaoVDRtakqiXY7X5E93zl4fQvJnuwE
         fvqUJiKN5TM7yOpRQgG0AFeThE/sjMn56qquCxic=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 01/18] Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
Date:   Wed, 13 Mar 2019 02:05:15 +0200
Message-Id: <20190313000532.7087-2-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

This reverts commit 3299ba5c0b21 ("[media] v4l: vsp1: Supply frames to
the DU continuously")

The DU output mode does not rely on frames being supplied on the WPF as
its pipeline is supplied from DRM. For the upcoming WPF writeback
functionality, we will choose to enable writeback mode if there is an
output buffer, or disable it (leaving the existing display pipeline
unharmed) otherwise.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 7ceaf3222145..328d686189be 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -307,11 +307,6 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
  * This function completes the current buffer by filling its sequence number,
  * time stamp and payload size, and hands it back to the videobuf core.
  *
- * When operating in DU output mode (deep pipeline to the DU through the LIF),
- * the VSP1 needs to constantly supply frames to the display. In that case, if
- * no other buffer is queued, reuse the one that has just been processed instead
- * of handing it back to the videobuf core.
- *
  * Return the next queued buffer or NULL if the queue is empty.
  */
 static struct vsp1_vb2_buffer *
@@ -333,12 +328,6 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	done = list_first_entry(&video->irqqueue,
 				struct vsp1_vb2_buffer, queue);
 
-	/* In DU output mode reuse the buffer if the list is singular. */
-	if (pipe->lif && list_is_singular(&video->irqqueue)) {
-		spin_unlock_irqrestore(&video->irqlock, flags);
-		return done;
-	}
-
 	list_del(&done->queue);
 
 	if (!list_empty(&video->irqqueue))
-- 
Regards,

Laurent Pinchart

