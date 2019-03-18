Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5F3C10F00
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E1F120872
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="apOVxiU4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfCRObm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:42 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59242 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfCRObm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:42 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0854F1235;
        Mon, 18 Mar 2019 15:31:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919496;
        bh=LTxeJ5gTHWF8ouf3E3iF1z31XC4fKp9g0/CV3ti2uWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apOVxiU4XRyASFV6bdNni8YKRAQ3l5nbuy3ZskAfeTtF5Gh0UCFZrGvJBSjRZj9pv
         8klJdnxMdoNBCjNIKmohvpCYRvc7YCCfVf7z1IwfPsQ+aKQlVLARi1ZPUEFAUqsVNL
         JsLooRyx2U4nlc+Taj3XOTBeMKCWm9n6W3h4P4dQ=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 07/18] media: vsp1: dl: Allow chained display lists for display pipelines
Date:   Mon, 18 Mar 2019 16:31:10 +0200
Message-Id: <20190318143121.29561-8-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
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
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
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

