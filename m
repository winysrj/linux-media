Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35865 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdE2C4h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 22:56:37 -0400
Received: by mail-yw0-f170.google.com with SMTP id b68so23525944ywe.3
        for <linux-media@vger.kernel.org>; Sun, 28 May 2017 19:56:36 -0700 (PDT)
Received: from mail-yb0-f170.google.com (mail-yb0-f170.google.com. [209.85.213.170])
        by smtp.gmail.com with ESMTPSA id v14sm4783585ywh.45.2017.05.28.19.56.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 May 2017 19:56:34 -0700 (PDT)
Received: by mail-yb0-f170.google.com with SMTP id r66so5579083yba.2
        for <linux-media@vger.kernel.org>; Sun, 28 May 2017 19:56:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7A4F467111FEF64486F40DFE7DF3500A03EAF344@ORSMSX111.amr.corp.intel.com>
References: <1495844847-21655-1-git-send-email-hyungwoo.yang@intel.com>
 <20170527203053.GY29527@valkosipuli.retiisi.org.uk> <7A4F467111FEF64486F40DFE7DF3500A03EAF344@ORSMSX111.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 29 May 2017 11:56:13 +0900
Message-ID: <CAAFQd5Bd_KXeALAJxfOKwJecE0nZLmbPR2butXPmvrdnW=cW0A@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] [media] i2c: add support for OV13858 sensor
To: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hsu, Cedric" <cedric.hsu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hyungwoo,

On Mon, May 29, 2017 at 8:26 AM, Yang, Hyungwoo <hyungwoo.yang@intel.com> wrote:
>
> Hi Sakari,
>
> Here's my comments.
>
> -Hyungwoo
>
>
> -----Original Message-----
>> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
>> Sent: Saturday, May 27, 2017 1:31 PM
>> To: Yang, Hyungwoo <hyungwoo.yang@intel.com>
>> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hsu, Cedric <cedric.hsu@intel.com>; tfiga@chromium.org
>> Subject: Re: [PATCH v3 1/1] [media] i2c: add support for OV13858 sensor
>>
>> Hi Hyungwoo,
>>
>> Thanks for the update. A few comments below.
>>
[snip]
>> > +/* Update VTS that meets expected vertical blanking */ static int
>> > +ov13858_update_vblank(struct ov13858 *ov13858,
>> > +                            struct v4l2_ctrl *ctrl)
>> > +{
>> > +   return ov13858_write_reg(
>> > +                   ov13858, OV13858_REG_VTS,
>> > +                   OV13858_REG_VALUE_16BIT,
>> > +                   ov13858->cur_mode->height + ov13858->vblank->val); }
>> > +
>> > +/* Update analog gain */
>> > +static int ov13858_update_analog_gain(struct ov13858 *ov13858,
>> > +                                 struct v4l2_ctrl *ctrl)
>> > +{
>> > +   return ov13858_write_reg(ov13858, OV13858_REG_ANALOG_GAIN,
>> > +                            OV13858_REG_VALUE_16BIT, ctrl->val);
>>
>> I think I'd move what the four above functions do to ov13858_set_ctrl() unless they're used in more than one location.
>
> Why ? Personally I like this. Since there  wouldn't be any difference in generated machine code, I want to keep this if there's no strict rule on this.

Personally I wouldn't probably care about this, but I see one
advantage of Sakari's suggestion.

Namely, it improves code readability, because there is less
indirection and the person reading ov13858_set_ctrl() instantly knows
that all it does is directly writing the control value to hardware
registers. Otherwise, with the indirection in current version, until
you read ov13858_update_analog_gain() (or such), you don't know
whether it does some extra processing, power management or whatnot.

If ov13858_update_analog_gain() did more than just a simple register
write, it would indeed make sense to separate it, as it's intuitive
that a separate function means some more complicated work. (And vice
versa, it's counter-intuitive to have a function that is only there to
call a register accessor.)

>
>>
>> > +}
>> > +
>> > +static int ov13858_set_ctrl(struct v4l2_ctrl *ctrl) {
>> > +   struct ov13858 *ov13858 = container_of(ctrl->handler,
>> > +                                          struct ov13858, ctrl_handler);
>> > +   struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
>> > +   int ret;
>> > +
>> > +   /* Propagate change of current control to all related controls */
>> > +   switch (ctrl->id) {
>> > +   case V4L2_CID_VBLANK:
>> > +           ov13858_update_exposure_limits(ov13858);
>> > +           break;
>> > +   };
>> > +
>> > +   /*
>> > +    * Applying V4L2 control value only happens
>> > +    * when power is up for streaming
>> > +    */
>> > +   if (pm_runtime_get_if_in_use(&client->dev) <= 0)
>> > +           return 0;
>> > +
>> > +   ret = 0;
>> > +   switch (ctrl->id) {
>> > +   case V4L2_CID_ANALOGUE_GAIN:
>> > +           ret = ov13858_update_analog_gain(ov13858, ctrl);
>> > +           break;
>> > +   case V4L2_CID_EXPOSURE:
>> > +           ret = ov13858_update_exposure(ov13858, ctrl);
>> > +           break;
>> > +   case V4L2_CID_VBLANK:
>> > +           ret = ov13858_update_vblank(ov13858, ctrl);
>> > +           break;
>> > +   default:
>> > +           dev_info(&client->dev,
>> > +                    "ctrl(id:0x%x,val:0x%x) is not handled\n",
>> > +                    ctrl->id, ctrl->val);
>> > +           break;
>> > +   };
>> > +
>> > +   pm_runtime_put(&client->dev);
>> > +
>> > +   return ret;
>> > +}
>> > +
>                 :
>                 :
>> > +/*
>> > + * Prepare streaming by writing default values and customized values.
>> > + * This should be called with ov13858->mutex acquired.
>> > + */
>> > +static int ov13858_prepare_streaming(struct ov13858 *ov13858)
>> > +{
>> > +   struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
>> > +   const struct ov13858_reg_list *reg_list;
>> > +   int ret, link_freq_index;
>> > +
>> > +   /* Get out of from software reset */
>> > +   ret = ov13858_write_reg(ov13858, OV13858_REG_SOFTWARE_RST,
>> > +                           OV13858_REG_VALUE_08BIT, OV13858_SOFTWARE_RST);
>> > +   if (ret) {
>> > +           dev_err(&client->dev, "%s failed to set powerup registers\n",
>> > +                   __func__);
>> > +           return ret;
>> > +   }
>> > +
>> > +   /* Setup PLL */
>> > +   link_freq_index = ov13858->cur_mode->link_freq_index;
>> > +   reg_list = &link_freq_configs[link_freq_index].reg_list;
>> > +   ret = ov13858_write_reg_list(ov13858, reg_list);
>> > +   if (ret) {
>> > +           dev_err(&client->dev, "%s failed to set plls\n", __func__);
>> > +           return ret;
>> > +   }
>> > +
>> > +   /* Apply default values of current mode */
>> > +   reg_list = &ov13858->cur_mode->reg_list;
>> > +   ret = ov13858_write_reg_list(ov13858, reg_list);
>> > +   if (ret) {
>> > +           dev_err(&client->dev, "%s failed to set mode\n", __func__);
>> > +           return ret;
>> > +   }
>> > +
>> > +   /* Apply customized values from user */
>> > +   return __v4l2_ctrl_handler_setup(ov13858->sd.ctrl_handler);
>> > +}
>> > +
>> > +/* Start streaming */
>> > +static int ov13858_start_streaming(struct ov13858 *ov13858)
>> > +{
>> > +   int ret;
>> > +
>> > +   /* Write default & customized values */
>> > +   ret = ov13858_prepare_streaming(ov13858);
>>
>> Could you merge this with ov13858_prepare_streaming()?
>>
>
> Why ? I want to keep this. If you want to worry about 1 more jump then, if it is really there, I can make this function "inline"

I doubt it's about the number of jumps. The same argument of code
readability as I mentioned above applies here as well. I see no point
in having ov13858_start_streaming() separate if all it does on top of
ov13858_prepare_streaming() is a register write, it is
counter-intuitive for readers of the code.

Best regards,
Tomasz
