Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51739 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0KTKeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 05:34:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Cohen <david.cohen@nokia.com>
Subject: Re: [omap3isp][PATCH v2 8/9] omap3isp: ccp2: Make SYSCONFIG fields consistent
Date: Sat, 20 Nov 2010 11:34:04 +0100
Cc: "ext Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com> <A24693684029E5489D1D202277BE8944850C0D6D@dlee02.ent.ti.com> <20101120100030.GA13186@esdhcp04381.research.nokia.com>
In-Reply-To: <20101120100030.GA13186@esdhcp04381.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011201134.05258.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On Saturday 20 November 2010 11:00:30 David Cohen wrote:
> On Sat, Nov 20, 2010 at 12:10:11AM +0100, ext Aguirre, Sergio wrote:
> > On Friday, November 19, 2010 9:44 AM Aguirre, Sergio wrote:
> > > On Friday, November 19, 2010 4:06 AM David Cohen wrote:
> > > > On Mon, Nov 15, 2010 at 03:30:00PM +0100, ext Sergio Aguirre wrote:
> > > > > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > > > > ---
> > > > > 
> > > > >  drivers/media/video/isp/ispccp2.c |    3 +--
> > > > >  drivers/media/video/isp/ispreg.h  |   14 ++++++++------
> > > > >  2 files changed, 9 insertions(+), 8 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/media/video/isp/ispccp2.c
> > > > 
> > > > b/drivers/media/video/isp/ispccp2.c
> > > > 
> > > > > index fa23394..3127a74 100644
> > > > > --- a/drivers/media/video/isp/ispccp2.c
> > > > > +++ b/drivers/media/video/isp/ispccp2.c
> > > > > @@ -419,8 +419,7 @@ static void ispccp2_mem_configure(struct
> > > > 
> > > > isp_ccp2_device *ccp2,
> > > > 
> > > > >  		config->src_ofst = 0;
> > > > >  	
> > > > >  	}
> > > > > 
> > > > > -	isp_reg_writel(isp, (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
> > > > > -		       ISPCSI1_MIDLEMODE_SHIFT),
> > > > > +	isp_reg_writel(isp, ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART,
> > > > > 
> > > > >  		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_SYSCONFIG);
> > > > 
> > > > To make your cleanup even better, you could change isp_reg_clr_set()
> > > > instead.
> > > > If CCP2 MSTANDY_MODE is set to NOSTANDY, the result is going to be an
> > > > invalid 0x3 value. Despite it cannot happen with the current code,
> > > > it's still better to avoid such situations for future versions. :)
> > > 
> > > Hmm you're right, I guess I didn't do any real functional changes, just
> > > defines renaming.
> > > 
> > > I can repost an updated patch with this suggestion. No problem.
> > 
> > David,
> > 
> > Geez I guess I wasn't paying much attention to this either. Sorry.
> > 
> > The case you mention about it potentially become 0x3 is not possible,
> > because, I'm basically overwriting the whole register with (0x2 << 12)
> > Notice the isp_reg_write, there's no OR operation...
> 
> That's correct. My mistake.
> IMO ISP power settings still need a better way to be setup, but it
> definitively does not belong to your cleanup patch.
> I'm fine with your changes.
> 
> > Now, this means that we have been implicitly setting other fields as
> > Zeroes (SOFT_RESET = 0, and AUTO_IDLE = 0) aswell.
> > 
> > Has AUTOIDLE in CCP2 been tried in N900? I don't have a CCP2 sensor to
> > test with :(.
> 
> I have no idea. Indeed, AUTOIDLE in ISP doesn't seem to be much reliable
> so far. It should be set to 0 until somebody proves it can be set to 1 :)

To summarize things, we're only setting the CCP2 AUTOIDLE bit on ES 1.0 
devices, and we're clearing it anyway ispccp2_mem_configure(). For the sake of 
correctness we should replace isp_reg_writel() by isp_reg_clr_set() in 
ispccp2_mem_configure(), which will only make a difference on ES 1.0 devices 
that have basically no users. Is that OK with both of you ?

-- 
Regards,

Laurent Pinchart
