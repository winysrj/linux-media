Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44196 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751612AbdJMSDm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 14:03:42 -0400
Date: Fri, 13 Oct 2017 11:03:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [Patch 3/6] ARM: OMAP: DRA7xx: Make CAM clock domain SWSUP only
Message-ID: <20171013180338.GS4394@atomide.com>
References: <20171012192719.15193-1-bparrot@ti.com>
 <20171012192719.15193-4-bparrot@ti.com>
 <20171013170113.GL4394@atomide.com>
 <20171013175942.GH25400@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013175942.GH25400@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Benoit Parrot <bparrot@ti.com> [171013 11:01]:
> Tony Lindgren <tony@atomide.com> wrote on Fri [2017-Oct-13 10:01:13 -0700]:
> > * Benoit Parrot <bparrot@ti.com> [171012 12:29]:
> > > HWSUP on this domain is only working when VIP1 probes.
> > > If only VIP2 on DRA74x or CAL on DRA72x probes the domain does
> > > not get enabled. This might indicates an issue in the HW Auto
> > > state-machine for this domain.
> > >
> > > Work around is to set the CAM domain to use SWSUP only.
> > 
> > Hmm this you might get fixed automatically by configuring the
> > parent interconnect target module to use "ti,sysc-omap4" and
> > adding VIP1 and VIP2 as children to it.
> > 
> > The reason why I suspect it will fix the issue is because
> > with the parent being "ti,sysc-omap4" with "ti,hwmods" being
> > in that parent node too, you automatically get PM runtime
> > refcounting keep the parent active for either child.
> > 
> > Maybe give it a try against today's Linux next and see for
> > example how it was done for musb:
> > 
> > https://patchwork.kernel.org/patch/9978783/
> > 
> > Just use "ti,sysc-omap2" for type1 and "ti,sysc-omap4"
> > for type2.
> 
> Hmm interesting, I'll give that a try and if it fixes it.

OK great. Note that you need to manually apply "[PATCH] ARM:
head-common.S: Clear lr before jumping to start_kernel()" on
today's next and make sure CONFIG_DRM and CONFIG_DRM_KMS_HELPER
are built-in and not modules if using them.

Regards,

Tony
