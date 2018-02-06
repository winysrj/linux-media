Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbeBFNYM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 08:24:12 -0500
Date: Tue, 6 Feb 2018 16:23:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing
 with a mask
Message-ID: <20180206132335.luut6em3kut7f7ej@mwanda>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
 <20180206131044.oso33fvv553trrd7@mwanda>
 <alpine.DEB.2.20.1802061414340.3306@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1802061414340.3306@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 06, 2018 at 02:15:51PM +0100, Julia Lawall wrote:
> 
> 
> On Tue, 6 Feb 2018, Dan Carpenter wrote:
> 
> > On Mon, Feb 05, 2018 at 09:09:57PM +0100, Wolfram Sang wrote:
> > > In one Renesas driver, I found a typo which turned an intended bit shift ('<<')
> > > into a comparison ('<'). Because this is a subtle issue, I looked tree wide for
> > > similar patterns. This small patch series is the outcome.
> > >
> > > Buildbot and checkpatch are happy. Only compile-tested. To be applied
> > > individually per sub-system, I think. I'd think only the net: amd: patch needs
> > > to be conisdered for stable, but I leave this to people who actually know this
> > > driver.
> > >
> > > CCing Dan. Maybe he has an idea how to add a test to smatch? In my setup, only
> > > cppcheck reported a 'coding style' issue with a low prio.
> > >
> >
> > Most of these are inside macros so it makes it complicated for Smatch
> > to warn about them.  It might be easier in Coccinelle.  Julia the bugs
> > look like this:
> >
> > -			reissue_mask |= 0xffff < 4;
> > +			reissue_mask |= 0xffff << 4;
> 
> Thanks.  I'll take a look.  Do you have an example of the macro issue
> handy?
> 

It's the same:

#define EXYNOS_CIIMGEFF_PAT_CBCR_MASK          ((0xff < 13) | (0xff < 0)) 

Smatch only sees the outside of the macro (where it is used in the code)
and the pre-processed code.

regards,
dan carpenter
