Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47559 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbANAzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 19:55:13 -0500
Received: by mail-pa0-f44.google.com with SMTP id et14so6931101pad.3
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 16:55:12 -0800 (PST)
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH] [media] rcar_vin: Update device_caps and capabilities in querycap
Date: Wed, 14 Jan 2015 09:55:02 +0900
Message-Id: <1421196902-24155-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

device_caps in v4l2_capability structure must have been set value like
capabilities. This set the value to device_caps, and set V4L2_CAP_DEVICE_CAPS
to capabilities.
This fixes check by commit 454a4e728dd5 ("[media] v4l2-ioctl: WARN_ON if
querycap didn't fill device_caps").

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 0c1f556..9f1473c 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1799,7 +1799,9 @@ static int rcar_vin_querycap(struct soc_camera_host *ici,
 			     struct v4l2_capability *cap)
 {
 	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
 	return 0;
 }
 
-- 
2.1.3

