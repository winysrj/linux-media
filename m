Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:51794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab1CWKEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 06:04:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 99DA4189B85
	for <linux-media@vger.kernel.org>; Wed, 23 Mar 2011 11:04:35 +0100 (CET)
Date: Wed, 23 Mar 2011 11:04:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: imx074: return a meaningful error code instead of -1
Message-ID: <Pine.LNX.4.64.1103231104000.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/imx074.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 1a11691..0382ea7 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -298,7 +298,7 @@ static unsigned long imx074_query_bus_param(struct soc_camera_device *icd)
 static int imx074_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
-	return -1;
+	return -EINVAL;
 }
 
 static struct soc_camera_ops imx074_ops = {
-- 
1.7.2.5

