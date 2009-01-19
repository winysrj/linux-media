Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50839 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754397AbZASJLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 04:11:08 -0500
Date: Mon, 19 Jan 2009 10:11:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ov772x: Add image flip support
In-Reply-To: <u4ozvpt27.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901191007110.5166@axis700.grange>
References: <u63kbpxm9.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901190844330.4142@axis700.grange> <u4ozvpt27.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2009, morimoto.kuninori@renesas.com wrote:

> > > @@ -768,8 +844,17 @@ static int ov772x_set_fmt(struct soc_camera_device *icd,
> > >  	 * set COM3
> > >  	 */
> > >  	val = priv->fmt->com3;
> > > +	if (priv->info->flags & OV772X_FLAG_VFLIP)
> > > +		val |= VFLIP_IMG;
> > > +	if (priv->info->flags & OV772X_FLAG_HFLIP)
> > > +		val |= HFLIP_IMG;
> > > +
> > > +	mask = SWAP_MASK;
> > > +	if (IMG_MASK & val)
> > > +		mask |= IMG_MASK;
> > > +
> > >  	ret = ov772x_mask_set(priv->client,
> > > -			      COM3, SWAP_MASK, val);
> > > +			      COM3, mask, val);
> > 
> > Do I understand it right, that this throws away any flip control settings 
> > performed before S_FMT? You probably want to set priv->fmt->com3 in your 
> > set_control and XOR instead of an OR here as well. Or was this 
> > intentional?
> 
> Sorry, I can not understand what you want to say.
> I think set_fmt function set default flip control.
> And set_control function change flip on/off.
> Therefore OR operation on set_fmt is correct I think.
> And set_control use only XOR. priv->fmt->com3 is not needed here.
> Do you say should I remember flip value ?

I think, yes. If someone sets vertical or horizontal flip using the 
respective control, and then calls S_FMT, I think, flip should be 
preserved. S_FMT is in no way a reset, it only sets fields that are 
explicitly passed with it - pixel format, image size, etc.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
