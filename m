Return-path: <mchehab@gaivota>
Received: from devils.ext.ti.com ([198.47.26.153]:50859 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab0KSW6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 17:58:40 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>,
	David Cohen <david.cohen@nokia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 19 Nov 2010 16:58:32 -0600
Subject: RE: [omap3isp][PATCH v2 7/9] omap3isp: Cleanup isp_power_settings
Message-ID: <A24693684029E5489D1D202277BE8944850C0D5C@dlee02.ent.ti.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
 <1289831401-593-8-git-send-email-saaguirre@ti.com>
 <20101119101802.GB13490@esdhcp04381.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



> -----Original Message-----
> From: Aguirre, Sergio
> Sent: Friday, November 19, 2010 9:46 AM
> To: 'David Cohen'
> Cc: Laurent Pinchart; linux-media@vger.kernel.org
> Subject: RE: [omap3isp][PATCH v2 7/9] omap3isp: Cleanup isp_power_settings
> > -----Original Message-----
> > From: David Cohen [mailto:david.cohen@nokia.com]
> > Sent: Friday, November 19, 2010 4:18 AM
> > To: Aguirre, Sergio
> > Cc: Laurent Pinchart; linux-media@vger.kernel.org
> > Subject: Re: [omap3isp][PATCH v2 7/9] omap3isp: Cleanup
> isp_power_settings
> >
> > Hi Sergio,
> >
> > Thanks for the patch.
> 
> Hi David,
> 
> Thanks for the comments.
> 
> >
> > On Mon, Nov 15, 2010 at 03:29:59PM +0100, ext Sergio Aguirre wrote:
> > > 1. Get rid of CSI2 / CCP2 power settings, as they are controlled
> > >    in the receivers code anyways.
> >
> > CCP2 is not correctly handling this. It's setting SMART STANDBY mode one
> > when reading from memory. You should fix it before remove such code from
> > ISP core driver.
> 
> Ok, agreed.
> 
> I'll generate a new patch before this to compensate that. Not a problem.

Is N900 seeing any functional difference w/ this patch?

Actually, I reanalyzed the patch, and this code should be unexecuted, since
it is conditioned to 3430 ES1.0 chip (omap_rev() == OMAP3430_REV_ES1_0),
which I don't think much people has access. And not definitely any
production quality device.

Even the N900 is using ES3.1 or something like that AFAIK.

So, It should not make any functional difference, unless you have an ES1.0.

Regards,
Sergio

> 
> >
> > > 2. Avoid code duplication.
> >
> > Agree. But only after considering the comment above.
> 
> Ok.
> 
> Thanks and Regards,
> Sergio
> 
> >
> > Regards,
> >
> > David
> >
> > >
> > > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > > ---
> > >  drivers/media/video/isp/isp.c |   49 ++++++--------------------------
> --
> > -------
> > >  1 files changed, 7 insertions(+), 42 deletions(-)
> > >
> > > diff --git a/drivers/media/video/isp/isp.c
> > b/drivers/media/video/isp/isp.c
> > > index de9352b..30bdc48 100644
> > > --- a/drivers/media/video/isp/isp.c
> > > +++ b/drivers/media/video/isp/isp.c
> > > @@ -254,48 +254,13 @@ EXPORT_SYMBOL(isp_set_xclk);
> > >   */
> > >  static void isp_power_settings(struct isp_device *isp, int idle)
> > >  {
> > > -	if (idle) {
> > > -		isp_reg_writel(isp,
> > > -			       (ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY <<
> > > -				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
> > > -			       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
> > > -		if (omap_rev() == OMAP3430_REV_ES1_0) {
> > > -			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
> > > -				       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
> > > -					ISPCSI1_MIDLEMODE_SHIFT),
> > > -				       OMAP3_ISP_IOMEM_CSI2A_REGS1,
> > > -				       ISPCSI2_SYSCONFIG);
> > > -			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
> > > -				       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
> > > -					ISPCSI1_MIDLEMODE_SHIFT),
> > > -				       OMAP3_ISP_IOMEM_CCP2,
> > > -				       ISPCCP2_SYSCONFIG);
> > > -		}
> > > -		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE,
> > OMAP3_ISP_IOMEM_MAIN,
> > > -			       ISP_CTRL);
> > > -
> > > -	} else {
> > > -		isp_reg_writel(isp,
> > > -			       (ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY <<
> > > -				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
> > > -			       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
> > > -		if (omap_rev() == OMAP3430_REV_ES1_0) {
> > > -			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
> > > -				       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
> > > -					ISPCSI1_MIDLEMODE_SHIFT),
> > > -				       OMAP3_ISP_IOMEM_CSI2A_REGS1,
> > > -				       ISPCSI2_SYSCONFIG);
> > > -
> > > -			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
> > > -				       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
> > > -					ISPCSI1_MIDLEMODE_SHIFT),
> > > -				       OMAP3_ISP_IOMEM_CCP2,
> > > -				       ISPCCP2_SYSCONFIG);
> > > -		}
> > > -
> > > -		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE,
> > OMAP3_ISP_IOMEM_MAIN,
> > > -			       ISP_CTRL);
> > > -	}
> > > +	isp_reg_writel(isp,
> > > +		       ((idle ? ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY :
> > > +				ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY) <<
> > > +			ISP_SYSCONFIG_MIDLEMODE_SHIFT),
> > > +		       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
> > > +	isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
> > > +		       ISP_CTRL);
> > >  }
> > >
> > >  /*
> > > --
> > > 1.7.0.4
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media"
> > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
