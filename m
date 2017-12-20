Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:40901 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756450AbdLTVUl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 16:20:41 -0500
Received: by mail-lf0-f68.google.com with SMTP id u84so5647075lff.7
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 13:20:40 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 20 Dec 2017 22:20:38 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 16/28] rcar-vin: add function to manipulate Gen3 chsel
 value
Message-ID: <20171220212038.GG32148@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-17-niklas.soderlund+renesas@ragnatech.se>
 <20173129.GKy7R676Pn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20173129.GKy7R676Pn@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

On 2017-12-08 11:52:01 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 8 December 2017 03:08:30 EET Niklas Söderlund wrote:
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
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c | 25 +++++++++++++++++++++++++
> >  drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
> >  2 files changed, 27 insertions(+)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> > b/drivers/media/platform/rcar-vin/rcar-dma.c index
> > ace95d5b543a17e3..d2788d8bb9565aaa 100644
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
> > @@ -1228,3 +1229,27 @@ int rvin_dma_register(struct rvin_dev *vin, int irq)
> > 
> >  	return ret;
> >  }
> > +
> > +/* ------------------------------------------------------------------------
> >   + * Gen3 CHSEL manipulation
> > + */
> > +
> > +void rvin_set_chsel(struct rvin_dev *vin, u8 chsel)
> 
> How about naming the function a bit more explicitly, 
> rvin_set_channel_routing() for instance ?

I agree, it's a much better name.

> 
> > +{
> > +	u32 ifmd, vnmc;
> > +
> > +	pm_runtime_get_sync(vin->dev);
> 
> Shouldn't you check the return value of this function ?

Sakari asked the same thing in v4 :-)

In short no its not needed please see Geert's response [1]. If I recall 
correctly this was also discussed in more detail in another thread for 
some other driver whit a bit longer answer saying that it 
pm_runtime_get_sync() fails you have big problems but I can't find that 
thread now :-(

1. https://www.spinics.net/lists/linux-media/msg115241.html

> 
> > +
> > +	/* Make register writes take effect immediately */
> > +	vnmc = rvin_read(vin, VNMC_REG) & ~VNMC_VUP;
> > +	rvin_write(vin, vnmc, VNMC_REG);
> 
> Shouldn't you restore the original value of VNMC at the end of the function ? 
> What if this races with device access local to the VIN0 or VIN4 instance ?

Media link changes are not allowed when any VIN in the group are 
streaming so this should not be an issue. But I agree it's good form to 
restore the value anyhow so I will update this for the next version.

> 
> > +	ifmd = VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
> > +		VNCSI_IFMD_CSI_CHSEL(chsel);
> > +
> > +	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
> > +
> > +	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
> > +
> > +	pm_runtime_put(vin->dev);
> > +}
> > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> > b/drivers/media/platform/rcar-vin/rcar-vin.h index
> > a440effe4b86af31..7819c760c2c13422 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > @@ -163,4 +163,6 @@ void rvin_v4l2_unregister(struct rvin_dev *vin);
> > 
> >  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
> > 
> > +void rvin_set_chsel(struct rvin_dev *vin, u8 chsel);
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
