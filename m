Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:55641 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab0FQOXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 10:23:13 -0400
Date: Thu, 17 Jun 2010 17:23:21 +0300
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	"Nagarajan, Rajkumar" <x0133774@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: Alternative for defconfig
Message-ID: <20100617142321.GJ12255@atomide.com>
References: <201006091227.29175.laurent.pinchart@ideasonboard.com>
 <AANLkTilPWyHcoT6q1T-o-UMvcMSs2_If45f9UocVtrbl@mail.gmail.com>
 <A24693684029E5489D1D202277BE894455DDEC44@dlee02.ent.ti.com>
 <201006111707.34463.laurent.pinchart@ideasonboard.com>
 <AANLkTikdUanfxhkbb0sYZ-Yhd_9dVywv9Yj1a5DL18oN@mail.gmail.com>
 <20100616075642.GA12255@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616075642.GA12255@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [100616 10:50]:
> * Felipe Contreras <felipe.contreras@gmail.com> [100611 19:03]:
> > On Fri, Jun 11, 2010 at 6:07 PM, Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:
> > > My understanding is that Linus will remove all ARM defconfigs in 2.6.36,
> > > unless someone can convince him not to.
> > 
> > Huh? I thought he was only threatening to remove them[1]. I don't
> > think he said he was going to do that without any alternative in
> > place.
> > 
> > My suggestion[2] was to have minimal defconfigs so that we could do
> > $ cp arch/arm/configs/omap3_beagle_baseconfig .config
> > $ echo "" | make ARCH=arm oldconfig
> > 
> > [1] http://article.gmane.org/gmane.linux.kernel/994194
> > [2] http://article.gmane.org/gmane.linux.kernel/995412
> 
> Sounds like the defconfigs will be going though and we'll use
> some Kconfig based system that's still open. I believe Russell
> said he is not taking any more defconfig patches, so we should
> not merge them either.
> 
> Anyways, we already have multi-omap mostly working for both
> mach-omap1 and mach-omap2.
> 
> So the remaining things to do are:
> 
> 1. For mach-omap1, patch entry-macro.S to allow compiling in
>    7xx, 15xx and 16xx. This can be done in a similar way as
>    for mach-omap2. The only issue is how to detect 7xx from
>    other mach-omap1 omaps. If anybody has a chance to work
>    on this, please go for it!

Have not done anything about this.
 
> 2. The old omap_cfg_reg mux function needs to disappear
>    for mach-omap2 and use the new mux code instead. I'm
>    currently working on this and should have it ready
>    for testing this week.

Got finally rid of these. These are in devel-mux branch
on top of the devel-tls branch.
 
> 3. To boot both ARMv6 and 7, we need to get rid of
>    CONFIG_HAS_TLS_REG. I already have a patch for that,
>    I'll try to update that during this week.

Need to still look at this, but a working version is in
devel-tls branch.
 
> 4. To make CONFIG_VFP work for both ARMv6 and 7, we need
>    to fix CONFIG_VFPv3 so it boots on ARMv6 too. It currently
>    oopses. Will take a look at this after I'm done with the
>    CONFIG_HAS_TLS_REG. This is another one where some help
>    would be nice. To reproduce, boot Linux on ARMv6 with
>    CONFIG_VFPv3 set.

Got this fixed, but need to still test. Also in devel-tls
branch.

Regards,

Tony
