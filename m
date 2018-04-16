Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39573 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752921AbeDPJaW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 05:30:22 -0400
Message-ID: <1523871020.5918.4.camel@pengutronix.de>
Subject: Re: imx-media: MT9P031 Capture issues on IMX6
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Mon, 16 Apr 2018 11:30:20 +0200
In-Reply-To: <CAPQseg29hJ+vdWxU3RkXtaeJki9209OjqvGOQQ-U45Z_vvjnnw@mail.gmail.com>
References: <CAPQseg2t1-LgmeuQBW2YXSwN26WKcJWakN2KCLfCjKZ_wJeWGw@mail.gmail.com>
         <1523629085.3396.10.camel@pengutronix.de>
         <CAPQseg29hJ+vdWxU3RkXtaeJki9209OjqvGOQQ-U45Z_vvjnnw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-04-16 at 09:54 +0200, Ibtsam Ul-Haq wrote:
[...]
> This indeed looks the case. But then, is 'GR16' the FourCC for 'SGRBG16'?

Yes, see Documentation/media/uapi/v4l/pixfmt-srggb16.rst:
https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-srggb16.html

> To be honest, I had not seen GR16 as FourCC before.
> And the Gstreamer debug logs (I used GST_DEBUG=5) also say that they
> do not know this FourCC:
> v4l2 gstv4l2object.c:1541:gst_v4l2_object_v4l2fourcc_to_bare_struct: [00m
> Unsupported fourcc 0x36315247 GR16

The GStreamer V4L2 elements currently only support 8-bit per component
Bayer formats.

> Is there a way we can get by this?

There's two ways to handle this correctly, IMHO. One would be adding
SGRBG8_1X8 support to the mt9p031 driver. This is the correct way if the
device tree is configured for 8-bit parallel and there are only 8 data
lines connected between camera and SoC. As a quick hack, I think you
could just:

  sed "s/MEDIA_BUS_FMT_SGRBG12_1X12/MEDIA_BUS_FMT_SGRBG8_1X8/" -i drivers/media/i2c/mt9p031.c

The other would be to connect all 12 data lines, configure the device
tree with 12 bit data width, and extend the imx-media CSI subdevice
driver to allow setting SGRBG12_1X12 on the sink pad and SGRBG8_1X8 on
the source pad at the same time (and then just internally configuring
the hardware to 8-bit, ignoring the 4 LSB). That would be a bit more
involved.

Another possiblity would be to replace v4l2_subdev_link_validate() in
drivers/media/v4l2-core/v4l2-subdev.c with a variant that allows
source_fmt->format.code != sink_fmt->format.code in case the source
format can be turned into the sink format by just dropping LSB for one
of the links.

regards
Philipp
