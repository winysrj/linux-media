Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38791 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbeDQIeu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 04:34:50 -0400
Message-ID: <1523954089.3612.1.camel@pengutronix.de>
Subject: Re: imx-media: MT9P031 Capture issues on IMX6
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Tue, 17 Apr 2018 10:34:49 +0200
In-Reply-To: <CAPQseg3qXkgU=1yvUXdh73XnGT-kcFWsBF6nDx6AMa+OV7w3nQ@mail.gmail.com>
References: <CAPQseg2t1-LgmeuQBW2YXSwN26WKcJWakN2KCLfCjKZ_wJeWGw@mail.gmail.com>
         <1523629085.3396.10.camel@pengutronix.de>
         <CAPQseg29hJ+vdWxU3RkXtaeJki9209OjqvGOQQ-U45Z_vvjnnw@mail.gmail.com>
         <1523871020.5918.4.camel@pengutronix.de>
         <CAPQseg3qXkgU=1yvUXdh73XnGT-kcFWsBF6nDx6AMa+OV7w3nQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ibtsam,

On Tue, 2018-04-17 at 09:26 +0200, Ibtsam Ul-Haq wrote:
> On Mon, Apr 16, 2018 at 11:30 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > On Mon, 2018-04-16 at 09:54 +0200, Ibtsam Ul-Haq wrote:
> > [...]
> > > This indeed looks the case. But then, is 'GR16' the FourCC for 'SGRBG16'?
> > 
> > Yes, see Documentation/media/uapi/v4l/pixfmt-srggb16.rst:
> > https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-srggb16.html
> > 
> > > To be honest, I had not seen GR16 as FourCC before.
> > > And the Gstreamer debug logs (I used GST_DEBUG=5) also say that they
> > > do not know this FourCC:
> > > v4l2 gstv4l2object.c:1541:gst_v4l2_object_v4l2fourcc_to_bare_struct: [00m
> > > Unsupported fourcc 0x36315247 GR16
> > 
> > The GStreamer V4L2 elements currently only support 8-bit per component
> > Bayer formats.
> > 
> > > Is there a way we can get by this?
> > 
> > There's two ways to handle this correctly, IMHO. One would be adding
> > SGRBG8_1X8 support to the mt9p031 driver. This is the correct way if the
> > device tree is configured for 8-bit parallel and there are only 8 data
> > lines connected between camera and SoC. As a quick hack, I think you
> > could just:
> > 
> >   sed "s/MEDIA_BUS_FMT_SGRBG12_1X12/MEDIA_BUS_FMT_SGRBG8_1X8/" -i drivers/media/i2c/mt9p031.c
> > 
> 
> 
> I tried that and it works well for my case. All pads in the pipeline
> now report their format as SGRBG8_1X8.
>
> However, now I am getting a Broken Pipe error from STREAMON when I try
> to run the pipeline:
> v4l2bufferpool gstv4l2bufferpool.c:677:gst_v4l2_buffer_pool_streamon:<v4l2src0:pool:src>
> [00m
> error with STREAMON 32 (Broken pipe)

What about format width and height, are they the same throughout the
pipeline? It didn't look that way in your last mail.

> 
> I also get a corresponding error on the dmesg:
> [ 1398.723524] ipu1_csi0: pipeline start failed with -32

That is the same issue. I assume link validation fails with -EPIPE
because frame dimensions differ between some connected source and sink
pad. If you have dynamic debug enabled, you can verify this by enabling
the relevant debug printks in drivers/media:

  echo "func __media_pipeline_start +p" > /sys/kernel/debug/dynamic_debug/control

This will show exactly which link causes the failure:

  imx-media capture-subsystem: link validation failed for 'ipu1_csi0_mux':2 -> 'ipu1_csi0':0, error -32
  ipu1_csi0: pipeline start failed with -32

Here width and height were different between connected source and sink
pad:

  media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
		[fmt:UYVY8_1X16/640x480 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]

  media-ctl --get-v4l2 "'ipu1_csi0':0"
		[fmt:UYVY8_1X16/1920x1080@1/60 field:none colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range
		 crop.bounds:(0,0)/1920x1080
		 crop:(0,0)/1920x1080
		 compose.bounds:(0,0)/1920x1080
		 compose:(0,0)/1920x1080]

If you look at v4l2_subdev_link_validate_default in 
drivers/media/v4l2-core/v4l2-subdev.c, you can see that besides the
format code, it also checks width, height, and field setting.

regards
Philipp
