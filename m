Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45477 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754928AbdCTNQY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 09:16:24 -0400
Message-ID: <1490015741.2917.66.camel@pengutronix.de>
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
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
        devel@driverdev.osuosl.org
Date: Mon, 20 Mar 2017 14:15:41 +0100
In-Reply-To: <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
         <20170318192258.GL21222@n2100.armlinux.org.uk>
         <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2017-03-18 at 12:58 -0700, Steve Longerbeam wrote:
> 
> On 03/18/2017 12:22 PM, Russell King - ARM Linux wrote:
> > Hi Steve,
> >
> > I've just been trying to get gstreamer to capture and h264 encode
> > video from my camera at various frame rates, and what I've discovered
> > does not look good.
> >
> > 1) when setting frame rates, media-ctl _always_ calls
> >     VIDIOC_SUBDEV_S_FRAME_INTERVAL with pad=0.

To allow setting pad > 0:
https://patchwork.linuxtv.org/patch/39348/

> > 2) media-ctl never retrieves the frame interval information, so there's
> >     no way to read it back with standard tools, and no indication that
> >     this is going on...
> 
> I think Philipp Zabel submitted a patch which addresses these
> in media-ctl. Check with him.

To read back and propagate the frame interval:
https://patchwork.linuxtv.org/patch/39349/
https://patchwork.linuxtv.org/patch/39351/

regards
Philipp
