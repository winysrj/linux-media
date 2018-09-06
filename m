Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58105 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbeIFPRY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 11:17:24 -0400
Message-ID: <1536230551.5357.7.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/4] dt-bindings: media: Add i.MX Pixel Pipeline
 binding
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Philippe De Muyter <phdm@macq.eu>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Date: Thu, 06 Sep 2018 12:42:31 +0200
In-Reply-To: <20180906103642.GA26723@frolo.macqel>
References: <20180906090215.15719-1-p.zabel@pengutronix.de>
         <20180906090215.15719-2-p.zabel@pengutronix.de>
         <20180906103642.GA26723@frolo.macqel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,

On Thu, 2018-09-06 at 12:36 +0200, Philippe De Muyter wrote:
[...]
> > --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/fsl-pxp.txt
> > @@ -0,0 +1,26 @@
> > +Freescale Pixel Pipeline
> > +========================
> > +
> > +The Pixel Pipeline (PXP) is a memory-to-memory graphics processing engine
> > +that supports scaling, colorspace conversion, alpha blending, rotation, and
> > +pixel conversion via lookup table. Different versions are present on various
> > +i.MX SoCs from i.MX23 to i.MX7.
> > +
> > +Required properties:
> > +- compatible: should be "fsl,<soc>-pxp", where SoC can be one of imx23, imx28,
> > +  imx6dl, imx6sl, imx6ul, imx6sx, imx6ull, or imx7d.
> 
> Is imx6q also compatible ?

There is no pixel pipeline on i.MX6Q. It has the IPU image converter
that can be used for scaling and colorspace conversion instead [1].

[1] https://patchwork.linuxtv.org/patch/51045/

regards
Philipp
