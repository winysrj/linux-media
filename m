Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33281 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755710AbdDERC4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 13:02:56 -0400
Received: by mail-qt0-f173.google.com with SMTP id i34so16091700qtc.0
        for <linux-media@vger.kernel.org>; Wed, 05 Apr 2017 10:02:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170405131725.22c13a1d@vento.lan>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
 <1490894749.2404.33.camel@pengutronix.de> <20170404231053.GE7909@n2100.armlinux.org.uk>
 <19f0ce92-cad6-8950-8018-e3224e2bf266@gmail.com> <7235285c-f39a-64bc-195a-11cfde9e67c5@gmail.com>
 <20170405082134.GF7909@n2100.armlinux.org.uk> <1491384859.2381.51.camel@pengutronix.de>
 <20170405115336.7135e542@vento.lan> <CAGoCfizXdDV_Eo1NSOAb+-wrC7F47iFQKyP8-wiJMpb-nsYArA@mail.gmail.com>
 <20170405131725.22c13a1d@vento.lan>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 5 Apr 2017 13:02:52 -0400
Message-ID: <CAGoCfiyfXc2bcTR72XwL3Vv8ny-dQUjEUk2OUuy_s4nedNJqxA@mail.gmail.com>
Subject: Re: [RFC] [media] imx: assume MEDIA_ENT_F_ATV_DECODER entities output
 video on pad 1
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> For what it's worth, I doubt most of the em28xx designs have the
>> tvp5150 interrupt request line connected in any way.
>
> True. But, on embedded hardware, such line may be connected into the
> SoC. Actually, from the IGEPv3 expansion diagram:
>
>         https://www.isee.biz/support/downloads/item/igepv2-expansion-rc-schematics
>
> The INT line is connected to CAM_IRQ. That's connected to GPIO_154 pin
> at OMAP3.
>
> So, on a first glance, it seems possible to use it, instead of polling.

To be clear, I wasn't suggesting that the IRQ request line on the
tvp5150 couldn't be supported in general (for example, for those
embedded targets which have it wired up to a host processor).  I'm
just saying you shouldn't expect it to work on most (perhaps all)
em28xx designs which have the tvp5150.  In fact on some em28xx designs
the pin is used as a GPIO output tied to a mux to control input
selection.  Hence blindly enabling the interrupt request line by
default would do all sorts of bad things.

>> You would likely
>> have to poll the FIFO status register via I2C,
>
> Yes, I considered this option when I wrote the driver. It could work,
> although it would likely have some performance drawback, as the driver
> would need to poll it at least 60 times per second.
>
>> or use the feature to
>> embed the sliced data into as VANC data in the 656 output (as
>> described in sec 3.9 of the tvp5150am1 spec).
>
> True, but the bridge driver would need to handle such data.

Correct.

> I remember I looked on this when I wrote the driver, but I was
> unable to find a way for em28xx to parse (or forward) such
> data packets.

I'm pretty sure it's possible, but I haven't looked at the datasheets
in a number of years and don't recall the details.

Hardware VBI splicing is supported by a number of decoders but it's
rarely used on commodity PCs (the Conexant and NXP decoders support it
as well).  That said, I won't argue there might be some value on
really low end platforms.  All I would ask is that if you do introduce
any such functionality into the tvp5150 driver for some embedded
application that you please not break support for devices such as the
em28xx.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
