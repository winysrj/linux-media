Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44491 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753381AbdCTNVo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 09:21:44 -0400
Message-ID: <1490016016.2917.68.camel@pengutronix.de>
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
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
        devel@driverdev.osuosl.org
Date: Mon, 20 Mar 2017 14:20:16 +0100
In-Reply-To: <20170319121402.GS21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
         <20170318192258.GL21222@n2100.armlinux.org.uk>
         <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
         <20170319121402.GS21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2017-03-19 at 12:14 +0000, Russell King - ARM Linux wrote:
> On Sat, Mar 18, 2017 at 12:58:27PM -0700, Steve Longerbeam wrote:
> > On 03/18/2017 12:22 PM, Russell King - ARM Linux wrote:
> > >0:00:01.955927879 20954  0x15ffe90 INFO                    v4l2 gstv4l2object.c:3811:gst_v4l2_object_get_caps:<v4l2src0> probed caps: video/x-bayer, format=(string)rggb, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)I420, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)YV12, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)BGR, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)RGB, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1
> > >
> > >    despite the media pipeline actually being configured for 60fps.
> > >
> > >    Forcing it by adjusting the pipeline only results in gstreamer
> > >    failing, because it believes that v4l2 is unable to operate at
> > >    60fps.
> > >
> > >    Also note the complaints from v4l2src about the non-compliance...
> > 
> > Thanks, I've fixed most of v4l2-compliance issues, but this is not
> > done yet. Is that something you can help with?
> 
> I've looked at this, and IMHO it's yet another media control API mess.
> 
> - media-ctl itself allows setting the format on subdev pads via
>   struct v4l2_subdev_format.
> 
> - struct v4l2_subdev_format contains a struct v4l2_mbus_framefmt.
> 
> - struct v4l2_mbus_framefmt contains:
>   * @width:      frame width
>   * @height:     frame height
>   * @code:       data format code (from enum v4l2_mbus_pixelcode)
>   * @field:      used interlacing type (from enum v4l2_field)
>   * @colorspace: colorspace of the data (from enum v4l2_colorspace)
>   * @ycbcr_enc:  YCbCr encoding of the data (from enum v4l2_ycbcr_encoding)
>   * @quantization: quantization of the data (from enum v4l2_quantization)
>   * @xfer_func:  transfer function of the data (from enum v4l2_xfer_func)
> 
> - media-ctl sets width, height, code and field, but nothing else.
> 
> We're already agreed that the fields that media-ctl are part of the
> format negotiation between the ultimate source, flowing down to the
> capture device.  However, there's no support in media-ctl to deal
> with these other fields - so media-ctl in itself is only half-
> implemented.

To set and read colorimetry information:
https://patchwork.linuxtv.org/patch/39350/

regards
Philipp
