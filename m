Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34741 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1HaPjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 11:39:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: [PATCH] media: Add camera controls for the ov5642 driver
Date: Wed, 31 Aug 2011 17:39:42 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <alpine.DEB.2.02.1108171553540.17550@ipanema> <201108282006.09790.laurent.pinchart@ideasonboard.com> <CABYn4sx5jQPyLC4d6OfVbX5SSuS4TiNsB_LPoCheaOSbwM9Pzw@mail.gmail.com>
In-Reply-To: <CABYn4sx5jQPyLC4d6OfVbX5SSuS4TiNsB_LPoCheaOSbwM9Pzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311739.43057.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

On Wednesday 31 August 2011 17:27:49 Bastian Hecht wrote:
> 2011/8/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Wednesday 17 August 2011 18:02:07 Bastian Hecht wrote:
> >> The driver now supports automatic/manual gain, automatic/manual white
> >> balance, automatic/manual exposure control, vertical flip, brightness
> >> control, contrast control and saturation control. Additionally the
> >> following effects are available now: rotating the hue in the colorspace,
> >> gray scale image and solarize effect.
> > 
> > Any chance to port soc-camera to the control framework ? :-)
> 
> I redirect that to Guennadi :-)

Guennadi, do you have any update on this ? Hans posted patches early this 
year, do you know if there has been any work on them since then ?

> >> Signed-off-by: Bastian Hecht <hechtb@gmail.com>
> >> ---
> >> 
> >> diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
> >> index 1b40d90..069a720 100644
> >> --- a/drivers/media/video/ov5642.c
> >> +++ b/drivers/media/video/ov5642.c
> >> @@ -74,6 +74,34 @@
> >>  #define REG_AVG_WINDOW_END_Y_HIGH    0x5686
> >>  #define REG_AVG_WINDOW_END_Y_LOW     0x5687
> >> 
> >> +/* default values in native space */
> >> +#define DEFAULT_RBBALANCE            0x400
> >> +#define DEFAULT_CONTRAST             0x20
> >> +#define DEFAULT_SATURATION           0x40
> >> +
> >> +#define MAX_EXP_NATIVE                       0x01ffff
> >> +#define MAX_GAIN_NATIVE                      0x1f
> >> +#define MAX_RBBALANCE_NATIVE         0x0fff
> >> +#define MAX_EXP                              0xffff
> >> +#define MAX_GAIN                     0xff
> >> +#define MAX_RBBALANCE                        0xff
> >> +#define MAX_HUE_TRIG_NATIVE          0x80
> >> +
> >> +#define OV5642_CONTROL_BLUE_SATURATION       (V4L2_CID_PRIVATE_BASE +
> >> 0) +#define OV5642_CONTROL_RED_SATURATION        (V4L2_CID_PRIVATE_BASE
> >> + 1) +#define OV5642_CONTROL_GRAY_SCALE    (V4L2_CID_PRIVATE_BASE + 2)
> >> +#define OV5642_CONTROL_SOLARIZE              (V4L2_CID_PRIVATE_BASE +
> >> 3)
> > 
> > If I'm not mistaken V4L2_CID_PRIVATE_BASE is deprecated.
> 
> I checked at http://v4l2spec.bytesex.org/spec/x542.htm, googled
> "V4L2_CID_PRIVATE_BASE deprecated" and read
> Documentation/feature-removal-schedule.txt. I couldn't find anything.
> If it is deprecated, do you have an idea how to offer device specific
> features to the user?

The basic idea is that controls should be standardized, or at least documented 
and added to the V4L2 spec. Controls should belong to a class, so you should 
select the proper base class and add a big offset (I've used 0x1000) in the 
meantime if you want to export private controls.

> >> +
> >> +#define EXP_V4L2_TO_NATIVE(x) ((x) << 4)
> >> +#define EXP_NATIVE_TO_V4L2(x) ((x) >> 4)
> >> +#define GAIN_V4L2_TO_NATIVE(x) ((x) * MAX_GAIN_NATIVE / MAX_GAIN)
> >> +#define GAIN_NATIVE_TO_V4L2(x) ((x) * MAX_GAIN / MAX_GAIN_NATIVE)
> >> +#define RBBALANCE_V4L2_TO_NATIVE(x) ((x) * MAX_RBBALANCE_NATIVE /
> >> MAX_RBBALANCE) +#define RBBALANCE_NATIVE_TO_V4L2(x) ((x) * MAX_RBBALANCE
> >> / MAX_RBBALANCE_NATIVE) +
> >> +/* flaw in the datasheet. we need some extra lines */
> >> +#define MANUAL_LONG_EXP_SAFETY_DISTANCE      20
> >> +
> >>  /* active pixel array size */
> >>  #define OV5642_SENSOR_SIZE_X 2592
> >>  #define OV5642_SENSOR_SIZE_Y 1944
> > 
> > [snip]
> > 
> >> @@ -804,6 +1013,100 @@ static int ov5642_set_resolution(struct
> >> v4l2_subdev *sd) return ret;
> >>  }
> >> 
> >> +static int ov5642_restore_state(struct v4l2_subdev *sd)
> >> +{
> >> +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +     struct ov5642 *priv = to_ov5642(client);
> >> +     struct v4l2_control set_ctrl;
> >> +     int tmp_red_balance = priv->red_balance;
> >> +     int tmp_blue_balance = priv->blue_balance;
> >> +     int tmp_gain = priv->gain;
> >> +     int tmp_exp = priv->exposure;
> >> +     int ret;
> >> +
> >> +     set_ctrl.id = V4L2_CID_AUTOGAIN;
> >> +     set_ctrl.value = priv->agc;
> >> +     ret = ov5642_s_ctrl(sd, &set_ctrl);
> > 
> > What about writing to registers directly ?
> 
> I thought about that too, but code duplication would be very large
> (e.g. take the hue control). I considered the speedup of avoiding
> function calls less than the error-proness of this duplication. It is
> just cleaner imho.

OK. This will be replaced when soc-camera will use the control framework 
anyway.

> >> +
> >> +     if (!priv->agc) {
> >> +             set_ctrl.id = V4L2_CID_GAIN;
> >> +             set_ctrl.value = tmp_gain;
> >> +             if (!ret)
> >> +                     ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +     }
> >> +
> >> +     set_ctrl.id = V4L2_CID_AUTO_WHITE_BALANCE;
> >> +     set_ctrl.value = priv->awb;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     if (!priv->awb) {
> >> +             set_ctrl.id = V4L2_CID_RED_BALANCE;
> >> +             set_ctrl.value = tmp_red_balance;
> >> +             if (!ret)
> >> +                     ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +             set_ctrl.id = V4L2_CID_BLUE_BALANCE;
> >> +             set_ctrl.value = tmp_blue_balance;
> >> +             if (!ret)
> >> +                     ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +     }
> >> +
> >> +     set_ctrl.id = V4L2_CID_EXPOSURE_AUTO;
> >> +     set_ctrl.value = priv->aec;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     if (priv->aec == V4L2_EXPOSURE_MANUAL) {
> >> +             set_ctrl.id = V4L2_CID_EXPOSURE;
> >> +             set_ctrl.value = tmp_exp;
> >> +             if (!ret)
> >> +                     ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +     }
> >> +
> >> +     set_ctrl.id = V4L2_CID_VFLIP;
> >> +     set_ctrl.value = priv->vflip;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     set_ctrl.id = OV5642_CONTROL_GRAY_SCALE;
> >> +     set_ctrl.value = priv->grayscale;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     set_ctrl.id = OV5642_CONTROL_SOLARIZE;
> >> +     set_ctrl.value = priv->solarize;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     set_ctrl.id = OV5642_CONTROL_BLUE_SATURATION;
> >> +     set_ctrl.value = priv->blue_saturation;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     set_ctrl.id = OV5642_CONTROL_RED_SATURATION;
> >> +     set_ctrl.value = priv->red_saturation;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     set_ctrl.id = V4L2_CID_BRIGHTNESS;
> >> +     set_ctrl.value = priv->brightness;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     set_ctrl.id = V4L2_CID_CONTRAST;
> >> +     set_ctrl.value = priv->contrast;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     set_ctrl.id = V4L2_CID_HUE;
> >> +     set_ctrl.value = priv->hue;
> >> +     if (!ret)
> >> +             ret = ov5642_s_ctrl(sd, &set_ctrl);
> >> +
> >> +     return ret;
> >> +}
> >> +
> >>  static int ov5642_try_fmt(struct v4l2_subdev *sd, struct
> >> v4l2_mbus_framefmt *mf) {
> >>       const struct ov5642_datafmt *fmt   =
> >> ov5642_find_datafmt(mf->code); @@ -856,6 +1159,9 @@ static int
> >> ov5642_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf) if
> >> (!ret)
> >>               ret = ov5642_write_array(client,
> >> ov5642_default_regs_finalise);
> >> 
> >> +     /* the chip has been reset, so configure it again */
> >> +     if (!ret)
> >> +             ret = ov5642_restore_state(sd);
> > 
> > I suppose there's no way to avoid resetting the chip ?
> 
> Whenever the clock is down, the chip looses its state.

But the clock isn't turned down at every s_fmt call. Would it be possible 
reinit the chip in the .s_power operation instead ?

> >>       return ret;
> >>  }
> > 
> > [snip]
> > 
> >> +static int ov5642_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control
> >> *ctrl) +{
> >> +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +     struct ov5642 *priv = to_ov5642(client);
> >> +     int ret = 0;
> >> +     u8 val8;
> >> +     u16 val16;
> >> +     u32 val32;
> >> +     int trig;
> >> +     struct v4l2_control aux_ctrl;
> >> +
> >> +     switch (ctrl->id) {
> >> +     case V4L2_CID_AUTOGAIN:
> >> +             if (!ctrl->value) {
> >> +                     aux_ctrl.id = V4L2_CID_GAIN;
> >> +                     ret = ov5642_g_ctrl(sd, &aux_ctrl);
> >> +                     if (ret)
> >> +                             break;
> >> +                     priv->gain = aux_ctrl.value;
> >> +             }
> >> +
> >> +             ret = reg_read(client, REG_EXP_GAIN_CTRL, &val8);
> >> +             if (ret)
> >> +                     break;
> >> +             val8 = ctrl->value ? val8 & ~BIT(1) : val8 | BIT(1);
> >> +             ret = reg_write(client, REG_EXP_GAIN_CTRL, val8);
> >> +             if (!ret)
> >> +                     priv->agc = ctrl->value;
> > 
> > What about caching the content of this register (and of other registers
> > below) instead of reading it back ? If you can't do that, a
> > reg_clr_set() function would make the code simpler.
> 
> Ok I will do the caching.
> 
> >> +             break;

-- 
Regards,

Laurent Pinchart
