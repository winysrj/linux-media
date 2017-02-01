Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43838 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdBAKLx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 05:11:53 -0500
Date: Wed, 1 Feb 2017 10:11:12 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, mark.rutland@arm.com,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        nick@shmanahar.org, songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        arnd@arndb.de, mchehab@kernel.org, bparrot@ti.com,
        robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        kernel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
Message-ID: <20170201101111.GL27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1485870854.2932.63.camel@pengutronix.de>
 <5586b893-bf5c-6133-0789-ccce60626b86@gmail.com>
 <1485941457.3353.13.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485941457.3353.13.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 01, 2017 at 10:30:57AM +0100, Philipp Zabel wrote:
> On Tue, 2017-01-31 at 17:26 -0800, Steve Longerbeam wrote:
> [...]
> > right, need to fix that. Probably by poking the attached
> > source subdev (csi or prpenc/vf) for its supported formats.
> 
> You are right, in bayer/raw mode only one specific format should be
> listed, depending on the CSI output pad format.

It depends what Steve means by "source subdev".

It should be the next sub-device below the bridge - if we have this
setup of subdev's:

---> CSI ---> SMFC ---> IDMAC

then the format configured at the SMFC's output pad is what matters,
not what was configured at CSI.

It's the responsibility of SMFC and CSI to make sure that their source
pads are configured with a compatible format for their corresponding
source pad, and it's also the sink subdev's responsibility to check
that the configuration across a link is valid (possibly via
v4l2_subdev_link_validate(), or a more intensive or relaxed test if
required.)

For example:

- when CSI's source pad is configured with a RGGB output format,
  userspace media-ctl will also set that on SMFC's sink pad.
- when SMFC's sink pad is configured, SMFC should configure it's
  source pad with an identical format (RGGB).
- when SMFC's source pad is configured, it should refuse to change
  the format, because SMFC can't modify pixel the format - it's
  just a buffer.

When starting to stream (Documentation/media/kapi/v4l2-subdev.rst) the
link validation function is called, and:

- the SMFC driver's link_validate function will be called to validate
  the CSI -> SMFC link.  This allows the SMFC to be sure that there's
  a compatible configuration - and, since the link does not allow
  format conversion, it should verify that the format on the CSI's
  source pad is the same as SMFC's sink pad.

Not only does this match what the hardware's doing, it also means that,
because there's no format conversion between the CSI's hardware output
and IDMAC, we don't need to care about trying to fetch the CSI's source
pad configuration from the IDMAC end - we can fetch that information
from our neighbour's SMFC's source pad _or_ our own sink pad if we have
one.

To see why this is an important, consider what the effect would be if
SMFC did have the capability to change the pixel format.  That means the
format presented to the IDMAC block would depend on the configuration of
SMFC, and the CSI's source pad format is no longer relevant to IDMAC.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
