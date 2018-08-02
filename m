Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:39251 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbeHBKor (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 06:44:47 -0400
Received: by mail-wm0-f41.google.com with SMTP id q8-v6so1584766wmq.4
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 01:54:35 -0700 (PDT)
Subject: Re: [RFC 0/4] media: meson: add video decoder driver
To: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-media@vger.kernel.org
Cc: linux-amlogic@lists.infradead.org
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <7502893f-da68-8712-a616-b4eb5b4d67a8@baylibre.com>
Date: Thu, 2 Aug 2018 10:54:33 +0200
MIME-Version: 1.0
In-Reply-To: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2018 21:33, Maxime Jourdan wrote:
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

This seems to be internal resets

> 	- writel_relaxed(0x3ff, core->dos_base + DOS_GCLK_EN0);

This seems to be internal gates

If it's in the VDEC/DO registers space, you can keep this internaly, no need to use
the clk or reset framework.

Neil

> 
> and a few other instances where that happens.
> 
> Is it okay to not create specific controllers for those ? The main issue is
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
