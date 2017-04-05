Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40800
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755216AbdDEQRi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 12:17:38 -0400
Date: Wed, 5 Apr 2017 13:17:25 -0300
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
Message-ID: <20170405131725.22c13a1d@vento.lan>
In-Reply-To: <CAGoCfizXdDV_Eo1NSOAb+-wrC7F47iFQKyP8-wiJMpb-nsYArA@mail.gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 5 Apr 2017 11:39:06 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > Currently, the driver doesn't support (2), because, at the time
> > I wrote the driver, I didn't find a way to read the interrupts generated
> > by tvp5150 at em28xx[1], due to the lack of em28xx documentation,
> > but adding support for it shoudn't be hard. I may eventually do it
> > when I have some time to play with my ISEE hardware.  
> 
> For what it's worth, I doubt most of the em28xx designs have the
> tvp5150 interrupt request line connected in any way.

True. But, on embedded hardware, such line may be connected into the
SoC. Actually, from the IGEPv3 expansion diagram:

	https://www.isee.biz/support/downloads/item/igepv2-expansion-rc-schematics

The INT line is connected to CAM_IRQ. That's connected to GPIO_154 pin
at OMAP3.

So, on a first glance, it seems possible to use it, instead of polling.

> You would likely
> have to poll the FIFO status register via I2C,

Yes, I considered this option when I wrote the driver. It could work, 
although it would likely have some performance drawback, as the driver
would need to poll it at least 60 times per second.

> or use the feature to
> embed the sliced data into as VANC data in the 656 output (as
> described in sec 3.9 of the tvp5150am1 spec).

True, but the bridge driver would need to handle such data. 

I remember I looked on this when I wrote the driver, but I was
unable to find a way for em28xx to parse (or forward) such
data packets.

Thanks,
Mauro
