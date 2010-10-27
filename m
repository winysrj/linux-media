Return-path: <mchehab@pedra>
Received: from tango.tkos.co.il ([62.219.50.35]:39693 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0J0HEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 03:04:45 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] mx2_camera: fix pixel clock polarity configuration
Date: Wed, 27 Oct 2010 09:03:52 +0200
Message-Id: <a54ec7e539912fd6009803cffa331b028fdb9a67.1288162873.git.baruch@tkos.co.il>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

When SOCAM_PCLK_SAMPLE_FALLING, just leave CSICR1_REDGE unset, otherwise we get
the inverted behaviour.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/video/mx2_camera.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 3ea2ec0..02f144f 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -811,8 +811,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
 
 	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
 		csicr1 |= CSICR1_REDGE;
-	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
-		csicr1 |= CSICR1_INV_PCLK;
 	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_SOF_POL;
 	if (common_flags & SOCAM_HSYNC_ACTIVE_HIGH)
-- 
1.7.1

