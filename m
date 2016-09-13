Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46919 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759537AbcIMXQi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:38 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 07/13] v4l: vsp1: Fix RPF cropping
Date: Wed, 14 Sep 2016 02:17:00 +0300
Message-Id: <1473808626-19488-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RPF cropping offset for the chroma planes is incorrectly computed,
it needs to be divided by the horizontal subsampling factor.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 388838913205..3d6669dbeacf 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -105,7 +105,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 
 	if (format->num_planes > 1) {
 		rpf->offsets[1] = crop->top * format->plane_fmt[1].bytesperline
-				+ crop->left * fmtinfo->bpp[1] / 8;
+				+ crop->left / fmtinfo->hsub * fmtinfo->bpp[1]
+				/ 8;
 		pstride |= format->plane_fmt[1].bytesperline
 			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
 	} else {
-- 
Regards,

Laurent Pinchart

