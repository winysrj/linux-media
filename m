Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:54994 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2LZRgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:36:01 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 2E46B40B99
	for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 18:35:59 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Tnuta-0001cJ-OE
	for linux-media@vger.kernel.org; Wed, 26 Dec 2012 18:35:58 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/6] media: sh_mobile_ceu_camera: fix CSI2 format negotiation
Date: Wed, 26 Dec 2012 18:35:53 +0100
Message-Id: <1356543358-6180-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CSI-2 format negotiation has been broken by a changed order of driver
probing. Fix this by allowing an early CSI2 discovery during format
enumeration.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index cc46b65..cf65e7f 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1052,7 +1052,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		return 0;
 	}
 
-	if (!pcdev->csi2_pdev) {
+	if (!pcdev->pdata || !pcdev->pdata->csi2) {
 		/* Are there any restrictions in the CSI-2 case? */
 		ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
 		if (ret < 0)
-- 
1.7.2.5

