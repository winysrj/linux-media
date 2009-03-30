Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51049 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751013AbZC3OzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 10:55:16 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1LoItZ-00020O-7Q
	for linux-media@vger.kernel.org; Mon, 30 Mar 2009 16:55:25 +0200
Date: Mon, 30 Mar 2009 16:55:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] mt9m001: fix advertised pixel clock polarity
Message-ID: <Pine.LNX.4.64.0903301654000.4455@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MT9M001 datasheet says, that the data is ready on the falling edge of the pixel
clock, but the driver wrongly sets the SOCAM_PCLK_SAMPLE_RISING flag. Changing
this doesn't seem to produce any visible difference, still, it is better to
comply to the datasheet.

Reported-by: Sascha Oppermann <oppermann@garage-computers.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Objections?

 drivers/media/video/mt9m001.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index fa7e509..684f62f 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -207,7 +207,7 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
 	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
 	/* MT9M001 has all capture_format parameters fixed */
-	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING |
+	unsigned long flags = SOCAM_PCLK_SAMPLE_FALLING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
 		SOCAM_DATA_ACTIVE_HIGH | SOCAM_MASTER;
 
-- 
1.5.4

