Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60404 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab0IXOOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:43 -0400
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
Subject: [PATCH 13/16] vpif_capture: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:11 +0200
Message-Id: <1285337654-5044-14-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, don't use the module names hardcoded in platform
data by passing a NULL module name to those functions.

The only platform using the VPIF capture device (DM646x EVM) hardcodes
the module names to invalid values (tvp514x-0 and tvp514x-1). As this is
already broken, there's no risk of breaking it more.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/davinci/vpif_capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 730bd4c..4b8e70c 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -2012,7 +2012,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		vpif_obj.sd[i] =
 			v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
 						  i2c_adap,
-						  subdevdata->name,
+						  NULL,
 						  &subdevdata->board_info,
 						  NULL);
 
-- 
1.7.2.2

