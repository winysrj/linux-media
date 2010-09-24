Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60404 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab0IXOOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:44 -0400
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
Subject: [PATCH 15/16] cx18: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:13 +0200
Message-Id: <1285337654-5044-16-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, replace the hardcoded module name passed to those
functions by NULL.

The sub-devices without a listed module name don't result in and I2C
sub-device being created, as they either are IR devices or don't have an
I2C address listed. It's thus safe to rely on modaliases only.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the cx18 driver
uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/cx18/cx18-i2c.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index 809f7d3..3b67984 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -71,19 +71,6 @@ static const u8 hw_bus[] = {
 };
 
 /* This array should match the CX18_HW_ defines */
-static const char * const hw_modules[] = {
-	"tuner",	/* CX18_HW_TUNER */
-	NULL,		/* CX18_HW_TVEEPROM */
-	"cs5345",	/* CX18_HW_CS5345 */
-	NULL,		/* CX18_HW_DVB */
-	NULL,		/* CX18_HW_418_AV */
-	NULL,		/* CX18_HW_GPIO_MUX */
-	NULL,		/* CX18_HW_GPIO_RESET_CTRL */
-	NULL,		/* CX18_HW_Z8F0811_IR_TX_HAUP */
-	NULL,		/* CX18_HW_Z8F0811_IR_RX_HAUP */
-};
-
-/* This array should match the CX18_HW_ defines */
 static const char * const hw_devicenames[] = {
 	"tuner",
 	"tveeprom",
@@ -125,7 +112,6 @@ int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 	struct v4l2_subdev *sd;
 	int bus = hw_bus[idx];
 	struct i2c_adapter *adap = &cx->i2c_adap[bus];
-	const char *mod = hw_modules[idx];
 	const char *type = hw_devicenames[idx];
 	u32 hw = 1 << idx;
 
@@ -135,15 +121,15 @@ int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 	if (hw == CX18_HW_TUNER) {
 		/* special tuner group handling */
 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
-				adap, mod, type, 0, cx->card_i2c->radio);
+				adap, NULL, type, 0, cx->card_i2c->radio);
 		if (sd != NULL)
 			sd->grp_id = hw;
 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
-				adap, mod, type, 0, cx->card_i2c->demod);
+				adap, NULL, type, 0, cx->card_i2c->demod);
 		if (sd != NULL)
 			sd->grp_id = hw;
 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
-				adap, mod, type, 0, cx->card_i2c->tv);
+				adap, NULL, type, 0, cx->card_i2c->tv);
 		if (sd != NULL)
 			sd->grp_id = hw;
 		return sd != NULL ? 0 : -1;
@@ -157,7 +143,8 @@ int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 		return -1;
 
 	/* It's an I2C device other than an analog tuner or IR chip */
-	sd = v4l2_i2c_new_subdev(&cx->v4l2_dev, adap, mod, type, hw_addrs[idx], NULL);
+	sd = v4l2_i2c_new_subdev(&cx->v4l2_dev, adap, NULL, type, hw_addrs[idx],
+				 NULL);
 	if (sd != NULL)
 		sd->grp_id = hw;
 	return sd != NULL ? 0 : -1;
-- 
1.7.2.2

