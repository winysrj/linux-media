Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49495 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbeDQMd5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 08:33:57 -0400
Message-ID: <1523968435.3612.8.camel@pengutronix.de>
Subject: Re: imx-media: MT9P031 Capture issues on IMX6
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Tue, 17 Apr 2018 14:33:55 +0200
In-Reply-To: <CAPQseg1dtXk94b=emhJJHPtNvmW4mkCRLq-UkMjSzpz-45Do_g@mail.gmail.com>
References: <CAPQseg2t1-LgmeuQBW2YXSwN26WKcJWakN2KCLfCjKZ_wJeWGw@mail.gmail.com>
         <1523629085.3396.10.camel@pengutronix.de>
         <CAPQseg29hJ+vdWxU3RkXtaeJki9209OjqvGOQQ-U45Z_vvjnnw@mail.gmail.com>
         <1523871020.5918.4.camel@pengutronix.de>
         <CAPQseg3qXkgU=1yvUXdh73XnGT-kcFWsBF6nDx6AMa+OV7w3nQ@mail.gmail.com>
         <1523954089.3612.1.camel@pengutronix.de>
         <CAPQseg1dtXk94b=emhJJHPtNvmW4mkCRLq-UkMjSzpz-45Do_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-04-17 at 11:32 +0200, Ibtsam Ul-Haq wrote:
> On Tue, Apr 17, 2018 at 10:34 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Hi Ibtsam,
> > 
> > On Tue, 2018-04-17 at 09:26 +0200, Ibtsam Ul-Haq wrote:
> > > On Mon, Apr 16, 2018 at 11:30 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > > > On Mon, 2018-04-16 at 09:54 +0200, Ibtsam Ul-Haq wrote:
> > > > [...]
> > > > > This indeed looks the case. But then, is 'GR16' the FourCC for 'SGRBG16'?
> > > > 
> > > > Yes, see Documentation/media/uapi/v4l/pixfmt-srggb16.rst:
> > > > https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-srggb16.html
> > > > 
> > > > > To be honest, I had not seen GR16 as FourCC before.
> > > > > And the Gstreamer debug logs (I used GST_DEBUG=5) also say that they
> > > > > do not know this FourCC:
> > > > > v4l2 gstv4l2object.c:1541:gst_v4l2_object_v4l2fourcc_to_bare_struct: [00m
> > > > > Unsupported fourcc 0x36315247 GR16
> > > > 
> > > > The GStreamer V4L2 elements currently only support 8-bit per component
> > > > Bayer formats.
> > > > 
> > > > > Is there a way we can get by this?
> > > > 
> > > > There's two ways to handle this correctly, IMHO. One would be adding
> > > > SGRBG8_1X8 support to the mt9p031 driver. This is the correct way if the
> > > > device tree is configured for 8-bit parallel and there are only 8 data
> > > > lines connected between camera and SoC. As a quick hack, I think you
> > > > could just:
> > > > 
> > > >   sed "s/MEDIA_BUS_FMT_SGRBG12_1X12/MEDIA_BUS_FMT_SGRBG8_1X8/" -i drivers/media/i2c/mt9p031.c
> > > > 
> > > 
> > > 
> > > I tried that and it works well for my case. All pads in the pipeline
> > > now report their format as SGRBG8_1X8.
> > > 
> > > However, now I am getting a Broken Pipe error from STREAMON when I try
> > > to run the pipeline:
> > > v4l2bufferpool gstv4l2bufferpool.c:677:gst_v4l2_buffer_pool_streamon:<v4l2src0:pool:src>
> > > [00m
> > > error with STREAMON 32 (Broken pipe)
> > 
> > What about format width and height, are they the same throughout the
> > pipeline? It didn't look that way in your last mail.
> > 
> 
> Indeed they were not the same. That was probably because the default
> window width and height were 2592x1944.
> So when I tried to set resolution to 640x480, it actually became
> 648x486, and the ipu1_csi0 expanded it to 656x486.

Yes, the CSI currently aligns width to a multiple of 16 pixels to
simplify handling DMA controller alignment restrictions.
This should probably be relaxed, especially for non-planar formats.

> I have that changed now, so the pads now look to have the same width and height:
> 
> :~# media-ctl --get-v4l2 "'mt9p031 0-0048':0"
>                 [fmt:SGRBG8_1X8/640x480 field:none colorspace:srgb
>                  crop:(16,54)/2560x1920]
> 
> :~# media-ctl --get-v4l2 "'mt9p031 0-0048':0"
>                 [fmt:SGRBG8_1X8/640x480 field:none colorspace:srgb
>                  crop:(16,54)/2560x1920]
> 
> :~# media-ctl --get-v4l2 "'ipu1_csi0_mux':1"
>                 [fmt:SGRBG8_1X8/640x480 field:none colorspace:srgb]
> 
> :~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
>                 [fmt:SGRBG8_1X8/640x480 field:none colorspace:srgb]
> 
> :~# media-ctl --get-v4l2 "'ipu1_csi0':0"
>                 [fmt:SGRBG8_1X8/640x480@1/30 field:none
> colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range
>                  crop.bounds:(0,0)/640x480
>                  crop:(0,0)/640x480
>                  compose.bounds:(0,0)/640x480
>                  compose:(0,0)/640x480]
> 
> :~# media-ctl --get-v4l2 "'ipu1_csi0':2"
>                 [fmt:SGRBG8_1X8/640x480@1/30 field:none
> colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]
> 
> But now I am getting:
> gst_v4l2_buffer_pool_pthe handlingoll ():
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> poll error 1: Invalid argument (22)
> 
> This is accompanied by dmesg errors:
> [ 8056.756841] alloc_contig_range: [80400, 80496) PFNs busy

This is not a memory allocation problem. The above is a harmless info
message that points out a slight inefficiency in the CMA allocator.

> [ 8057.833501] ipu1_csi0: EOF timeout
> [ 8058.953717] ipu1_csi0: wait last EOF timeout

This is the problem. The driver believes all is configured correctly.
It starts the DMA transfer and waits for the End-Of-Frame interrupt.
The reason that doesn't happen could be the sensor failing to start
streaming, or the signal not arriving at the CSI properly. Can you
measure the pixel clock and vsync/hsync signals? Is pinctrl set up
correctly?

regards
Philipp
