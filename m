Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35261 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbcFIR5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2016 13:57:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id k184so12474691wme.2
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2016 10:57:06 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: laurent.pinchart@ideasonboard.com
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH] [media] v4l: vsp1: Fix format-info documentation
Date: Thu,  9 Jun 2016 18:57:02 +0100
Message-Id: <1465495022-8177-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Minor tweaks to document the swap register and make the documentation
match the struct ordering

Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
---
 drivers/media/platform/vsp1/vsp1_pipe.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 7b56113511dd..6ee3db1fab55 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -25,11 +25,12 @@ struct vsp1_rwpf;
 
 /*
  * struct vsp1_format_info - VSP1 video format description
- * @mbus: media bus format code
  * @fourcc: V4L2 pixel format FCC identifier
+ * @mbus: media bus format code
+ * @hwfmt: VSP1 hardware format
+ * @swap: swap register control
  * @planes: number of planes
  * @bpp: bits per pixel
- * @hwfmt: VSP1 hardware format
  * @swap_yc: the Y and C components are swapped (Y comes before C)
  * @swap_uv: the U and V components are swapped (V comes before U)
  * @hsub: horizontal subsampling factor
-- 
2.7.4

