Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35573 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965186AbeBMRLf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:11:35 -0500
Received: by mail-lf0-f65.google.com with SMTP id a204so26005067lfa.2
        for <linux-media@vger.kernel.org>; Tue, 13 Feb 2018 09:11:35 -0800 (PST)
Date: Tue, 13 Feb 2018 18:11:32 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 13/30] rcar-vin: add function to manipulate Gen3
 chsel value
Message-ID: <20180213171132.GF18618@bigcity.dyn.berto.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
 <6540925.qhrue9hUJl@avalon>
 <20180213165809.GE18618@bigcity.dyn.berto.se>
 <5978650.TJRMUHOLl6@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5978650.TJRMUHOLl6@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 2018-02-13 19:02:38 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> On Tuesday, 13 February 2018 18:58:09 EET Niklas Söderlund wrote:
> > On 2018-02-13 18:41:33 +0200, Laurent Pinchart wrote:
> > > On Monday, 29 January 2018 18:34:18 EET Niklas Söderlund wrote:
> > > > On Gen3 the CSI-2 routing is controlled by the VnCSI_IFMD register. One
> > > > feature of this register is that it's only present in the VIN0 and VIN4
> > > > instances. The register in VIN0 controls the routing for VIN0-3 and the
> > > > register in VIN4 controls routing for VIN4-7.
> > > > 
> > > > To be able to control routing from a media device this function is need
> > > > to control runtime PM for the subgroup master (VIN0 and VIN4). The
> > > > subgroup master must be switched on before the register is manipulated,
> > > > once the operation is complete it's safe to switch the master off and
> > > > the new routing will still be in effect.
> > > > 
> > > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > > ---
> > >> 
> > >>  drivers/media/platform/rcar-vin/rcar-dma.c | 28+++++++++++++++++++++++++
> > >>  drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
> > >>  2 files changed, 30 insertions(+)
> > >> 
> > >> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> > >> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> > >> 2f9ad1bec1c8a92f..ae286742f15a3ab5 100644
> > >> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > >> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > >> @@ -16,6 +16,7 @@
> > >> 
> > >>  #include <linux/delay.h>
> > >>  #include <linux/interrupt.h>
> > >> +#include <linux/pm_runtime.h>
> > >> 
> > >>  #include <media/videobuf2-dma-contig.h>
> > >> 
> > >> @@ -1228,3 +1229,30 @@ int rvin_dma_register(struct rvin_dev *vin, int
> > >> irq)
> > >>  	return ret;
> > >>  }
> > >> 
> > >> +
> > >> +/* ---------------------------------------------------------------------
> > >> + * Gen3 CHSEL manipulation
> > >> + */
> > >> +
> > >> +void rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
> > >> +{
> > >> +	u32 ifmd, vnmc;
> > >> +
> > >> +	pm_runtime_get_sync(vin->dev);
> > > 
> > > No need to check for errors ?
> > 
> > You asked the samething for v9 so I will copy paste the same reply :-)
> 
> Oh so you expect me to remember what happened with previous versions ? :-)

:-)

> 
> >     Sakari asked the same thing in v4 :-)
> > 
> >     In short no its not needed please see Geert's response [1]. If I
> >     recall correctly this was also discussed in more detail in another
> >     thread for some other driver whit a bit longer answer saying that it
> >     pm_runtime_get_sync() fails you have big problems but I can't find
> >     that thread now :-(
> > 
> >     1. https://www.spinics.net/lists/linux-media/msg115241.html
> 
> If kmalloc() fails we also have big problems, but we nonetheless check every 
> memory allocation.

I did some quick and dirty statistics for current upstream behavior,

$ git grep pm_runtime_get_sync | wc -l
1044
$ git grep pm_runtime_get_sync | grep = | wc -l
367

It looks like a less then half checks the return value :-) But as it 
will take at least one more incarnation of this patch set I will add a 
check for it get to the good side of things.

> 
> > >> +
> > >> +	/* Make register writes take effect immediately */
> > >> +	vnmc = rvin_read(vin, VNMC_REG);
> > >> +	rvin_write(vin, vnmc & ~VNMC_VUP, VNMC_REG);
> > >> +
> > >> +	ifmd = VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
> > >> +		VNCSI_IFMD_CSI_CHSEL(chsel);
> > >> +
> > >> +	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
> > >> +
> > >> +	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
> > >> +
> > >> +	/* Restore VNMC */
> > >> +	rvin_write(vin, vnmc, VNMC_REG);
> > > 
> > > No need for locking around all this ? What happens if this VIN instance
> > > decides to write to another VIN register (for instance due to a userpace
> > > call) when this function has disabled VNMC_VUP ?
> > 
> > You also asked a related question to this in v9 as a start I will copy
> > in that reply.
> > 
> >     Media link changes are not allowed when any VIN in the group are
> >     streaming so this should not be an issue.
> > 
> > And to compliment that. This function is only valid for a VIN which has
> > the CHSEL register which currently is VIN0 and VIN4. It can only be
> > modified when a media link is enabled. Catching media links are only
> > allowed when all VIN in the system are _not_ streaming. And VNMC_VUP is
> > only enabled when a VIN is streaming so there is no need for locking
> > here.
> 
> This seems a bit fragile to me, could you please capture the explanation in a 
> comment ?
> 

Will do.

> > >> +	pm_runtime_put(vin->dev);
> > >> +}
> > >> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> > >> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> > >> 146683142e6533fa..a5dae5b5e9cb704b 100644
> > >> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > >> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > >> @@ -165,4 +165,6 @@ const struct rvin_video_format
> > >> *rvin_format_from_pixel(u32 pixelformat); /* Cropping, composing and
> > >> scaling */
> > >> 
> > >>  void rvin_crop_scale_comp(struct rvin_dev *vin);
> > >> 
> > >> +void rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
> > >> +
> > >>  #endif
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
