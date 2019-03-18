Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009FCC4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C802E20989
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="l6w1yjst"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfCRObh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:37 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59216 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbfCRObg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:36 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 824A957C;
        Mon, 18 Mar 2019 15:31:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919493;
        bh=2j8OdR+H6+aPQbIwq6Sj0C4PAxEcp3yjTvTbiQB0rfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6w1yjst2E+iauhDlt3N6YreAEIw6VABCaZl8z27VQ1koCyQGA6YN1JQekqFA7rPu
         xABz1TnlmR/uDFX6yo75lT9EWMZNOhpOGCq2POscFy6bZ8f4FC3s8hF1Yv5EUebTKg
         eta8RTf21xXmZfXup7rVP35HSAZdQI3iRlL5FctI=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 02/18] media: vsp1: wpf: Fix partition configuration for display pipelines
Date:   Mon, 18 Mar 2019 16:31:05 +0200
Message-Id: <20190318143121.29561-3-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When configuring partitions for memory-to-memory pipelines, the WPF
accesses data of the current partition through pipe->partition.
Writeback support will require full configuration of the WPF while not
providing a valid pipe->partition. Rework the configuration code to fall
back to the full image width in that case, as is already done for the
part of the configuration currently relevant for display pipelines.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_wpf.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 32bb207b2007..a07c5944b598 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -362,6 +362,7 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 	const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 	unsigned int width;
 	unsigned int height;
+	unsigned int left;
 	unsigned int offset;
 	unsigned int flip;
 	unsigned int i;
@@ -371,13 +372,16 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 						 RWPF_PAD_SINK);
 	width = sink_format->width;
 	height = sink_format->height;
+	left = 0;
 
 	/*
 	 * Cropping. The partition algorithm can split the image into
 	 * multiple slices.
 	 */
-	if (pipe->partitions > 1)
+	if (pipe->partitions > 1) {
 		width = pipe->partition->wpf.width;
+		left = pipe->partition->wpf.left;
+	}
 
 	vsp1_wpf_write(wpf, dlb, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
@@ -408,13 +412,11 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 	flip = wpf->flip.active;
 
 	if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
-		offset = format->width - pipe->partition->wpf.left
-			- pipe->partition->wpf.width;
+		offset = format->width - left - width;
 	else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
-		offset = format->height - pipe->partition->wpf.left
-			- pipe->partition->wpf.width;
+		offset = format->height - left - width;
 	else
-		offset = pipe->partition->wpf.left;
+		offset = left;
 
 	for (i = 0; i < format->num_planes; ++i) {
 		unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
@@ -436,7 +438,7 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 		 * image height.
 		 */
 		if (wpf->flip.rotate)
-			height = pipe->partition->wpf.width;
+			height = width;
 		else
 			height = format->height;
 
-- 
Regards,

Laurent Pinchart

