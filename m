Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3GOJZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 05:25:11 -0400
Date: Mon, 15 Jul 2013 11:24:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: phil.edworthy@renesas.com
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
In-Reply-To: <OF23E0ECB2.378DD339-ON80257BA9.002CD00C-80257BA9.00321DEB@eu.necel.com>
Message-ID: <Pine.LNX.4.64.1307151114270.16726@axis700.grange>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
 <OF23E0ECB2.378DD339-ON80257BA9.002CD00C-80257BA9.00321DEB@eu.necel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phil

On Mon, 15 Jul 2013, phil.edworthy@renesas.com wrote:

[snip]

> > > +/* read a register */
> > > +static int ov10635_reg_read(struct i2c_client *client, u16 reg, u8 
> *val)
> > > +{
> > > +   int ret;
> > > +   u8 data[2] = { reg >> 8, reg & 0xff };
> > > +   struct i2c_msg msg = {
> > > +      .addr   = client->addr,
> > > +      .flags   = 0,
> > > +      .len   = 2,
> > > +      .buf   = data,
> > > +   };
> > > +
> > > +   ret = i2c_transfer(client->adapter, &msg, 1);
> > > +   if (ret < 0)
> > > +      goto err;
> > > +
> > > +   msg.flags = I2C_M_RD;
> > > +   msg.len   = 1;
> > > +   msg.buf   = data,
> > > +   ret = i2c_transfer(client->adapter, &msg, 1);
> > > +   if (ret < 0)
> > > +      goto err;
> > > +
> > > +   *val = data[0];
> > 
> > I think, you can do this in one I2C transfer with 2 messages. Look e.g. 
> > imx074.c. Although, now looking at it, I'm not sure why it has .len = 2 
> in 
> > the second message...
> Ok, I'll change this to one i2c transfer. As you sauy, no idea why the imx 
> code is reading 2 bytes though...

But I don't have any way to test it anymore, anyway: the only user - 
ap4evb - is gone now. So, that driver doesn't matter much anymore. We can 
just fix that blindly without testing, or we can leave it as is and mark 
the driver broken, or we can remove it completely.

[snip]

> > > +         continue;
> > > +
> > > +      /* Mult = reg 0x3003, bits 5:0 */
> > 
> > You could also define macros for 0x3003, 0x3004 and others, where you 
> know 
> > the role of those registers, even if not their official names.
> Do you mean macros for the bit fields?

No, primarily I mean macros for register addresses.

[snip]

> > > +            /* 2 clock cycles for every YUV422 pixel */
> > > +            if (pclk < (((hts * *vtsmin)/fps_denominator)
> > > +               * fps_numerator * 2))
> > 
> > Actually just
> > 
> > +            if (pclk < hts * *vtsmin / fps_denominator
> > +               * fps_numerator * 2)
> > 
> > would do just fine
> It would, but I think we should use parenthesis here to ensure the  divide 
> by the denominator happens before multiplying by the numerator. This is to 
> ensure the value doesn't overflow.

I think the C standard already guarantees that. You only need parenthesis 
to enforce a non-standard calculation order.

[snip]

> > > +static int ov10635_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> > > +{
> > > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> > > +   struct ov10635_priv *priv = to_ov10635(client);
> > > +
> > > +   if (priv) {
> > > +      a->c.width = priv->width;
> > > +      a->c.height = priv->height;
> > 
> > Wait, what is priv->width and priv->height? Are they sensor output sizes 
> > or crop sizes?
> Sensor output sizes. Ah, I guess this is one of the few cameras/drivers 
> that can support setup the sensor for any size (except restrictions for 
> 4:2:2 format). So maybe I should not implement these functions? Looking at 
> the CEU SoC camera host driver, it would then use the defrect cropcap. I 
> am not sure what that will be though.

Cropping and scaling are two different functions. Cropping selects an area 
on the sensor matrix to use for data sampling. Scaling configures to which 
output rectangle to scale that area. So, since your camera can do both and 
your driver supports both, you shouldn't return the same sizes in .g_fmt() 
and .g_crop() unless, of course, a 1:1 scale has been set. And currently 
you do exactly that - return priv->width and priv->height in both.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
