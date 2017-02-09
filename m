Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:39913 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752596AbdBIJob (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Feb 2017 04:44:31 -0500
Message-ID: <1486633391.2284.9.camel@pengutronix.de>
Subject: Re: [PATCH v3 21/24] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
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
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 09 Feb 2017 10:43:11 +0100
In-Reply-To: <ca0a2eb3-21b6-d312-c8e0-61da48c4c700@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
         <1486036237.2289.37.camel@pengutronix.de>
         <ca0a2eb3-21b6-d312-c8e0-61da48c4c700@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-02-08 at 15:23 -0800, Steve Longerbeam wrote:
[...]
> >> +
> >> +static int imxcsi2_get_fmt(struct v4l2_subdev *sd,
> >> +			   struct v4l2_subdev_pad_config *cfg,
> >> +			   struct v4l2_subdev_format *sdformat)
> >> +{
> >> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
> >> +
> >> +	sdformat->format = csi2->format_mbus;
> > The output formats are different from the input formats, see the media
> > bus format discussion in the other thread. The input pad is the MIPI
> > CSI-2 bus, but the four output pads are connected to the muxes / CSIs
> > via a 16-bit parallel bus.
> >
> > So if the input format is UYVY8_1X16, for example, the output should be
> > set to UYVY8_2X8.
> 
> Since the output buses from the CSI2IPU gasket are 16-bit
> parallel buses, shouldn't an input format UYVY8_1X16 also be
> the same at the output?

I looked at the reference manual again, and I think I have read this
incorrectly, probably confused by the coloring in Figure 19-10 "YUV422-8
data reception" in the CSI2IPU chapter. It looks like indeed the 16-bit
bus carries UYVY8_1X16, whereas the internal 32-bit bus between MIPI
CSI-2 decoder and the CSI2IPU carries two samples (complete UYVY) per
pixel clock.
So UYVY is straight forward. It's the YUV420, RGB, and RAW formats that
would be interesting to describe correctly.

regards
Philipp

