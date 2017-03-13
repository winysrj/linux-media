Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56826 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdCMK7Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 06:59:24 -0400
Date: Mon, 13 Mar 2017 10:58:42 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, mark.rutland@arm.com,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        nick@shmanahar.org, songjun.wu@microchip.com, pavel@ucw.cz,
        shuah@kernel.org, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, robert.jarzmik@free.fr,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        geert@linux-m68k.org, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, tiffany.lin@mediatek.com,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        jean-christophe.trotin@st.com, sakari.ailus@linux.intel.com,
        fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170313105842.GG21222@n2100.armlinux.org.uk>
References: <20170311101408.272a9187@vento.lan>
 <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
 <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
 <20170311184551.GD21222@n2100.armlinux.org.uk>
 <1f1b350a-5523-34bc-07b7-f3cd2d1fd4c1@gmail.com>
 <20170311185959.GF21222@n2100.armlinux.org.uk>
 <4917d7fb-2f48-17cd-aa2f-d54b0f19ed6e@gmail.com>
 <20170312073745.GI21222@n2100.armlinux.org.uk>
 <fba73c10-4b95-f0d2-e681-0b14ef1fbc1c@gmail.com>
 <734a1731-3fb6-b8cd-6806-5405bd21bf83@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <734a1731-3fb6-b8cd-6806-5405bd21bf83@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 13, 2017 at 11:44:50AM +0100, Hans Verkuil wrote:
> On 03/12/2017 06:56 PM, Steve Longerbeam wrote:
> > In summary, I do like the media framework, it's a good abstraction of
> > hardware pipelines. It does require a lot of system level knowledge to
> > configure, but as I said that is a matter of good documentation.
> 
> And the reason we went into this direction is that the end-users that use
> these SoCs with complex pipelines actually *need* this functionality. Which
> is also part of the reason why work on improved userspace support gets
> little attention: they don't need to have a plugin that allows generic V4L2
> applications to work (at least with simple scenarios).

If you stop inheriting controls from the capture sensor to the v4l2
capture device, then this breaks - generic v4l2 applications are not
going to be able to show the controls, because they're not visible at
the v4l2 capture device anymore.  They're only visible through the
subdev interfaces, which these generic applications know nothing about.

> If you want to blame anyone for this, blame Nokia who set fire to
> their linux-based phones and thus to the funding for this work.

No, I think that's completely unfair to Nokia.  If the MC approach is
the way you want to go, you should be thanking Nokia for the amount of
effort that they have put in to it, and recognising that it was rather
unfortunate that the market had changed, which meant that they weren't
able to continue.

No one has any right to require any of us to finish what we start
coding up in open source, unless there is a contractual obligation in
place.  That goes for Nokia too.

Nokia's decision had ramifications far and wide (resulting in knock on
effects in TI and further afield), so don't think for a moment I wasn't
affected by what happened in Nokia.  Even so, it was a decision for
Nokia to make, they had the right to make it, and we have no right to
attribute "blame" to Nokia for having made that decision.

To even suggest that Nokia should be blamed is absurd.

Open source gives rights to everyone.  It gives rights to contribute
and use, but it also gives rights to walk away without notice (remember
the "as is" and "no warranty" clauses?)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
