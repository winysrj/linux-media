Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:6257
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759443Ab2EUWKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 18:10:42 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <g.liakhovetski@gmx.de>
CC: <mchehab@infradead.org>, <javier.martin@vista-silicon.com>,
	<linux-media@vger.kernel.org>, <kernel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] video: mx2_camera: Fix build error due to the lack of 'pixfmt' definition
Date: Mon, 21 May 2012 19:10:27 -0300
Message-ID: <1337638227-20379-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit d509835 ([media] media: mx2_camera: Fix mbus format handling) caused
the following build error:

drivers/media/video/mx2_camera.c:1032:42: error: 'pixfmt' undeclared (first use in this function)
make[4]: *** [drivers/media/video/mx2_camera.o] Error 1

Fix this build error by providing a 'pixfmt' definition.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx2_camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ded26b7..ef72733 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -989,6 +989,7 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 	int ret;
 	int bytesperline;
 	u32 csicr1 = pcdev->csicr1;
+	u32 pixfmt = icd->current_fmt->host_fmt->fourcc;
 
 	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
 	if (!ret) {
-- 
1.7.1


