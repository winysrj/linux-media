Return-path: <mchehab@pedra>
Received: from mail.visioncatalog.com ([217.6.246.34]:45626 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab1DFOGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 10:06:07 -0400
Received: from idefix.phytec.de (idefix.phytec.de [172.16.0.10])
	by root.phytec.de (Postfix) with ESMTP id BDF81BF08A
	for <linux-media@vger.kernel.org>; Wed,  6 Apr 2011 16:08:03 +0200 (CEST)
From: =?UTF-8?q?Teresa=20G=C3=A1mez?= <t.gamez@phytec.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Teresa=20G=C3=A1mez?= <t.gamez@phytec.de>
Subject: [PATCH 1/2] mt9v022: fix pixel clock
Date: Wed, 6 Apr 2011 16:01:54 +0200
Message-Id: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Measurements show that the setup of the pixel clock is not correct.
The 'Invert Pixel Clock' bit has to be set to 1 for falling edge
and not for rising.

Signed-off-by: Teresa Gámez <t.gamez@phytec.de>
---
 drivers/media/video/mt9v022.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 6a784c8..dec2a69 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -228,7 +228,7 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 
 	flags = soc_camera_apply_sensor_flags(icl, flags);
 
-	if (flags & SOCAM_PCLK_SAMPLE_RISING)
+	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
 		pixclk |= 0x10;
 
 	if (!(flags & SOCAM_HSYNC_ACTIVE_HIGH))
-- 
1.7.0.4

