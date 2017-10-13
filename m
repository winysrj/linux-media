Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:37162 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdJMSFi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 14:05:38 -0400
Date: Fri, 13 Oct 2017 13:05:34 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Tero Kristo <t-kristo@ti.com>, Rob Herring <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [Patch 5/6] ARM: DRA7: hwmod: Add VPE nodes
Message-ID: <20171013180534.GI25400@ti.com>
References: <20171012192719.15193-1-bparrot@ti.com>
 <20171012192719.15193-6-bparrot@ti.com>
 <20171013170513.GM4394@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20171013170513.GM4394@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tony Lindgren <tony@atomide.com> wrote on Fri [2017-Oct-13 10:05:13 -0700]:
> * Benoit Parrot <bparrot@ti.com> [171012 12:28]:
> > +static struct omap_hwmod_class_sysconfig dra7xx_vpe_sysc = {
> > +	.sysc_offs	= 0x0010,
> > +	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
> > +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
> > +			   MSTANDBY_FORCE | MSTANDBY_NO |
> > +			   MSTANDBY_SMART),
> > +	.sysc_fields	= &omap_hwmod_sysc_type2,
> > +};
> 
> I think checkpatch.pl --strict would complain about unnecessary
> parentheses, might as well check the whole series while at it.

I actually ran the whole series through "checkpatch.pl --strict"
before posting. And other then the usual MAINTAINER file needing
update warning for the binding patch it no other warning or error.

Based on the rest of the file I believe the parentheses around those
flags are at least consistent.

Now, would the .rev_offs comment also apply here?

Benoit

> 
> Regards,
> 
> Tony
