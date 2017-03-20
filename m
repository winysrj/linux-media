Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33090 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754768AbdCTMcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 08:32:36 -0400
Date: Mon, 20 Mar 2017 12:08:55 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
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
Subject: Re: [PATCH v5 38/39] media: imx: csi: fix crop rectangle reset in
 sink set_fmt
Message-ID: <20170320120855.GH21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-39-git-send-email-steve_longerbeam@mentor.com>
 <20170319152233.GW21222@n2100.armlinux.org.uk>
 <327d67d9-68c1-7f74-0c0f-f6aee1c4b546@gmail.com>
 <1490010926.2917.59.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490010926.2917.59.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 12:55:26PM +0100, Philipp Zabel wrote:
> The above paragraph suggests we skip any rectangles that are not
> supported. In our case that would be 3. and 4., since the CSI can't
> compose into a larger frame. I hadn't realised that the crop selection
> currently happens on the source pad.

I'd recommend viewing the documentation in its post-processed version,
because then you get the examples as pictures, and they say that a
picture is worth 1000 words.  See

  https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/dev-subdev.html

There is almost an exact example of what we're trying to do - it's
figure 4.6.  Here, we have a sink pad with a cropping rectangle on
the input, which is then scaled to a composition rectangle (there's
no bounds rectangle, and it's specified that in such a case the
top,left of the composition rectangle will always be 0,0 - see quote
below).

Where it differs is that the example also supports source cropping
for two source pads.  We don't support that.

The same document says:

  Scaling support is optional. When supported by a subdev, the crop
  rectangle on the subdev's sink pad is scaled to the size configured
  using the
  :ref:`VIDIOC_SUBDEV_S_SELECTION <VIDIOC_SUBDEV_G_SELECTION>` IOCTL
  using ``V4L2_SEL_TGT_COMPOSE`` selection target on the same pad. If the
  subdev supports scaling but not composing, the top and left values are
  not used and must always be set to zero.

which in itself describes _exactly_ our hardware here as far as the
cropping and scaling the hardware supports.

> Except when composing is not supported. If the sink compose and source
> crop rectangles are not supported, the source pad format takes their
> place in determining the scaling output resolution. At least that's how
> I read the documentation.

This isn't how I read it.  Scaling is the relationship between the size
of the sink crop and sink compose rectangle.  Composition requires that
there be a composition bounds rectangle to define the composition space,
and the top,left of the composition rectangle be adjustable to place
the composition rectangle within that space.

The above quoted paragraph from the documentation backs up my view in
its final sentence - it doesn't say "if the subdev supports scaling
but not composing, there is no composition rectangle" but says that
there _is_ one but its top,left coordinates are always zero.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
