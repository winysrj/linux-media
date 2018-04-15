Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:44632 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752992AbeDOV0J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 17:26:09 -0400
Received: by mail-lf0-f51.google.com with SMTP id g203-v6so19245061lfg.11
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 14:26:09 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sun, 15 Apr 2018 23:26:06 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180415212606.GG20093@bigcity.dyn.berto.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <5149348.Rp98f1K5qJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5149348.Rp98f1K5qJ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

I have addressed all your comment's but one for the next version. Please 
indicate if you are fine with this and I can still keep your review tag 
:-)

On 2018-04-04 18:15:16 +0300, Laurent Pinchart wrote:

[snip]

> > +static int rcar_csi2_start(struct rcar_csi2 *priv)
> > +{
> > +	const struct rcar_csi2_format *format;
> > +	u32 phycnt, phypll, vcdt = 0, vcdt2 = 0;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
> > +		priv->mf.width, priv->mf.height,
> > +		priv->mf.field == V4L2_FIELD_NONE ? 'p' : 'i');
> > +
> > +	/* Code is validated in set_fmt */
> > +	format = rcar_csi2_code_to_fmt(priv->mf.code);
> 
> You could store the format pointer iin the rcar_csi2 structure to avoid 
> looking it up here.

I could do that, but then I would duplicate the storage of the code 
between the two cached values priv->mf and priv-><cached pointer to 
rcar_csi2>. I could find that acceptable but if you don't strongly 
disagree I would prefer to keep the current way of looking it up here 
:-)

[snip]

> > +static int rcar_csi2_probe_resources(struct rcar_csi2 *priv,
> > +				     struct platform_device *pdev)
> > +{
> > +	struct resource *res;
> > +	int irq;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(priv->base))
> > +		return PTR_ERR(priv->base);
> > +
> > +	irq = platform_get_irq(pdev, 0);
> > +	if (irq < 0)
> > +		return irq;
> 
> You don't seem to use the IRQ. Is this meant to catch invalid DT that don't 
> specify an IRQ, to make sure we'll always have one available when we'll need 
> to later ?

Yes, as you deducted this is currently only to catch invalid DT. In the 
DT documentation I list it as a mandatory property. I think there might 
be potential use-case to at some point add interrupt support of for the 
some of the error interrupts which can be enabled, specially now when we 
seen similar patches for VIN floating around.

> > +
> > +	return 0;
> > +
> > +error:
> > +	v4l2_async_notifier_unregister(&priv->notifier);
> > +	v4l2_async_notifier_cleanup(&priv->notifier);
> > +
> > +	return ret;
> > +}
> 
> [snip]
> 
> With these small issues fixed and Kieran's and Maxime's comments addressed as 
> you see fit,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks, I will hold of adding it until you indicate if you are OK with 
the one comment I'm not fully agreeing with you on.

-- 
Regards,
Niklas Söderlund
