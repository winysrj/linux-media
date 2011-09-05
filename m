Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49675 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1IELVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 07:21:50 -0400
Received: by gxk21 with SMTP id 21so3262998gxk.19
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2011 04:21:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108311737350.8429@axis700.grange>
References: <alpine.DEB.2.02.1108171553540.17550@ipanema>
	<201108282006.09790.laurent.pinchart@ideasonboard.com>
	<CABYn4sx5jQPyLC4d6OfVbX5SSuS4TiNsB_LPoCheaOSbwM9Pzw@mail.gmail.com>
	<Pine.LNX.4.64.1108311737350.8429@axis700.grange>
Date: Mon, 5 Sep 2011 11:21:49 +0000
Message-ID: <CABYn4syNg0p3A0VT=6yNVs6Tdg4n1CO60+fgMw2cSY7H0bM7_A@mail.gmail.com>
Subject: Re: [PATCH] media: Add camera controls for the ov5642 driver
From: Bastian Hecht <hechtb@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/31 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Wed, 31 Aug 2011, Bastian Hecht wrote:
>
>> 2011/8/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > Hi Bastian,
>> >
>> > Thanks for the patch.
>> >
>> > On Wednesday 17 August 2011 18:02:07 Bastian Hecht wrote:
>> >> The driver now supports automatic/manual gain, automatic/manual white
>> >> balance, automatic/manual exposure control, vertical flip, brightness
>> >> control, contrast control and saturation control. Additionally the
>> >> following effects are available now: rotating the hue in the colorspace,
>> >> gray scale image and solarize effect.
>> >
>> > Any chance to port soc-camera to the control framework ? :-)
>>
>> I redirect that to Guennadi :-)
>
> Hans is prepaing an update of his port, then we'll integrate it... This
> all will take time, so, it's better to do this driver now the "old
> soc-camera" way, and port it later.
>
> [snip]
>
>> >> +static int ov5642_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control
>> >> *ctrl) +{
>> >> +     struct i2c_client *client = v4l2_get_subdevdata(sd);
>> >> +     struct ov5642 *priv = to_ov5642(client);
>> >> +     int ret = 0;
>> >> +     u8 val8;
>> >> +     u16 val16;
>> >> +     u32 val32;
>> >> +     int trig;
>> >> +     struct v4l2_control aux_ctrl;
>> >> +
>> >> +     switch (ctrl->id) {
>> >> +     case V4L2_CID_AUTOGAIN:
>> >> +             if (!ctrl->value) {
>> >> +                     aux_ctrl.id = V4L2_CID_GAIN;
>> >> +                     ret = ov5642_g_ctrl(sd, &aux_ctrl);
>> >> +                     if (ret)
>> >> +                             break;
>> >> +                     priv->gain = aux_ctrl.value;
>> >> +             }
>> >> +
>> >> +             ret = reg_read(client, REG_EXP_GAIN_CTRL, &val8);
>> >> +             if (ret)
>> >> +                     break;
>> >> +             val8 = ctrl->value ? val8 & ~BIT(1) : val8 | BIT(1);
>> >> +             ret = reg_write(client, REG_EXP_GAIN_CTRL, val8);
>> >> +             if (!ret)
>> >> +                     priv->agc = ctrl->value;
>> >
>> > What about caching the content of this register (and of other registers below)
>> > instead of reading it back ? If you can't do that, a reg_clr_set() function
>> > would make the code simpler.
>>
>> Ok I will do the caching.
>
> Wasn't the reason for reading those registers from the hardware, that the
> sensor changes them in auto* modes (autogain in this case)?

There are different cases. E.g. this register sets the autogain and
autoexposure on/off not the gain value itself. So indeed one should
cache it (sometimes I registered side-effects on the ov5642 - setting
1 register changed others. I hope I won't run into trouble with
these).

best,

 Bastian


> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
