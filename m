Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:11673 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbdFNWTu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 18:19:50 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v2 00/12] Intel IPU3 ImgU patchset
Date: Wed, 14 Jun 2017 17:19:15 -0500
Message-Id: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds support for the Intel IPU3 (Image Processing Unit)
ImgU which is essentially a modern memory-to-memory ISP. It implements
raw Bayer to YUV image format conversion as well as a large number of
other pixel processing algorithms for improving the image quality.

Meta data formats are defined for image statistics (3A, i.e. automatic
white balance, exposure and focus, histogram and local area contrast
enhancement) as well as for the pixel processing algorithm parameters.
The documentation for these formats is currently not included in the
patchset but will be added in a future version of this set.

The algorithm parameters need to be considered specific to a given frame
and typically a large number of these parameters change on frame to frame
basis. Additionally, the parameters are highly structured (and not a flat
space of independent configuration primitives). They also reflect the
data structures used by the firmware and the hardware. On top of that,
the algorithms require highly specialized user space to make meaningful
use of them. For these reasons it has been chosen video buffers to pass
the parameters to the device.

On individual patches:

The heart of ImgU is the CSS, or Camera Subsystem, which contains the
image processors and HW accelerators.

The 3A statistics and other firmware parameter computation related
functions are implemented in patch 8.

All h/w programming related code can be found in patch 9.

To access DDR via ImgU's own memory space, IPU3 is also equipped with
its own MMU unit, the driver is implemented in patch 2.

Patch 3 uses above driver for DMA mapping operation.

Patch 5-10 are basically IPU3 CSS specific implementations:

6 and 7 provide some utility functions and manage IPU3 fw download and
install.

Will add a link here when the fw (ie. ipu3_fw.bin) is submitted.

Patch 9 and 10 are of the same file, the latter implements interface
functions for access fw & hw capabilities defined in patch 8.

Patch 12 uses Kconfig and Makefile created by IPU3 cio2 patch set,
the code path, however is updated to drivers/media/pci/intel/ipu3.
The path change will be reflected in next revision of the cio2 patch as well.

Here is the device topology:

localhost ~ # media-ctl -d /dev/media0 -p
Media controller API version 0.1.0

Media device information
------------------------
driver          ipu3-imgu
model           ipu3-imgu
serial          
bus info        0000:00:05.0
hw revision     0x0
driver version  4.12.0

Device topology
- entity 1: ipu3-imgu:0 (8 pads, 8 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
        pad0:Sink
                stream:0[fmt:UYVY2X8/352x288]
                link: 
                <- "input":0 [ENABLED,IMMUTABLE]
        pad1:Sink
                stream:0[fmt:UYVY2X8/352x288]
                link: 
                <- "parameters":0 []
        pad2:Source
                stream:0[fmt:UYVY2X8/352x288]
                link: 
                -> "output":0 []
        pad3:Source
                stream:0[fmt:UYVY2X8/352x288]
                link: 
                -> "viewfinder":0 []
        pad4:Source
                stream:0[fmt:UYVY2X8/352x288]
                link: 
                -> "postview":0 []
        pad5:Source
                stream:0[fmt:UYVY2X8/352x288]
                link: 
                -> "3a stat":0 []
        pad6:Source
                stream:0[fmt:UYVY2X8/352x288]
                link: 
                -> "dvs stat":0 []
        pad7:Source
                stream:0[fmt:UYVY2X8/352x288]
                link: 
                -> "lace stat":0 []

- entity 2: input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0:Source
                link: 
                -> "ipu3-imgu:0":0 [ENABLED,IMMUTABLE]

- entity 3: parameters (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video1
        pad0:Source
                link: 
                -> "ipu3-imgu:0":1 []

- entity 4: output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video2
        pad0:Sink
                link: 
                <- "ipu3-imgu:0":2 []

- entity 5: viewfinder (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video3
        pad0:Sink
                link: 
                <- "ipu3-imgu:0":3 []

- entity 6: postview (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video4
        pad0:Sink
                link: 
                <- "ipu3-imgu:0":4 []

- entity 7: 3a stat (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video5
        pad0:Sink
                link: 
                <- "ipu3-imgu:0":5 []

- entity 8: dvs stat (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video6
        pad0:Sink
                link: 
                <- "ipu3-imgu:0":6 []

- entity 9: lace stat (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video7
        pad0:Sink
                link: 
                <- "ipu3-imgu:0":7 []

===========
= history =
===========
version 2:

This version cherry-picked firmware ABI change and other
fix in order to bring the code up-to-date with our internal release.

I will go over the review comments in v1 and address them in v3 and
future update.

version 1:
- Initial submission

Tuukka Toivonen (1):
  intel-ipu3: mmu: implement driver

Yong Zhi (11):
  videodev2.h, v4l2-ioctl: add IPU3 meta buffer format
  intel-ipu3: Add DMA API implementation
  intel-ipu3: Add user space ABI definitions
  intel-ipu3: css: tables
  intel-ipu3: css: imgu dma buff pool
  intel-ipu3: css: firmware management
  intel-ipu3: params: compute and program ccs
  intel-ipu3: css hardware setup
  intel-ipu3: css pipeline
  intel-ipu3: Add imgu v4l2 driver
  intel-ipu3: imgu top level pci device

 drivers/media/pci/intel/ipu3/Kconfig           |   32 +
 drivers/media/pci/intel/ipu3/Makefile          |    8 +
 drivers/media/pci/intel/ipu3/ipu3-abi.h        | 1573 ++++
 drivers/media/pci/intel/ipu3/ipu3-css-fw.c     |  272 +
 drivers/media/pci/intel/ipu3/ipu3-css-fw.h     |  219 +
 drivers/media/pci/intel/ipu3/ipu3-css-params.c | 3119 ++++++++
 drivers/media/pci/intel/ipu3/ipu3-css-params.h |  105 +
 drivers/media/pci/intel/ipu3/ipu3-css-pool.c   |  129 +
 drivers/media/pci/intel/ipu3/ipu3-css-pool.h   |   53 +
 drivers/media/pci/intel/ipu3/ipu3-css.c        | 2267 ++++++
 drivers/media/pci/intel/ipu3/ipu3-css.h        |  235 +
 drivers/media/pci/intel/ipu3/ipu3-dmamap.c     |  366 +
 drivers/media/pci/intel/ipu3/ipu3-dmamap.h     |   20 +
 drivers/media/pci/intel/ipu3/ipu3-mmu.c        |  422 ++
 drivers/media/pci/intel/ipu3/ipu3-mmu.h        |   73 +
 drivers/media/pci/intel/ipu3/ipu3-tables.c     | 9621 ++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-tables.h     |   82 +
 drivers/media/pci/intel/ipu3/ipu3-v4l2.c       |  727 ++
 drivers/media/pci/intel/ipu3/ipu3.c            |  740 ++
 drivers/media/pci/intel/ipu3/ipu3.h            |  183 +
 drivers/media/v4l2-core/v4l2-ioctl.c           |    4 +
 include/uapi/linux/intel-ipu3.h                | 2182 ++++++
 include/uapi/linux/videodev2.h                 |    6 +
 23 files changed, 22438 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-abi.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-params.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-params.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-v4l2.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3.h
 create mode 100644 include/uapi/linux/intel-ipu3.h

-- 
2.7.4
