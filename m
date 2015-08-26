Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56185 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbbHZL7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 07:59:36 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NTO00NTKUNA6O70@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Aug 2015 20:59:34 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	jh1009.sung@samsung.com, rany.kwon@samsung.com
Subject: [RFC PATCH v3 0/5] Refactoring Videobuf2 for common use
Date: Wed, 26 Aug 2015 20:59:27 +0900
Message-id: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,

This is the 3rd round for refactoring Videobuf2(a.k.a VB2).
The purpose of this patch series is to separate existing VB2 framework
into core part and V4L2 specific part. So that not only V4L2 but also other
frameworks can use them to manage buffer and utilize queue.

Why do we try to make the VB2 framework to be common?

As you may know, current DVB framework uses ringbuffer mechanism to demux
MPEG-2 TS data and pass it to userspace. However, this mechanism requires
extra memory copy because DVB framework provides only read() system call for
application - read() system call copies the kernel data to user-space buffer.
So if we can use VB2 framework which supports streaming I/O and buffer
sharing mechanism, then we could enhance existing DVB framework by removing
the extra memory copy - with VB2 framework, application can access the kernel
data directly through mmap system call.

We have a plan for this work as follows:
1. Separate existing VB2 framework into three parts - VB2 common, VB2-v4l2.
   Of course, this change will not affect other v4l2-based
   device drivers. This patch series corresponds to this step.

2. Add and implement new APIs for DVB streaming I/O.
   We can remove unnecessary memory copy between kernel-space and user-space
   by using these new APIs. However, we leaves legacy interfaces as-is
   for backward compatibility.

This patch series is the first step for it.
The previous version of this patch series can be found at [1] and [2].

[1] RFC PATCH v1 - http://www.spinics.net/lists/linux-media/msg90688.html
[2] RFC PATCH v2 - http://www.spinics.net/lists/linux-media/msg92130.html


Changes since v2

1. Remove v4l2 stuffs completely from vb2_buffer
The v4l2 stuffs - v4l2_buf and v4l2_planes - are removed completely from
struct vb2_buffer. New member variables - index, type, memory - are added
to struct vb2_buffer, all of which can be used commonly. And bytesused,
length, offset, userptr, fd, data_offset are added to struct vb2_plane
for the same reason. So, we can manage video buffer by only using
struct vb2_buffer.
And, v4l2 stuffs - flags, field, timestamp, timecode, sequence - are defined
as member variables of struct vb2_v4l2_buffer.

2. Create new header file for VB2 internal use
videobuf2-internal.h is created, which is referred by videobuf2-core
and videobuf2-v4l2. The header file contains dprintk() for debug,
macro functions to invoke various callbacks, and vb2_core_* function prototypes
referred by inside of videobuf2.

3. Remove buffer-specific callbacks as much as possible
There were many callback functions to handle video buffer information
in previous patch series. In this patch series, I try to remove these callbacks
as much as possible without breaking the existing function flow.
As a result, only four callbacks are remained - fill_user_buffer(),
fill_vb2_buffer(), fill_vb2_timestamp() and is_last().

All ideas above are from Hans and it seems to be better and right way.


Changes since v1

1. Divide patch set into more pieces
v1 was not reviewed normally because the 2/3 patch is failed to send to mailing
list with size problem - over 300kb. So I have divided the patch set into five
pieces and refined them neatly, which was pointed by Hans.

2. Add shell scripts for renaming patch
In case of renaming patch, shell scripts are included inside the body of the
patches by Mauro's advice. 1/5 and 5/5 patches include these scripts, which can
be used by reviewers or maintainers to regenerate big patch file if something
goes wrong during patch apply.

3. Remove dependency on v4l2 from videobuf2
In previous patch set, videobuf2-core uses v4l2-specific stuff as it is.
e.g. enum v4l2_buf_type and enum v4l2_memory. That prevented other frameworks
from using videobuf2 independently and made them forced to include
v4l2-specific stuff.
In this version, these dependent stuffs are replaced with VB2 own stuffs.
e.g. enum vb2_buf_type and enum vb2_memory. So, v4l2-specific header file isn't
required to use videobuf2 in other modules. Please, note that videobuf2 stuffs
will be translated to v4l2-specific stuffs in videobuf2-v4l2.c file for
backward compatibility.

4. Unify duplicated definitions
VB2_DEBUG() is newly defined in videobuf2-core header file in order to unify
duplicated macro functions that invoke callback functions implemented in vb2
backends - i.e., videobuf2-vmalloc and videobuf2-dma-sg - and queue relevant
callbacks of device drivers.
In previous patch set, these macro functions were defined
in both videobuf2-core.c and videobuf2-v4l2.c.


This patch series is based on media_tree.git [3]. I have applied this patches
to my own git [4] for review, and tested this patch series on ubuntu
PC(Intel i7-3770) for x86 system and odroid-xu3(exynos5422) for ARM.

[3] media_tree.git - http://git.linuxtv.org/cgit.cgi/media_tree.git/
[4] jsung/dvb-vb2.git - http://git.linuxtv.org/cgit.cgi/jsung/dvb-vb2.git/
    (branch: vb2-refactoring)

Any suggestions and comments are welcome.

Regards,
Junghak

Junghak Sung (5):
  media: videobuf2: Replace videobuf2-core with videobuf2-v4l2
  media: videobuf2: Restructure vb2_buffer for common use.
  media: videobuf2: Modify all device drivers related with previous
    change.
  media: videobuf2: Change queue_setup argument
  media: videobuf2: Divide videobuf2-core into 2 parts

 drivers/input/touchscreen/sur40.c                  |   20 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   16 +-
 drivers/media/pci/cobalt/cobalt-driver.h           |    2 +-
 drivers/media/pci/cobalt/cobalt-irq.c              |    8 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   11 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   13 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   24 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   11 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |   18 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   29 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   24 +-
 drivers/media/pci/cx25821/cx25821.h                |    3 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   15 +-
 drivers/media/pci/cx88/cx88-core.c                 |    8 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   13 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |   14 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   19 +-
 drivers/media/pci/cx88/cx88-video.c                |   21 +-
 drivers/media/pci/cx88/cx88.h                      |    2 +-
 drivers/media/pci/dt3155/dt3155.c                  |   20 +-
 drivers/media/pci/dt3155/dt3155.h                  |    3 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |   21 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   14 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |   16 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |   12 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   23 +-
 drivers/media/pci/saa7134/saa7134.h                |    4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    2 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   14 +-
 drivers/media/pci/tw68/tw68-video.c                |   13 +-
 drivers/media/pci/tw68/tw68.h                      |    2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   23 +-
 drivers/media/platform/am437x/am437x-vpfe.h        |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   13 +-
 drivers/media/platform/coda/coda-bit.c             |    2 +-
 drivers/media/platform/coda/coda-common.c          |    4 +-
 drivers/media/platform/coda/coda.h                 |    2 +-
 drivers/media/platform/coda/trace.h                |    2 +-
 drivers/media/platform/davinci/vpbe_display.c      |    3 +-
 drivers/media/platform/davinci/vpif_capture.c      |   20 +-
 drivers/media/platform/davinci/vpif_capture.h      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |   30 +-
 drivers/media/platform/davinci/vpif_display.h      |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    4 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   18 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    5 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   15 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    4 +-
 drivers/media/platform/m2m-deinterlace.c           |   25 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   46 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
 drivers/media/platform/mx2_emmaprp.c               |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   21 +-
 drivers/media/platform/omap3isp/ispvideo.h         |    4 +-
 drivers/media/platform/rcar_jpu.c                  |    5 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   15 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
 drivers/media/platform/s3c-camif/camif-core.h      |    4 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    4 +-
 drivers/media/platform/s5p-tv/mixer.h              |    4 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   10 +-
 drivers/media/platform/sh_veu.c                    |   22 +-
 drivers/media/platform/sh_vou.c                    |   18 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    8 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    7 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    7 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    5 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    8 +-
 drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    3 +-
 drivers/media/platform/ti-vpe/vpe.c                |    4 +-
 drivers/media/platform/vim2m.c                     |    3 +-
 drivers/media/platform/vivid/vivid-core.h          |    4 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   54 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |   34 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   17 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   25 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |    5 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |    6 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |    6 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   15 +-
 drivers/media/platform/vsp1/vsp1_video.h           |    4 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   23 +-
 drivers/media/platform/xilinx/xilinx-dma.h         |    2 +-
 drivers/media/usb/airspy/airspy.c                  |   19 +-
 drivers/media/usb/au0828/au0828-vbi.c              |    9 +-
 drivers/media/usb/au0828/au0828-video.c            |   48 +-
 drivers/media/usb/au0828/au0828.h                  |    3 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    5 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   25 +-
 drivers/media/usb/em28xx/em28xx.h                  |    3 +-
 drivers/media/usb/go7007/go7007-driver.c           |   24 +-
 drivers/media/usb/go7007/go7007-priv.h             |    4 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   22 +-
 drivers/media/usb/hackrf/hackrf.c                  |   17 +-
 drivers/media/usb/msi2500/msi2500.c                |   12 +-
 drivers/media/usb/pwc/pwc-if.c                     |   31 +-
 drivers/media/usb/pwc/pwc-uncompress.c             |    8 +-
 drivers/media/usb/pwc/pwc.h                        |    3 +-
 drivers/media/usb/s2255/s2255drv.c                 |   29 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   17 +-
 drivers/media/usb/stk1160/stk1160-video.c          |   12 +-
 drivers/media/usb/stk1160/stk1160.h                |    4 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   24 +-
 drivers/media/usb/usbtv/usbtv.h                    |    3 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   29 +-
 drivers/media/usb/uvc/uvc_video.c                  |   20 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    6 +-
 drivers/media/v4l2-core/Makefile                   |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   10 +-
 drivers/media/v4l2-core/v4l2-trace.c               |    2 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 2039 +++-----------------
 drivers/media/v4l2-core/videobuf2-internal.h       |  184 ++
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 1671 ++++++++++++++++
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    2 +-
 drivers/staging/media/omap4iss/iss_video.c         |    2 +-
 drivers/usb/gadget/function/uvc_queue.c            |   28 +-
 drivers/usb/gadget/function/uvc_queue.h            |    4 +-
 include/media/soc_camera.h                         |    2 +-
 include/media/v4l2-mem2mem.h                       |   11 +-
 include/media/videobuf2-core.h                     |  212 +-
 include/media/videobuf2-dvb.h                      |    2 +-
 include/media/videobuf2-v4l2.h                     |  159 ++
 include/trace/events/v4l2.h                        |   39 +-
 141 files changed, 3163 insertions(+), 2625 deletions(-)
 create mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
 create mode 100644 drivers/media/v4l2-core/videobuf2-v4l2.c
 create mode 100644 include/media/videobuf2-v4l2.h

-- 
1.7.9.5

