Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:38007 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1HaUiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 16:38:54 -0400
Date: Wed, 31 Aug 2011 23:38:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, gary@mlbassoc.com
Subject: Re: [HACK v2 1/4] omap3isp: ccdc: Remove support for interlaced
 data and master HS/VS mode
Message-ID: <20110831203849.GP12368@valkosipuli.localdomain>
References: <1314808322-30069-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1314808322-30069-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20110831194711.GO12368@valkosipuli.localdomain>
 <201108312158.43549.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108312158.43549.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 31, 2011 at 09:58:42PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wednesday 31 August 2011 21:47:11 Sakari Ailus wrote:
> > On Wed, Aug 31, 2011 at 06:31:59PM +0200, Laurent Pinchart wrote:
> > > Those features are half-implemented and not used. Remove them.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/media/video/omap3isp/ispccdc.c |   42
> > >  +++---------------------------- drivers/media/video/omap3isp/ispccdc.h
> > >  |   18 -------------
> > >  2 files changed, 4 insertions(+), 56 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/omap3isp/ispccdc.c
> > > b/drivers/media/video/omap3isp/ispccdc.c index 40b141c..176efae 100644
> > > --- a/drivers/media/video/omap3isp/ispccdc.c
> > > +++ b/drivers/media/video/omap3isp/ispccdc.c
> > > @@ -965,13 +965,11 @@ static void ccdc_config_sync_if(struct
> > > isp_ccdc_device *ccdc,
> > > 
> > >  	u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
> > >  	
> > >  				     ISPCCDC_SYN_MODE);
> > > 
> > > +	syn_mode &= ~(ISPCCDC_SYN_MODE_FLDSTAT | ISPCCDC_SYN_MODE_EXWEN |
> > > +		      ISPCCDC_SYN_MODE_FLDMODE | ISPCCDC_SYN_MODE_FLDPOL |
> > > +		      ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT);
> > 
> > This might be a silly question but is there a need to read some bits from
> > the the register? It seems to me that awfully many of the will always get
> > overwritten.
> 
> I've been thinking about that as well. The only bits we won't overwrite are 
> the reserved bits. I guess we can just write them to 0.

I agree. The read can be removed, and that actually simplifies the rest of
the function as well since there's no need to reset those bits anymore.

> > >  	syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
> > > 
> > > -	if (syncif->fldstat)
> > > -		syn_mode |= ISPCCDC_SYN_MODE_FLDSTAT;
> > > -	else
> > > -		syn_mode &= ~ISPCCDC_SYN_MODE_FLDSTAT;
> > > -
> > > 
> > >  	syn_mode &= ~ISPCCDC_SYN_MODE_DATSIZ_MASK;
> > >  	switch (syncif->datsz) {
> > > 
> > >  	case 8:
> > > @@ -988,21 +986,11 @@ static void ccdc_config_sync_if(struct
> > > isp_ccdc_device *ccdc,
> > > 
> > >  		break;
> > >  	
> > >  	};
> > > 
> > > -	if (syncif->fldmode)
> > > -		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
> > > -	else
> > > -		syn_mode &= ~ISPCCDC_SYN_MODE_FLDMODE;
> > > -
> > > 
> > >  	if (syncif->datapol)
> > >  	
> > >  		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
> > >  	
> > >  	else
> > >  	
> > >  		syn_mode &= ~ISPCCDC_SYN_MODE_DATAPOL;
> > > 
> > > -	if (syncif->fldpol)
> > > -		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
> > > -	else
> > > -		syn_mode &= ~ISPCCDC_SYN_MODE_FLDPOL;
> > > -
> > > 
> > >  	if (syncif->hdpol)
> > >  	
> > >  		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
> > >  	
> > >  	else
> > > 
> > > @@ -1013,23 +1001,6 @@ static void ccdc_config_sync_if(struct
> > > isp_ccdc_device *ccdc,
> > > 
> > >  	else
> > >  	
> > >  		syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
> > > 
> > > -	if (syncif->ccdc_mastermode) {
> > > -		syn_mode |= ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT;
> > > -		isp_reg_writel(isp,
> > > -			       syncif->hs_width << ISPCCDC_HD_VD_WID_HDW_SHIFT
> > > -			     | syncif->vs_width << ISPCCDC_HD_VD_WID_VDW_SHIFT,
> > > -			       OMAP3_ISP_IOMEM_CCDC,
> > > -			       ISPCCDC_HD_VD_WID);
> > > -
> > > -		isp_reg_writel(isp,
> > > -			       syncif->ppln << ISPCCDC_PIX_LINES_PPLN_SHIFT
> > > -			     | syncif->hlprf << ISPCCDC_PIX_LINES_HLPRF_SHIFT,
> > > -			       OMAP3_ISP_IOMEM_CCDC,
> > > -			       ISPCCDC_PIX_LINES);
> > > -	} else
> > > -		syn_mode &= ~(ISPCCDC_SYN_MODE_FLDOUT |
> > > -			      ISPCCDC_SYN_MODE_VDHDOUT);
> > > -
> > > 
> > >  	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
> > >  	
> > >  	if (!syncif->bt_r656_en)
> > > 
> > > @@ -1148,6 +1119,7 @@ static void ccdc_configure(struct isp_ccdc_device
> > > *ccdc)
> > > 
> > >  	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
> > >  	
> > >  	ccdc->syncif.datsz = depth_out;
> > > 
> > > +	ccdc->syncif.datapol = 0;
> > > 
> > >  	ccdc->syncif.hdpol = pdata ? pdata->hs_pol : 0;
> > >  	ccdc->syncif.vdpol = pdata ? pdata->vs_pol : 0;
> > >  	ccdc_config_sync_if(ccdc, &ccdc->syncif);
> > > 
> > > @@ -2258,13 +2230,7 @@ int omap3isp_ccdc_init(struct isp_device *isp)
> > > 
> > >  	INIT_LIST_HEAD(&ccdc->lsc.free_queue);
> > >  	spin_lock_init(&ccdc->lsc.req_lock);
> > > 
> > > -	ccdc->syncif.ccdc_mastermode = 0;
> > > -	ccdc->syncif.datapol = 0;
> > > 
> > >  	ccdc->syncif.datsz = 0;
> > > 
> > > -	ccdc->syncif.fldmode = 0;
> > > -	ccdc->syncif.fldout = 0;
> > > -	ccdc->syncif.fldpol = 0;
> > > -	ccdc->syncif.fldstat = 0;
> > > 
> > >  	ccdc->clamp.oblen = 0;
> > >  	ccdc->clamp.dcsubval = 0;
> > > 
> > > diff --git a/drivers/media/video/omap3isp/ispccdc.h
> > > b/drivers/media/video/omap3isp/ispccdc.h index 483a19c..0e98f10 100644
> > > --- a/drivers/media/video/omap3isp/ispccdc.h
> > > +++ b/drivers/media/video/omap3isp/ispccdc.h
> > > @@ -48,35 +48,17 @@ enum ccdc_input_entity {
> > > 
> > >  /*
> > >  
> > >   * struct ispccdc_syncif - Structure for Sync Interface between sensor
> > >   and CCDC
> > > 
> > > - * @ccdc_mastermode: Master mode. 1 - Master, 0 - Slave.
> > > - * @fldstat: Field state. 0 - Odd Field, 1 - Even Field.
> > > 
> > >   * @datsz: Data size.
> > > 
> > > - * @fldmode: 0 - Progressive, 1 - Interlaced.
> > > 
> > >   * @datapol: 0 - Positive, 1 - Negative.
> > > 
> > > - * @fldpol: 0 - Positive, 1 - Negative.
> > > 
> > >   * @hdpol: 0 - Positive, 1 - Negative.
> > >   * @vdpol: 0 - Positive, 1 - Negative.
> > > 
> > > - * @fldout: 0 - Input, 1 - Output.
> > > - * @hs_width: Width of the Horizontal Sync pulse, used for HS/VS Output.
> > > - * @vs_width: Width of the Vertical Sync pulse, used for HS/VS Output.
> > > - * @ppln: Number of pixels per line, used for HS/VS Output.
> > > - * @hlprf: Number of half lines per frame, used for HS/VS Output.
> > > 
> > >   * @bt_r656_en: 1 - Enable ITU-R BT656 mode, 0 - Sync mode.
> > >   */
> > >  
> > >  struct ispccdc_syncif {
> > > 
> > > -	u8 ccdc_mastermode;
> > > -	u8 fldstat;
> > > 
> > >  	u8 datsz;
> > > 
> > > -	u8 fldmode;
> > > 
> > >  	u8 datapol;
> > > 
> > > -	u8 fldpol;
> > > 
> > >  	u8 hdpol;
> > >  	u8 vdpol;
> > > 
> > > -	u8 fldout;
> > > -	u8 hs_width;
> > > -	u8 vs_width;
> > > -	u8 ppln;
> > > -	u8 hlprf;
> > > 
> > >  	u8 bt_r656_en;
> > >  
> > >  };
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
sakari.ailus@iki.fi
