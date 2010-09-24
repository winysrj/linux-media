Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60404 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab0IXOOl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [PATCH 09/16] radio-si4713: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:07 +0200
Message-Id: <1285337654-5044-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, replace the hardcoded module name passed to those
functions by NULL.

As no board seems to use this driver, no platform data has been checked.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/radio/radio-si4713.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 13554ab..045b10f 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -291,7 +291,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 		goto unregister_v4l2_dev;
 	}
 
-	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter, "si4713_i2c",
+	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter, NULL,
 					pdata->subdev_board_info, NULL);
 	if (!sd) {
 		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
-- 
1.7.2.2

