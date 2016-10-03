Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43109 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbcJCKBT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2016 06:01:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Wayne Porter <wporter82@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] [media] v4l: omap4iss: Fix using BIT macro
Date: Mon, 03 Oct 2016 13:01:16 +0300
Message-ID: <20214585.uMqxn84aLo@avalon>
In-Reply-To: <20161003065822.65e43177@vento.lan>
References: <20161001233746.nowzbvhimd3jutbz@Chronos> <20161003065822.65e43177@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 03 Oct 2016 06:58:22 Mauro Carvalho Chehab wrote:
> Em Sat, 1 Oct 2016 16:37:46 -0700 Wayne Porter escreveu:
> > Checks found by checkpatch
> > 
> > Signed-off-by: Wayne Porter <wporter82@gmail.com>
> > ---
> > 
> >  drivers/staging/media/omap4iss/iss_regs.h | 76 ++++++++++++--------------
> >  1 file changed, 38 insertions(+), 38 deletions(-)
> > 
> > diff --git a/drivers/staging/media/omap4iss/iss_regs.h
> > b/drivers/staging/media/omap4iss/iss_regs.h index cb415e8..c675212 100644
> > --- a/drivers/staging/media/omap4iss/iss_regs.h
> > +++ b/drivers/staging/media/omap4iss/iss_regs.h
> > @@ -42,7 +42,7 @@
> >  #define ISS_CTRL_CLK_DIV_MASK				(3 << 4)
> >  #define ISS_CTRL_INPUT_SEL_MASK				(3 << 2)
> >  #define ISS_CTRL_INPUT_SEL_CSI2A			(0 << 2)
> > -#define ISS_CTRL_INPUT_SEL_CSI2B			(1 << 2)
> > +#define ISS_CTRL_INPUT_SEL_CSI2B			BIT(2)
> 
> Converting just a few of such macros won't help. Either convert all
> or none.
> 
> Also, as most of the bit masks here have more than one bit, you should
> use GENMASK(), instead of BIT, like:
> 
> #define ISS_CTRL_CLK_DIV_MASK		GENMASK(4, 5)
> #define ISS_CTRL_INPUT_SEL_MASK		GENMASK(2, 3)
> #define   ISS_CTRL_INPUT_SEL_CSI2A	0
> #define   ISS_CTRL_INPUT_SEL_CSI2B	BIT(2)
> 
> Yet, not sure if I would like such patch, as this kind of change
> could easily break the driver if you make any typo at the GENMASK
> parameters.

It would be best to automate such a change with a script than performing it 
manually.

-- 
Regards,

Laurent Pinchart

