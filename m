Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43547 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751202AbdBWJNK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 04:13:10 -0500
Message-ID: <1487841019.2916.7.camel@pengutronix.de>
Subject: Re: [PATCH v4 33/36] media: imx: redo pixel format enumeration and
 negotiation
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
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
Date: Thu, 23 Feb 2017 10:10:19 +0100
In-Reply-To: <9a4a4da7-418e-860e-05ec-da44b3c945cc@gmail.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
         <1487211578-11360-34-git-send-email-steve_longerbeam@mentor.com>
         <1487244744.2377.38.camel@pengutronix.de>
         <9a4a4da7-418e-860e-05ec-da44b3c945cc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Wed, 2017-02-22 at 15:52 -0800, Steve Longerbeam wrote:
> Hi Philipp,
> 
> 
> On 02/16/2017 03:32 AM, Philipp Zabel wrote:
> > On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
> >> The previous API and negotiation of mbus codes and pixel formats
> >> was broken, and has been completely redone.
> >>
> >> The negotiation of media bus codes should be as follows:
> >>
> >> CSI:
> >>
> >> sink pad     direct src pad      IDMAC src pad
> >> --------     ----------------    -------------
> >> RGB (any)        IPU RGB           RGB (any)
> >> YUV (any)        IPU YUV           YUV (any)
> >> Bayer              N/A             must be same bayer code as sink
> >
> > The IDMAC src pad should also use the internal 32-bit RGB / YUV format,
> > except if bayer/raw mode is selected, in which case the attached capture
> > video device should only allow a single mode corresponding to the output
> > pad media bus format.
> 
> The IDMAC source pad is going to memory, so it has left the IPU.
> Are you sure it should be an internal IPU format? I realize it
> is linked to a capture device node, and the IPU format could then
> be translated to a v4l2 fourcc by the capture device, but IMHO this
> pad is external to the IPU.

The CSI IDMAC source pad should describe the format at the connection
between the CSI and the IDMAC, just as the icprpvf and icprpenc source
pads.
The format outside of the IPU is the memory format written by the IDMAC,
but that is a memory pixel format and not a media bus format at all.

That would also make it more straightforward to enumerate the memory
pixel formats in the capture device: If the source pad media bus format
is 32-bit YUV, enumerate all YUV formats, if it is 32-bit RGB or RGB565,
enumerate all rgb formats, otherwise (bayer/raw mode) only allow the
specific memory format matching the bus format.

regards
Philipp
