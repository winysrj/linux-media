Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:55336 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbbFLKvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 06:51:21 -0400
Message-ID: <557AB99C.6030905@xs4all.nl>
Date: Fri, 12 Jun 2015 12:51:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>, linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com, sangbae90.lee@samsung.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [RFC PATCH 0/3] Refactoring Videobuf2 for common use
References: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

On 06/08/2015 03:35 PM, Junghak Sung wrote:
> Hello everybody,
> 
> This patch series refactories exsiting Videobuf2, so that not only V4L2
> but also other frameworks can use it to manage buffer and utilize
> queue.
> 
> I would separate existing Videobuf2-core framework into two parts - common
> and v4l2-specific part. This work is as follows :
> 
> 1. Separate existing vb2_buffer structure into common buffer and
>    v4l2-specific parts by removing v4l2-specific members and
>    embedding it into vb2_v4l2_buffer structure like this:
> 
>     struct vb2_v4l2_buffer {
>         struct vb2_buffer    vb2;
>         struct v4l2_buffer   v4l2_buf;
>         struct v4l2_plane    v4l2_planes[VIDEO_MAX_PLANES];
>     };
> 
> 2. Abstract the v4l2-specific elements, and specify them when the device
>    drives use them. For example, vb2_v4l2_buffer structure can be abstracted
>    by vb2_buffer structure, and device drivers can get framework-specific
>    object such as vb2_v4l2_buffer by using container_of().
> 
> 3. Separate VB2-core framework into real VB2-core and v4l2-specific part.
>    This means that it moves V4L2-specific parts of VB2-core to v4l2-specific
>    part because current VB2-core framework has some codes dependent of V4L2.
>    As a result, we will have two VB2 files - videobuf2-core.c and
>    videobuf2-v4l2.c.
> 
> Why do we try to make the VB2 framework to be common?
> 
> As you may know, current DVB framework uses ringbuffer mechanism to demux
> MPEG-2 TS data and pass it to userspace. However, this mechanism requires
> extra memory copy because DVB framework provides only read() system call for
> application - read() system call copies the kernel data to user-space buffer.
> 
> So if we can use VB2 framework which supports streaming I/O and buffer
> sharing mechanism, then we could enhance existing DVB framework by removing
> the extra memory copy - with VB2 framework, application can access the kernel
> data directly through mmap system call.
> 
> This patch series is the first step for it.
> 
> We have a plan for this work as follows:
> 
> 1. Separate existing VB2 framework into three parts - VB2 common, VB2-v4l2,
>    and VB2-dvb. Of course, this change should not affect other v4l2-based
>    device drivers. This patch series includes some parts of this step.
> 
> 2. Add new APIs for DVB streaming I/O. These APIs will be implemented
>    in VB2-dvb framework. So, we can remove unnecessary memory copy between
>    kernel-space and user-space by using these new APIs.
>    However, we leaves legacy interfaces as-is for backward compatibility.
> 
> We are working on this project with Mauro and have a discussion with him
> on IRC channel weekly. Nowaday, we are discussing more detailed DVB user
> scenario for streaming I/O.
> 
> The final goal of this project is to enhance current DVB framework.
> The first mission is to achieve zero-copy functionality between kernel-space
> and user-space with mmap system call. More missions are under consideration:
> i.e., we could share the buffer not only between kernel-space and user-space
> but also between devices - demux, hw video codec - by exporting a buffer
> to dmabuf fd with VB2 framework.
> 
> Any suggestions and comments are welcome.

I've tried to review it, but in the current form it is too hard to do. It's not
helped by the fact that patch 2 didn't make it to the mailinglist. It might
be better to just split up such large patches and make a note that the pull
request will combine the two (or more) patches into one.

BTW, I fully agree with what you want to do, where I am having trouble is
verifying that nothing breaks and in the details of the vb2 API changes.

Can you make a new patch series that only shows the changes to the videobuf2
sources and headers, so without all the driver changes? The driver changes
are automatically checked by the compiler when you build the drivers, so I
believe that that's correct (I hope :-) ).

Also try to split it up in smaller pieces. I had the feeling that you combined
multiple but otherwise independent changes in one patch. The vb2 framework is
an important piece of code, and I want to be confident about the changes made.

Regarding the split into core and v4l2 sources/headers: I've been thinking about
this a bit more, and what would probably make reviewing easiest is if you start
off with making a simple videobuf2-v4l2.h header that just includes core.h and
slowly move the v4l2-specific parts from videobuf2-core.h to videobuf2-v4l2.h.

And do the same with videobuf2-v4l2.c: start off with an empty source and move
code from core.c to v4l2.c whenever a v4l2-specific part migrates.

Another note: I noticed that the queue_setup op was changed so the v4l2_format
argument became a void *. I do not think that that is the right approach since
we lose strong typing.

I wonder if v4l2-specific queue ops should be introduced. I'm not sure how that
would work out, but I think we can look at that for the next round of patches.

Regards,

	Hans

> 
> Best regards,
> Junghak
> 
> Junghak Sung (3):
>   modify the vb2_buffer structure for common video buffer     and make
>     struct vb2_v4l2_buffer
>   move struct vb2_queue to common and apply the changes related with
>     that     Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>   make vb2-core part with not v4l2-specific elements
> 
>  Documentation/video4linux/v4l2-pci-skeleton.c      |   16 +-
>  drivers/media/dvb-frontends/rtl2832_sdr.c          |   13 +-
>  drivers/media/pci/cx23885/cx23885-417.c            |   13 +-
>  drivers/media/pci/cx23885/cx23885-core.c           |    4 +-
>  drivers/media/pci/cx23885/cx23885-dvb.c            |   12 +-
>  drivers/media/pci/cx23885/cx23885-vbi.c            |   17 +-
>  drivers/media/pci/cx23885/cx23885-video.c          |   19 +-
>  drivers/media/pci/cx23885/cx23885.h                |    2 +-
>  drivers/media/pci/cx25821/cx25821-video.c          |   20 +-
>  drivers/media/pci/cx25821/cx25821.h                |    2 +-
>  drivers/media/pci/cx88/cx88-blackbird.c            |   15 +-
>  drivers/media/pci/cx88/cx88-core.c                 |    2 +-
>  drivers/media/pci/cx88/cx88-dvb.c                  |   13 +-
>  drivers/media/pci/cx88/cx88-mpeg.c                 |    2 +-
>  drivers/media/pci/cx88/cx88-vbi.c                  |   17 +-
>  drivers/media/pci/cx88/cx88-video.c                |   17 +-
>  drivers/media/pci/cx88/cx88.h                      |    2 +-
>  drivers/media/pci/saa7134/saa7134-core.c           |    4 +-
>  drivers/media/pci/saa7134/saa7134-ts.c             |   28 +-
>  drivers/media/pci/saa7134/saa7134-vbi.c            |   22 +-
>  drivers/media/pci/saa7134/saa7134-video.c          |   17 +-
>  drivers/media/pci/saa7134/saa7134.h                |    8 +-
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   19 +-
>  drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   11 +-
>  drivers/media/pci/solo6x10/solo6x10.h              |    4 +-
>  drivers/media/pci/sta2x11/sta2x11_vip.c            |   24 +-
>  drivers/media/pci/tw68/tw68-video.c                |   20 +-
>  drivers/media/pci/tw68/tw68.h                      |    2 +-
>  drivers/media/platform/am437x/am437x-vpfe.c        |   33 +-
>  drivers/media/platform/am437x/am437x-vpfe.h        |    2 +-
>  drivers/media/platform/blackfin/bfin_capture.c     |   30 +-
>  drivers/media/platform/coda/coda-bit.c             |   20 +-
>  drivers/media/platform/coda/coda-common.c          |   28 +-
>  drivers/media/platform/coda/coda-jpeg.c            |    2 +-
>  drivers/media/platform/coda/coda.h                 |    6 +-
>  drivers/media/platform/davinci/vpbe_display.c      |   25 +-
>  drivers/media/platform/davinci/vpif_capture.c      |   30 +-
>  drivers/media/platform/davinci/vpif_capture.h      |    2 +-
>  drivers/media/platform/davinci/vpif_display.c      |   34 +-
>  drivers/media/platform/davinci/vpif_display.h      |    6 +-
>  drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
>  drivers/media/platform/exynos-gsc/gsc-core.h       |    6 +-
>  drivers/media/platform/exynos-gsc/gsc-m2m.c        |   12 +-
>  drivers/media/platform/exynos4-is/fimc-capture.c   |   23 +-
>  drivers/media/platform/exynos4-is/fimc-core.c      |    4 +-
>  drivers/media/platform/exynos4-is/fimc-core.h      |    6 +-
>  drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |   25 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
>  drivers/media/platform/exynos4-is/fimc-isp.h       |    4 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c      |   25 +-
>  drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
>  drivers/media/platform/exynos4-is/fimc-m2m.c       |   14 +-
>  drivers/media/platform/m2m-deinterlace.c           |   16 +-
>  drivers/media/platform/marvell-ccic/mcam-core.c    |   26 +-
>  drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
>  drivers/media/platform/mx2_emmaprp.c               |   16 +-
>  drivers/media/platform/omap3isp/ispvideo.c         |   24 +-
>  drivers/media/platform/omap3isp/ispvideo.h         |    4 +-
>  drivers/media/platform/s3c-camif/camif-capture.c   |   23 +-
>  drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
>  drivers/media/platform/s3c-camif/camif-core.h      |    4 +-
>  drivers/media/platform/s5p-g2d/g2d.c               |   14 +-
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |   34 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |   14 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   36 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   57 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    4 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    4 +-
>  drivers/media/platform/s5p-tv/mixer.h              |    4 +-
>  drivers/media/platform/s5p-tv/mixer_reg.c          |    2 +-
>  drivers/media/platform/s5p-tv/mixer_video.c        |   11 +-
>  drivers/media/platform/sh_veu.c                    |   25 +-
>  drivers/media/platform/soc_camera/atmel-isi.c      |   26 +-
>  drivers/media/platform/soc_camera/mx2_camera.c     |   41 +-
>  drivers/media/platform/soc_camera/mx3_camera.c     |   34 +-
>  drivers/media/platform/soc_camera/rcar_vin.c       |   30 +-
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |   47 +-
>  drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
>  drivers/media/platform/ti-vpe/vpe.c                |   30 +-
>  drivers/media/platform/vim2m.c                     |   28 +-
>  drivers/media/platform/vivid/vivid-core.h          |    4 +-
>  drivers/media/platform/vivid/vivid-kthread-cap.c   |    8 +-
>  drivers/media/platform/vivid/vivid-kthread-out.c   |    8 +-
>  drivers/media/platform/vivid/vivid-sdr-cap.c       |   18 +-
>  drivers/media/platform/vivid/vivid-vbi-cap.c       |   14 +-
>  drivers/media/platform/vivid/vivid-vbi-out.c       |   14 +-
>  drivers/media/platform/vivid/vivid-vid-cap.c       |   24 +-
>  drivers/media/platform/vivid/vivid-vid-out.c       |   21 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c             |    4 +-
>  drivers/media/platform/vsp1/vsp1_video.c           |   20 +-
>  drivers/media/platform/vsp1/vsp1_video.h           |    6 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c             |    4 +-
>  drivers/media/usb/airspy/airspy.c                  |   15 +-
>  drivers/media/usb/au0828/au0828-vbi.c              |   17 +-
>  drivers/media/usb/au0828/au0828-video.c            |   29 +-
>  drivers/media/usb/au0828/au0828.h                  |    2 +-
>  drivers/media/usb/em28xx/em28xx-vbi.c              |   15 +-
>  drivers/media/usb/em28xx/em28xx-video.c            |   30 +-
>  drivers/media/usb/em28xx/em28xx.h                  |    2 +-
>  drivers/media/usb/go7007/go7007-driver.c           |    2 +-
>  drivers/media/usb/go7007/go7007-priv.h             |    4 +-
>  drivers/media/usb/go7007/go7007-v4l2.c             |   15 +-
>  drivers/media/usb/hackrf/hackrf.c                  |   13 +-
>  drivers/media/usb/msi2500/msi2500.c                |   13 +-
>  drivers/media/usb/pwc/pwc-if.c                     |   26 +-
>  drivers/media/usb/pwc/pwc.h                        |    2 +-
>  drivers/media/usb/s2255/s2255drv.c                 |   16 +-
>  drivers/media/usb/stk1160/stk1160-v4l.c            |   15 +-
>  drivers/media/usb/stk1160/stk1160-video.c          |    2 +-
>  drivers/media/usb/stk1160/stk1160.h                |    4 +-
>  drivers/media/usb/usbtv/usbtv-video.c              |   11 +-
>  drivers/media/usb/usbtv/usbtv.h                    |    2 +-
>  drivers/media/usb/uvc/uvc_queue.c                  |   32 +-
>  drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
>  drivers/media/v4l2-core/Makefile                   |    2 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |    8 +-
>  drivers/media/v4l2-core/videobuf2-core.c           | 1888 ++------------------
>  drivers/media/v4l2-core/videobuf2-dma-contig.c     |    2 +-
>  drivers/media/v4l2-core/videobuf2-dma-sg.c         |    2 +-
>  drivers/media/v4l2-core/videobuf2-dvb.c            |    2 +-
>  drivers/media/v4l2-core/videobuf2-memops.c         |    2 +-
>  drivers/media/v4l2-core/videobuf2-v4l2.c           | 1878 +++++++++++++++++++
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
>  include/media/v4l2-mem2mem.h                       |   10 +-
>  include/media/videobuf2-core.h                     |  235 ++-
>  include/media/videobuf2-dma-contig.h               |    6 +-
>  include/media/videobuf2-dma-sg.h                   |    6 +-
>  include/media/videobuf2-dvb.h                      |    2 +-
>  include/media/videobuf2-memops.h                   |    2 +-
>  include/media/videobuf2-v4l2.h                     |  139 ++
>  include/media/videobuf2-vmalloc.h                  |    2 +-
>  144 files changed, 3290 insertions(+), 2662 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/videobuf2-v4l2.c
>  create mode 100644 include/media/videobuf2-v4l2.h
> 

