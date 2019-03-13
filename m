Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D58C10F0B
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37262177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="dlr83Uie"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfCMAFw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:05:52 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42062 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbfCMAFv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:51 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A51B233C;
        Wed, 13 Mar 2019 01:05:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435548;
        bh=bZyqFm28qTqCIjEEP3BudO9TOwL05Jo42MqGQr2Qu0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlr83UieH8qb+IPOvSpJRbgeSUitzZe1ArtLzgPozDsyrwPrcQTWNCIzx96U2NLt6
         KHb+ldppbhXW4XFM7jnAGdBmRU+YfsfsmlnuALNKXWJ+GCm3EoviSmWGyzmyW8WAkp
         iNuU6QffsEKsnRh2HhIzWA8PlQ1dIr6W5u5M4BWk=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 07/18] media: vsp1: dl: Allow chained display lists for display pipelines
Date:   Wed, 13 Mar 2019 02:05:21 +0200
Message-Id: <20190313000532.7087-8-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Refactor the display list header setup to allow chained display lists
with display pipelines. Chain the display lists as for mem-to-mem
pipelines, but enable the frame end interrupt for every list as display
pipelines have a single list per frame.

This feature will be used to disable writeback exactly one frame after
enabling it by chaining a writeback disable display list.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 35 ++++++++++++++++++---------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 886b3a69d329..ed7cda4130f2 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -770,17 +770,35 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 	}
 
 	dl->header->num_lists = num_lists;
+	dl->header->flags = 0;
 
-	if (!list_empty(&dl->chain) && !is_last) {
+	/*
+	 * Enable the interrupt for the end of each frame. In continuous mode
+	 * chained lists are used with one list per frame, so enable the
+	 * interrupt for each list. In singleshot mode chained lists are used
+	 * to partition a single frame, so enable the interrupt for the last
+	 * list only.
+	 */
+	if (!dlm->singleshot || is_last)
+		dl->header->flags |= VSP1_DLH_INT_ENABLE;
+
+	/*
+	 * In continuous mode enable auto-start for all lists, as the VSP must
+	 * loop on the same list until a new one is queued. In singleshot mode
+	 * enable auto-start for all lists but the last to chain processing of
+	 * partitions without software intervention.
+	 */
+	if (!dlm->singleshot || !is_last)
+		dl->header->flags |= VSP1_DLH_AUTO_START;
+
+	if (!is_last) {
 		/*
-		 * If this display list's chain is not empty, we are on a list,
-		 * and the next item is the display list that we must queue for
-		 * automatic processing by the hardware.
+		 * If this is not the last display list in the chain, queue the
+		 * next item for automatic processing by the hardware.
 		 */
 		struct vsp1_dl_list *next = list_next_entry(dl, chain);
 
 		dl->header->next_header = next->dma;
-		dl->header->flags = VSP1_DLH_AUTO_START;
 	} else if (!dlm->singleshot) {
 		/*
 		 * if the display list manager works in continuous mode, the VSP
@@ -788,13 +806,6 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 		 * instructed to do otherwise.
 		 */
 		dl->header->next_header = dl->dma;
-		dl->header->flags = VSP1_DLH_INT_ENABLE | VSP1_DLH_AUTO_START;
-	} else {
-		/*
-		 * Otherwise, in mem-to-mem mode, we work in single-shot mode
-		 * and the next display list must not be started automatically.
-		 */
-		dl->header->flags = VSP1_DLH_INT_ENABLE;
 	}
 
 	if (!dl->extension)
-- 
Regards,

Laurent Pinchart

