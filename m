Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42363 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750947AbdE2Nwr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 09:52:47 -0400
Message-ID: <1496065877.17695.82.camel@pengutronix.de>
Subject: Re: [PATCH v7 15/34] add mux and video interface bridge entity
 functions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
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
Date: Mon, 29 May 2017 15:51:17 +0200
In-Reply-To: <3d3f0c9f-7315-69f0-877e-04b33c498c46@xs4all.nl>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
         <1495672189-29164-16-git-send-email-steve_longerbeam@mentor.com>
         <3d3f0c9f-7315-69f0-877e-04b33c498c46@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-05-29 at 15:37 +0200, Hans Verkuil wrote:
> On 05/25/2017 02:29 AM, Steve Longerbeam wrote:
> > From: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > - renamed MEDIA_ENT_F_MUX to MEDIA_ENT_F_VID_MUX
> > 
> > Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> > ---
> >   Documentation/media/uapi/mediactl/media-types.rst | 22 ++++++++++++++++++++++
> >   include/uapi/linux/media.h                        |  6 ++++++
> >   2 files changed, 28 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
> > index 2a5164a..47ee003 100644
> > --- a/Documentation/media/uapi/mediactl/media-types.rst
> > +++ b/Documentation/media/uapi/mediactl/media-types.rst
> > @@ -299,6 +299,28 @@ Types and flags used to represent the media graph elements
> >   	  received on its sink pad and outputs the statistics data on
> >   	  its source pad.
> >   
> > +    -  ..  row 29
> > +
> > +       ..  _MEDIA-ENT-F-VID-MUX:
> > +
> > +       -  ``MEDIA_ENT_F_VID_MUX``
> > +
> > +       - Video multiplexer. An entity capable of multiplexing must have at
> > +         least two sink pads and one source pad, and must pass the video
> > +         frame(s) received from the active sink pad to the source pad. Video
> > +         frame(s) from the inactive sink pads are discarded.
> > +
> > +    -  ..  row 30
> > +
> > +       ..  _MEDIA-ENT-F-VID-IF-BRIDGE:
> > +
> > +       -  ``MEDIA_ENT_F_VID_IF_BRIDGE``
> > +
> > +       - Video interface bridge. A video interface bridge entity must have at
> > +         least one sink pad and one source pad. It receives video frame(s) on
> > +         its sink pad in one bus format (HDMI, eDP, MIPI CSI-2, ...) and
> > +         converts them and outputs them on its source pad in another bus format
> > +         (eDP, MIPI CSI-2, parallel, ...).
> 
> I'm unhappy with the term 'bus format'. It's too close to 'mediabus format'.
> How about calling it "bus protocol"?

How about:

   "It receives video frames on its sink pad from an input video bus
    of one type (HDMI, eDP, MIPI CSI-2, ...), and outputs them on its
    source pad to an output video bus of another type (eDP, MIPI
    CSI-2, parallel, ...)."

regards
Philipp
