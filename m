Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34157 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752170AbdCMNzm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 09:55:42 -0400
Message-ID: <1489413301.2288.53.camel@pengutronix.de>
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
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
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 13 Mar 2017 14:55:01 +0100
In-Reply-To: <20170313132701.GJ21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
         <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
         <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
         <20170221001332.GS21222@n2100.armlinux.org.uk>
         <25596b21-70de-5e46-f149-f9ce3a86ecb7@gmail.com>
         <1487667023.2331.8.camel@pengutronix.de>
         <20170313131647.GB10701@valkosipuli.retiisi.org.uk>
         <20170313132701.GJ21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-03-13 at 13:27 +0000, Russell King - ARM Linux wrote:
> On Mon, Mar 13, 2017 at 03:16:48PM +0200, Sakari Ailus wrote:
> > The vast majority of existing drivers do not implement them nor the user
> > space expects having to set them. Making that mandatory would break existing
> > user space.
> > 
> > In addition, that does not belong to link validation either: link validation
> > should only include static properties of the link that are required for
> > correct hardware operation. Frame rate is not such property: hardware that
> > supports the MC interface generally does not recognise such concept (with
> > the exception of some sensors). Additionally, it is dynamic: the frame rate
> > can change during streaming, making its validation at streamon time useless.
> 
> So how do we configure the CSI, which can do frame skipping?
> 
> With what you're proposing, it means it's possible to configure the
> camera sensor source pad to do 50fps.  Configure the CSI sink pad to
> an arbitary value, such as 30fps, and configure the CSI source pad to
> 15fps.
> 
> What you actually get out of the CSI is 25fps, which bears very little
> with the actual values used on the CSI source pad.
> 
> You could say "CSI should ask the camera sensor" - well, that's fine
> if it's immediately downstream, but otherwise we'd need to go walking
> down the graph to find something that resembles its source - there may
> be mux and CSI2 interface subdev blocks in that path.  Or we just accept
> that frame rates are completely arbitary and bear no useful meaning what
> so ever.

Which would include the frame interval returned by VIDIOC_G_PARM on the
connected video device, as that gets its information from the CSI output
pad's frame interval.

regards
Philipp
