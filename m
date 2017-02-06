Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47223 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751307AbdBFK2g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 05:28:36 -0500
Message-ID: <1486376840.3005.28.camel@pengutronix.de>
Subject: Re: [PATCH v3 12/24] add mux and video interface bridge entity
 functions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarit.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 06 Feb 2017 11:27:20 +0100
In-Reply-To: <6948005.DnfziI9GIJ@avalon>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-13-git-send-email-steve_longerbeam@mentor.com>
         <6948005.DnfziI9GIJ@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2017-02-05 at 17:36 +0200, Laurent Pinchart wrote:
> Hi Steve,
> 
> Thank you for the patch
> 
> On Friday 06 Jan 2017 18:11:30 Steve Longerbeam wrote:
> > From: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  Documentation/media/uapi/mediactl/media-types.rst | 22 ++++++++++++++++++++
> >  include/uapi/linux/media.h                        |  6 ++++++
> >  2 files changed, 28 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/mediactl/media-types.rst
> > b/Documentation/media/uapi/mediactl/media-types.rst index 3e03dc2..023be29
> > 100644
> > --- a/Documentation/media/uapi/mediactl/media-types.rst
> > +++ b/Documentation/media/uapi/mediactl/media-types.rst
> > @@ -298,6 +298,28 @@ Types and flags used to represent the media graph
> > elements received on its sink pad and outputs the statistics data on
> >  	  its source pad.
> > 
> > +    -  ..  row 29
> > +
> > +       ..  _MEDIA-ENT-F-MUX:
> > +
> > +       -  ``MEDIA_ENT_F_MUX``
> > +
> > +       - Video multiplexer. An entity capable of multiplexing must have at
> > +         least two sink pads and one source pad, and must pass the video
> > +         frame(s) received from the active sink pad to the source pad.
> > Video
> > +         frame(s) from the inactive sink pads are discarded.
> 
> Apart from the comment made by Hans regarding the macro name, this looks good 
> to me.
> 
> > +    -  ..  row 30
> > +
> > +       ..  _MEDIA-ENT-F-VID-IF-BRIDGE:
> > +
> > +       -  ``MEDIA_ENT_F_VID_IF_BRIDGE``
> > +
> > +       - Video interface bridge. A video interface bridge entity must have
> > at
> > +         least one sink pad and one source pad. It receives video frame(s)
> > on
> > +         its sink pad in one bus format (HDMI, eDP, MIPI CSI-2, ...) and
> > +         converts them and outputs them on its source pad in another bus
> > format
> > +         (eDP, MIPI CSI-2, parallel, ...).
> 
> 
> The first sentence mentions *at least* one sink pad and one source pad, and 
> the second one refers to "its sink pad" and "its source pad". This is a bit 
> confusing. An easy option would be to require a single sink and a single 
> source pad, but that would exclude bridges that combine a multiplexer.

Would it be enough to just switch to plural?

"It receives video frame(s) on its sink pads in one bus format and
converts them and outputs them on its source pads in another bus
format"?

I fear if this is made too specific to single-input single-output
devices, a whole lot of multi-input devices will have to be split up
unnecessarily. Although in cases of freely configurable multiplexers, it
might also make sense to describe them as multiple entities. Especially
if they can run in parallel with different configurations.

> I also wonder whether "bridge" is the appropriate word here. Transceiver might 
> be a better choice, to insist on the fact that one of the two pads corresponds 
> to a physical interface that has special electrical properties (such as HDMI, 
> eDP, or CSI-2 that all require PHYs).

What media entity function would you suggest to use for the IPU CSI,
which basically is
 - a video interface bridge, because it converts media bus formats from
   an external (up to) 20-bit parallel bus to an internal 128-bit bus,
   with the option to either expand/compand/pack >8-bit per component
   pixel formats (so parts of a write pixel formatter)
 - also a video scaler, because it can crop and reduce width and/or
   height to 1/2 the original size

I wouldn't call it a transceiver, as it is completely contained inside
the SoC.

regards
Philipp

