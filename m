Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45633 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751202AbdBAKmy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 05:42:54 -0500
Message-ID: <1485945751.3353.28.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
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
Date: Wed, 01 Feb 2017 11:42:31 +0100
In-Reply-To: <20170201101111.GL27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1485870854.2932.63.camel@pengutronix.de>
         <5586b893-bf5c-6133-0789-ccce60626b86@gmail.com>
         <1485941457.3353.13.camel@pengutronix.de>
         <20170201101111.GL27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-02-01 at 10:11 +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 01, 2017 at 10:30:57AM +0100, Philipp Zabel wrote:
> > On Tue, 2017-01-31 at 17:26 -0800, Steve Longerbeam wrote:
> > [...]
> > > right, need to fix that. Probably by poking the attached
> > > source subdev (csi or prpenc/vf) for its supported formats.
> > 
> > You are right, in bayer/raw mode only one specific format should be
> > listed, depending on the CSI output pad format.
> 
> It depends what Steve means by "source subdev".
> 
> It should be the next sub-device below the bridge - if we have this
> setup of subdev's:
> 
> ---> CSI ---> SMFC ---> IDMAC
> 
> then the format configured at the SMFC's output pad is what matters,
> not what was configured at CSI.

Right, it's just that in the latest version there is no v4l2_subdev for
fifos and idmac. There is the capture interface entity that represents
one of the IDMAC write channels, but that doesn't have a pad and format
configuration.
The SMFC entity was removed because the fifo can be considered part of
the link between CSI and IDMAC. There is no manual configuration
necessary as the SMFC itself can't do anything to the data that flows
through it. There is no reason to present it to userspace as a no-op
entity.
So in the direct CSI -> SMFC -> IDMAC case, the CSI source pad now is
the nearest neighbor pad to the IDMAC capture video device.

> It's the responsibility of SMFC and CSI to make sure that their source
> pads are configured with a compatible format for their corresponding
> source pad, and it's also the sink subdev's responsibility to check
> that the configuration across a link is valid (possibly via
> v4l2_subdev_link_validate(), or a more intensive or relaxed test if
> required.)
> 
> For example:
> 
> - when CSI's source pad is configured with a RGGB output format,
>   userspace media-ctl will also set that on SMFC's sink pad.
> - when SMFC's sink pad is configured, SMFC should configure it's
>   source pad with an identical format (RGGB).
> - when SMFC's source pad is configured, it should refuse to change
>   the format, because SMFC can't modify pixel the format - it's
>   just a buffer.
>
> When starting to stream (Documentation/media/kapi/v4l2-subdev.rst) the
> link validation function is called, and:
> 
> - the SMFC driver's link_validate function will be called to validate
>   the CSI -> SMFC link.  This allows the SMFC to be sure that there's
>   a compatible configuration - and, since the link does not allow
>   format conversion, it should verify that the format on the CSI's
>   source pad is the same as SMFC's sink pad.
> 
> Not only does this match what the hardware's doing, it also means that,
> because there's no format conversion between the CSI's hardware output
> and IDMAC, we don't need to care about trying to fetch the CSI's source
> pad configuration from the IDMAC end - we can fetch that information
> from our neighbour's SMFC's source pad _or_ our own sink pad if we have
> one.

See above. All this is correct for the remaining entities, just the CSI
source pad now takes the role of the SMFC source pad as nearest neighbor
to the IDMAC capture video device.

> To see why this is an important, consider what the effect would be if
> SMFC did have the capability to change the pixel format.  That means the
> format presented to the IDMAC block would depend on the configuration of
> SMFC, and the CSI's source pad format is no longer relevant to IDMAC.

Yes, this is exactly the case for the CSI -> IC PRP -> IC PRPVF -> IDMAC
route, as the IC can do color space conversion. Here, (only) the IC
PRPVF source pad should determine the capture video device's format, and
the negotiation between CSI->IC PRP and between IC PRP->IC PRPVF should
happen as you say.

regards
Philipp

