Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54748 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1EYJlM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 05:41:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH] ivtv: use display information in info not in var for panning
Date: Wed, 25 May 2011 11:41:23 +0200
Message-Id: <1306316483-12899-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We must not use any information in the passed var besides xoffset,
yoffset and vmode as otherwise applications might abuse it. Also use the
aligned fix.line_length and not the (possible) unaligned xres_virtual.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/ivtv/ivtvfb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Andy,

This patch hasn't been tested as I don't have access to ivtv hardware. Can you
push it through your tree if it works for you ? You could CC stable@kernel.org
as well.

diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
index 1724745..2d5a974 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -836,7 +836,8 @@ static int ivtvfb_pan_display(struct fb_var_screeninfo *var, struct fb_info *inf
 	u32 osd_pan_index;
 	struct ivtv *itv = (struct ivtv *) info->par;
 
-	osd_pan_index = (var->xoffset + (var->yoffset * var->xres_virtual))*var->bits_per_pixel/8;
+	osd_pan_index = var->yoffset * info->fix.line_length
+		      + var->xoffset * info->var.bits_per_pixel / 8;
 	write_reg(osd_pan_index, 0x02A0C);
 
 	/* Pass this info back the yuv handler */
-- 
Regards,

Laurent Pinchart

