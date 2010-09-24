Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60405 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab0IXOOo (ORCPT
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
Subject: [PATCH 14/16] ivtv: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:12 +0200
Message-Id: <1285337654-5044-15-git-send-email-laurent.pinchart@ideasonboard.com>
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
a module aliases table with names corresponding to what the ivtv driver
uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ivtv/ivtv-i2c.c |   42 ++++++----------------------------
 1 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index d391bbd..d104c98 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -121,31 +121,6 @@ static const u8 hw_addrs[] = {
 };
 
 /* This array should match the IVTV_HW_ defines */
-static const char *hw_modules[] = {
-	"cx25840",
-	"saa7115",
-	"saa7127",
-	"msp3400",
-	"tuner",
-	"wm8775",
-	"cs53l32a",
-	NULL,
-	"saa7115",
-	"upd64031a",
-	"upd64083",
-	"saa717x",
-	"wm8739",
-	"vp27smpx",
-	"m52790",
-	NULL,
-	NULL,		/* IVTV_HW_I2C_IR_RX_AVER */
-	NULL,		/* IVTV_HW_I2C_IR_RX_HAUP_EXT */
-	NULL,		/* IVTV_HW_I2C_IR_RX_HAUP_INT */
-	NULL,		/* IVTV_HW_Z8F0811_IR_TX_HAUP */
-	NULL,		/* IVTV_HW_Z8F0811_IR_RX_HAUP */
-};
-
-/* This array should match the IVTV_HW_ defines */
 static const char * const hw_devicenames[] = {
 	"cx25840",
 	"saa7115",
@@ -256,7 +231,6 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 {
 	struct v4l2_subdev *sd;
 	struct i2c_adapter *adap = &itv->i2c_adap;
-	const char *mod = hw_modules[idx];
 	const char *type = hw_devicenames[idx];
 	u32 hw = 1 << idx;
 
@@ -265,17 +239,17 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 	if (hw == IVTV_HW_TUNER) {
 		/* special tuner handling */
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, mod, type,
+				adap, NULL, type,
 				0, itv->card_i2c->radio);
 		if (sd)
 			sd->grp_id = 1 << idx;
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, mod, type,
+				adap, NULL, type,
 				0, itv->card_i2c->demod);
 		if (sd)
 			sd->grp_id = 1 << idx;
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, mod, type,
+				adap, NULL, type,
 				0, itv->card_i2c->tv);
 		if (sd)
 			sd->grp_id = 1 << idx;
@@ -292,16 +266,17 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 	/* It's an I2C device other than an analog tuner or IR chip */
 	if (hw == IVTV_HW_UPD64031A || hw == IVTV_HW_UPD6408X) {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, mod, type, 0, I2C_ADDRS(hw_addrs[idx]));
+				adap, NULL, type, 0, I2C_ADDRS(hw_addrs[idx]));
 	} else if (hw == IVTV_HW_CX25840) {
 		struct cx25840_platform_data pdata;
 
 		pdata.pvr150_workaround = itv->pvr150_workaround;
 		sd = v4l2_i2c_new_subdev_cfg(&itv->v4l2_dev,
-				adap, mod, type, 0, &pdata, hw_addrs[idx], NULL);
+				adap, NULL, type, 0, &pdata, hw_addrs[idx],
+				NULL);
 	} else {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, mod, type, hw_addrs[idx], NULL);
+				adap, NULL, type, hw_addrs[idx], NULL);
 	}
 	if (sd)
 		sd->grp_id = 1 << idx;
@@ -705,8 +680,7 @@ int init_ivtv_i2c(struct ivtv *itv)
 	/* Sanity checks for the I2C hardware arrays. They must be the
 	 * same size.
 	 */
-	if (ARRAY_SIZE(hw_devicenames) != ARRAY_SIZE(hw_addrs) ||
-	    ARRAY_SIZE(hw_devicenames) != ARRAY_SIZE(hw_modules)) {
+	if (ARRAY_SIZE(hw_devicenames) != ARRAY_SIZE(hw_addrs)) {
 		IVTV_ERR("Mismatched I2C hardware arrays\n");
 		return -ENODEV;
 	}
-- 
1.7.2.2

