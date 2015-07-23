Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:61675 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbbGWMVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2015 08:21:48 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 13/13] media: rcar_vin: Reject videobufs that are too small for current format
Date: Thu, 23 Jul 2015 13:21:43 +0100
Message-Id: <1437654103-26409-14-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

In videobuf_setup reject buffers that are too small for the configured
format. Fixes v4l2-compliance issue.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 93e20d6..f4e611b 100644
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

