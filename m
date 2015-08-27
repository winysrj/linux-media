Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60263 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbbH0IvQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2015 04:51:16 -0400
Date: Thu, 27 Aug 2015 05:51:08 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Junghak Sung <jh1009.sung@samsung.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v3 1/5] media: videobuf2: Replace videobuf2-core
 with videobuf2-v4l2
Message-ID: <20150827055108.3e4a7c9b@recife.lan>
In-Reply-To: <1440590372-2377-2-git-send-email-jh1009.sung@samsung.com>
References: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
	<1440590372-2377-2-git-send-email-jh1009.sung@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Aug 2015 20:59:28 +0900
Junghak Sung <jh1009.sung@samsung.com> escreveu:

> Make videobuf2-v4l2 as a wrapper of videobuf2-core for v4l2-use.
> And replace videobuf2-core.h with videobuf2-v4l2.h.
> This renaming change should be accompanied by the modifications
> of all device drivers that include videobuf2-core.h.
> It can be done with just running this shell script.
> 
> replace()
> {
> str1=$1
> str2=$2
> dir=$3
> for file in $(find $dir -name *.h -o -name *.c -o -name Makefile)
> do
>     echo $file
>     sed "s/$str1/$str2/g" $file > $file.out
>     mv $file.out $file
> done
> }
> 
> replace "videobuf2-core" "videobuf2-v4l2" "include/media/"
> replace "videobuf2-core" "videobuf2-v4l2" "drivers/media/"
> replace "videobuf2-core" "videobuf2-v4l2" "drivers/usb/gadget/"

Looks OK for me.

> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---
>  drivers/media/pci/solo6x10/solo6x10.h              |    2 +-
>  drivers/media/platform/coda/coda-bit.c             |    2 +-
>  drivers/media/platform/coda/coda-common.c          |    2 +-
>  drivers/media/platform/coda/coda.h                 |    2 +-
>  drivers/media/platform/coda/trace.h                |    2 +-
>  drivers/media/platform/exynos-gsc/gsc-core.h       |    2 +-
>  drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
>  drivers/media/platform/exynos4-is/fimc-core.c      |    2 +-
>  drivers/media/platform/exynos4-is/fimc-core.h      |    2 +-
>  drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
>  drivers/media/platform/exynos4-is/fimc-isp.h       |    2 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c      |    2 +-
>  drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
>  drivers/media/platform/exynos4-is/fimc-m2m.c       |    2 +-
>  drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
>  drivers/media/platform/omap3isp/ispvideo.h         |    2 +-
>  drivers/media/platform/rcar_jpu.c                  |    2 +-
>  drivers/media/platform/s3c-camif/camif-capture.c   |    2 +-
>  drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
>  drivers/media/platform/s3c-camif/camif-core.h      |    2 +-
>  drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +-
>  drivers/media/platform/s5p-tv/mixer.h              |    2 +-
>  drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
>  drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
>  drivers/media/platform/ti-vpe/vpe.c                |    2 +-
>  drivers/media/platform/vivid/vivid-core.h          |    2 +-
>  drivers/media/platform/vsp1/vsp1_video.c           |    2 +-
>  drivers/media/platform/vsp1/vsp1_video.h           |    2 +-
>  drivers/media/platform/xilinx/xilinx-dma.c         |    2 +-
>  drivers/media/platform/xilinx/xilinx-dma.h         |    2 +-
>  drivers/media/usb/go7007/go7007-priv.h             |    2 +-
>  drivers/media/usb/stk1160/stk1160.h                |    2 +-
>  drivers/media/usb/usbtv/usbtv-video.c              |    2 +-
>  drivers/media/usb/uvc/uvcvideo.h                   |    2 +-
>  drivers/media/v4l2-core/Makefile                   |    2 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |    2 +-
>  drivers/media/v4l2-core/v4l2-trace.c               |    2 +-
>  drivers/media/v4l2-core/videobuf2-core.c           |   10 +++----
>  drivers/media/v4l2-core/videobuf2-v4l2.c           |   31 ++++++++++++++++++++
>  drivers/usb/gadget/function/uvc_queue.h            |    2 +-
>  include/media/soc_camera.h                         |    2 +-
>  include/media/v4l2-mem2mem.h                       |    2 +-
>  include/media/videobuf2-core.h                     |    3 +-
>  include/media/videobuf2-dvb.h                      |    2 +-
>  include/media/videobuf2-v4l2.h                     |   17 +++++++++++
>  53 files changed, 103 insertions(+), 56 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/videobuf2-v4l2.c
>  create mode 100644 include/media/videobuf2-v4l2.h
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
> index 27423d7..5cc9e9d 100644
> --- a/drivers/media/pci/solo6x10/solo6x10.h
> +++ b/drivers/media/pci/solo6x10/solo6x10.h
> @@ -35,7 +35,7 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #include "solo6x10-regs.h"
>  
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index fd7819d..cd41d49 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -25,7 +25,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-mem2mem.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  #include <media/videobuf2-vmalloc.h>
>  
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 04310cd..6e0c9be 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -36,7 +36,7 @@
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-mem2mem.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  #include <media/videobuf2-vmalloc.h>
>  
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 59b2af9..feb9671 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -24,7 +24,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-fh.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #include "coda_regs.h"
>  
> diff --git a/drivers/media/platform/coda/trace.h b/drivers/media/platform/coda/trace.h
> index d9099a0..9db6a66 100644
> --- a/drivers/media/platform/coda/trace.h
> +++ b/drivers/media/platform/coda/trace.h
> @@ -5,7 +5,7 @@
>  #define __CODA_TRACE_H__
>  
>  #include <linux/tracepoint.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #include "coda.h"
>  
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
> index fa572aa..769ff50 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.h
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.h
> @@ -19,7 +19,7 @@
>  #include <linux/videodev2.h>
>  #include <linux/io.h>
>  #include <linux/pm_runtime.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mem2mem.h>
> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
> index cfebf29..d0ceae3 100644
> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
> @@ -24,7 +24,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-mem2mem.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "common.h"
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
> index 1101c41..cef2a7f 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.c
> +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -27,7 +27,7 @@
>  #include <linux/slab.h>
>  #include <linux/clk.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "fimc-core.h"
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
> index 7328f08..ccb5d91 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.h
> +++ b/drivers/media/platform/exynos4-is/fimc-core.h
> @@ -22,7 +22,7 @@
>  #include <linux/sizes.h>
>  
>  #include <media/media-entity.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mem2mem.h>
> diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
> index e0be691..386eb49 100644
> --- a/drivers/media/platform/exynos4-is/fimc-is.h
> +++ b/drivers/media/platform/exynos4-is/fimc-is.h
> @@ -22,7 +22,7 @@
>  #include <linux/sizes.h>
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-ctrls.h>
>  
>  #include "fimc-isp.h"
> diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
> index 76b6b4d..195f9b5 100644
> --- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
> +++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
> @@ -28,7 +28,7 @@
>  
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  #include <media/exynos-fimc.h>
>  
> diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.h b/drivers/media/platform/exynos4-is/fimc-isp-video.h
> index 98c6626..f79a1b3 100644
> --- a/drivers/media/platform/exynos4-is/fimc-isp-video.h
> +++ b/drivers/media/platform/exynos4-is/fimc-isp-video.h
> @@ -11,7 +11,7 @@
>  #ifndef FIMC_ISP_VIDEO__
>  #define FIMC_ISP_VIDEO__
>  
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include "fimc-isp.h"
>  
>  #ifdef CONFIG_VIDEO_EXYNOS4_ISP_DMA_CAPTURE
> diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
> index b99be09..ad9908b 100644
> --- a/drivers/media/platform/exynos4-is/fimc-isp.h
> +++ b/drivers/media/platform/exynos4-is/fimc-isp.h
> @@ -21,7 +21,7 @@
>  #include <linux/videodev2.h>
>  
>  #include <media/media-entity.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mediabus.h>
>  #include <media/exynos-fimc.h>
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index ca6261a..7e37c9a 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -28,7 +28,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-mem2mem.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  #include <media/exynos-fimc.h>
>  
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
> index ea19dc7..7e4c708 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.h
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.h
> @@ -19,7 +19,7 @@
>  #include <linux/videodev2.h>
>  
>  #include <media/media-entity.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mediabus.h>
> diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
> index 0ad1b6f..9c27335 100644
> --- a/drivers/media/platform/exynos4-is/fimc-m2m.c
> +++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
> @@ -24,7 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/clk.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "common.h"
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 97167f6..35cd9e5 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -10,7 +10,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-dev.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  /*
>   * Create our own symbols for the supported buffer modes, but, for now,
> diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
> index 4071dd7..31c2445 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.h
> +++ b/drivers/media/platform/omap3isp/ispvideo.h
> @@ -20,7 +20,7 @@
>  #include <media/media-entity.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #define ISP_VIDEO_DRIVER_NAME		"ispvideo"
>  #define ISP_VIDEO_DRIVER_VERSION	"0.0.2"
> diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
> index 2973f07..18e62d0 100644
> --- a/drivers/media/platform/rcar_jpu.c
> +++ b/drivers/media/platform/rcar_jpu.c
> @@ -37,7 +37,7 @@
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-mem2mem.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index 76e6289..bb01eaa 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -34,7 +34,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "camif-core.h"
> diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
> index f47b332..1ba9bb0 100644
> --- a/drivers/media/platform/s3c-camif/camif-core.c
> +++ b/drivers/media/platform/s3c-camif/camif-core.c
> @@ -32,7 +32,7 @@
>  #include <media/media-device.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "camif-core.h"
> diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
> index 35d2fcd..8ef6f26 100644
> --- a/drivers/media/platform/s3c-camif/camif-core.h
> +++ b/drivers/media/platform/s3c-camif/camif-core.h
> @@ -25,7 +25,7 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mediabus.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/s3c_camif.h>
>  
>  #define S3C_CAMIF_DRIVER_NAME	"s3c-camif"
> diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
> index 421a7c3..81483da 100644
> --- a/drivers/media/platform/s5p-g2d/g2d.c
> +++ b/drivers/media/platform/s5p-g2d/g2d.c
> @@ -23,7 +23,7 @@
>  #include <media/v4l2-mem2mem.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "g2d.h"
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 9690f9d..5b1861b 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -26,7 +26,7 @@
>  #include <linux/string.h>
>  #include <media/v4l2-mem2mem.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "jpeg-core.h"
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 8de61dc..b3758b8 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -22,7 +22,7 @@
>  #include <media/v4l2-event.h>
>  #include <linux/workqueue.h>
>  #include <linux/of.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include "s5p_mfc_common.h"
>  #include "s5p_mfc_ctrl.h"
>  #include "s5p_mfc_debug.h"
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 24262bb..10884a7 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -21,7 +21,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include "regs-mfc.h"
>  #include "regs-mfc-v8.h"
>  
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index aebe4fd..2fd59e7 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -22,7 +22,7 @@
>  #include <linux/workqueue.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-event.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include "s5p_mfc_common.h"
>  #include "s5p_mfc_ctrl.h"
>  #include "s5p_mfc_debug.h"
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 2e57e9f..e42014c 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -23,7 +23,7 @@
>  #include <media/v4l2-event.h>
>  #include <linux/workqueue.h>
>  #include <media/v4l2-ctrls.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include "s5p_mfc_common.h"
>  #include "s5p_mfc_ctrl.h"
>  #include "s5p_mfc_debug.h"
> diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
> index fb2acc5..855b723 100644
> --- a/drivers/media/platform/s5p-tv/mixer.h
> +++ b/drivers/media/platform/s5p-tv/mixer.h
> @@ -24,7 +24,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/wait.h>
>  #include <media/v4l2-device.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #include "regs-mixer.h"
>  
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
> index ea4c423..6e41335 100644
> --- a/drivers/media/platform/soc_camera/mx2_camera.c
> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> @@ -32,7 +32,7 @@
>  
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  #include <media/soc_camera.h>
>  #include <media/soc_mediabus.h>
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 9087fed..3a18df7 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -38,7 +38,7 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-of.h>
>  #include <media/videobuf-core.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  /* Default to VGA resolution */
>  #define DEFAULT_WIDTH	640
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index c44760b..d82c2f2 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -40,7 +40,7 @@
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-mem2mem.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "vpdma.h"
> diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
> index c72349c..5f1b1da 100644
> --- a/drivers/media/platform/vivid/vivid-core.h
> +++ b/drivers/media/platform/vivid/vivid-core.h
> @@ -21,7 +21,7 @@
>  #define _VIVID_CORE_H_
>  
>  #include <linux/fb.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-ctrls.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 3c124c1..dfd45c7 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -24,7 +24,7 @@
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-subdev.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "vsp1.h"
> diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
> index 0887a4d..d808301 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.h
> +++ b/drivers/media/platform/vsp1/vsp1_video.h
> @@ -18,7 +18,7 @@
>  #include <linux/wait.h>
>  
>  #include <media/media-entity.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  struct vsp1_video;
>  
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index e779c93..d9dcd4b 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -22,7 +22,7 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "xilinx-dma.h"
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
> index a540111..7a1621a 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.h
> +++ b/drivers/media/platform/xilinx/xilinx-dma.h
> @@ -22,7 +22,7 @@
>  
>  #include <media/media-entity.h>
>  #include <media/v4l2-dev.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  struct dma_chan;
>  struct xvip_composite_device;
> diff --git a/drivers/media/usb/go7007/go7007-priv.h b/drivers/media/usb/go7007/go7007-priv.h
> index 2251c3f..9e83bbf 100644
> --- a/drivers/media/usb/go7007/go7007-priv.h
> +++ b/drivers/media/usb/go7007/go7007-priv.h
> @@ -20,7 +20,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-fh.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  struct go7007;
>  
> diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
> index 72cc8e8..047131b 100644
> --- a/drivers/media/usb/stk1160/stk1160.h
> +++ b/drivers/media/usb/stk1160/stk1160.h
> @@ -23,7 +23,7 @@
>  #include <linux/i2c.h>
>  #include <sound/core.h>
>  #include <sound/ac97_codec.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
>  
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
> index 08fb0f2..a46766c 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -29,7 +29,7 @@
>   */
>  
>  #include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #include "usbtv.h"
>  
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index 816dd1a..53e6484 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -15,7 +15,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-fh.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  /* --------------------------------------------------------------------------
>   * UVC constants
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index d1dd440..ad07401 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -33,7 +33,7 @@ obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
>  obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
>  obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
>  
> -obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o
> +obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o videobuf2-v4l2.o
>  obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
>  obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
>  obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 4a384fc..5dc6908 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -26,7 +26,7 @@
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-device.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #include <trace/events/v4l2.h>
>  
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index ec3ad4e..38703bd 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -17,7 +17,7 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-mem2mem.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
> diff --git a/drivers/media/v4l2-core/v4l2-trace.c b/drivers/media/v4l2-core/v4l2-trace.c
> index ae10b02..4004814 100644
> --- a/drivers/media/v4l2-core/v4l2-trace.c
> +++ b/drivers/media/v4l2-core/v4l2-trace.c
> @@ -1,6 +1,6 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-fh.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/v4l2.h>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index b866a6b..ab00ea0 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1,5 +1,5 @@
>  /*
> - * videobuf2-core.c - V4L2 driver helper framework
> + * videobuf2-core.c - video buffer 2 core framework
>   *
>   * Copyright (C) 2010 Samsung Electronics
>   *
> @@ -28,7 +28,7 @@
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-common.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  #include <trace/events/v4l2.h>
>  
> @@ -1810,7 +1810,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  	/*
>  	 * If you see this warning, then the driver isn't cleaning up properly
>  	 * after a failed start_streaming(). See the start_streaming()
> -	 * documentation in videobuf2-core.h for more information how buffers
> +	 * documentation in videobuf2-v4l2.h for more information how buffers
>  	 * should be returned to vb2 in start_streaming().
>  	 */
>  	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
> @@ -2197,7 +2197,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	/*
>  	 * If you see this warning, then the driver isn't cleaning up properly
>  	 * in stop_streaming(). See the stop_streaming() documentation in
> -	 * videobuf2-core.h for more information how buffers should be returned
> +	 * videobuf2-v4l2.h for more information how buffers should be returned
>  	 * to vb2 in stop_streaming().
>  	 */
>  	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
> @@ -2731,7 +2731,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
>   * responsible of clearing it's content and setting initial values for some
>   * required entries before calling this function.
>   * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
> - * to the struct vb2_queue description in include/media/videobuf2-core.h
> + * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
>   * for more information.
>   */
>  int vb2_queue_init(struct vb2_queue *q)
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> new file mode 100644
> index 0000000..2f2b738
> --- /dev/null
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -0,0 +1,31 @@
> +/*
> + * videobuf2-v4l2.c - V4L2 driver helper framework
> + *
> + * Copyright (C) 2010 Samsung Electronics
> + *
> + * Author: Pawel Osciak <pawel@osciak.com>
> + *	   Marek Szyprowski <m.szyprowski@samsung.com>
> + *
> + * The vb2_thread implementation was based on code from videobuf-dvb.c:
> + *	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/freezer.h>
> +#include <linux/kthread.h>
> +
> +#include <media/videobuf2-v4l2.h>
> +
> +MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
> +MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
> index 01ca9ea..0ffe498 100644
> --- a/drivers/usb/gadget/function/uvc_queue.h
> +++ b/drivers/usb/gadget/function/uvc_queue.h
> @@ -6,7 +6,7 @@
>  #include <linux/kernel.h>
>  #include <linux/poll.h>
>  #include <linux/videodev2.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  /* Maximum frame size in bytes, for sanity checking. */
>  #define UVC_MAX_FRAME_SIZE	(16*1024*1024)
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 2f6261f..97aa133 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -18,7 +18,7 @@
>  #include <linux/pm.h>
>  #include <linux/videodev2.h>
>  #include <media/videobuf-core.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 8849aab..5c60da9 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -17,7 +17,7 @@
>  #ifndef _MEDIA_V4L2_MEM2MEM_H
>  #define _MEDIA_V4L2_MEM2MEM_H
>  
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  /**
>   * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 4f7f7ae..155991e 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -1,5 +1,5 @@
>  /*
> - * videobuf2-core.h - V4L2 driver helper framework
> + * videobuf2-core.h - Video Buffer 2 Core Framework
>   *
>   * Copyright (C) 2010 Samsung Electronics
>   *
> @@ -661,5 +661,4 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
>  
>  void vb2_ops_wait_prepare(struct vb2_queue *vq);
>  void vb2_ops_wait_finish(struct vb2_queue *vq);
> -
>  #endif /* _MEDIA_VIDEOBUF2_CORE_H */
> diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
> index 8f61456..bef9127 100644
> --- a/include/media/videobuf2-dvb.h
> +++ b/include/media/videobuf2-dvb.h
> @@ -6,7 +6,7 @@
>  #include <dvb_demux.h>
>  #include <dvb_net.h>
>  #include <dvb_frontend.h>
> -#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  struct vb2_dvb {
>  	/* filling that the job of the driver */
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> new file mode 100644
> index 0000000..d4a4d9a
> --- /dev/null
> +++ b/include/media/videobuf2-v4l2.h
> @@ -0,0 +1,17 @@
> +/*
> + * videobuf2-v4l2.h - V4L2 driver helper framework
> + *
> + * Copyright (C) 2010 Samsung Electronics
> + *
> + * Author: Pawel Osciak <pawel@osciak.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + */
> +#ifndef _MEDIA_VIDEOBUF2_V4L2_H
> +#define _MEDIA_VIDEOBUF2_V4L2_H
> +
> +#include <media/videobuf2-core.h>
> +
> +#endif /* _MEDIA_VIDEOBUF2_V4L2_H */
