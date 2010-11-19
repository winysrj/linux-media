Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:53776 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab0KSPoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 10:44:24 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: David Cohen <david.cohen@nokia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 19 Nov 2010 09:44:17 -0600
Subject: RE: [omap3isp][PATCH v2 8/9] omap3isp: ccp2: Make SYSCONFIG fields
 consistent
Message-ID: <A24693684029E5489D1D202277BE8944850C0800@dlee02.ent.ti.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
 <1289831401-593-9-git-send-email-saaguirre@ti.com>
 <20101119100613.GA13490@esdhcp04381.research.nokia.com>
In-Reply-To: <20101119100613.GA13490@esdhcp04381.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


> -----Original Message-----
> From: David Cohen [mailto:david.cohen@nokia.com]
> Sent: Friday, November 19, 2010 4:06 AM
> To: Aguirre, Sergio
> Cc: Laurent Pinchart; linux-media@vger.kernel.org
> Subject: Re: [omap3isp][PATCH v2 8/9] omap3isp: ccp2: Make SYSCONFIG
> fields consistent
> 
> Hi Sergio,

Hi David,

Thanks for the review.

> 
> I've few comments below.
> 
> On Mon, Nov 15, 2010 at 03:30:00PM +0100, ext Sergio Aguirre wrote:
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > ---
> >  drivers/media/video/isp/ispccp2.c |    3 +--
> >  drivers/media/video/isp/ispreg.h  |   14 ++++++++------
> >  2 files changed, 9 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/media/video/isp/ispccp2.c
> b/drivers/media/video/isp/ispccp2.c
> > index fa23394..3127a74 100644
> > --- a/drivers/media/video/isp/ispccp2.c
> > +++ b/drivers/media/video/isp/ispccp2.c
> > @@ -419,8 +419,7 @@ static void ispccp2_mem_configure(struct
> isp_ccp2_device *ccp2,
> >  		config->src_ofst = 0;
> >  	}
> >
> > -	isp_reg_writel(isp, (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
> > -		       ISPCSI1_MIDLEMODE_SHIFT),
> > +	isp_reg_writel(isp, ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART,
> >  		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_SYSCONFIG);
> 
> To make your cleanup even better, you could change isp_reg_clr_set()
> instead.
> If CCP2 MSTANDY_MODE is set to NOSTANDY, the result is going to be an
> invalid 0x3 value. Despite it cannot happen with the current code, it's
> still better to avoid such situations for future versions. :)

Hmm you're right, I guess I didn't do any real functional changes, just defines renaming.

I can repost an updated patch with this suggestion. No problem.

> 
> >
> >  	/* Hsize, Skip */
> > diff --git a/drivers/media/video/isp/ispreg.h
> b/drivers/media/video/isp/ispreg.h
> > index d885541..9b0d3ad 100644
> > --- a/drivers/media/video/isp/ispreg.h
> > +++ b/drivers/media/video/isp/ispreg.h
> > @@ -141,6 +141,14 @@
> >  #define ISPCCP2_REVISION		(0x000)
> >  #define ISPCCP2_SYSCONFIG		(0x004)
> >  #define ISPCCP2_SYSCONFIG_SOFT_RESET	(1 << 1)
> > +#define ISPCCP2_SYSCONFIG_AUTO_IDLE		0x1
> > +#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT	12
> > +#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_FORCE	\
> > +	(0x0 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
> > +#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_NO	\
> > +	(0x1 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
> > +#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART	\
> > +	(0x2 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
> 
> You can add some ISPCCP2_SYSCONFIG_MSTANDY_MODE_MASK, as 2 bits must be
> always set together.

Sure, will do.

Thanks and Regards,
Sergio

> 
> Regards,
> 
> David Cohen
> 
> >  #define ISPCCP2_SYSSTATUS		(0x008)
> >  #define ISPCCP2_SYSSTATUS_RESET_DONE	(1 << 0)
> >  #define ISPCCP2_LC01_IRQENABLE		(0x00C)
> > @@ -1309,12 +1317,6 @@
> >  #define ISPMMU_SIDLEMODE_SMARTIDLE		2
> >  #define ISPMMU_SIDLEMODE_SHIFT			3
> >
> > -#define ISPCSI1_AUTOIDLE			0x1
> > -#define ISPCSI1_MIDLEMODE_SHIFT			12
> > -#define ISPCSI1_MIDLEMODE_FORCESTANDBY		0x0
> > -#define ISPCSI1_MIDLEMODE_NOSTANDBY		0x1
> > -#define ISPCSI1_MIDLEMODE_SMARTSTANDBY		0x2
> > -
> >  /* --------------------------------------------------------------------
> ---------
> >   * CSI2 receiver registers (ES2.0)
> >   */
> > --
> > 1.7.0.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
