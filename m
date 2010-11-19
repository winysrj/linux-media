Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.48]:32167 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860Ab0KSVOX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 16:14:23 -0500
Date: Fri, 19 Nov 2010 23:15:21 +0200
From: David Cohen <david.cohen@nokia.com>
To: "ext Aguirre, Sergio" <saaguirre@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [omap3isp][PATCH v2 5/9] omap3isp: Remove unused CBUFF
 register access
Message-ID: <20101119211521.GA12283@esdhcp04381.research.nokia.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
 <1289831401-593-6-git-send-email-saaguirre@ti.com>
 <20101119101944.GC13490@esdhcp04381.research.nokia.com>
 <201011191133.19016.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE8944850C0826@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A24693684029E5489D1D202277BE8944850C0826@dlee02.ent.ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Nov 19, 2010 at 04:54:01PM +0100, ext Aguirre, Sergio wrote:
> Hi Laurent and David,

Hi Sergio,

> 
> > -----Original Message-----
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > Sent: Friday, November 19, 2010 4:33 AM
> > To: David Cohen
> > Cc: Aguirre, Sergio; linux-media@vger.kernel.org
> > Subject: Re: [omap3isp][PATCH v2 5/9] omap3isp: Remove unused CBUFF
> > register access
> > 
> > Hi David,
> > 
> > On Friday 19 November 2010 11:19:44 David Cohen wrote:
> > > On Mon, Nov 15, 2010 at 03:29:57PM +0100, ext Sergio Aguirre wrote:
> > 
> > [snip]
> > 
> > > > @@ -244,26 +239,6 @@
> > > >
> > > >  #define ISP_CSIB_SYSCONFIG		ISPCCP2_SYSCONFIG
> > > >  #define ISP_CSIA_SYSCONFIG		ISPCSI2_SYSCONFIG
> > > >
> > > > -/* ISP_CBUFF Registers */
> > > > -
> > > > -#define ISP_CBUFF_SYSCONFIG		(0x010)
> > > > -#define ISP_CBUFF_IRQENABLE		(0x01C)
> > > > -
> > > > -#define ISP_CBUFF0_CTRL			(0x020)
> > > > -#define ISP_CBUFF1_CTRL			(0x024)
> > > > -
> > > > -#define ISP_CBUFF0_START		(0x040)
> > > > -#define ISP_CBUFF1_START		(0x044)
> > > > -
> > > > -#define ISP_CBUFF0_END			(0x050)
> > > > -#define ISP_CBUFF1_END			(0x054)
> > > > -
> > > > -#define ISP_CBUFF0_WINDOWSIZE		(0x060)
> > > > -#define ISP_CBUFF1_WINDOWSIZE		(0x064)
> > > > -
> > > > -#define ISP_CBUFF0_THRESHOLD		(0x070)
> > > > -#define ISP_CBUFF1_THRESHOLD		(0x074)
> > > > -
> > >
> > > No need to remove the registers from header file. We're not using them
> > > on current version, but it doesn't mean we won't use ever. :)
> > 
> > I would have made the same comment for other registers, but we're not
> > using
> > the CBUFF module at all here, with no plans to use it in the future. It
> > might
> > not be worth it keeping the register definitions. I have no strong feeling
> > about it, I'm fine with both choices.
> 
> David,
> 
> IMO, we should not introduce dead code/unusued defines in the first omap3isp
> upstream version. I think it's already quite hard to review for somebody
> outside the omap3isp development team.
> 
> Having all this just in case will most probably end up in bulk, as we
> might never implement the CBUFF HW block, as Laurent mentions.

That's a good point. I see no problem in removing it in that case.

Br,

David

> 
> I'll be more biased on all this being re-added if we end up implementing a ispcbuff submodule.
> 
> Regards,
> Sergio
> 
> 
> > 
> > --
> > Regards,
> > 
> > Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
