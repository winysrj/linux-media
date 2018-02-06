Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:47665 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752246AbeBFNQJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 08:16:09 -0500
Date: Tue, 6 Feb 2018 14:15:51 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing
 with a mask
In-Reply-To: <20180206131044.oso33fvv553trrd7@mwanda>
Message-ID: <alpine.DEB.2.20.1802061414340.3306@hadrien>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com> <20180206131044.oso33fvv553trrd7@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 6 Feb 2018, Dan Carpenter wrote:

> On Mon, Feb 05, 2018 at 09:09:57PM +0100, Wolfram Sang wrote:
> > In one Renesas driver, I found a typo which turned an intended bit shift ('<<')
> > into a comparison ('<'). Because this is a subtle issue, I looked tree wide for
> > similar patterns. This small patch series is the outcome.
> >
> > Buildbot and checkpatch are happy. Only compile-tested. To be applied
> > individually per sub-system, I think. I'd think only the net: amd: patch needs
> > to be conisdered for stable, but I leave this to people who actually know this
> > driver.
> >
> > CCing Dan. Maybe he has an idea how to add a test to smatch? In my setup, only
> > cppcheck reported a 'coding style' issue with a low prio.
> >
>
> Most of these are inside macros so it makes it complicated for Smatch
> to warn about them.  It might be easier in Coccinelle.  Julia the bugs
> look like this:
>
> -			reissue_mask |= 0xffff < 4;
> +			reissue_mask |= 0xffff << 4;

Thanks.  I'll take a look.  Do you have an example of the macro issue
handy?

julia

>
> regards,
> dan carpenter
>
> > Wolfram Sang (4):
> >   v4l: vsp1: fix mask creation for MULT_ALPHA_RATIO
> >   drm/exynos: fix comparison to bitshift when dealing with a mask
> >   v4l: dvb-frontends: stb0899: fix comparison to bitshift when dealing
> >     with a mask
> >   net: amd-xgbe: fix comparison to bitshift when dealing with a mask
> >
> >  drivers/gpu/drm/exynos/regs-fimc.h        | 2 +-
> >  drivers/media/dvb-frontends/stb0899_reg.h | 8 ++++----
> >  drivers/media/platform/vsp1/vsp1_regs.h   | 2 +-
> >  drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 2 +-
> >  4 files changed, 7 insertions(+), 7 deletions(-)
> >
> > --
> > 2.11.0
>
