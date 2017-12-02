Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54908 "EHLO mga11.intel.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751308AbdLBEc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 23:32:57 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hyungwoo.yang@intel.com, chiranjeevi.rapolu@intel.com,
        jerry.w.hu@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v5 00/12] Intel IPU3 ImgU patchset
Date: Fri,  1 Dec 2017 22:32:10 -0600
Message-Id: <1512189142-19863-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series adds support for the Intel IPU3 (Image Processing Unit)
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

The libraries for image processing inputs computation are provided
in patch 8.

Patch 9 implements all h/w related functions, patch 10 is of the same file which maps
v4l2 level operations to low level imaging pipeline programming using a simple
interface. The communication between firmware and host driver is implemented with
circular queues.

To access DDR via ImgU's own memory space, IPU3 is also equipped with
its own MMU unit, the driver is implemented in patch 3.

The original driver uses iommu_ops, in current version, however, the iommu
dependency was removed based on review, few new functions are added in v5 based on
drivers/iommu/iommu.c.

Patch 4 is the DMAMAP driver that calls above MMU driver directly.

Patch 5 implements buffer pool to support dynamic parameters, each pool is intialized
to contain a specific type of parameter structure.

Patch 6 manages IPU3 fw download and install using standard linux firmware API.

The firmware which is called ipu3-fw.bin can be downloaded from:

git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
(commit 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f)

Patch 7 supplies various default settings and tables for IPU3 programming.

Patch 11 is the v4l2 driver that exposes controls and device nodes, it currently
has a out-of-tree dependency on Sakari's V4L2_BUF_TYPE_META_OUTPUT work:

<URL:https://patchwork.kernel.org/patch/9976295/>

Patch 12 is the top level ImgU PCI device driver, it uses Kconfig and Makefile created
by IPU3 cio2 patch series.

Link to user space implementation:

<URL:https://chromium.googlesource.com/chromiumos/platform/arc-camera/+/master>

The IPU3 modules are tested on Kaby Lake based platform, the media topology and
v4l2 compliance results are posted at the end for reference.

===========
= history =
===========

version v5:
- ipu3-css-pool.c/ipu3_css_pool_check().
  add handling of the framenum wrap around case in ipu3_css_pool_check().
- ipu3.c, ipu3-v4l2.c, ipu3.h
  merge struct ipu3_mem2mem2_device into imgu_device and update the code
  accordingly. (Suggested by Sakari)
- ipu3-mmu.c driver:
  use __get_free_page() for page-aligned allocations (Tomasz).
  optimize tlb invalidation by calling them at the end of map/unmap. (Tomasz).
  remove dependency on iommu. (Sakari)
  introduce few new functions from iommu.c.
- ipu3-dmamap.c driver
  call mmu directly without IOMMU_SUPPORT (Sakari)
  update dmamap APIs. (Suggested by Tomasz)
- ipu3_v4l2.c
  move g/s_selection callback to V4l2 sub-device (Sakari)
  remove colon from ImgU sub-device name. (Sakari)
- ipu3-css-params.c
  fix indentation, 0-day scan warnings etc.
- ipu3-css.c
  fix warning about NULL comparison. (Sakari)
- intel-ipu3.h: 
  remove redundant IPU3_ALIGN attribute (Sakari).
  fix up un-needed fields in struct ipu3_uapi_params (Sakari)
  re-order this to be 2nd in the patch set.
- Makefile: remove Copyright header. (Sakari)
- Internal fix: 
  optimize shot-to-shot performance.
  update default white balance gains defined in ipu3-tables.c

TODOs:

- Documentation on ImgU driver programming interface to configure and enable
  ISP HW,  which will include details on complete V4L2 Kernel driver interface
  and IO-Control parameters, except for the ISP internal algorithm and its 
  parameters (which is Intel proprietary IP).

- Review ipu3_css_pool_* group APIs usage.

version 4:
- Used V4L2_BUF_TYPE_META_OUTPUT for:
    - V4L2_META_FMT_IPU3_STAT_PARAMS

- Used V4L2_BUF_TYPE_META_CAPTURE for:
    - V4L2_META_FMT_IPU3_STAT_3A
    - V4L2_META_FMT_IPU3_STAT_DVS
    - V4L2_META_FMT_IPU3_STAT_LACE
- Supported v4l2 MPLANE format on video nodes.
- ipu3-dmamap.c: Removed dma ops and dependencies on IOMMU_DMA lib.
- ipu3-mmu.c: Restructured the driver.
- intel-ipu3.h: Added __padding qualifier for uapi definitions.
- Internal fix: power and performance related issues.
- Fixed v4l2-compliance test.
- Fixed build failure for x86 with 32bit config.

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

Media topology

localhost bin # ./media-ctl -d /dev/media0 -p
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
- entity 1: ipu3-imgu (7 pads, 7 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
	pad0: Sink
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
		 crop:(0,0)/1920x1080
		 compose:(0,0)/1920x1080]
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

- entity 11: input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video0
	pad0: Source
		-> "ipu3-imgu":0 [ENABLED,IMMUTABLE]

- entity 17: parameters (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
	pad0: Source
		-> "ipu3-imgu":1 []

- entity 23: output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video2
	pad0: Sink
		<- "ipu3-imgu":2 []

- entity 29: viewfinder (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video3
	pad0: Sink
		<- "ipu3-imgu":3 []

- entity 35: postview (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video4
	pad0: Sink
		<- "ipu3-imgu":4 []

- entity 41: 3a stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Sink
		<- "ipu3-imgu":5 []

- entity 47: dvs stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Sink
		<- "ipu3-imgu":6 []

v4l2-compliance test for input node and 3A node:

localhost bin # ./v4l2-compliance -d /dev/video0                                
v4l2-compliance SHA   : f71ba5a1779ddb6a5a59562504dcf4fabf5c1de1

Driver Info:
	Driver name   : ipu3-imgu
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
localhost bin # ./v4l2-compliance -d /dev/video5                                
v4l2-compliance SHA   : f71ba5a1779ddb6a5a59562504dcf4fabf5c1de1

Driver Info:
	Driver name   : ipu3-imgu
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

Note:

Stream test with -f fails as pre-configuration of sub-devs is needed.

Tomasz Figa (2):
  intel-ipu3: mmu: Implement driver
  intel-ipu3: Implement DMA mapping functions

Yong Zhi (10):
  v4l: Add Intel IPU3 meta buffer formats
  intel-ipu3: Add user space ABI definitions
  intel-ipu3: css: Add dma buff pool utility functions
  intel-ipu3: css: Add support for firmware management
  intel-ipu3: css: Add static settings for image pipeline
  intel-ipu3: css: Compute and program ccs
  intel-ipu3: css: Enable css hardware setup
  intel-ipu3: Add css pipeline programming
  intel-ipu3: Add v4l2 driver based on media framework
  intel-ipu3: Add imgu top level pci device driver

 drivers/media/pci/intel/ipu3/Kconfig           |   30 +
 drivers/media/pci/intel/ipu3/Makefile          |   13 +
 drivers/media/pci/intel/ipu3/ipu3-abi.h        | 1579 ++++
 drivers/media/pci/intel/ipu3/ipu3-css-fw.c     |  271 +
 drivers/media/pci/intel/ipu3/ipu3-css-fw.h     |  212 +
 drivers/media/pci/intel/ipu3/ipu3-css-params.c | 3169 ++++++++
 drivers/media/pci/intel/ipu3/ipu3-css-params.h |   36 +
 drivers/media/pci/intel/ipu3/ipu3-css-pool.c   |  137 +
 drivers/media/pci/intel/ipu3/ipu3-css-pool.h   |   53 +
 drivers/media/pci/intel/ipu3/ipu3-css.c        | 2303 ++++++
 drivers/media/pci/intel/ipu3/ipu3-css.h        |  218 +
 drivers/media/pci/intel/ipu3/ipu3-dmamap.c     |  291 +
 drivers/media/pci/intel/ipu3/ipu3-dmamap.h     |   33 +
 drivers/media/pci/intel/ipu3/ipu3-mmu.c        |  581 ++
 drivers/media/pci/intel/ipu3/ipu3-mmu.h        |   39 +
 drivers/media/pci/intel/ipu3/ipu3-tables.c     | 9621 ++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-tables.h     |   82 +
 drivers/media/pci/intel/ipu3/ipu3-v4l2.c       | 1066 +++
 drivers/media/pci/intel/ipu3/ipu3.c            |  883 +++
 drivers/media/pci/intel/ipu3/ipu3.h            |  165 +
 drivers/media/v4l2-core/v4l2-ioctl.c           |    3 +
 include/uapi/linux/intel-ipu3.h                | 2196 ++++++
 include/uapi/linux/videodev2.h                 |    5 +
 23 files changed, 22986 insertions(+)
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
