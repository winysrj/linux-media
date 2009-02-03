Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.renesas.com ([202.234.163.13]:40647 "EHLO
	mail06.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609AbZBTBx4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 20:53:56 -0500
Date: Tue, 03 Feb 2009 14:51:44 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH] ov772x: use soft sleep mode in stop_capture
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media <linux-media@vger.kernel.org>
Message-id: <umychzxe9.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
 drivers/media/video/ov772x.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 681a11b..6889fa8 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -646,6 +646,8 @@ static int ov772x_start_capture(struct soc_camera_device *icd)
 		return -EPERM;
 	}
 
+	ov772x_mask_set(priv->client, COM2, SOFT_SLEEP_MODE, 0);
+
 	dev_dbg(&icd->dev,
 		 "format %s, win %s\n", priv->fmt->name, priv->win->name);
 
@@ -654,6 +656,8 @@ static int ov772x_start_capture(struct soc_camera_device *icd)
 
 static int ov772x_stop_capture(struct soc_camera_device *icd)
 {
+	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	ov772x_mask_set(priv->client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
 	return 0;
 }
 
-- 
1.5.6.3

