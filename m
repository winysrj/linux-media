Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43175 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbbFLJ6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:58:36 -0400
Message-ID: <557AAD40.9020009@xs4all.nl>
Date: Fri, 12 Jun 2015 11:58:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>, linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com, sangbae90.lee@samsung.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [RFC PATCH 1/3] modify the vb2_buffer structure for common video
 buffer and make struct vb2_v4l2_buffer
References: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com> <1433770535-21143-2-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1433770535-21143-2-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

On 06/08/2015 03:35 PM, Junghak Sung wrote:
> Make the struct vb2_buffer to common buffer by removing v4l2-specific members.
> And common video buffer is embedded into v4l2-specific video buffer like:
> struct vb2_v4l2_buffer {
>     struct vb2_buffer    vb2;
>     struct v4l2_buffer    v4l2_buf;
>     struct v4l2_plane    v4l2_planes[VIDEO_MAX_PLANES];
> };
> This changes require the modifications of all device drivers that use this structure.

It's next to impossible to review just large diffs, but it is unavoidable for
changes like this I guess.

I do recommend that you do a 'git grep videobuf2-core' to make sure all usages
of that have been replaced with videobuf2-v4l2. I think I saw videobuf2-core
mentioned in a comment, but it is hard to be sure.

It would also be easier to review if the renaming of core.[ch] to v4l2.[ch] was
done in a separate patch. If it is relatively easy to split it up like that,
then I would appreciate it, but if it takes a lot of time, then leave it as is.

Anyway, assuming that 'git grep videobuf2-core' doesn't find anything:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> ---
>  Documentation/video4linux/v4l2-pci-skeleton.c      |   12 +-
>  drivers/media/dvb-frontends/rtl2832_sdr.c          |   10 +-
>  drivers/media/pci/cx23885/cx23885-417.c            |   12 +-
>  drivers/media/pci/cx23885/cx23885-dvb.c            |   12 +-
>  drivers/media/pci/cx23885/cx23885-vbi.c            |   12 +-
>  drivers/media/pci/cx23885/cx23885-video.c          |   12 +-
>  drivers/media/pci/cx23885/cx23885.h                |    2 +-
>  drivers/media/pci/cx25821/cx25821-video.c          |   12 +-
>  drivers/media/pci/cx25821/cx25821.h                |    2 +-
>  drivers/media/pci/cx88/cx88-blackbird.c            |   14 +-
>  drivers/media/pci/cx88/cx88-dvb.c                  |   14 +-
>  drivers/media/pci/cx88/cx88-vbi.c                  |   12 +-
>  drivers/media/pci/cx88/cx88-video.c                |   12 +-
>  drivers/media/pci/cx88/cx88.h                      |    2 +-
>  drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
>  drivers/media/pci/saa7134/saa7134-ts.c             |   10 +-
>  drivers/media/pci/saa7134/saa7134-vbi.c            |   12 +-
>  drivers/media/pci/saa7134/saa7134-video.c          |   18 +-
>  drivers/media/pci/saa7134/saa7134.h                |    8 +-
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   14 +-
>  drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    6 +-
>  drivers/media/pci/solo6x10/solo6x10.h              |    4 +-
>  drivers/media/pci/sta2x11/sta2x11_vip.c            |   20 +-
>  drivers/media/pci/tw68/tw68-video.c                |   12 +-
>  drivers/media/pci/tw68/tw68.h                      |    2 +-
>  drivers/media/platform/am437x/am437x-vpfe.c        |   16 +-
>  drivers/media/platform/am437x/am437x-vpfe.h        |    2 +-
>  drivers/media/platform/blackfin/bfin_capture.c     |   20 +-
>  drivers/media/platform/coda/coda-bit.c             |   20 +-
>  drivers/media/platform/coda/coda-common.c          |   24 +-
>  drivers/media/platform/coda/coda-jpeg.c            |    2 +-
>  drivers/media/platform/coda/coda.h                 |    6 +-
>  drivers/media/platform/davinci/vpbe_display.c      |    8 +-
>  drivers/media/platform/davinci/vpif_capture.c      |   16 +-
>  drivers/media/platform/davinci/vpif_capture.h      |    2 +-
>  drivers/media/platform/davinci/vpif_display.c      |   18 +-
>  drivers/media/platform/davinci/vpif_display.h      |    6 +-
>  drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
>  drivers/media/platform/exynos-gsc/gsc-core.h       |    6 +-
>  drivers/media/platform/exynos-gsc/gsc-m2m.c        |   16 +-
>  drivers/media/platform/exynos4-is/fimc-capture.c   |   12 +-
>  drivers/media/platform/exynos4-is/fimc-core.c      |    4 +-
>  drivers/media/platform/exynos4-is/fimc-core.h      |    6 +-
>  drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |   14 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
>  drivers/media/platform/exynos4-is/fimc-isp.h       |    4 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c      |   10 +-
>  drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
>  drivers/media/platform/exynos4-is/fimc-m2m.c       |   16 +-
>  drivers/media/platform/m2m-deinterlace.c           |   16 +-
>  drivers/media/platform/marvell-ccic/mcam-core.c    |   24 +-
>  drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
>  drivers/media/platform/mx2_emmaprp.c               |   16 +-
>  drivers/media/platform/omap3isp/ispvideo.c         |    8 +-
>  drivers/media/platform/omap3isp/ispvideo.h         |    4 +-
>  drivers/media/platform/s3c-camif/camif-capture.c   |   12 +-
>  drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
>  drivers/media/platform/s3c-camif/camif-core.h      |    4 +-
>  drivers/media/platform/s5p-g2d/g2d.c               |   16 +-
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |   30 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   10 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   18 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    2 +-
>  drivers/media/platform/s5p-tv/mixer.h              |    4 +-
>  drivers/media/platform/s5p-tv/mixer_video.c        |    4 +-
>  drivers/media/platform/sh_veu.c                    |   20 +-
>  drivers/media/platform/soc_camera/atmel-isi.c      |   20 +-
>  drivers/media/platform/soc_camera/mx2_camera.c     |   14 +-
>  drivers/media/platform/soc_camera/mx3_camera.c     |   18 +-
>  drivers/media/platform/soc_camera/rcar_vin.c       |   14 +-
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |   22 +-
>  drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
>  drivers/media/platform/ti-vpe/vpe.c                |   26 +-
>  drivers/media/platform/vim2m.c                     |   24 +-
>  drivers/media/platform/vivid/vivid-core.h          |    4 +-
>  drivers/media/platform/vivid/vivid-sdr-cap.c       |    8 +-
>  drivers/media/platform/vivid/vivid-vbi-cap.c       |   10 +-
>  drivers/media/platform/vivid/vivid-vbi-out.c       |   10 +-
>  drivers/media/platform/vivid/vivid-vid-cap.c       |   12 +-
>  drivers/media/platform/vivid/vivid-vid-out.c       |    8 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c             |    4 +-
>  drivers/media/platform/vsp1/vsp1_video.c           |   16 +-
>  drivers/media/platform/vsp1/vsp1_video.h           |    6 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c             |    4 +-
>  drivers/media/usb/airspy/airspy.c                  |    6 +-
>  drivers/media/usb/au0828/au0828-vbi.c              |    8 +-
>  drivers/media/usb/au0828/au0828-video.c            |    8 +-
>  drivers/media/usb/au0828/au0828.h                  |    2 +-
>  drivers/media/usb/em28xx/em28xx-vbi.c              |    8 +-
>  drivers/media/usb/em28xx/em28xx-video.c            |    8 +-
>  drivers/media/usb/em28xx/em28xx.h                  |    2 +-
>  drivers/media/usb/go7007/go7007-priv.h             |    4 +-
>  drivers/media/usb/go7007/go7007-v4l2.c             |   10 +-
>  drivers/media/usb/hackrf/hackrf.c                  |    6 +-
>  drivers/media/usb/msi2500/msi2500.c                |    6 +-
>  drivers/media/usb/pwc/pwc-if.c                     |   18 +-
>  drivers/media/usb/pwc/pwc.h                        |    2 +-
>  drivers/media/usb/s2255/s2255drv.c                 |   10 +-
>  drivers/media/usb/stk1160/stk1160-v4l.c            |    4 +-
>  drivers/media/usb/stk1160/stk1160.h                |    4 +-
>  drivers/media/usb/usbtv/usbtv-video.c              |    6 +-
>  drivers/media/usb/usbtv/usbtv.h                    |    2 +-
>  drivers/media/usb/uvc/uvc_queue.c                  |   14 +-
>  drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
>  drivers/media/v4l2-core/Makefile                   |    2 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |    6 +-
>  drivers/media/v4l2-core/videobuf2-core.c           |  398 +++++++++----------
>  drivers/media/v4l2-core/videobuf2-dma-contig.c     |    2 +-
>  drivers/media/v4l2-core/videobuf2-dma-sg.c         |    2 +-
>  drivers/media/v4l2-core/videobuf2-dvb.c            |    2 +-
>  drivers/media/v4l2-core/videobuf2-memops.c         |    2 +-
>  .../{videobuf2-core.c => videobuf2-v4l2.c}         |  400 ++++++++++----------
>  drivers/media/v4l2-core/videobuf2-vmalloc.c        |    2 +-
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    |   30 +-
>  drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 +-
>  drivers/staging/media/dt3155v4l/dt3155v4l.c        |   14 +-
>  drivers/staging/media/dt3155v4l/dt3155v4l.h        |    2 +-
>  drivers/staging/media/omap4iss/iss_video.c         |   16 +-
>  drivers/staging/media/omap4iss/iss_video.h         |    4 +-
>  drivers/usb/gadget/function/uvc_queue.c            |   14 +-
>  drivers/usb/gadget/function/uvc_queue.h            |    4 +-
>  include/media/davinci/vpbe_display.h               |    2 +-
>  include/media/soc_camera.h                         |    2 +-
>  include/media/v4l2-mem2mem.h                       |    8 +-
>  include/media/videobuf2-core.h                     |   76 ++--
>  include/media/videobuf2-dma-contig.h               |    4 +-
>  include/media/videobuf2-dma-sg.h                   |    4 +-
>  include/media/videobuf2-dvb.h                      |    2 +-
>  include/media/videobuf2-memops.h                   |    2 +-
>  .../media/{videobuf2-core.h => videobuf2-v4l2.h}   |   80 ++--
>  include/media/videobuf2-vmalloc.h                  |    2 +-
>  136 files changed, 1081 insertions(+), 1045 deletions(-)
>  copy drivers/media/v4l2-core/{videobuf2-core.c => videobuf2-v4l2.c} (89%)
>  copy include/media/{videobuf2-core.h => videobuf2-v4l2.h} (94%)

