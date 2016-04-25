Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37218 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331AbcDYS2s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 14:28:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCHv4 13/13] vb2: replace void *alloc_ctxs by struct device *alloc_devs
Date: Mon, 25 Apr 2016 21:29:10 +0300
Message-ID: <1650651.URx9R0XE8D@avalon>
In-Reply-To: <1461409429-24995-14-git-send-email-hverkuil@xs4all.nl>
References: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl> <1461409429-24995-14-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Saturday 23 Apr 2016 13:03:49 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Make this a proper typed array. Drop the old allocate context code since
> that is no longer used.
> 
> Note that the memops functions now get a struct device pointer instead of
> the struct device ** that was there initially (actually a void pointer to
> a struct containing only a struct device pointer).
> 
> This code is now a lot cleaner.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

For OMAP3 ISP, R-Car JPU, R-Car VSP1, Xilinx, UVC, OMAP4 ISS and videobuf2,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/video4linux/v4l2-pci-skeleton.c      |  2 +-
>  drivers/input/touchscreen/sur40.c                  |  2 +-
>  drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 +-
>  drivers/media/pci/cobalt/cobalt-v4l2.c             |  2 +-
>  drivers/media/pci/cx23885/cx23885-417.c            |  2 +-
>  drivers/media/pci/cx23885/cx23885-dvb.c            |  2 +-
>  drivers/media/pci/cx23885/cx23885-vbi.c            |  2 +-
>  drivers/media/pci/cx23885/cx23885-video.c          |  2 +-
>  drivers/media/pci/cx25821/cx25821-video.c          |  2 +-
>  drivers/media/pci/cx88/cx88-blackbird.c            |  2 +-
>  drivers/media/pci/cx88/cx88-dvb.c                  |  2 +-
>  drivers/media/pci/cx88/cx88-vbi.c                  |  2 +-
>  drivers/media/pci/cx88/cx88-video.c                |  2 +-
>  drivers/media/pci/dt3155/dt3155.c                  |  2 +-
>  drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  2 +-
>  drivers/media/pci/saa7134/saa7134-ts.c             |  2 +-
>  drivers/media/pci/saa7134/saa7134-vbi.c            |  2 +-
>  drivers/media/pci/saa7134/saa7134-video.c          |  2 +-
>  drivers/media/pci/saa7134/saa7134.h                |  2 +-
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |  2 +-
>  drivers/media/pci/solo6x10/solo6x10-v4l2.c         |  2 +-
>  drivers/media/pci/sta2x11/sta2x11_vip.c            |  2 +-
>  drivers/media/pci/tw68/tw68-video.c                |  2 +-
>  drivers/media/pci/tw686x/tw686x-video.c            |  2 +-
>  drivers/media/platform/am437x/am437x-vpfe.c        |  4 +--
>  drivers/media/platform/blackfin/bfin_capture.c     |  2 +-
>  drivers/media/platform/coda/coda-common.c          |  2 +-
>  drivers/media/platform/davinci/vpbe_display.c      |  2 +-
>  drivers/media/platform/davinci/vpif_capture.c      |  4 +--
>  drivers/media/platform/davinci/vpif_display.c      |  4 +--
>  drivers/media/platform/exynos-gsc/gsc-core.h       |  1 -
>  drivers/media/platform/exynos-gsc/gsc-m2m.c        |  2 +-
>  drivers/media/platform/exynos4-is/fimc-capture.c   |  2 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |  2 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c      |  2 +-
>  drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 +-
>  drivers/media/platform/m2m-deinterlace.c           |  2 +-
>  drivers/media/platform/marvell-ccic/mcam-core.c    |  2 +-
>  drivers/media/platform/mx2_emmaprp.c               |  2 +-
>  drivers/media/platform/omap3isp/ispvideo.c         |  2 +-
>  drivers/media/platform/rcar_jpu.c                  |  2 +-
>  drivers/media/platform/s3c-camif/camif-capture.c   |  2 +-
>  drivers/media/platform/s5p-g2d/g2d.c               |  2 +-
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |  2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 10 +++---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 12 +++----
>  drivers/media/platform/s5p-tv/mixer_video.c        |  2 +-
>  drivers/media/platform/sh_veu.c                    |  2 +-
>  drivers/media/platform/sh_vou.c                    |  2 +-
>  drivers/media/platform/soc_camera/atmel-isi.c      |  2 +-
>  drivers/media/platform/soc_camera/rcar_vin.c       |  2 +-
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |  2 +-
>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |  2 +-
>  drivers/media/platform/ti-vpe/cal.c                |  2 +-
>  drivers/media/platform/ti-vpe/vpe.c                |  2 +-
>  drivers/media/platform/vim2m.c                     |  7 +---
>  drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 +-
>  drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 +-
>  drivers/media/platform/vivid/vivid-vbi-out.c       |  2 +-
>  drivers/media/platform/vivid/vivid-vid-cap.c       |  7 +---
>  drivers/media/platform/vivid/vivid-vid-out.c       |  7 +---
>  drivers/media/platform/vsp1/vsp1_video.c           |  8 ++---
>  drivers/media/platform/xilinx/xilinx-dma.c         |  2 +-
>  drivers/media/usb/airspy/airspy.c                  |  2 +-
>  drivers/media/usb/au0828/au0828-vbi.c              |  2 +-
>  drivers/media/usb/au0828/au0828-video.c            |  2 +-
>  drivers/media/usb/em28xx/em28xx-vbi.c              |  2 +-
>  drivers/media/usb/em28xx/em28xx-video.c            |  2 +-
>  drivers/media/usb/go7007/go7007-v4l2.c             |  2 +-
>  drivers/media/usb/hackrf/hackrf.c                  |  2 +-
>  drivers/media/usb/msi2500/msi2500.c                |  2 +-
>  drivers/media/usb/pwc/pwc-if.c                     |  2 +-
>  drivers/media/usb/s2255/s2255drv.c                 |  2 +-
>  drivers/media/usb/stk1160/stk1160-v4l.c            |  2 +-
>  drivers/media/usb/usbtv/usbtv-video.c              |  2 +-
>  drivers/media/usb/uvc/uvc_queue.c                  |  2 +-
>  drivers/media/v4l2-core/videobuf2-core.c           | 18 +++++-----
>  drivers/media/v4l2-core/videobuf2-dma-contig.c     | 39 +++---------------
>  drivers/media/v4l2-core/videobuf2-dma-sg.c         | 42 +++----------------
>  drivers/media/v4l2-core/videobuf2-vmalloc.c        |  6 ++--
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    |  4 +--
>  drivers/staging/media/mx2/mx2_camera.c             |  2 +-
>  drivers/staging/media/mx3/mx3_camera.c             |  2 +-
>  drivers/staging/media/omap4iss/iss_video.c         |  2 +-
>  drivers/staging/media/tw686x-kh/tw686x-kh-video.c  |  2 +-
>  drivers/usb/gadget/function/uvc_queue.c            |  2 +-
>  include/media/videobuf2-core.h                     | 18 +++++-----
>  include/media/videobuf2-dma-contig.h               |  3 --
>  include/media/videobuf2-dma-sg.h                   |  3 --
>  89 files changed, 129 insertions(+), 210 deletions(-)

-- 
Regards,

Laurent Pinchart

