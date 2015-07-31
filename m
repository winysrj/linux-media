Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47033 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbGaIoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 04:44:46 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NSC01YJ5GAFL240@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Jul 2015 17:44:39 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, jh1009.sung@samsung.com
Subject: [RFC PATCH v2 0/5] Refactoring Videobuf2 for common use
Date: Fri, 31 Jul 2015 17:44:32 +0900
Message-id: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,

This is the 2nd round for refactoring Videobuf2(a.k.a VB2).
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
The previous version of this patch series can be found at [1].

[1] RFC PATCH v1 - http://www.spinics.net/lists/linux-media/msg90688.html

Changes since v1:
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

This patch series is base on media_tree.git [2] by Mauro & Hans's request.
And I applied this patches to my own git [3] which can be helpful to review.
My test boards are ubuntu PC(Intel i7-3770) and odroid-xu3(exynos5422). And
basic oprerations, e.g. reqbuf, querybuf, qbuf, dqbuf, are tested with
v4l-utils. But, more tests for the all ioctls will be required on many other
targets.

[2] media_tree.git - http://git.linuxtv.org/cgit.cgi/media_tree.git/
[3] jsung/dvb-vb2.git - http://git.linuxtv.org/cgit.cgi/jsung/dvb-vb2.git/

Any suggestions and comments are welcome.

Regards,
Junghak

Junghak Sung (5):
  media: videobuf2: Rename videobuf2-core to videobuf2-v4l2
  media: videobuf2: Restructurng struct vb2_buffer for common use.
  media: videobuf2: Divide videobuf2-core into 2 parts
  media: videobuf2: Define vb2_buf_type and vb2_memory
  media: videobuf2: Modify prefix for VB2 functions

 drivers/input/touchscreen/sur40.c                  |   23 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   19 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c         |    4 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |    8 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   15 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   10 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   13 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |   17 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   23 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   22 +-
 drivers/media/pci/cx25821/cx25821.h                |    3 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   17 +-
 drivers/media/pci/cx88/cx88-core.c                 |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   15 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    8 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   17 +-
 drivers/media/pci/cx88/cx88-video.c                |   21 +-
 drivers/media/pci/cx88/cx88.h                      |    2 +-
 drivers/media/pci/dt3155/dt3155.c                  |   23 +-
 drivers/media/pci/dt3155/dt3155.h                  |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    9 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |    6 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |    4 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |   30 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |   24 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   43 +-
 drivers/media/pci/saa7134/saa7134.h                |    9 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   35 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   20 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   35 +-
 drivers/media/pci/tw68/tw68-video.c                |   22 +-
 drivers/media/pci/tw68/tw68.h                      |    2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   40 +-
 drivers/media/platform/am437x/am437x-vpfe.h        |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   42 +-
 drivers/media/platform/coda/coda-bit.c             |   62 +-
 drivers/media/platform/coda/coda-common.c          |   30 +-
 drivers/media/platform/coda/coda-jpeg.c            |    6 +-
 drivers/media/platform/coda/coda.h                 |    6 +-
 drivers/media/platform/coda/trace.h                |    2 +-
 drivers/media/platform/davinci/vpbe_display.c      |   16 +-
 drivers/media/platform/davinci/vpif_capture.c      |   43 +-
 drivers/media/platform/davinci/vpif_capture.h      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |   49 +-
 drivers/media/platform/davinci/vpif_display.h      |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   10 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    6 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   16 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   30 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   12 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    6 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   22 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   25 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   18 +-
 drivers/media/platform/m2m-deinterlace.c           |   26 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   40 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
 drivers/media/platform/mx2_emmaprp.c               |   25 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   47 +-
 drivers/media/platform/omap3isp/ispvideo.h         |    4 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   49 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
 drivers/media/platform/s3c-camif/camif-core.h      |    4 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   22 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   57 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   42 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   63 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  120 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   28 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   28 +-
 drivers/media/platform/s5p-tv/mixer.h              |    4 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |    2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   33 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |    5 +-
 drivers/media/platform/sh_veu.c                    |   38 +-
 drivers/media/platform/sh_vou.c                    |    8 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   32 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |   44 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |   39 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   38 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   49 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   24 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    8 +-
 drivers/media/platform/ti-vpe/vpe.c                |   39 +-
 drivers/media/platform/vim2m.c                     |   39 +-
 drivers/media/platform/vivid/vivid-core.c          |   10 +-
 drivers/media/platform/vivid/vivid-core.h          |    4 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   20 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |   14 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   24 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   23 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |   19 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   25 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |   20 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   26 +-
 drivers/media/platform/vsp1/vsp1_video.h           |    6 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |    6 +-
 drivers/media/platform/xilinx/xilinx-dma.h         |    2 +-
 drivers/media/usb/airspy/airspy.c                  |   22 +-
 drivers/media/usb/au0828/au0828-vbi.c              |   15 +-
 drivers/media/usb/au0828/au0828-video.c            |   55 +-
 drivers/media/usb/au0828/au0828.h                  |    3 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |   17 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   33 +-
 drivers/media/usb/em28xx/em28xx.h                  |    3 +-
 drivers/media/usb/go7007/go7007-driver.c           |    4 +-
 drivers/media/usb/go7007/go7007-priv.h             |    4 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   20 +-
 drivers/media/usb/hackrf/hackrf.c                  |   20 +-
 drivers/media/usb/msi2500/msi2500.c                |   23 +-
 drivers/media/usb/pwc/pwc-if.c                     |   28 +-
 drivers/media/usb/pwc/pwc-uncompress.c             |    8 +-
 drivers/media/usb/pwc/pwc.h                        |    3 +-
 drivers/media/usb/s2255/s2255drv.c                 |   26 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   17 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    4 +-
 drivers/media/usb/stk1160/stk1160.h                |    4 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   24 +-
 drivers/media/usb/usbtv/usbtv.h                    |    3 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   56 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
 drivers/media/v4l2-core/Makefile                   |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   30 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 2393 +++-----------------
 drivers/media/v4l2-core/videobuf2-dvb.c            |    2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 1970 ++++++++++++++++
 drivers/usb/gadget/function/uvc_queue.c            |   46 +-
 drivers/usb/gadget/function/uvc_queue.h            |    4 +-
 include/media/soc_camera.h                         |    2 +-
 include/media/v4l2-mem2mem.h                       |   10 +-
 include/media/videobuf2-core.h                     |  430 ++--
 include/media/videobuf2-dvb.h                      |    2 +-
 include/media/videobuf2-v4l2.h                     |  186 ++
 include/trace/events/v4l2.h                        |   38 +-
 143 files changed, 4185 insertions(+), 3462 deletions(-)
 create mode 100644 drivers/media/v4l2-core/videobuf2-v4l2.c
 create mode 100644 include/media/videobuf2-v4l2.h

-- 
1.7.9.5

