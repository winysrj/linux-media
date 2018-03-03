Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35716 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752001AbeCCODx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2018 09:03:53 -0500
Received: by mail-lf0-f68.google.com with SMTP id 70so17181656lfw.2
        for <linux-media@vger.kernel.org>; Sat, 03 Mar 2018 06:03:52 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 3 Mar 2018 15:03:49 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 19/32] rcar-vin: add function to manipulate Gen3
 chsel value
Message-ID: <20180303140349.GG12470@bigcity.dyn.berto.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
 <20180302015751.25596-20-niklas.soderlund+renesas@ragnatech.se>
 <1626554.hLmvUq6KA6@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1626554.hLmvUq6KA6@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for your feedback.

On 2018-03-02 13:31:47 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 2 March 2018 03:57:38 EET Niklas Söderlund wrote:
> > On Gen3 the CSI-2 routing is controlled by the VnCSI_IFMD register. One
> > feature of this register is that it's only present in the VIN0 and VIN4
> > instances. The register in VIN0 controls the routing for VIN0-3 and the
> > register in VIN4 controls routing for VIN4-7.
> > 
> > To be able to control routing from a media device this function is need
> > to control runtime PM for the subgroup master (VIN0 and VIN4). The
> > subgroup master must be switched on before the register is manipulated,
> > once the operation is complete it's safe to switch the master off and
> > the new routing will still be in effect.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thank you.

> 
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c | 38 +++++++++++++++++++++++++++
> >  drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
> >  2 files changed, 40 insertions(+)
> 
> By the way it would be useful if you added per-patch changelogs. You can 
> capture them in the commit message below a --- line.

I'm feeling the pain already of not doing this. I have in the past tried 
to keep such change long under a --- line like you suggest. But 
something in my work flow at that time caused the --- to be dropped and 
I never figured out what caused it.

I will try it again and see if I can figure out what caused it and how I 
can work around it. Thanks for brining this up.

> 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> > b/drivers/media/platform/rcar-vin/rcar-dma.c index
> > 57bb288b3ca67a60..3fb9c325285c5a5a 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -16,6 +16,7 @@
> > 
> >  #include <linux/delay.h>
> >  #include <linux/interrupt.h>
> > +#include <linux/pm_runtime.h>
> > 
> >  #include <media/videobuf2-dma-contig.h>
> > 
> > @@ -1228,3 +1229,40 @@ int rvin_dma_register(struct rvin_dev *vin, int irq)
> > 
> >  	return ret;
> >  }
> > +
> > +/* ------------------------------------------------------------------------
> > + * Gen3 CHSEL manipulation
> > + */
> > +
> > +/*
> > + * There is no need to have locking around changing the routing
> > + * as it's only possible to do so when no VIN in the group is
> > + * streaming so nothing can race with the VNMC register.
> > + */
> > +int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
> > +{
> > +	u32 ifmd, vnmc;
> > +	int ret;
> > +
> > +	ret = pm_runtime_get_sync(vin->dev);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Make register writes take effect immediately. */
> > +	vnmc = rvin_read(vin, VNMC_REG);
> > +	rvin_write(vin, vnmc & ~VNMC_VUP, VNMC_REG);
> > +
> > +	ifmd = VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
> > +		VNCSI_IFMD_CSI_CHSEL(chsel);
> > +
> > +	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
> > +
> > +	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
> > +
> > +	/* Restore VNMC. */
> > +	rvin_write(vin, vnmc, VNMC_REG);
> > +
> > +	pm_runtime_put(vin->dev);
> > +
> > +	return ret;
> > +}
> > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> > b/drivers/media/platform/rcar-vin/rcar-vin.h index
> > b3802651eaa78ea9..666308946eb4994d 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > @@ -165,4 +165,6 @@ const struct rvin_video_format
> > *rvin_format_from_pixel(u32 pixelformat); /* Cropping, composing and
> > scaling */
> >  void rvin_crop_scale_comp(struct rvin_dev *vin);
> > 
> > +int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
> > +
> >  #endif
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
