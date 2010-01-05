Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47909 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751746Ab0AEJdM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 04:33:12 -0500
Date: Tue, 5 Jan 2010 10:33:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc-camera: ov772x: Add buswidth selection flags for
 platform
In-Reply-To: <u637ggasq.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.1001051031410.5259@axis700.grange>
References: <u8wcdf9r8.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.1001050848140.5259@axis700.grange> <u637ggasq.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 5 Jan 2010, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> Thank you for checking patch
> 
> > Can you explain a bit why this patch is needed? Apart from a slight 
> > stylistic improvement and a saving of 4 bytes of platform data per camera 
> > instance? Is it going to be needed for some future changes?
> 
> This patch is not so important/necessary at once.
>  -> for saving of 4 bytes.
> 
> > 	if (!is_power_of_2(priv->info->flags & (OV772X_FLAG_8BIT | OV772X_FLAG_10BIT)))
> > 		return 0;
> > 
> > make sense here? Or even just modify your tests above to
> (snip)
> > Adding a "default:" case just above the "case OV772X_FLAG_10BIT:" line 
> > would seem like a good idea to me too.
> 
> I understand.
> 
> > > +#define OV772X_FLAG_8BIT	(1 << 2) /*  8bit buswidth */
> > > +#define OV772X_FLAG_10BIT	(1 << 3) /* 10bit buswidth */
> 
> May I suggest here ?
> What do you think if it have only 10BIT flag,
> and check/operation like this ?
> 
> 	if (priv->info->flags & OV772X_FLAG_10BIT) {
>  		flags |= SOCAM_DATAWIDTH_10;
>  	else
>  		flags |= SOCAM_DATAWIDTH_8;
> 
> This case, below check became not needed,
> Does this operation make sense for you ?

Do you really want to make 8 bits default? Even though this is, probably, 
how most implementations will connect the sensor, it is actually a 10-bit 
device.

> 
> > >  	/*
> > > -	 * ov772x only use 8 or 10 bit bus width
> > > -	 */
> > > -	if (SOCAM_DATAWIDTH_10 != priv->info->buswidth &&
> > > -	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
> > > -		dev_err(&client->dev, "bus width error\n");
> > > -		return -ENODEV;
> > > -	}

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
