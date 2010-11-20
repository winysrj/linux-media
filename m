Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.47]:42116 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0KTJ7b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 04:59:31 -0500
Date: Sat, 20 Nov 2010 12:00:30 +0200
From: David Cohen <david.cohen@nokia.com>
To: "ext Aguirre, Sergio" <saaguirre@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [omap3isp][PATCH v2 8/9] omap3isp: ccp2: Make SYSCONFIG fields
 consistent
Message-ID: <20101120100030.GA13186@esdhcp04381.research.nokia.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
 <1289831401-593-9-git-send-email-saaguirre@ti.com>
 <20101119100613.GA13490@esdhcp04381.research.nokia.com>
 <A24693684029E5489D1D202277BE8944850C0D6D@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A24693684029E5489D1D202277BE8944850C0D6D@dlee02.ent.ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, Nov 20, 2010 at 12:10:11AM +0100, ext Aguirre, Sergio wrote:
> 
> 
> > -----Original Message-----
> > From: Aguirre, Sergio
> > Sent: Friday, November 19, 2010 9:44 AM
> > To: 'David Cohen'
> > Cc: Laurent Pinchart; linux-media@vger.kernel.org
> > Subject: RE: [omap3isp][PATCH v2 8/9] omap3isp: ccp2: Make SYSCONFIG
> > fields consistent
> > 
> > 
> > > -----Original Message-----
> > > From: David Cohen [mailto:david.cohen@nokia.com]
> > > Sent: Friday, November 19, 2010 4:06 AM
> > > To: Aguirre, Sergio
> > > Cc: Laurent Pinchart; linux-media@vger.kernel.org
> > > Subject: Re: [omap3isp][PATCH v2 8/9] omap3isp: ccp2: Make SYSCONFIG
> > > fields consistent
> > >
> > > Hi Sergio,
> > 
> > Hi David,
> > 
> > Thanks for the review.
> > 
> > >
> > > I've few comments below.
> > >
> > > On Mon, Nov 15, 2010 at 03:30:00PM +0100, ext Sergio Aguirre wrote:
> > > > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > > > ---
> > > >  drivers/media/video/isp/ispccp2.c |    3 +--
> > > >  drivers/media/video/isp/ispreg.h  |   14 ++++++++------
> > > >  2 files changed, 9 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/drivers/media/video/isp/ispccp2.c
> > > b/drivers/media/video/isp/ispccp2.c
> > > > index fa23394..3127a74 100644
> > > > --- a/drivers/media/video/isp/ispccp2.c
> > > > +++ b/drivers/media/video/isp/ispccp2.c
> > > > @@ -419,8 +419,7 @@ static void ispccp2_mem_configure(struct
> > > isp_ccp2_device *ccp2,
> > > >  		config->src_ofst = 0;
> > > >  	}
> > > >
> > > > -	isp_reg_writel(isp, (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
> > > > -		       ISPCSI1_MIDLEMODE_SHIFT),
> > > > +	isp_reg_writel(isp, ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART,
> > > >  		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_SYSCONFIG);
> > >
> > > To make your cleanup even better, you could change isp_reg_clr_set()
> > > instead.
> > > If CCP2 MSTANDY_MODE is set to NOSTANDY, the result is going to be an
> > > invalid 0x3 value. Despite it cannot happen with the current code, it's
> > > still better to avoid such situations for future versions. :)
> > 
> > Hmm you're right, I guess I didn't do any real functional changes, just
> > defines renaming.
> > 
> > I can repost an updated patch with this suggestion. No problem.
> 
> David,
> 
> Geez I guess I wasn't paying much attention to this either. Sorry.
> 
> The case you mention about it potentially become 0x3 is not possible, because, I'm basically overwriting the whole register with (0x2 << 12)
> Notice the isp_reg_write, there's no OR operation...

That's correct. My mistake.
IMO ISP power settings still need a better way to be setup, but it
definitively does not belong to your cleanup patch.
I'm fine with your changes.

> 
> Now, this means that we have been implicitly setting other fields as Zeroes (SOFT_RESET = 0, and AUTO_IDLE = 0) aswell.
> 
> Has AUTOIDLE in CCP2 been tried in N900? I don't have a CCP2 sensor to test
> with :(.

I have no idea. Indeed, AUTOIDLE in ISP doesn't seem to be much reliable
so far. It should be set to 0 until somebody proves it can be set to 1 :)

Br,

David

> 
> Regards,
> Sergio
> 
> > 
> > >
> > > >
> > > >  	/* Hsize, Skip */
> > > > diff --git a/drivers/media/video/isp/ispreg.h
> > > b/drivers/media/video/isp/ispreg.h
> > > > index d885541..9b0d3ad 100644
> > > > --- a/drivers/media/video/isp/ispreg.h
> > > > +++ b/drivers/media/video/isp/ispreg.h
> > > > @@ -141,6 +141,14 @@
> > > >  #define ISPCCP2_REVISION		(0x000)
> > > >  #define ISPCCP2_SYSCONFIG		(0x004)
> > > >  #define ISPCCP2_SYSCONFIG_SOFT_RESET	(1 << 1)
> > > > +#define ISPCCP2_SYSCONFIG_AUTO_IDLE		0x1
> > > > +#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT	12
> > > > +#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_FORCE	\
> > > > +	(0x0 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
> > > > +#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_NO	\
> > > > +	(0x1 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
> > > > +#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART	\
> > > > +	(0x2 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
> > >
> > > You can add some ISPCCP2_SYSCONFIG_MSTANDY_MODE_MASK, as 2 bits must be
> > > always set together.
> > 
> > Sure, will do.
> > 
> > Thanks and Regards,
> > Sergio
> > 
> > >
> > > Regards,
> > >
> > > David Cohen
> > >
> > > >  #define ISPCCP2_SYSSTATUS		(0x008)
> > > >  #define ISPCCP2_SYSSTATUS_RESET_DONE	(1 << 0)
> > > >  #define ISPCCP2_LC01_IRQENABLE		(0x00C)
> > > > @@ -1309,12 +1317,6 @@
> > > >  #define ISPMMU_SIDLEMODE_SMARTIDLE		2
> > > >  #define ISPMMU_SIDLEMODE_SHIFT			3
> > > >
> > > > -#define ISPCSI1_AUTOIDLE			0x1
> > > > -#define ISPCSI1_MIDLEMODE_SHIFT			12
> > > > -#define ISPCSI1_MIDLEMODE_FORCESTANDBY		0x0
> > > > -#define ISPCSI1_MIDLEMODE_NOSTANDBY		0x1
> > > > -#define ISPCSI1_MIDLEMODE_SMARTSTANDBY		0x2
> > > > -
> > > >  /* ------------------------------------------------------------------
> > --
> > > ---------
> > > >   * CSI2 receiver registers (ES2.0)
> > > >   */
> > > > --
> > > > 1.7.0.4
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-media"
> > > in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
