Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33337 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbcGGNbX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 09:31:23 -0400
Received: by mail-io0-f181.google.com with SMTP id t74so21999472ioi.0
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2016 06:31:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com> <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 7 Jul 2016 06:31:22 -0700
Message-ID: <CAJ+vNU3axars5pX113Zf-H1c4afTHFTpqvd-RO7zwCqANv7ddQ@mail.gmail.com>
Subject: Re: [PATCH 00/28] i.MX5/6 Video Capture, v2
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 6, 2016 at 4:06 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Philipp Zabel (2):
>   media: imx: Add video switch
>   ARM: dts: imx6qdl: Add mipi_ipu1/2 video muxes, mipi_csi, and their
>     connections
>
> Steve Longerbeam (25):
>   gpu: ipu-v3: Add Video Deinterlacer unit
>   gpu: ipu-cpmem: Add ipu_cpmem_set_uv_offset()
>   gpu: ipu-cpmem: Add ipu_cpmem_get_burstsize()
>   gpu: ipu-v3: Add ipu_get_num()
>   gpu: ipu-v3: Add IDMA channel linking support
>   gpu: ipu-v3: Add ipu_set_vdi_src_mux()
>   gpu: ipu-v3: Add VDI input IDMAC channels
>   gpu: ipu-v3: Add ipu_csi_set_src()
>   gpu: ipu-v3: Add ipu_ic_set_src()
>   gpu: ipu-v3: set correct full sensor frame for PAL/NTSC
>   gpu: ipu-v3: Fix CSI data format for 16-bit media bus formats
>   gpu: ipu-v3: Fix IRT usage
>   gpu: ipu-ic: Add complete image conversion support with tiling
>   gpu: ipu-ic: allow multiple handles to ic
>   gpu: ipu-v3: rename CSI client device
>   gpio: pca953x: Add optional reset gpio control
>   clocksource/drivers/imx: add input capture support
>   media: Add i.MX5/6 camera interface driver
>   media: imx: Add MIPI CSI-2 Receiver driver
>   media: imx: Add support for MIPI CSI-2 OV5640
>   media: imx: Add support for Parallel OV5642
>   media: Add i.MX5/6 mem2mem driver
>   ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver node
>   ARM: dts: imx6qdl: add mem2mem devices
>   ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers
>
> Suresh Dhandapani (1):
>   gpu: ipu-v3: Fix CSI0 blur in NTSC format
>
>  Documentation/devicetree/bindings/media/imx.txt    |  449 ++
>  Documentation/video4linux/imx_camera.txt           |  243 ++
>  arch/arm/boot/dts/imx6dl.dtsi                      |  183 +
>  arch/arm/boot/dts/imx6q.dtsi                       |  127 +
>  arch/arm/boot/dts/imx6qdl.dtsi                     |   19 +
>  arch/arm/configs/imx_v6_v7_defconfig               |    2 +
>  drivers/clocksource/timer-imx-gpt.c                |  463 ++-
>  drivers/gpio/gpio-pca953x.c                        |   18 +
>  drivers/gpu/ipu-v3/Makefile                        |    2 +-
>  drivers/gpu/ipu-v3/ipu-common.c                    |  155 +-
>  drivers/gpu/ipu-v3/ipu-cpmem.c                     |   13 +
>  drivers/gpu/ipu-v3/ipu-csi.c                       |   36 +-
>  drivers/gpu/ipu-v3/ipu-ic.c                        | 1769 +++++++-
>  drivers/gpu/ipu-v3/ipu-prv.h                       |    7 +
>  drivers/gpu/ipu-v3/ipu-vdi.c                       |  266 ++
>  drivers/staging/media/Kconfig                      |    2 +
>  drivers/staging/media/Makefile                     |    1 +
>  drivers/staging/media/imx/Kconfig                  |   35 +
>  drivers/staging/media/imx/Makefile                 |    2 +
>  drivers/staging/media/imx/capture/Kconfig          |   35 +
>  drivers/staging/media/imx/capture/Makefile         |    9 +
>  drivers/staging/media/imx/capture/imx-camif.c      | 2326 +++++++++++
>  drivers/staging/media/imx/capture/imx-camif.h      |  270 ++
>  drivers/staging/media/imx/capture/imx-csi.c        |  195 +
>  drivers/staging/media/imx/capture/imx-ic-prpenc.c  |  661 +++
>  drivers/staging/media/imx/capture/imx-of.c         |  354 ++
>  drivers/staging/media/imx/capture/imx-of.h         |   18 +
>  drivers/staging/media/imx/capture/imx-smfc.c       |  506 +++
>  drivers/staging/media/imx/capture/imx-vdic.c       |  995 +++++
>  .../staging/media/imx/capture/imx-video-switch.c   |  347 ++
>  drivers/staging/media/imx/capture/mipi-csi2.c      |  373 ++
>  drivers/staging/media/imx/capture/ov5640-mipi.c    | 2303 +++++++++++
>  drivers/staging/media/imx/capture/ov5642.c         | 4309 ++++++++++++++++++++
>  drivers/staging/media/imx/m2m/Makefile             |    1 +
>  drivers/staging/media/imx/m2m/imx-m2m.c            | 1049 +++++
>  include/linux/mxc_icap.h                           |   20 +
>  include/media/imx.h                                |   15 +
>  include/uapi/Kbuild                                |    1 +
>  include/uapi/linux/v4l2-controls.h                 |    4 +
>  include/uapi/media/Kbuild                          |    2 +
>  include/uapi/media/imx.h                           |   22 +
>  include/video/imx-ipu-v3.h                         |   96 +-
>  42 files changed, 17596 insertions(+), 107 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/imx.txt
>  create mode 100644 Documentation/video4linux/imx_camera.txt
>  create mode 100644 drivers/gpu/ipu-v3/ipu-vdi.c
>  create mode 100644 drivers/staging/media/imx/Kconfig
>  create mode 100644 drivers/staging/media/imx/Makefile
>  create mode 100644 drivers/staging/media/imx/capture/Kconfig
>  create mode 100644 drivers/staging/media/imx/capture/Makefile
>  create mode 100644 drivers/staging/media/imx/capture/imx-camif.c
>  create mode 100644 drivers/staging/media/imx/capture/imx-camif.h
>  create mode 100644 drivers/staging/media/imx/capture/imx-csi.c
>  create mode 100644 drivers/staging/media/imx/capture/imx-ic-prpenc.c
>  create mode 100644 drivers/staging/media/imx/capture/imx-of.c
>  create mode 100644 drivers/staging/media/imx/capture/imx-of.h
>  create mode 100644 drivers/staging/media/imx/capture/imx-smfc.c
>  create mode 100644 drivers/staging/media/imx/capture/imx-vdic.c
>  create mode 100644 drivers/staging/media/imx/capture/imx-video-switch.c
>  create mode 100644 drivers/staging/media/imx/capture/mipi-csi2.c
>  create mode 100644 drivers/staging/media/imx/capture/ov5640-mipi.c
>  create mode 100644 drivers/staging/media/imx/capture/ov5642.c
>  create mode 100644 drivers/staging/media/imx/m2m/Makefile
>  create mode 100644 drivers/staging/media/imx/m2m/imx-m2m.c
>  create mode 100644 include/linux/mxc_icap.h
>  create mode 100644 include/media/imx.h
>  create mode 100644 include/uapi/media/Kbuild
>  create mode 100644 include/uapi/media/imx.h
>

Steve,

I think at this point it would be best to send 'just' your gpu: ipu*
patches above in their own series 'to' Philipp (as he's the maintainer
for the drivers/files in those dirs) with a cc to linux-media and with
an explanation in the cover-letter that explains these are primitives
necessary for capture drivers to come in a separate series. There are
15 patches there which you have posted before and they have never
really been commented on (because I think the entire series they are
always a part of is large and goes across several sub-systems). I
think if you treat those as separate patches and we focus on getting
those in, the rest will be easier as follow-on patches.

Also, if you use the format '[PATCH v2 00/28]' it tends to filter
these way better in mail-readers so that they get the proper attention
they deserve. Because there was no 'v2' in the prefix of these patches
they got all mixed up with your most recent series and are difficult
to review.

Regards,

Tim
