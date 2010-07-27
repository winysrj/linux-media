Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:34851 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab0G0FFC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 01:05:02 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] mx2_camera: fix type of dma buffer virtual address pointer
Date: Tue, 27 Jul 2010 08:03:30 +0300
Message-Id: <2a17cba0d337a8805a37471986f9c4a0f5945e1c.1280206807.git.baruch@tkos.co.il>
In-Reply-To: <20100726120008.GR14113@pengutronix.de>
References: <20100726120008.GR14113@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/video/mx2_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 98c93fa..026bef0 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -238,7 +238,7 @@ struct mx2_camera_dev {
 
 	u32			csicr1;
 
-	void __iomem		*discard_buffer;
+	void			*discard_buffer;
 	dma_addr_t		discard_buffer_dma;
 	size_t			discard_size;
 };
-- 
1.7.1

