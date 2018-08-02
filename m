Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f50.google.com ([209.85.221.50]:45826 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbeHBLFO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 07:05:14 -0400
Received: by mail-wr1-f50.google.com with SMTP id f12-v6so1325623wrv.12
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 02:14:57 -0700 (PDT)
Message-ID: <80eb63eee4ad1927a617ce526e7aba2342ac66f8.camel@baylibre.com>
Subject: Re: [RFC 0/4] media: meson: add video decoder driver
From: Jerome Brunet <jbrunet@baylibre.com>
To: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-media@vger.kernel.org
Cc: linux-amlogic@lists.infradead.org
Date: Thu, 02 Aug 2018 11:14:55 +0200
In-Reply-To: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-08-01 at 21:33 +0200, Maxime Jourdan wrote:
> This is a Request for Comments for the amlogic (meson) video decoder driver.
> It is written around the V4L2 M2M framework without using the Request
> API as there are a hardware bitstream parser and firmwares.
> 
> It features decoding for:
> - MPEG 1/2/4, H.263, H.264, MJPEG, HEVC 8-bit (partial)
> 
> Even though they are supported in hardware, it doesn't leverage support for:
> - HEVC 10-bit, VP9, VC1 (all those are in TODOs)
> 
> The output is multiplanar NV12 (V4L2_PIX_FMT_NV12M).
> Supported SoCs are: GXBB (S905), GXL (S905X/W/D), GXM (S912)
> It was tested primarily with FFmpeg, GStreamer and kodi.
> 
> The file hierarchy can be boiled down to:
> 
> 			| codec_h264.c
> 			| codec_mjpeg.c
> 			| codec_mpeg4.c
>           | vdec_1.c -->| codec_mpeg12.c
> vdec.c -->| vdec_hevc.c -->| codec_hevc.c
> 	  | esparser.c
> 
> The V4L2 code is handled mostly in vdec.c.
> Each VDEC and CODEC unit is accessed via ops structs to facilitate the code.
> 
> The arrangement between vdecs and codecs can be seen in vdec_platform.c
> This file also declares things like pixfmts, min/max buffers and firmware paths
> for each SoC.
> 
> Specific questions about the code:
> 
> - While I do use the platform's general clks and resets tied to the vdec in
> a nice way (dts + clock/reset controller with clk/reset frameworks),
> there are some subclocks and resets that I use in the driver by writing
> directly to registers. e.g:
> 
> 	- writel_relaxed((1<<7) | (1<<6), core->dos_base + DOS_SW_RESET0);
> 	- writel_relaxed(0x3ff, core->dos_base + DOS_GCLK_EN0);

Answering for the clocks here:
- There is no obligation to use the clock framework to model your clocks. It is
just very convenient when we need to handle clk parenting (rate, enable) because
you don't need to worry about setting the whole tree (It is not the only reason
to use CCF of course) ... but this is assuming you have been able to model this
tree in CCF.

If you know nothing about the clock and you just know that you need to flip this
bit to 'make it work' then don't bother with CCF for now.

> 
> and a few other instances where that happens.
> 
> Is it okay to not create specific controllers for those ?

It depends what you mean by controller:

- Any device may add a clk to CCF (call clk(_hw)_register()). the clk pointer
will just be available to the related driver. As described above, this might be
useful to propagate your changes to the rest of the tree.

- A device may also be a provider. After registering, it may call
of_clk_add_hw_provider() (or any similar function). Other devices will then be
able to request the clocks this device has registered. This is useful when the
clock is in region by one device and used by another device.


> The main issue is
> the lack of documentation so I don't know which resets/clocks are impacted by
> those writes.
> The only thing I'm certain of is that they only apply to the vdec/esparser.
> 
> - I tend to call vdec_* functions from the codec handlers.
> 
> For instance, codec_h264 will call vdec_dst_buf_done_idx to DONE
> a capture buffer. vdec_dst_buf_done_idx is as such a public symbol.
> 
> Should I use an ops struct for those instead, so that the codec handlers
> don't depend directly on the vdec general code ?
> 
> - Naming: my public symbols either start with vdec_* or esparser_*
> 
> Should I change that to something meson/amlogic specific ?

That what we tend to do yes.

If the symbol is not static, you should probably have a prefix like 'meson_gx_'
... maybe 'meson_gx_vdec'. Another (amlogic) platform may come along someday,
with another 'type' of vdec.

If the symbol is static, then maybe vdec_ is enough.

> 
> - I have a _lot_ of writel_relaxed calls.
> 
> Can I leave them be or is there a nicer way to do it ?
> 
> - Since the decoder is single instance, I only allow one _open at a time.
> 
> However the v4l2 compliance suite complains about this.
> How should I safely make it single instance ? Not allowing multiple start_streaming ?
> 
> - I am getting these 2 fails, but unsure what they are about:
> 
> Buffer ioctls:
> 	fail: ../../../v4l-utils-1.12.3/utils/v4l2-compliance/v4l2-test-buffers.cpp(428): node->node2 == NULL
> 	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
> 	fail: ../../../v4l-utils-1.12.3/utils/v4l2-compliance/v4l2-test-buffers.cpp(571): q.has_expbuf(node)
> 	test VIDIOC_EXPBUF: FAIL
> 
> 
> 
> And of course, I will gladly accept any kind of other feedback you would have.
> 
> Thanks!
> 
> 
> Maxime Jourdan (4):
>   media: meson: add v4l2 m2m video decoder driver
>   ARM64: dts: meson-gx: add vdec entry
>   ARM64: dts: meson: add vdec entries
>   dt-bindings: media: add Amlogic Meson Video Decoder Bindings
> 
>  .../bindings/media/amlogic,meson-vdec.txt     |   60 +
>  arch/arm64/boot/dts/amlogic/meson-gx.dtsi     |   14 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |    8 +
>  arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |    8 +
>  arch/arm64/boot/dts/amlogic/meson-gxm.dtsi    |    4 +
>  drivers/media/platform/Kconfig                |   10 +
>  drivers/media/platform/meson/Makefile         |    1 +
>  drivers/media/platform/meson/vdec/Makefile    |    7 +
>  drivers/media/platform/meson/vdec/canvas.c    |   69 +
>  drivers/media/platform/meson/vdec/canvas.h    |   42 +
>  .../media/platform/meson/vdec/codec_h264.c    |  376 +++++
>  .../media/platform/meson/vdec/codec_h264.h    |   13 +
>  .../media/platform/meson/vdec/codec_helpers.c |   45 +
>  .../media/platform/meson/vdec/codec_helpers.h |    8 +
>  .../media/platform/meson/vdec/codec_hevc.c    | 1383 +++++++++++++++++
>  .../media/platform/meson/vdec/codec_hevc.h    |   13 +
>  .../media/platform/meson/vdec/codec_mjpeg.c   |  203 +++
>  .../media/platform/meson/vdec/codec_mjpeg.h   |   13 +
>  .../media/platform/meson/vdec/codec_mpeg12.c  |  183 +++
>  .../media/platform/meson/vdec/codec_mpeg12.h  |   13 +
>  .../media/platform/meson/vdec/codec_mpeg4.c   |  213 +++
>  .../media/platform/meson/vdec/codec_mpeg4.h   |   13 +
>  drivers/media/platform/meson/vdec/esparser.c  |  320 ++++
>  drivers/media/platform/meson/vdec/esparser.h  |   16 +
>  drivers/media/platform/meson/vdec/hevc_regs.h |  742 +++++++++
>  drivers/media/platform/meson/vdec/vdec.c      | 1009 ++++++++++++
>  drivers/media/platform/meson/vdec/vdec.h      |  152 ++
>  drivers/media/platform/meson/vdec/vdec_1.c    |  266 ++++
>  drivers/media/platform/meson/vdec/vdec_1.h    |   13 +
>  drivers/media/platform/meson/vdec/vdec_hevc.c |  188 +++
>  drivers/media/platform/meson/vdec/vdec_hevc.h |   22 +
>  .../media/platform/meson/vdec/vdec_platform.c |  273 ++++
>  .../media/platform/meson/vdec/vdec_platform.h |   29 +
>  33 files changed, 5729 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/amlogic,meson-vdec.txt
>  create mode 100644 drivers/media/platform/meson/vdec/Makefile
>  create mode 100644 drivers/media/platform/meson/vdec/canvas.c
>  create mode 100644 drivers/media/platform/meson/vdec/canvas.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_h264.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_h264.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_helpers.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_helpers.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_hevc.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_hevc.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mjpeg.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mjpeg.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg4.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg4.h
>  create mode 100644 drivers/media/platform/meson/vdec/esparser.c
>  create mode 100644 drivers/media/platform/meson/vdec/esparser.h
>  create mode 100644 drivers/media/platform/meson/vdec/hevc_regs.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_hevc.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_hevc.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.h
> 
