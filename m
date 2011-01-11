Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1AKQXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 11:23:36 -0500
Message-ID: <4D2CA021.5080001@redhat.com>
Date: Tue, 11 Jan 2011 16:23:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com>
In-Reply-To: <4D21FDC1.7000803@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

I've created a tree/branch for my tests with vb2 and for the multiplane patches, at:
	git://linuxtv.org/git/mchehab/experimental.git vb2_test

I'll be putting there the patches I'm working with. For now, I've reviewed
the multiplane patches. Please see my comments bellow. I'll be sending you
other emails after reviewing the remaining patches.

Thanks,
Mauro.


Em 03-01-2011 14:48, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> Please pull from our tree for the following items:
> 
> 1. V4L2 multiplane extension,
> 2. The Videobuf2 framework,
> 3. Mem2mem framework and vivi conversion to Videbuf2,
> 4. s5p-fimc driver conversion to Videbuf2 and multiplane ext. and various
>    driver updates and bugfixes,
> 5. Siliconfile NOON010PC30 sensor subdev driver,
> 6. Patches for SAA7134 driver for Videbuf2 testing.
> 
> The patch series has been rebased onto staging/for_v2.6.38 branch on top
> of s5p-fimc driver patches that were recently added to v2.6.37-rc8.
> The SAA7134 driver patches are meant for Vb2 testing only. The test hardware
> for those was the Avermedia  AVerTV Super 007 TV card.
> 
> Thanks!
> Sylwester
> 
> 
> 
> The following changes since commit 6d09afc3bdf7f6b52358c30490b9434ba18d6344:
> 
>   [media] s5p-fimc: Fix output DMA handling in S5PV310 IP revisions (2010-12-28
> 15:50:50 +0100)
> 
> are available in the git repository at:
>   git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2
> 
> Andrzej Pietrasiewicz (3):
>       v4l: videobuf2: add DMA scatter/gather allocator
>       v4l: saa7134: remove radio, vbi, mpeg, input, alsa, tvaudio, saa6752hs
> support
>       v4l: saa7134: quick and dirty port to videobuf2
> 
> Hyunwoong Kim (5):
>       [media] s5p-fimc: fix the value of YUV422 1-plane formats
>       [media] s5p-fimc: Configure scaler registers depending on FIMC version
>       [media] s5p-fimc: update checking scaling ratio range
>       [media] s5p-fimc: Support stop_streaming and job_abort
>       [media] s5p-fimc: fix MSCTRL.FIFO_CTRL for performance enhancement
> 
> Marek Szyprowski (4):
>       v4l: videobuf2: add generic memory handling routines
>       v4l: videobuf2: add read() and write() emulator
>       v4l: vivi: port to videobuf2
>       v4l: mem2mem: port to videobuf2
> 
> Pawel Osciak (8):
>       v4l: Add multi-planar API definitions to the V4L2 API
>       v4l: Add multi-planar ioctl handling code

>       v4l: Add compat functions for the multi-planar API
>       v4l: fix copy sizes in compat32 for ext controls

Are you sure that we need to add compat32 stuff for the multi-planar definitions?
Had you test if the compat32 code is actually working? Except if you use things
that have different sizes on 32 and 64 bit architectures, there's no need to add
anything for compat.

Anyway, I'll be merging the two compat functions into just one patch, as it will
help to track any regressions there, if ever needed. They are at my temporary
branch, but, if they are not needed, I'll drop when merging upstream.

>       v4l: v4l2-ioctl: add buffer type conversion for multi-planar-aware ioctls

NACK. 

We shouldn't be doing those videobuf memcpy operations inside the kernel. 
If you want such feature, please implement it on libv4l.

>       v4l: add videobuf2 Video for Linux 2 driver framework
>       v4l: videobuf2: add vmalloc allocator
>       v4l: videobuf2: add DMA coherent allocator
> 
> Sungchun Kang (1):
>       [media] s5p-fimc: fimc_stop_capture bug fix
> 
> Sylwester Nawrocki (15):
>       v4l: v4l2-ioctl: Fix conversion between multiplane and singleplane buffers

NACK. 

We shouldn't be doing those videobuf memcpy operations inside the kernel. 
If you want such feature, please implement it on libv4l.


>       v4l: mem2mem: port m2m_testdev to vb2
>       v4l: Add multiplanar format fourccs for s5p-fimc driver
>       [media] s5p-fimc: Porting to videobuf 2
>       [media] s5p-fimc: Conversion to multiplanar formats
>       [media] s5p-fimc: Use v4l core mutex in ioctl and file operations
>       [media] s5p-fimc: Rename s3c_fimc* to s5p_fimc*
>       [media] s5p-fimc: Derive camera bus width from mediabus pixelcode
>       [media] s5p-fimc: Enable interworking without subdev s_stream
>       [media] s5p-fimc: Use default input DMA burst count
>       [media] s5p-fimc: Enable simultaneous rotation and flipping
>       [media] s5p-fimc: Add control of the external sensor clock
>       [media] s5p-fimc: Move scaler details handling to the register API file
>       [media] Add chip identity for NOON010PC30 camera sensor
>       [media] Add v4l2 subdev driver for NOON010PC30L image sensor
> 
>  drivers/media/video/Kconfig                 |   36 +-
>  drivers/media/video/Makefile                |    7 +
>  drivers/media/video/mem2mem_testdev.c       |  227 ++--
>  drivers/media/video/noon010pc30.c           |  792 ++++++++++++
>  drivers/media/video/s5p-fimc/fimc-capture.c |  550 +++++----
>  drivers/media/video/s5p-fimc/fimc-core.c    |  872 +++++++------
>  drivers/media/video/s5p-fimc/fimc-core.h    |  133 +--
>  drivers/media/video/s5p-fimc/fimc-reg.c     |  201 ++--
>  drivers/media/video/s5p-fimc/regs-fimc.h    |   29 +-
>  drivers/media/video/saa7134/Kconfig         |    2 +-
>  drivers/media/video/saa7134/Makefile        |    8 +-
>  drivers/media/video/saa7134/saa7134-cards.c | 1415 ++++++++-------------
>  drivers/media/video/saa7134/saa7134-core.c  |  454 +++-----
>  drivers/media/video/saa7134/saa7134-video.c |  859 +++++--------
>  drivers/media/video/saa7134/saa7134.h       |   48 +-
>  drivers/media/video/v4l2-compat-ioctl32.c   |  229 +++-
>  drivers/media/video/v4l2-ioctl.c            |  626 +++++++++-
>  drivers/media/video/v4l2-mem2mem.c          |  232 ++--
>  drivers/media/video/videobuf2-core.c        | 1804 +++++++++++++++++++++++++++
>  drivers/media/video/videobuf2-dma-contig.c  |  185 +++
>  drivers/media/video/videobuf2-dma-sg.c      |  292 +++++
>  drivers/media/video/videobuf2-memops.c      |  232 ++++
>  drivers/media/video/videobuf2-vmalloc.c     |  132 ++
>  drivers/media/video/vivi.c                  |  357 +++---
>  include/linux/videodev2.h                   |  131 ++-
>  include/media/noon010pc30.h                 |   28 +
>  include/media/{s3c_fimc.h => s5p_fimc.h}    |   20 +-
>  include/media/v4l2-chip-ident.h             |    3 +
>  include/media/v4l2-ioctl.h                  |   16 +
>  include/media/v4l2-mem2mem.h                |   56 +-
>  include/media/videobuf2-core.h              |  380 ++++++
>  include/media/videobuf2-dma-contig.h        |   29 +
>  include/media/videobuf2-dma-sg.h            |   32 +
>  include/media/videobuf2-memops.h            |   45 +
>  include/media/videobuf2-vmalloc.h           |   20 +
>  35 files changed, 7392 insertions(+), 3090 deletions(-)
>  create mode 100644 drivers/media/video/noon010pc30.c
>  create mode 100644 drivers/media/video/videobuf2-core.c
>  create mode 100644 drivers/media/video/videobuf2-dma-contig.c
>  create mode 100644 drivers/media/video/videobuf2-dma-sg.c
>  create mode 100644 drivers/media/video/videobuf2-memops.c
>  create mode 100644 drivers/media/video/videobuf2-vmalloc.c
>  create mode 100644 include/media/noon010pc30.h
>  rename include/media/{s3c_fimc.h => s5p_fimc.h} (75%)
>  create mode 100644 include/media/videobuf2-core.h
>  create mode 100644 include/media/videobuf2-dma-contig.h
>  create mode 100644 include/media/videobuf2-dma-sg.h
>  create mode 100644 include/media/videobuf2-memops.h
>  create mode 100644 include/media/videobuf2-vmalloc.h
> 
> Regards,

