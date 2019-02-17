Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB1AC43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42712218AC
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="VYyfwNdN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbfBQCtD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 21:49:03 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45164 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfBQCtC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 21:49:02 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8111E122B;
        Sun, 17 Feb 2019 03:49:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550371740;
        bh=MsA0HCyuC/wJs/kkEXZxE1EseTw1hb1jKlMxAm9l6eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYyfwNdNdUpAJJWsgG4gECJihG/BGpvYTRQ2kd6SpwbaBfbVRvRsJAJwmg+9vkEYj
         JONAB/1ukt6pcTxFI2Qt7c8vIOnp5SYHZzCPWrrELY9e/m5+TcfUPe63S4TuZogLnm
         uRRgjc/vrCY64sNbXIYx2UZ4fNEekwIAAFuSx3CM=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 2/7] media: vsp1: wpf: Fix partition configuration for display pipelines
Date:   Sun, 17 Feb 2019 04:48:47 +0200
Message-Id: <20190217024852.23328-3-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The WPF accesses partition configuration from pipe->partition in the
partition configuration that is not used for display pipelines.
Writeback support will require full configuration of the WPF while not
providing a valid pipe->partition. Rework the configuration code to fall
back to the full image width in that case, as is already done for the
part of the configuration currently relevant for display pipelines.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
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

