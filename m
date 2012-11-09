Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56529 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2KIIOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 03:14:33 -0500
Message-ID: <509CBB61.40206@gmail.com>
Date: Fri, 09 Nov 2012 09:14:25 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Andrey Gusakov <dron0gus@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com> <5096C561.5000108@gmail.com> <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com> <5096E8D7.4070304@gmail.com> <CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com> <50979998.8090809@gmail.com> <CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com> <50983CFD.2030104@gmail.com> <CAA11ShDAscm8snYzjnC3Fe1MaVXc-FJqhWM677iJwgbgu2_J1Q@mail.gmail.com> <509AD957.5070301@gmail.com> <CAA11ShCn3S_nxXg5_pAsgcMsPFpER7XrHsvg71DrznAmONu7Lg@mail.gmail.com>
In-Reply-To: <CAA11ShCn3S_nxXg5_pAsgcMsPFpER7XrHsvg71DrznAmONu7Lg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/08/2012 07:47 PM, Andrey Gusakov wrote:
>> Ok, thanks. I will add the missing CONFIG_PM_RUNTIME dependency in Kconfig.
>> The driver has to have PM_RUNTIME enabled since on s3c64xx SoCs there are
>> power domains and the camera power domain needs to be enabled for the CAMIF
>> operation. The pm_runtime_* calls in the driver are supposed to ensure that.
>> I wonder why it works for you without PM_RUNTIME, i.e. how comes the power
>> domain is enabled. It is supposed to be off by default.
> DS says that all power domaint are on after reset. My bootloader did
> not switch then off. So when linux start everything is on.
> CONFIG_PM_RUNTIME was disabled, so nothing switch them off in linux
> too.

Yes, indeed. But there was a PM code added that is supposed to disable all
unused power domains on the system boot. I noticed that one needs to call
explicitly s3c64xx_pm_init() function from machine_init() callback within
the board file. So far this function is called only in mach-crag6410.c.
I'm not sure it it won't kill the display if you use it though. Probably
PM domain state should be read from a respective register and this
information passed to pm_genpd_init() function within s3c64_pm_init().

>>>> I hope to eventually prepare the ov9650 sensor driver for mainline. Your
>>>> help in making it ready for VER=0x52 would be very much appreciated. :-)
>>>
>>> I'll try to helpful.
>>>
>>>
>>>>> Next step is to make ov2460 work.
>>>>
>>>> For now I can only recommend you to make the ov2460 driver more similar
>>>> to the ov9650 one.
>>>
>>> Thanks, I'll try.
>>>
>>> P.S. I add support of image effects just for fun. And found in DS that
>>> s3c2450 also support effects. It's FIMC in-between of 2440 and
>>> 6400/6410. Does anyone have s3c2450 hardware to test it?
>
>> Patches adding image effect are welcome. I'm bit to busy to play with these
>> things, other than I don't have hardware to test it.
>> I wasn't really aware of CAMIF in s3c2450. I think a separate variant data
>> structure would need to be defined for s3c2450. If anyone ever needs it
>> it could be added easily. For now I'll pretend this version doesn't exist.
>> :-)
> Attached.
>
> I often get "VIDIOC_QUERYCAP: failed: Inappropriate ioctl for device"

This is an issue in the v4l2-ctl, it is going to be fixed by adding
VIDIOC_SUBDEV_QUERYCAP ioctl for subdevs. It has been just discussed today.
I guess you get it when running v4l2-ctl on /dev/v4l-subdev* ?

> or "system error: Inappropriate ioctl for device"

I think this one is caused by unimplemented VIDIOC_G/S_PARM ioctls
at the s3c-camif driver.

> Is it because of not implemented set/get framerate func? How this

Yes, I think so. ioctls as above.

> should work? I mean framerate heavy depend of sensor's settings. So
> set/get framerate call to fimc should get/set framerate from sensor.
> What is mechanism of such things?

With user space subdev API one should control frame interval directly
on the sensor subdev device node [1]. For Gstreamer to work with
VIDIOC_G/S_PARM ioctls we need a dedicated v4l2 library (possibly with
a plugin for s3c-camif, but that shouldn't be needed since it is very
simple driver) that will translate those video node ioctls into the
subdev node ioctls [2]. Unfortunately such library is still not available.

> And same question about synchronizing format of sensor and FIMC pads.
> I make ov2640 work, but if did not call media-ctl for sensor, format
> of FIMC sink pad and format of sensor source pad different. I think I
> missed something, but reading other sources did not help.

As I explained previously, s3c-fimc is supposed to synchronize format
with the sensor subdev. Have you got pad level get_fmt callback
implemented in the ov2640 driver ?
Could you post your 'media-ctl -p' output, run right after the system boot ?

[1] 
http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-subdev-g-frame-interval.html
[2] http://git.linuxtv.org/v4l-utils.git/tree/
-----------------------------------------------------------------------------

 From 04b88737f65f772f8b375234a92c7cdd481eac1b Mon Sep 17 00:00:00 2001
From: Andrey Gusakov <dron_gus@mail.ru>
Date: Mon, 5 Nov 2012 15:50:23 +0400
Subject: [PATCH] S3C-FIMC: add effect controls

SN:
I prefer using s3c-camif name, FIMC appears only in later version of
the SoCs. Also would be nice to put at least some brief description why
this patch is needed.

Signed-off-by: Andrey Gusakov <dron_gus@mail.ru>
---
  drivers/media/platform/s3c-camif/camif-capture.c |   58 
++++++++++++++++++++--
  drivers/media/platform/s3c-camif/camif-core.h    |    5 ++
  drivers/media/platform/s3c-camif/camif-regs.c    |   38 ++++++++++----
  drivers/media/platform/s3c-camif/camif-regs.h    |    6 ++-
  4 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c 
b/drivers/media/platform/s3c-camif/camif-capture.c
index ca31c45..046ebf6 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -81,6 +81,9 @@ static int s3c_camif_hw_init(struct camif_dev *camif, 
struct camif_vp *vp)
  	camif_hw_set_source_format(camif);
  	camif_hw_set_camera_crop(camif);
  	camif_hw_set_test_pattern(camif, camif->test_pattern->val);
+	if (ip_rev >= S3C2450_CAMIF_IP_REV)
+		camif_hw_set_effect(camif, camif->effect->val,
+				camif->effect_cr->val, camif->effect_cb->val);
  	if (ip_rev == S3C6410_CAMIF_IP_REV)
  		camif_hw_set_input_path(vp);
  	camif_cfg_video_path(vp);
@@ -108,8 +111,8 @@ static int s3c_camif_hw_vp_init(struct camif_dev 
*camif, struct camif_vp *vp)
  	if (ip_rev == S3C244X_CAMIF_IP_REV)
  		camif_hw_clear_fifo_overflow(vp);
  	camif_cfg_video_path(vp);
-	if (ip_rev == S3C6410_CAMIF_IP_REV)
-		camif_hw_set_effect(vp, false);
+	if (ip_rev >= S3C2450_CAMIF_IP_REV)
+		camif_hw_set_effect(camif, 0, 0, 0);
  	vp->state &= ~ST_VP_CONFIG;

  	spin_unlock_irqrestore(&camif->slock, flags);
@@ -374,6 +377,10 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
  		camif_hw_set_scaler(vp);
  		camif_hw_set_flip(vp);
  		camif_hw_set_test_pattern(camif, camif->test_pattern->val);
+		if (ip_rev >= S3C2450_CAMIF_IP_REV)
+			camif_hw_set_effect(camif, camif->effect->val,
+					camif->effect_cr->val,
+					camif->effect_cb->val);
  		vp->state &= ~ST_VP_CONFIG;
  	}
  unlock:
@@ -1530,7 +1537,7 @@ static const struct v4l2_ctrl_ops 
s3c_camif_subdev_ctrl_ops = {
  	.s_ctrl	= s3c_camif_subdev_s_ctrl,
  };

-static const struct v4l2_ctrl_config s3c_camif_priv_ctrl = {
+static const struct v4l2_ctrl_config s3c_camif_priv_ctrl_test = {
  	.ops	= &s3c_camif_subdev_ctrl_ops,
  	.id	= V4L2_CTRL_CLASS_USER | 0x1001,
  	.type	= V4L2_CTRL_TYPE_INTEGER,
@@ -1541,6 +1548,39 @@ static const struct v4l2_ctrl_config 
s3c_camif_priv_ctrl = {
  	.def	= 0,
  };

+static const struct v4l2_ctrl_config s3c_camif_priv_ctrl_eff = {
+	.ops	= &s3c_camif_subdev_ctrl_ops,
+	.id	= V4L2_CTRL_CLASS_USER | 0x1002,
+	.type	= V4L2_CTRL_TYPE_INTEGER,
+	.name	= "Effect",
+	.min	= 0,
+	.max	= 5,
+	.step	= 1,
+	.def	= 0,
+};
+
+static const struct v4l2_ctrl_config s3c_camif_priv_ctrl_eff_cb = {
+	.ops	= &s3c_camif_subdev_ctrl_ops,
+	.id	= V4L2_CTRL_CLASS_USER | 0x1003,
+	.type	= V4L2_CTRL_TYPE_INTEGER,
+	.name	= "PAT_Cb",
+	.min	= 16,
+	.max	= 240,
+	.step	= 1,
+	.def	= 128,
+};
+
+static const struct v4l2_ctrl_config s3c_camif_priv_ctrl_eff_cr = {
+	.ops	= &s3c_camif_subdev_ctrl_ops,
+	.id	= V4L2_CTRL_CLASS_USER | 0x1004,
+	.type	= V4L2_CTRL_TYPE_INTEGER,
+	.name	= "PAT_Cr",
+	.min	= 16,
+	.max	= 240,
+	.step	= 1,
+	.def	= 128,
+};

SN:
There is no need to create these 3 private controls, we have now standard
controls for this image effect. Can you rework it to use V4L2_CID_COLORFX
and V4L2_CID_COLORFX_CBCR controls ? Not used option of V4L2_CID_COLORFX
can be easily masked off by passing proper mask to v4l2_ctrl_new_std().
Unfortunately the CB/CR coefficients will have fixed min and max values
then - 0, 255. That shouldn't be a big issue though.

AFAICT the range for CB/CR depends on the CSCR2Y_c bit which means:

"YCbCr Data Dynamic Range Selection for the Color Space Conversion RGB
to YCbCr"

CSCR2Y_c	1 : Wide => Y/Cb/Cr (0 ~ 255) : Wide default
		0 : Narrow => Y (16 ~ 235), Cb/Cr (16 ~ 240)

By default CSCR2Y_c bit is set so we get 0 ~ 255 range.


  int s3c_camif_create_subdev(struct camif_dev *camif)
  {
  	struct v4l2_ctrl_handler *handler = &camif->ctrl_handler;
@@ -1560,10 +1600,18 @@ int s3c_camif_create_subdev(struct camif_dev *camif)
  	if (ret)
  		return ret;

-	v4l2_ctrl_handler_init(handler, 1);
+	v4l2_ctrl_handler_init(handler, 4);
  	camif->test_pattern = v4l2_ctrl_new_custom(handler,
-					&s3c_camif_priv_ctrl, NULL);
+					&s3c_camif_priv_ctrl_test, NULL);
+	camif->effect = v4l2_ctrl_new_custom(handler,
+					&s3c_camif_priv_ctrl_eff, NULL);
+	camif->effect_cr = v4l2_ctrl_new_custom(handler,
+					&s3c_camif_priv_ctrl_eff_cb, NULL);
+	camif->effect_cb = v4l2_ctrl_new_custom(handlerEffect,
+					&s3c_camif_priv_ctrl_eff_cr, NULL);
+
  	if (handler->error) {
+		v4l2_ctrl_handler_free(handler);
  		media_entity_cleanup(&sd->entity);
  		return handler->error;
  	}
diff --git a/drivers/media/platform/s3c-camif/camif-core.h 
b/drivers/media/platform/s3c-camif/camif-core.h
index 96f5d3d..5f9eb3a 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -39,6 +39,8 @@
  #define CAMIF_STOP_TIMEOUT	1500 /* ms */

  #define S3C244X_CAMIF_IP_REV	0x20 /* 2.0 */
+#define S3C2450_CAMIF_IP_REV	0x30 /* 3.0 - not implemented, not tested */
+#define S3C6400_CAMIF_IP_REV	0x31 /* 3.1 - not implemented, not tested */
  #define S3C6410_CAMIF_IP_REV	0x32 /* 3.2 */

  /* struct camif_vp::state */
@@ -277,6 +279,9 @@ struct camif_dev {

  	struct v4l2_ctrl_handler	ctrl_handler;
  	struct v4l2_ctrl		*test_pattern;
+	struct v4l2_ctrl		*effect;
+	struct v4l2_ctrl		*effect_cb;
+	struct v4l2_ctrl		*effect_cr;

As explained above 2 controls can be used instead.

  	struct camif_vp			vp[CAMIF_VP_NUM];
  	struct vb2_alloc_ctx		*alloc_ctx;
diff --git a/drivers/media/platform/s3c-camif/camif-regs.c 
b/drivers/media/platform/s3c-camif/camif-regs.c
index d8c55dc..1b03f73 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.c
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -57,6 +57,33 @@ void camif_hw_set_test_pattern(struct camif_dev 
*camif, unsigned int pattern)
  	camif_write(camif, S3C_CAMIF_REG_CIGCTRL, cfg);
  }

+void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
+			unsigned int cr, unsigned int cb)
+{
+	u32 cfg;
+
+	if (camif->variant->ip_revision < S3C2450_CAMIF_IP_REV)
+		return;

I think you can remove this check. Since camif_hw_set_effect() is always
called conditionally.

+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIIMGEFF(camif->vp->offset));
+	/* Set effect */
+	cfg &= ~CIIMGEFF_FIN_MASK;
+	cfg |= (effect << 26);
+	/* Set both paths */
+	if (camif->variant->ip_revision >= S3C6400_CAMIF_IP_REV) {
+		if (effect)
+			cfg |= CIIMGEFF_IE_ENABLE_MASK;
+		else
+			cfg &= ~CIIMGEFF_IE_ENABLE_MASK;
+	}
+	/* Set Cr, Cb */
+	if (effect == CIIMGEFF_FIN_ARBITRARY) {
+		cfg &= ~CIIMGEFF_PAT_CBCR_MASK;
+		cfg |= ((cb & 0xFF) << 13) | (cr & 0xFF);

Can you please use lower case for hex numbers ?

+	}
+	camif_write(camif, S3C_CAMIF_REG_CIIMGEFF(camif->vp->offset), cfg);
+}
+
  static const u32 src_pixfmt_map[8][2] = {
  	{ V4L2_MBUS_FMT_YUYV8_2X8, CISRCFMT_ORDER422_YCBYCR },
  	{ V4L2_MBUS_FMT_YVYU8_2X8, CISRCFMT_ORDER422_YCRYCB },
@@ -473,17 +500,6 @@ void camif_hw_set_lastirq(struct camif_vp *vp, int 
enable)
  	camif_write(vp->camif, addr, cfg);
  }

-void camif_hw_set_effect(struct camif_vp *vp, bool active)
-{
-	u32 cfg = 0;
-
-	if (active) {
-		/* TODO: effects support on 64xx */
-	}
-
-	camif_write(vp->camif, S3C_CAMIF_REG_CIIMGEFF, cfg);
-}
-
  void camif_hw_enable_capture(struct camif_vp *vp)
  {
  	struct camif_dev *camif = vp->camif;
diff --git a/drivers/media/platform/s3c-camif/camif-regs.h 
b/drivers/media/platform/s3c-camif/camif-regs.h
index a3488ca..213adbc 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.h
+++ b/drivers/media/platform/s3c-camif/camif-regs.h
@@ -177,8 +177,9 @@
  #define S3C_CAMIF_REG_CICPTSEQ			0xc4

  /* Image effects */
-#define S3C_CAMIF_REG_CIIMGEFF			0xd0
+#define S3C_CAMIF_REG_CIIMGEFF(_offs)		(0xb0 + (_offs))
  #define  CIIMGEFF_IE_ENABLE(id)			(1 << (30 + (id)))
+#define  CIIMGEFF_IE_ENABLE_MASK		(3 << 30)
  /* Image effect: 1 - after scaler, 0 - before scaler */
  #define  CIIMGEFF_IE_AFTER_SC			(1 << 29)
  #define  CIIMGEFF_FIN_MASK			(7 << 26)
@@ -243,7 +244,6 @@ void camif_hw_clear_fifo_overflow(struct camif_vp *vp);
  void camif_hw_set_lastirq(struct camif_vp *vp, int enable);
  void camif_hw_set_input_path(struct camif_vp *vp);
  void camif_hw_enable_scaler(struct camif_vp *vp, bool on);
-void camif_hw_set_effect(struct camif_vp *vp, bool active);
  void camif_hw_enable_capture(struct camif_vp *vp);
  void camif_hw_disable_capture(struct camif_vp *vp);
  void camif_hw_set_camera_bus(struct camif_dev *camif);
@@ -254,6 +254,8 @@ void camif_hw_set_flip(struct camif_vp *vp);
  void camif_hw_set_output_dma(struct camif_vp *vp);
  void camif_hw_set_target_format(struct camif_vp *vp);
  void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int 
pattern);
+void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
+			unsigned int cr, unsigned int cb);
  void camif_hw_set_output_addr(struct camif_vp *vp, struct camif_addr 
*paddr,
  			      int index);
  void camif_hw_dump_regs(struct camif_dev *camif, const char *label);
-- 1.7.0.4


Otherwise looks good.

--
Thanks,
Sylwester
