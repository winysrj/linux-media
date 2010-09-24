Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60404 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab0IXOOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:42 -0400
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
Subject: [PATCH 11/16] vpfe_capture: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:09 +0200
Message-Id: <1285337654-5044-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, don't use the module names hardcoded in platform
data by passing a NULL module name to those functions.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the vpfe_capture
platform data uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index b391125..5d90fb0 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1986,7 +1986,7 @@ static __init int vpfe_probe(struct platform_device *pdev)
 		vpfe_dev->sd[i] =
 			v4l2_i2c_new_subdev_board(&vpfe_dev->v4l2_dev,
 						  i2c_adap,
-						  sdinfo->name,
+						  NULL,
 						  &sdinfo->board_info,
 						  NULL);
 		if (vpfe_dev->sd[i]) {
-- 
1.7.2.2

