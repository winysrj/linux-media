Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:49654 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751973AbbFYJbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:31:15 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 14/15] media: rcar_vin: fill in bus_info field
Date: Thu, 25 Jun 2015 10:31:08 +0100
Message-Id: <1435224669-23672-15-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
References: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
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
index 1023c5b..20f690d 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1800,6 +1800,7 @@ static int rcar_vin_querycap(struct soc_camera_host *ici,
 	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s%d", DRV_NAME, ici->nr);
 
 	return 0;
 }
-- 
1.7.10.4

