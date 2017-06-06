Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38807 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751329AbdFFJOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 05:14:04 -0400
Subject: Re: [PATCH 00/12] Intel IPU3 ImgU patchset
To: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2fb8bd86-f856-8233-ad90-685f8d88999b@xs4all.nl>
Date: Tue, 6 Jun 2017 11:14:00 +0200
MIME-Version: 1.0
In-Reply-To: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/17 22:39, Yong Zhi wrote:
> This patchset adds support for the Intel IPU3 (Image Processing Unit)
> ImgU which is essentially a modern memory-to-memory ISP. It implements
> raw Bayer to YUV image format conversion as well as a large number of
> other pixel processing algorithms for improving the image quality.
> 
> Meta data formats are defined for image statistics (3A, i.e. automatic
> white balance, exposure and focus, histogram and local area contrast
> enhancement) as well as for the pixel processing algorithm parameters.
> The documentation for these formats is currently not included in the
> patchset but will be added in a future version of this set.
> 
> The algorithm parameters need to be considered specific to a given frame
> and typically a large number of these parameters change on frame to frame
> basis. Additionally, the parameters are highly structured (and not a flat
> space of independent configuration primitives). They also reflect the
> data structures used by the firmware and the hardware. On top of that,
> the algorithms require highly specialized user space to make meaningful
> use of them. For these reasons it has been chosen video buffers to pass
> the parameters to the device.
> 
> On individual patches:
> 
> The heart of ImgU is the CSS, or Camera Subsystem, which contains the
> image processors and HW accelerators.
> 
> The 3A statistics and other firmware parameter computation related
> functions are implemented in patch 8.
> 
> All h/w programming related code can be found in patch 9.
> 
> To access DDR via ImgU's own memory space, IPU3 is also equipped with
> its own MMU unit, the driver is implemented in patch 2.
> 
> Patch 3 uses above driver for DMA mapping operation.
> 
> Patch 5-10 are basically IPU3 CSS specific implementations:
> 
> 6 and 7 provide some utility functions and manage IPU3 fw download and
> install.
> 
> Patch 9 and 10 are of the same file, the latter implements interface
> functions for access fw & hw capabilities defined in patch 8.
> 
> Patch 12 uses Kconfig and Makefile created by IPU3 cio2 patch set,
> the code path, however is updated to drivers/media/pci/intel/ipu3.
> The path change will be reflected in next revision of the cio2 patch as well.

I need to see the v4l2-compliance output for the various video devices that
are created. Please compile directly from the https://git.linuxtv.org/v4l-utils.git/
repository to be sure you use the latest code.

Just run 'v4l2-compliance -d /dev/videoX'.

When you post v2 I'd like to see the output of that utility in the cover email.

If the utility reports fails and you aren't clear what's going on, then just
mail me (with a CC to Sakari).

It hasn't been used much (if at all) for video devices streaming metadata, so
you may run into issues with that.

Regards,

	Hans

> 
> Tuukka Toivonen (1):
>   intel-ipu3: mmu: implement driver
> 
> Yong Zhi (11):
>   videodev2.h, v4l2-ioctl: add IPU3 meta buffer format
>   intel-ipu3: Add DMA API implementation
>   intel-ipu3: Add user space ABI definitions
>   intel-ipu3: css: tables
>   intel-ipu3: css: imgu dma buff pool
>   intel-ipu3: css: firmware management
>   intel-ipu3: params: compute and program ccs
>   intel-ipu3: css hardware setup
>   intel-ipu3: css pipeline
>   intel-ipu3: Add imgu v4l2 driver
>   intel-ipu3: imgu top level pci device
> 
>  drivers/media/pci/intel/ipu3/Kconfig           |   32 +
>  drivers/media/pci/intel/ipu3/Makefile          |    8 +
>  drivers/media/pci/intel/ipu3/ipu3-abi.h        | 1572 ++++
>  drivers/media/pci/intel/ipu3/ipu3-css-fw.c     |  272 +
>  drivers/media/pci/intel/ipu3/ipu3-css-fw.h     |  215 +
>  drivers/media/pci/intel/ipu3/ipu3-css-params.c | 3113 ++++++++
>  drivers/media/pci/intel/ipu3/ipu3-css-params.h |  105 +
>  drivers/media/pci/intel/ipu3/ipu3-css-pool.c   |  129 +
>  drivers/media/pci/intel/ipu3/ipu3-css-pool.h   |   53 +
>  drivers/media/pci/intel/ipu3/ipu3-css.c        | 2242 ++++++
>  drivers/media/pci/intel/ipu3/ipu3-css.h        |  236 +
>  drivers/media/pci/intel/ipu3/ipu3-dmamap.c     |  408 +
>  drivers/media/pci/intel/ipu3/ipu3-dmamap.h     |   20 +
>  drivers/media/pci/intel/ipu3/ipu3-mmu.c        |  423 ++
>  drivers/media/pci/intel/ipu3/ipu3-mmu.h        |   73 +
>  drivers/media/pci/intel/ipu3/ipu3-tables.c     | 9621 ++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-tables.h     |   82 +
>  drivers/media/pci/intel/ipu3/ipu3-v4l2.c       |  723 ++
>  drivers/media/pci/intel/ipu3/ipu3.c            |  712 ++
>  drivers/media/pci/intel/ipu3/ipu3.h            |  184 +
>  drivers/media/v4l2-core/v4l2-ioctl.c           |    4 +
>  include/uapi/linux/intel-ipu3.h                | 2182 ++++++
>  include/uapi/linux/videodev2.h                 |    6 +
>  23 files changed, 22415 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-abi.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-params.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-params.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-v4l2.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3.h
>  create mode 100644 include/uapi/linux/intel-ipu3.h
> 
