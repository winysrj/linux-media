Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48461 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbaHEGwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 02:52:32 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so485373wes.31
        for <linux-media@vger.kernel.org>; Mon, 04 Aug 2014 23:52:31 -0700 (PDT)
Date: Tue, 5 Aug 2014 08:52:19 +0200
From: Zahari Doychev <zahari.doychev@linux.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [RFC PATCH 00/26] i.MX5/6 IPUv3 CSI/IC
Message-ID: <20140805065219.GA5775@rebelion>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Philipp,

can you tell which kernel tree I have to use for this patch set?

Thanks and Regards,
Zahari

On Thu, Jun 12, 2014 at 07:06:14PM +0200, Philipp Zabel wrote:
> Hi,
> 
> attached is a series of our work in progress i.MX6 capture drivers.
> I'm posting this now in reaction to Steve's i.MX6 Video capture series,
> as a reference for further discussion.
> Of the Image Converter (IC) we only use the postprocessor task, with
> tiling for larger frames, to implement v4l2 mem2mem scaler/colorspace
> converter and deinterlacer devices.
> The capture code capture code already uses the media controller framework
> and creates a subdevice representing the CSI, but the path to memory is
> fixed to IDMAC via SMFC, which is the only possible path for grayscale
> and  and anything with multiple output ports connected
> to the CSIs (such as the CSI2IPU gasket on i.MX6) doesn't work yet. Also,
> I think the CSI subdevice driver should be completely separate from the
> capture driver.
> 
> regards
> Philipp
> 
> Philipp Zabel (16):
>   gpu: ipu-v3: Add function to setup CP channel as interlaced
>   gpu: ipu-v3: Add ipu_cpmem_get_buffer function
>   gpu: ipu-v3: Add support for partial interleaved YCbCr 4:2:0 (NV12)
>     format
>   gpu: ipu-v3: Add support for planar YUV 4:2:2 (YUV422P) format
>   imx-drm: currently only IPUv3 is supported, make it mandatory
>   [media] Add i.MX SoC wide media device driver
>   [media] imx-ipu: Add i.MX IPUv3 capture driver
>   [media] ipuv3-csi: Skip 3 lines for NTSC BT.656
>   [media] imx-ipuv3-csi: Add support for temporarily stopping the stream
>     on sync loss
>   [media] imx-ipuv3-csi: Export sync lock event to userspace
>   [media] v4l2-subdev.h: Add lock status notification
>   [media] v4l2-subdev: Export v4l2_subdev_fops
>   mfd: syscon: add child device support
>   [media] imx: Add video switch
>   ARM: dts: Add IPU aliases on i.MX6
>   ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their
>     connections
> 
> Sascha Hauer (10):
>   gpu: ipu-v3: Add IC support
>   gpu: ipu-v3: Register IC with IPUv3
>   [media] imx-ipu: add ipu media common code
>   [media] imx-ipu: Add i.MX IPUv3 scaler driver
>   [media] imx-ipu: Add i.MX IPUv3 deinterlacer driver
>   [media] v4l2: subdev: Add v4l2_device_register_subdev_node function
>   [media] v4l2: Fix V4L2_CID_PIXEL_RATE
>   [media] v4l2 async: remove from notifier list
>   [media] ipuv3-csi: Pass ipucsi to v4l2_media_subdev_s_power
>   [media] ipuv3-csi: make subdev controls available on video device
> 
>  Documentation/devicetree/bindings/mfd/syscon.txt |   11 +
>  arch/arm/boot/dts/imx6dl.dtsi                    |  182 +++
>  arch/arm/boot/dts/imx6q.dtsi                     |  119 ++
>  arch/arm/boot/dts/imx6qdl.dtsi                   |    9 +
>  drivers/gpu/ipu-v3/Makefile                      |    2 +-
>  drivers/gpu/ipu-v3/ipu-common.c                  |  119 ++
>  drivers/gpu/ipu-v3/ipu-ic.c                      | 1227 +++++++++++++++
>  drivers/gpu/ipu-v3/ipu-prv.h                     |    6 +
>  drivers/media/platform/Kconfig                   |    4 +
>  drivers/media/platform/Makefile                  |    1 +
>  drivers/media/platform/imx/Kconfig               |   50 +
>  drivers/media/platform/imx/Makefile              |    6 +
>  drivers/media/platform/imx/imx-ipu-scaler.c      |  825 +++++++++++
>  drivers/media/platform/imx/imx-ipu-vdic.c        |  716 +++++++++
>  drivers/media/platform/imx/imx-ipu.c             |  313 ++++
>  drivers/media/platform/imx/imx-ipu.h             |   36 +
>  drivers/media/platform/imx/imx-ipuv3-csi.c       | 1729 ++++++++++++++++++++++
>  drivers/media/platform/imx/imx-media.c           |  174 +++
>  drivers/media/platform/imx/imx-video-switch.c    |  347 +++++
>  drivers/media/v4l2-core/v4l2-async.c             |    1 +
>  drivers/media/v4l2-core/v4l2-ctrls.c             |    8 +-
>  drivers/media/v4l2-core/v4l2-device.c            |   63 +-
>  drivers/media/v4l2-core/v4l2-subdev.c            |    1 +
>  drivers/mfd/syscon.c                             |    3 +
>  drivers/staging/imx-drm/Kconfig                  |    7 +-
>  include/media/imx.h                              |   25 +
>  include/media/v4l2-device.h                      |    5 +
>  include/media/v4l2-subdev.h                      |    3 +
>  include/video/imx-ipu-v3.h                       |   16 +
>  29 files changed, 5976 insertions(+), 32 deletions(-)
>  create mode 100644 drivers/gpu/ipu-v3/ipu-ic.c
>  create mode 100644 drivers/media/platform/imx/Kconfig
>  create mode 100644 drivers/media/platform/imx/Makefile
>  create mode 100644 drivers/media/platform/imx/imx-ipu-scaler.c
>  create mode 100644 drivers/media/platform/imx/imx-ipu-vdic.c
>  create mode 100644 drivers/media/platform/imx/imx-ipu.c
>  create mode 100644 drivers/media/platform/imx/imx-ipu.h
>  create mode 100644 drivers/media/platform/imx/imx-ipuv3-csi.c
>  create mode 100644 drivers/media/platform/imx/imx-media.c
>  create mode 100644 drivers/media/platform/imx/imx-video-switch.c
>  create mode 100644 include/media/imx.h
> 
> -- 
> 2.0.0.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
