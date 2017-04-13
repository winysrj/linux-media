Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41903 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755975AbdDMKIr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 06:08:47 -0400
Message-ID: <1492078027.2383.19.camel@pengutronix.de>
Subject: Re: [PATCH] [media] imx: csi: retain current field order and
 colorimetry setting as default
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 13 Apr 2017 12:07:07 +0200
In-Reply-To: <6c22519f-64f8-7213-d458-23470bdd5ecd@xs4all.nl>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
         <1490661656-10318-22-git-send-email-steve_longerbeam@mentor.com>
         <1491486929.2392.29.camel@pengutronix.de>
         <0f9690f8-c7f6-59ff-9e3e-123af9972d4b@xs4all.nl>
         <1491490451.2392.70.camel@pengutronix.de>
         <59e72974-bfb0-6061-8b13-5f13f8723ba6@xs4all.nl>
         <1491494481.2392.102.camel@pengutronix.de>
         <6c22519f-64f8-7213-d458-23470bdd5ecd@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-04-12 at 09:03 +0200, Hans Verkuil wrote:
[...]
> >> Do you have a git tree with this patch? It is really hard to review without
> >> having the full imx-media-csi.c source.
> > 
> > The patch applies on top of
> > 
> >   https://github.com/slongerbeam/mediatree.git imx-media-staging-md-v14
> > 
> > I have uploaded a branch
> > 
> >   git://git.pengutronix.de/git/pza/linux imx-media-staging-md-v14+color
> > 
> > with the patch applied on top.
> > 
> >> I think one problem is that it is not clearly defined how subdevs and colorspace
> >> information should work.
> 
> Ah, having the full source helped.
> 
> Ignore my previous review, it was incorrect.

Ok.

> I'll have to think about this some more. I'll get back to this, but it may take some
> time since my vacation starts tomorrow. The spec is simply unclear about how to handle
> this so we have to come up with some guidelines.

Yes, please. Until then, have a nice vacation.

regards
Philipp
