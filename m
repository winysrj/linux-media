Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64537 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab3CTPEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 11:04:37 -0400
Received: by mail-wi0-f172.google.com with SMTP id ez12so5401639wid.5
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 08:04:35 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 16:04:35 +0100
Message-ID: <CACKLOr28HKiEiC6mkhsR2vQGMqVZ1KL_YMc5o0tf=zkroQgwrQ@mail.gmail.com>
Subject: [RFC] mt9m131/mt9m111 manual exposure control.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?ISO-8859-1?Q?Beno=EEt_Th=E9baudeau?=
	<benoit.thebaudeau@advansee.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
the attached patch, adds support for manual exposure control for
sensor mt9m111.
For this purpose, the register 0x009 (Shutter width) is written with
values from 0x0000 to 0xffff.

In order to test this, an mt9m131 sensor was connected to a DM3730
(omap3isp). Using yavta to capture some frames, the results are quite
surprising. Only the second frame read from the sensor has the desired
exposure time, the other frames just keep the default exposure time.

Moreover, it seems this behaviour does not change no matter I
enable/disable autoexposure.

I just wanted to make it public just in case anyone feels like giving
a try to the patch.
Regards.

---
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c
b/drivers/media/i2c/soc_camera/mt9m111.c
index 9a4b8b0..a752be5 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -710,6 +710,13 @@ static int mt9m111_set_autoexposure(struct
mt9m111 *mt9m111, int on)
        return reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
 }

+static int mt9m111_set_exposure(struct mt9m111 *mt9m111, int val)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+
+       return reg_write(SHUTTER_WIDTH, val);
+}
+
 static int mt9m111_set_autowhitebalance(struct mt9m111 *mt9m111, int on)
 {
        struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
@@ -735,6 +742,8 @@ static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
                return mt9m111_set_global_gain(mt9m111, ctrl->val);
        case V4L2_CID_EXPOSURE_AUTO:
                return mt9m111_set_autoexposure(mt9m111, ctrl->val);
+       case V4L2_CID_EXPOSURE:
+               return mt9m111_set_exposure(mt9m111, ctrl->val);
        case V4L2_CID_AUTO_WHITE_BALANCE:
                return mt9m111_set_autowhitebalance(mt9m111, ctrl->val);
        }
@@ -1080,6 +1089,8 @@ static int mt9m111_probe(struct i2c_client *client,

        v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
        v4l2_ctrl_handler_init(&mt9m111->hdl, 5);
+        v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops, V4L2_CID_EXPOSURE,
+                       1, 0xffff, 1, 0x219);
        v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
                        V4L2_CID_VFLIP, 0, 1, 1, 0);
        v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
