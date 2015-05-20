Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56457 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932124AbbEUJDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:01 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 14/20] media: rcar_vin: Reject videobufs that are too small for current format
Date: Wed, 20 May 2015 17:39:34 +0100
Message-Id: <1432139980-12619-15-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In videobuf_setup reject buffers that are too small for the configured
format. Fixes v4l2-complience issue.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 571ab20..222002a 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -541,6 +541,9 @@ static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
 		unsigned int bytes_per_line;
 		int ret;
 
+		if (fmt->fmt.pix.sizeimage < icd->sizeimage)
+			return -EINVAL;
+
 		xlate = soc_camera_xlate_by_fourcc(icd,
 						   fmt->fmt.pix.pixelformat);
 		if (!xlate)
-- 
1.7.10.4

