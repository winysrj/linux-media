Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:61668 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752175AbbGWMVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2015 08:21:48 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 12/13] media: rcar_vin: fill in bus_info field
Date: Thu, 23 Jul 2015 13:21:42 +0100
Message-Id: <1437654103-26409-13-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Adapt rcar_vin_querycap() so that cap->bus_info is populated with
something meaningful/unique.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index dab729a..93e20d6 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1799,6 +1799,7 @@ static int rcar_vin_querycap(struct soc_camera_host *ici,
 	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s%d", DRV_NAME, ici->nr);
 
 	return 0;
 }
-- 
1.7.10.4

