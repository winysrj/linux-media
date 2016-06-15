Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36702 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161143AbcFOWbG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 18:31:06 -0400
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee.jones@linaro.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [PATCH 2/3] staging: media: omap1: fix sensor probe not working anymore
Date: Thu, 16 Jun 2016 00:29:49 +0200
Message-Id: <1466029790-31094-3-git-send-email-jmkrzyszt@gmail.com>
In-Reply-To: <1466029790-31094-1-git-send-email-jmkrzyszt@gmail.com>
References: <1466029790-31094-1-git-send-email-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After clock_start() removal from from soc_camera_probe() (commit
9aea470b39 '[media] soc-camera: switch I2C subdevice drivers to use
v4l2-clk', introduced in v3.11), it occurred omap1_camera's sensor
can't be probed successfully without its clock being turned on in
advance. Fix that by surrounding soc_camera_host_register() invocation
with clock_start() / clock_stop().

Created and tested on Amstrad Delta against Linux-4.7-rc3 with
'staging: media: omap1: fix null pointer dereference in
omap1_cam_probe()' applied.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/staging/media/omap1/omap1_camera.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap1/omap1_camera.c b/drivers/staging/media/omap1/omap1_camera.c
index dc35d30..9b6140a 100644
--- a/drivers/staging/media/omap1/omap1_camera.c
+++ b/drivers/staging/media/omap1/omap1_camera.c
@@ -1650,7 +1650,11 @@ static int omap1_cam_probe(struct platform_device *pdev)
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
 
-	err = soc_camera_host_register(&pcdev->soc_host);
+	err = omap1_cam_clock_start(&pcdev->soc_host);
+	if (!err) {
+		err = soc_camera_host_register(&pcdev->soc_host);
+		omap1_cam_clock_stop(&pcdev->soc_host);
+	}
 	if (err)
 		return err;
 
-- 
2.7.3

