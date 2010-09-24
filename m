Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60405 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab0IXOOn (ORCPT
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
Subject: [PATCH 12/16] vpif_display: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:10 +0200
Message-Id: <1285337654-5044-13-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, don't use the module names hardcoded in platform
data by passing a NULL module name to those functions.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the vpif_display
platform data uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/davinci/vpif_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 912c27b..2523a7f 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1552,7 +1552,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	for (i = 0; i < subdev_count; i++) {
 		vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
-						i2c_adap, subdevdata[i].name,
+						i2c_adap, NULL,
 						&subdevdata[i].board_info,
 						NULL);
 		if (!vpif_obj.sd[i]) {
-- 
1.7.2.2

