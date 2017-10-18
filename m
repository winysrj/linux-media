Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:3258 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdJRDrD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 23:47:03 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com, arnd@arndb.de,
        hch@lst.de, robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v4 00/12] Intel IPU3 ImgU patchset
Date: Tue, 17 Oct 2017 22:46:48 -0500
Message-Id: <1508298408-25822-1-git-send-email-yong.zhi@intel.com>
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

Currently, the MMU driver has dependency on two exported symbols
(iommu_group_ref_get and iommu_group_get_for_dev))to build as ko.

Patch 3 uses above IOMMU driver for DMA mem related functions.

Patch 5-10 are basically IPU3 CSS specific implementations:

6 and 7 provide some utility functions and manage IPU3 fw download and
install.

The firmware which is called ipu3-fw.bin can be downloaded from:

git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
(commit 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f)

Patch 9 and 10 are of the same file, the latter implements interface
functions for access fw & hw capabilities defined in patch 8.

Patch 11 has a dependency on Sakari's V4L2_BUF_TYPE_META_OUTPUT work:

<URL:https://patchwork.kernel.org/patch/9976293/>
<URL:https://patchwork.kernel.org/patch/9976295/>

Patch 12 uses Kconfig and Makefile created by IPU3 cio2 patch series.

Link to user space implementation:

<URL:https://chromium.googlesource.com/chromiumos/platform/arc-camera/+/master>

Device topology:

./media-ctl -d /dev/media0 -p                                                   
Media controller API version 4.14.0

Media device information
------------------------
driver          ipu3-imgu
model           ipu3-imgu
serial          
bus info        0000:00:05.0
hw revision     0x0
driver version  4.14.0

Device topology
- entity 1: ipu3-imgu:0 (8 pads, 8 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
	pad0: Sink
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		<- "input":0 [ENABLED,IMMUTABLE]
	pad1: Sink
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		<- "parameters":0 []
	pad2: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "output":0 []
	pad3: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "viewfinder":0 []
	pad4: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "postview":0 []
	pad5: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "3a stat":0 []
	pad6: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "dvs stat":0 []
	pad7: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "lace stat":0 []

- entity 12: input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video0
	pad0: Source
		-> "ipu3-imgu:0":0 [ENABLED,IMMUTABLE]

- entity 18: parameters (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
	pad0: Source
		-> "ipu3-imgu:0":1 []

- entity 24: output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video2
	pad0: Sink
		<- "ipu3-imgu:0":2 []

- entity 30: viewfinder (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video3
	pad0: Sink
		<- "ipu3-imgu:0":3 []

- entity 36: postview (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video4
	pad0: Sink
		<- "ipu3-imgu:0":4 []

- entity 42: 3a stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Sink
		<- "ipu3-imgu:0":5 []

- entity 48: dvs stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Sink
		<- "ipu3-imgu:0":6 []

- entity 54: lace stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video7
	pad0: Sink
		<- "ipu3-imgu:0":7 []


Sample test results on input and 3A video nodes:

localhost # ./v4l2-compliance -d /dev/video0                                    
v4l2-compliance SHA   : f71ba5a1779ddb6a5a59562504dcf4fabf5c1de1

Driver Info:
	Driver name   : ipu3-imgu:0
	Card type     : ipu3-imgu
	Bus info      : PCI:input
	Driver version: 4.14.0
	Capabilities  : 0x84202000
		Video Output Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04202000
		Video Output Multiplanar
		Streaming
		Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 1 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test output 0:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
		test VIDIOC_QUERYCTRL: OK (Not Supported)
		test VIDIOC_G/S_CTRL: OK (Not Supported)
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 0 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test output 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

localhost # ./v4l2-compliance -d /dev/video5                                    
v4l2-compliance SHA   : f71ba5a1779ddb6a5a59562504dcf4fabf5c1de1

Driver Info:
	Driver name   : ipu3-imgu:0
	Card type     : ipu3-imgu
	Bus info      : PCI:3a stat
	Driver version: 4.14.0
	Capabilities  : 0x84A00000
		Metadata Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04A00000
		Metadata Capture
		Streaming
		Extended Pix Format

Compliance test for device /dev/video5 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
		test VIDIOC_QUERYCTRL: OK (Not Supported)
		test VIDIOC_G/S_CTRL: OK (Not Supported)
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 0 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

Note: stream test with -f fails as pre-configuration of sub-devs is required.

===========
= history =
===========

version 4:
- Used V4L2_BUF_TYPE_META_OUTPUT for:
    - V4L2_META_FMT_IPU3_STAT_PARAMS
- Used V4L2_BUF_TYPE_META_CAPTURE for:
    - V4L2_META_FMT_IPU3_STAT_3A
    - V4L2_META_FMT_IPU3_STAT_DVS
    - V4L2_META_FMT_IPU3_STAT_LACE
- Supported v4l2 MPLANE format on video nodes.
- ipu3-dmamap.c: Removed dma ops and dependencies on IOMMU_DMA lib.
- ipu3-mmu.c: Re-structured the driver:
  Removed dependencies on linux/dma-iommu.h
  Add dev and dma_dev to struct ipu3_mmu to faciliate the dma_map_ops-less way of
  binding between mmu, dmamap and ipu3 driver.
  Addressed MMU review comments of v3.
  Removed cache flush via setting page table as un-cache for improved performance.
- intel-ipu3.h: Added __padding qualifier for uapi definitions.
- Internal fix: power and performance related issues.
- Fixed v4l2-compliance test failures on video and meta nodes.
- Fixed build failure for x86 with 32bit config.
- Fixed checkpatch.pl errors/warnings/checks.

version 3:
- ipu3-mmu.c and ipu3-dmamap.c:
  Tomasz Figa reworked both drivers and updated related files.
- ipu2-abi.h:
  update imgu_abi_binary_info ABI to support latest ipu3-fw.bin.
  use __packed qualifier on structs suggested by Sakari Ailus.
- ipu3-css-fw.c/ipu3-css-fw.h: following fix were suggested by Tomasz Figa:
  remove pointer type in firmware blob structs.
  fix binary_header array in struct imgu_fw_header.
  fix calling ipu3_css_fw_show_binary() before proper checking.
  fix logic error for valid length checking of blob name.
- ipu3-css-params.c/ipu3_css_scaler_get_exp():
  use lib helper suggested by Andy Shevchenko.
- ipu3-v4l2.c/ipu3_videoc_querycap():
  fill device_caps fix suggested by Hans Verkuil.
  add VB2_DMABUF suggested by Tomasz Figa.
- ipu3-css.c: increase IMGU freq from 300MHZ to 450MHZ (internal fix)
- ipu3.c: use vb2_dma_sg_memop for the time being(internal fix).

version 2:
This version cherry-picked firmware ABI change and other
fix in order to bring the code up-to-date with our internal release.

I will go over the review comments in v1 and address them in v3 and
future update.

version 1:
- Initial submission

Tomasz Figa (2):
  intel-ipu3: Add mmu driver
  intel-ipu3: Add IOMMU based dmamap support

Yong Zhi (10):
  videodev2.h, v4l2-ioctl: add IPU3 meta buffer format
  intel-ipu3: Add user space ABI definitions
  intel-ipu3: css: tables
  intel-ipu3: css: imgu dma buff pool
  intel-ipu3: css: firmware management
  intel-ipu3: params: compute and program ccs
  intel-ipu3: css hardware setup
  intel-ipu3: css pipeline
  intel-ipu3: Add imgu v4l2 driver
  intel-ipu3: imgu top level pci device

 drivers/media/pci/intel/ipu3/Kconfig           |   33 +
 drivers/media/pci/intel/ipu3/Makefile          |   21 +
 drivers/media/pci/intel/ipu3/ipu3-abi.h        | 1579 ++++
 drivers/media/pci/intel/ipu3/ipu3-css-fw.c     |  270 +
 drivers/media/pci/intel/ipu3/ipu3-css-fw.h     |  206 +
 drivers/media/pci/intel/ipu3/ipu3-css-params.c | 3161 ++++++++
 drivers/media/pci/intel/ipu3/ipu3-css-params.h |  105 +
 drivers/media/pci/intel/ipu3/ipu3-css-pool.c   |  132 +
 drivers/media/pci/intel/ipu3/ipu3-css-pool.h   |   54 +
 drivers/media/pci/intel/ipu3/ipu3-css.c        | 2278 ++++++
 drivers/media/pci/intel/ipu3/ipu3-css.h        |  225 +
 drivers/media/pci/intel/ipu3/ipu3-dmamap.c     |  342 +
 drivers/media/pci/intel/ipu3/ipu3-dmamap.h     |   33 +
 drivers/media/pci/intel/ipu3/ipu3-mmu.c        |  580 ++
 drivers/media/pci/intel/ipu3/ipu3-mmu.h        |   26 +
 drivers/media/pci/intel/ipu3/ipu3-tables.c     | 9621 ++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-tables.h     |   82 +
 drivers/media/pci/intel/ipu3/ipu3-v4l2.c       | 1150 +++
 drivers/media/pci/intel/ipu3/ipu3.c            |  882 +++
 drivers/media/pci/intel/ipu3/ipu3.h            |  186 +
 drivers/media/v4l2-core/v4l2-ioctl.c           |    4 +
 include/uapi/linux/intel-ipu3.h                | 2199 ++++++
 include/uapi/linux/videodev2.h                 |    6 +
 23 files changed, 23175 insertions(+)
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
