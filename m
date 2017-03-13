Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53510 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752928AbdCMU52 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 16:57:28 -0400
Date: Mon, 13 Mar 2017 22:56:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
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
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
Message-ID: <20170313205646.GC10701@valkosipuli.retiisi.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
 <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
 <20170221001332.GS21222@n2100.armlinux.org.uk>
 <25596b21-70de-5e46-f149-f9ce3a86ecb7@gmail.com>
 <1487667023.2331.8.camel@pengutronix.de>
 <20170313131647.GB10701@valkosipuli.retiisi.org.uk>
 <20170313132701.GJ21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313132701.GJ21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Mon, Mar 13, 2017 at 01:27:02PM +0000, Russell King - ARM Linux wrote:
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

The user is responsible for configuring the pipeline. It is thus not
unreasonable to as the user to configure the frame rate as well if there are
device in the pipeline that can affect the frame rate. The way I proposed to
implement it is compliant with the existing API and entirely deterministic,
contrary to what you're saying.

It's not the job of the CSI sub-device to figure it out.

S_PARM and G_PARM function as interface on the V4L2 API to access the frame
rate on plain V4L2 devices. The i.MX6 IPU is not a plain V4L2 device.
Essentially the V4L2 device node you have there is an interface to a rather
plain DMA engine, no more.

There have been plans to add device profiles to the documentation but that
work has not yet been done.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
