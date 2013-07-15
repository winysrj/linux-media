Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:51397 "EHLO
	relmlor2.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab3GOJHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 05:07:36 -0400
Received: from relmlir4.idc.renesas.com ([10.200.68.154])
 by relmlor2.idc.renesas.com ( SJSMS)
 with ESMTP id <0MPZ00DQZ00NIA80@relmlor2.idc.renesas.com> for
 linux-media@vger.kernel.org; Mon, 15 Jul 2013 18:07:35 +0900 (JST)
Received: from relmlac3.idc.renesas.com ([10.200.69.23])
 by relmlir4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MPZ00D3800NHX60@relmlir4.idc.renesas.com> for
 linux-media@vger.kernel.org; Mon, 15 Jul 2013 18:07:35 +0900 (JST)
In-reply-to: <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Message-id: <OF23E0ECB2.378DD339-ON80257BA9.002CD00C-80257BA9.00321DEB@eu.necel.com>
Date: Mon, 15 Jul 2013 10:07:25 +0100
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the review.

> I'll comment to this version, although the driver has to be updated to 
the 
> V4L2 clock API at least, preferably also to asynchronous probing.
Ok, I'll have to look into that.
 
<snip>
> > + * FIXME:
> > + *  Horizontal flip (mirroring) does not work correctly. The image is 
flipped,
> > + *  but the colors are wrong.
> 
> Then maybe just remove it, if you cannot fix it? You could post an 
> incremental patch / rfc later just to have it on the ML for the future, 
in 
> case someone manages to fix it.
Ok, I'll remove it.
 
<snip>
> > +/* Register definitions */
> > +#define   OV10635_VFLIP         0x381c
> > +#define    OV10635_VFLIP_ON      (0x3 << 6)
> > +#define    OV10635_VFLIP_SUBSAMPLE   0x1
> > +#define   OV10635_HMIRROR         0x381d
> > +#define    OV10635_HMIRROR_ON      0x3
> > +#define OV10635_PID         0x300a
> > +#define OV10635_VER         0x300b
> 
> Please, don't mix spaces and TABs for the same pattern, I'd just use 
> spaces between "#define" and the macro name above
Oops, missed those.
 
<snip>
> > +struct ov10635_priv {
> > +   struct v4l2_subdev   subdev;
> > +   struct v4l2_ctrl_handler   hdl;
> > +   int         xvclk;
> > +   int         fps_numerator;
> > +   int         fps_denominator;
> > +   const struct ov10635_color_format   *cfmt;
> > +   int         width;
> > +   int         height;
> > +};
> 
> Uhm, may I suggest to either align all the lines, or to leave all 
> unaligned :) Either variant would look better than the above imho :)
Ok

<snip>
> > +/* read a register */
> > +static int ov10635_reg_read(struct i2c_client *client, u16 reg, u8 
*val)
> > +{
> > +   int ret;
> > +   u8 data[2] = { reg >> 8, reg & 0xff };
> > +   struct i2c_msg msg = {
> > +      .addr   = client->addr,
> > +      .flags   = 0,
> > +      .len   = 2,
> > +      .buf   = data,
> > +   };
> > +
> > +   ret = i2c_transfer(client->adapter, &msg, 1);
> > +   if (ret < 0)
> > +      goto err;
> > +
> > +   msg.flags = I2C_M_RD;
> > +   msg.len   = 1;
> > +   msg.buf   = data,
> > +   ret = i2c_transfer(client->adapter, &msg, 1);
> > +   if (ret < 0)
> > +      goto err;
> > +
> > +   *val = data[0];
> 
> I think, you can do this in one I2C transfer with 2 messages. Look e.g. 
> imx074.c. Although, now looking at it, I'm not sure why it has .len = 2 
in 
> the second message...
Ok, I'll change this to one i2c transfer. As you sauy, no idea why the imx 
code is reading 2 bytes though...

<snip>
> Also here: wouldn't it be possible and better to do this as one I2C 
> transfer with 2 messages?
Ok

<snip>
> > +/* Read a register, alter its bits, write it back */
> > +static int ov10635_reg_rmw(struct i2c_client *client, u16 reg, u8 
set, u8 unset)
> > +{
> > +   u8 val;
> > +   int ret;
> > +
> > +   ret = ov10635_reg_read(client, reg, &val);
> > +   if (ret) {
> > +      dev_err(&client->dev,
> > +         "[Read]-Modify-Write of register %04x failed!\n", reg);
> > +      return ret;
> > +   }
> > +
> > +   val |= set;
> > +   val &= ~unset;
> > +
> > +   ret = ov10635_reg_write(client, reg, val);
> > +   if (ret)
> > +      dev_err(&client->dev,
> > +         "Read-Modify-[Write] of register %04x failed!\n", reg);
> > +
> > +   return ret;
> > +}
> > +
> > +
> 
> Are these two empty lines above on purpose?
No, I'll remove the extra one

<snip>
> > +/* Start/Stop streaming from the device */
> > +static int ov10635_s_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +
> > +   ov10635_reg_write(client, 0x0100, enable);
> > +   return 0;
> 
> Don't you want to return the possible error from reg_write()?
> 
>    return ov10635_reg_write(...);
Yes, I will do so. 

<snip>
> > +         continue;
> > +
> > +      /* Mult = reg 0x3003, bits 5:0 */
> 
> You could also define macros for 0x3003, 0x3004 and others, where you 
know 
> the role of those registers, even if not their official names.
Do you mean macros for the bit fields?

<snip>
> superfluous parenthesis
and
> Coding style - please, add spaces around arithmetic operations 
throughout 
> the code.
I'll check them all.

<snip>
> > +            /* 2 clock cycles for every YUV422 pixel */
> > +            if (pclk < (((hts * *vtsmin)/fps_denominator)
> > +               * fps_numerator * 2))
> 
> Actually just
> 
> +            if (pclk < hts * *vtsmin / fps_denominator
> +               * fps_numerator * 2)
> 
> would do just fine
It would, but I think we should use parenthesis here to ensure the  divide 
by the denominator happens before multiplying by the numerator. This is to 
ensure the value doesn't overflow.
 
<snip>
> > +   *r3003 = (u8)best_j;
> > +   *r3004 = ((u8)best_i << 4) | (u8)best_k;
> 
> You don't need those casts: i < 8, j < 32, k < 8.
Ok.
 
<snip>
> > +
> > +   /* Did we get a valid PCLK? */
> > +   if (best_pclk == INT_MAX)
> > +      return -1;
> 
> But you could move this check above *r3003 and *r3004 assignments and 
> please, return a proper error code, not -1 (-EPERM).
Ok

<snip>
> > +static int ov10635_set_regs(struct i2c_client *client,
> > +   const struct ov10635_reg *regs, int nr_regs)
> 
> You might consider defining a macro like
> 
> #define ov10635_set_reg_array(client, array) ov10635_set_regs(client, \
>             array, ARRAY_SIZE(array))
> 
> but that's up to you, just an idea
Will do
 
<snip>
> > +   u8 r3003, r3004;
> 
> I think you pretty much figured out, what those registers do, so, can 
> certainly come up with better names :)
Ok.
 
<snip>
> > +   /* Get the best PCLK & adjust hts,vts accordingly */
> 
> A space after the comma, please.
I'll reword it

<snip>
> > +ov10635_set_fmt_error:
> > +   dev_err(&client->dev, "Unsupported settings (%dx%d@(%d/%d)fps)\n",
> > +      *width, *height, priv->fps_numerator, priv->fps_denominator);
> > +   priv = NULL;
> > +   priv->cfmt = NULL;
> 
> Ouch... You're really sure you want an Oops here?
Whoops, I'll fix.

<snip>
> > +static int ov10635_g_fmt(struct v4l2_subdev *sd,
> > +         struct v4l2_mbus_framefmt *mf)
> > +{
> > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +   struct ov10635_priv *priv = to_ov10635(client);
> > +   u32 width = OV10635_MAX_WIDTH, height = OV10635_MAX_HEIGHT;
> > +   enum v4l2_mbus_pixelcode code;
> > +   int ret;
> > +
> > +   if (priv->cfmt)
> > +      code = priv->cfmt->code;
> > +   else
> > +      code = V4L2_MBUS_FMT_YUYV8_2X8;
> > +
> > +   ret = ov10635_set_params(client, &width, &height, code);
> 
> Do I understand it right, that you're setting hardware parameters here? 
> Please, don't do this. g_fmt should never modify the driver state or 
even 
> worse the hardware. You can just verify, whether the driver has been 
> configured in ov10635_s_stream(1) and if no - configure default there.
Ok

<snip>
> > +static int ov10635_g_parm(struct v4l2_subdev *sd, struct 
v4l2_streamparm *parms)
> > +static int ov10635_s_parm(struct v4l2_subdev *sd, struct 
v4l2_streamparm *parms)
> 
> If I'm not mistaken, .s_parm() / .g_parm() are kind of deprecated, 
> .s_frame_interval(), .g_frame_interval(), .enum_frameintervals() should 
be 
> used instead... But I might be wrong, just a heads up.
Ok, I hadn't noticed that change...
 
<snip>
> > +   /* FIXME Check we can handle the requested framerate */
> > +   priv->fps_denominator = cp->timeperframe.numerator;
> > +   priv->fps_numerator = cp->timeperframe.denominator;
> 
> Yes, fixing this could be a good idea :) Just add one parameter to your 
> set_params() and use NULL elsewhere.
Ok

> > +
> > +   if (priv->cfmt)
> > +      code = priv->cfmt->code;
> > +   else
> > +      code = V4L2_MBUS_FMT_YUYV8_2X8;
> > +
> > +   ret = ov10635_set_params(client, &priv->width, &priv->height, 
code);
> > +   if (ret < 0)
> > +      return ret;
> > +
> > +   return 0;
> 
> Simply
> 
> +   return ov10635_set_params(client, &priv->width, &priv->height, 
code);
Sure


> > +static int ov10635_s_crop(struct v4l2_subdev *sd, const struct 
v4l2_crop *a)
> > +{
> > +   struct v4l2_crop a_writable = *a;
> > +   struct v4l2_rect *rect = &a_writable.c;
> > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +   struct ov10635_priv *priv = to_ov10635(client);
> > +   int ret = -EINVAL;
> > +   enum v4l2_mbus_pixelcode code;
> > +
> > +   if (priv->cfmt)
> > +      code = priv->cfmt->code;
> > +   else
> > +      code = V4L2_MBUS_FMT_YUYV8_2X8;
> > +
> > +   ret = ov10635_set_params(client, &rect->width, &rect->height, 
code);
> > +   if (!ret)
> > +      return -EINVAL;
> 
> The above doesn't look right.
> 
> > +
> > +   rect->width = priv->width;
> > +   rect->height = priv->height;
> > +   rect->left = 0;
> > +   rect->top = 0;
> > +
> > +   return ret;
> > +}
> > +
> > +static int ov10635_g_crop(struct v4l2_subdev *sd, struct v4l2_crop 
*a)
> > +{
> > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +   struct ov10635_priv *priv = to_ov10635(client);
> > +
> > +   if (priv) {
> > +      a->c.width = priv->width;
> > +      a->c.height = priv->height;
> 
> Wait, what is priv->width and priv->height? Are they sensor output sizes 

> or crop sizes?
Sensor output sizes. Ah, I guess this is one of the few cameras/drivers 
that can support setup the sensor for any size (except restrictions for 
4:2:2 format). So maybe I should not implement these functions? Looking at 
the CEU SoC camera host driver, it would then use the defrect cropcap. I 
am not sure what that will be though.

<snip>
> > +   /* TODO External XVCLK is board specific */
> > +   priv->xvclk = 25000000;
> 
> v4l2_clk_get_rate()? Then soc-camera will have to implement it too...
That looks like the right thing to do. I'll have a look at your patches 
for this.
 
Thanks
Phil
