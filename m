Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57513 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933958AbdLSLLx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:11:53 -0500
Date: Tue, 19 Dec 2017 09:11:38 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mats Randgaard <matrandg@cisco.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sebastian Reichel <sre@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/8] media: v4l2-mediabus: convert flags to enums and
 document them
Message-ID: <20171219091138.51dc1e0d@vento.lan>
In-Reply-To: <1513675815.7538.4.camel@pengutronix.de>
References: <cover.1513625884.git.mchehab@s-opensource.com>
        <9adfe443125040ddef985c698a18a2404e5a638d.1513625884.git.mchehab@s-opensource.com>
        <1513675815.7538.4.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Dec 2017 10:30:15 +0100
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> Hi Mauro,
> 
> On Mon, 2017-12-18 at 17:53 -0200, Mauro Carvalho Chehab wrote:
> > There is a mess with media bus flags: there are two sets of
> > flags, one used by parallel and ITU-R BT.656 outputs,
> > and another one for CSI2.
> > 
> > Depending on the type, the same bit has different meanings.
> > 
> > That's very confusing, and counter-intuitive. So, split them
> > into two sets of flags, inside an enum.
> > 
> > This way, it becomes clearer that there are two separate sets
> > of flags. It also makes easier if CSI1, CSP, CSI3, etc. would
> > need a different set of flags.
> > 
> > As a side effect, enums can be documented via kernel-docs,
> > so there will be an improvement at flags documentation.
> > 
> > Unfortunately, soc_camera and pxa_camera do a mess with
> > the flags, using either one set of flags without proper
> > checks about the type. That could be fixed, but, as both drivers
> > are obsolete and in the process of cleanings, I opted to just
> > keep the behavior, using an unsigned int inside those two
> > drivers.
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> If I am not mistaken this is missing a conversion of
> drivers/staging/media/imx/imx-media-csi.c:
> 
> --------8<--------
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index eb7be5093a9d5..b1daac3a537d9 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -636,9 +636,10 @@ static int csi_setup(struct csi_priv *priv)
>  
>  	/* compose mbus_config from the upstream endpoint */
>  	mbus_cfg.type = priv->upstream_ep.bus_type;
> -	mbus_cfg.flags = (priv->upstream_ep.bus_type == V4L2_MBUS_CSI2) ?
> -		priv->upstream_ep.bus.mipi_csi2.flags :
> -		priv->upstream_ep.bus.parallel.flags;
> +	if (priv->upstream_ep.bus_type == V4L2_MBUS_CSI2)
> +		mbus_cfg.csi2_flags = priv->upstream_ep.bus.mipi_csi2.flags;
> +	else
> +		mbus_cfg.pb_flags = priv->upstream_ep.bus.parallel.flags;
>  
>  	/*
>  	 * we need to pass input frame to CSI interface, but


Oh, thanks for noticing! I really hate having drivers that don't
build with COMPILE_TEST, as that makes a lot harder to check if
something broke.


Thanks,
Mauro
