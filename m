Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34401
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751929AbdCMLma (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 07:42:30 -0400
Date: Mon, 13 Mar 2017 08:42:15 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>, mark.rutland@arm.com,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        nick@shmanahar.org, songjun.wu@microchip.com, pavel@ucw.cz,
        shuah@kernel.org, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, robert.jarzmik@free.fr,
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
Message-ID: <20170313084215.7eb6a054@vento.lan>
In-Reply-To: <20170313105842.GG21222@n2100.armlinux.org.uk>
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
        <20170313105842.GG21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 13 Mar 2017 10:58:42 +0000
Russell King - ARM Linux <linux@armlinux.org.uk> escreveu:

> On Mon, Mar 13, 2017 at 11:44:50AM +0100, Hans Verkuil wrote:
> > On 03/12/2017 06:56 PM, Steve Longerbeam wrote:  
> > > In summary, I do like the media framework, it's a good abstraction of
> > > hardware pipelines. It does require a lot of system level knowledge to
> > > configure, but as I said that is a matter of good documentation.  
> > 
> > And the reason we went into this direction is that the end-users that use
> > these SoCs with complex pipelines actually *need* this functionality. Which
> > is also part of the reason why work on improved userspace support gets
> > little attention: they don't need to have a plugin that allows generic V4L2
> > applications to work (at least with simple scenarios).  
> 
> If you stop inheriting controls from the capture sensor to the v4l2
> capture device, then this breaks - generic v4l2 applications are not
> going to be able to show the controls, because they're not visible at
> the v4l2 capture device anymore.  They're only visible through the
> subdev interfaces, which these generic applications know nothing about.

True. That's why IMHO, the best is to do control inheritance when
there are use cases for generic applications and is possible for
the driver to do it (e. g. when the pipeline is not too complex
to prevent it to work).

As Hans said, for the drivers currently upstreamed at drivers/media,
there are currently very little interest on running generic apps 
there, as they're meant to be used inside embedded hardware using
specialized applications.

I don't have myself any hardware with i.MX6. Yet, I believe that
a low cost board like SolidRun Hummingboard - with comes with a 
CSI interface compatible with RPi camera modules - will likely
attract users who need to run generic applications on their
devices.

So, I believe that it makes sense for i.MX6 driver to inherit
controls from video devnode.

Thanks,
Mauro
