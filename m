Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50646 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367Ab2J3MQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 08:16:51 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so82711eaa.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 05:16:49 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, fabio.estevam@freescale.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/4] media: mx2_camera: Add image size HW limits.
Date: Tue, 30 Oct 2012 13:16:33 +0100
Message-Id: <1351599395-16833-3-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI has some constraints regarding image with.
This patch makes sure those requirements are met
in try_fmt().

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index e1b44b1..bf1178c 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1234,7 +1234,11 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	/* FIXME: implement MX27 limits */
+	/*
+	 * With must be multiple of 8 as requested by the CSI.
+	 * (Table 39-2 in the i.MX27 Reference Manual).
+	 */
+	pix->width &= ~0x7;
 
 	/* limit to sensor capabilities */
 	mf.width	= pix->width;
-- 
1.7.9.5

