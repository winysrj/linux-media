Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60392 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab0IXOOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:37 -0400
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
Subject: [PATCH 01/16] v4l: Load I2C modules based on modalias
Date: Fri, 24 Sep 2010 16:13:59 +0200
Message-Id: <1285337654-5044-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

When creating a new sub-device, The V4L I2C subdev API has historically
required drivers to pass the name of the module that implements support
for the I2C device.

I2C modules can be loaded based on modaliases instead of the module
name. As the I2C device type name is already available to the
v4l2_i2c_new_subdev* functions, make the module name argument optional
and create a modalias based on the type name when no module name is
provided.

All in-tree drivers call those functions with a non-NULL module name
argument, this change is thus harmless.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 3ce7c64..120b4ac 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -378,6 +378,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 
 	if (module_name)
 		request_module(module_name);
+	else
+		request_module(I2C_MODULE_PREFIX "%s", info->type);
 
 	/* Create the i2c client */
 	if (info->addr == 0 && probe_addrs)
-- 
1.7.2.2

