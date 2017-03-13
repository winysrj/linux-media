Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36154 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753000AbdCMVJW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 17:09:22 -0400
Date: Mon, 13 Mar 2017 21:07:51 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
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
Message-ID: <20170313210751.GN21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
 <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
 <20170221001332.GS21222@n2100.armlinux.org.uk>
 <25596b21-70de-5e46-f149-f9ce3a86ecb7@gmail.com>
 <1487667023.2331.8.camel@pengutronix.de>
 <20170313131647.GB10701@valkosipuli.retiisi.org.uk>
 <20170313132701.GJ21222@n2100.armlinux.org.uk>
 <20170313205646.GC10701@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313205646.GC10701@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 13, 2017 at 10:56:46PM +0200, Sakari Ailus wrote:
> Hi Russell,
> 
> On Mon, Mar 13, 2017 at 01:27:02PM +0000, Russell King - ARM Linux wrote:
> > On Mon, Mar 13, 2017 at 03:16:48PM +0200, Sakari Ailus wrote:
> > > The vast majority of existing drivers do not implement them nor the user
> > > space expects having to set them. Making that mandatory would break existing
> > > user space.
> > > 
> > > In addition, that does not belong to link validation either: link validation
> > > should only include static properties of the link that are required for
> > > correct hardware operation. Frame rate is not such property: hardware that
> > > supports the MC interface generally does not recognise such concept (with
> > > the exception of some sensors). Additionally, it is dynamic: the frame rate
> > > can change during streaming, making its validation at streamon time useless.
> > 
> > So how do we configure the CSI, which can do frame skipping?
> > 
> > With what you're proposing, it means it's possible to configure the
> > camera sensor source pad to do 50fps.  Configure the CSI sink pad to
> > an arbitary value, such as 30fps, and configure the CSI source pad to
> > 15fps.
> > 
> > What you actually get out of the CSI is 25fps, which bears very little
> > with the actual values used on the CSI source pad.
> > 
> > You could say "CSI should ask the camera sensor" - well, that's fine
> > if it's immediately downstream, but otherwise we'd need to go walking
> > down the graph to find something that resembles its source - there may
> > be mux and CSI2 interface subdev blocks in that path.  Or we just accept
> > that frame rates are completely arbitary and bear no useful meaning what
> > so ever.
> 
> The user is responsible for configuring the pipeline. It is thus not
> unreasonable to as the user to configure the frame rate as well if there are
> device in the pipeline that can affect the frame rate. The way I proposed to
> implement it is compliant with the existing API and entirely deterministic,
> contrary to what you're saying.

You haven't really addressed my point at all.

What you seem to be saying is that you're quite happy for the situation
(which is a total misconfiguration) to exist.  Given the vapourware of
userspace (which I don't see changing in any kind of reasonable timeline)
I think this is completely absurd.

I'll state clearly now: everything that we've discussed so far, I'm
finding very hard to take anything you've said seriously.  I think we
have very different and incompatible point of views about what is
acceptable from a user point of view, so much so that we're never going
to agree on any point.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
