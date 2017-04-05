Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41107
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755252AbdDERRX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 13:17:23 -0400
Date: Wed, 5 Apr 2017 14:16:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, Hans Verkuil <hverkuil@xs4all.nl>,
        nick@shmanahar.org, markus.heiser@darmarit.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        shuah@kernel.org,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, devicetree@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [RFC] [media] imx: assume MEDIA_ENT_F_ATV_DECODER entities
 output video on pad 1
Message-ID: <20170405141655.46a46b72@vento.lan>
In-Reply-To: <CAGoCfiyfXc2bcTR72XwL3Vv8ny-dQUjEUk2OUuy_s4nedNJqxA@mail.gmail.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
        <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
        <1490894749.2404.33.camel@pengutronix.de>
        <20170404231053.GE7909@n2100.armlinux.org.uk>
        <19f0ce92-cad6-8950-8018-e3224e2bf266@gmail.com>
        <7235285c-f39a-64bc-195a-11cfde9e67c5@gmail.com>
        <20170405082134.GF7909@n2100.armlinux.org.uk>
        <1491384859.2381.51.camel@pengutronix.de>
        <20170405115336.7135e542@vento.lan>
        <CAGoCfizXdDV_Eo1NSOAb+-wrC7F47iFQKyP8-wiJMpb-nsYArA@mail.gmail.com>
        <20170405131725.22c13a1d@vento.lan>
        <CAGoCfiyfXc2bcTR72XwL3Vv8ny-dQUjEUk2OUuy_s4nedNJqxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 5 Apr 2017 13:02:52 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > I remember I looked on this when I wrote the driver, but I was
> > unable to find a way for em28xx to parse (or forward) such
> > data packets.  
> 
> I'm pretty sure it's possible, but I haven't looked at the datasheets
> in a number of years and don't recall the details.
> 
> Hardware VBI splicing is supported by a number of decoders but it's
> rarely used on commodity PCs (the Conexant and NXP decoders support it
> as well).  That said, I won't argue there might be some value on
> really low end platforms.  All I would ask is that if you do introduce
> any such functionality into the tvp5150 driver for some embedded
> application that you please not break support for devices such as the
> em28xx.

Yeah, sure. If I write such patchset[1], it will be optional, and
will depend on a DT variable (or platform_data) setup that would
tell what GPIO pin should be used for interrupt.

Not providing it should either disable such feature or enable it
via polling.

[1] Please notice that I don't have any demand of doing it. Yet,
I may do it for fun on my spare time:-)

I added in the past an initial support for sliced VBI API on em28xx, 
with got reverted on changeset 1d179eeedc8cb48712bc236ec82ec6c63af42008, 
mainly due to the lack of such feature on tvp5150. So, such code was never
tested (and likely need fixes/updates), but if I end by adding sliced VBI
support on tvp5150 and on OMAP3, I may add support for it on em28xx too,
using I2C poll. On such case, I'll likely add a modprobe parameter to
enable such feature.

Thanks,
Mauro
