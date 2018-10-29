Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:30516 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbeJ3HRz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 03:17:55 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date: Mon, 29 Oct 2018 15:22:54 -0700
Message-Id: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
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

The 3A statistics and other firmware parameter computation related
functions are implemented in patch 11.

All IPU3 pipeline default settings can be found in patch 10.

To access DDR via ImgU's own memory space, IPU3 is also equipped with
its own MMU unit, the driver is implemented in patch 6.

Patch 7 uses above driver for DMA mapping operation.

The communication between IPU3 firmware and driver is implemented with circular
queues in patch 8.

Patch 9 provide some utility functions and manage IPU3 fw download and
install.

The firmware which is called ipu3-fw.bin can be downloaded from:

git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
(commit 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f)

Firmware ABI is defined in patches 4 and 5.

Patches 12 and 13 are of the same file, the former contains all h/w programming
related code, the latter implements interface functions for access fw & hw
capabilities.

Patch 14 has a dependency on Sakari's V4L2_BUF_TYPE_META_OUTPUT work:

<URL:https://patchwork.kernel.org/patch/9976295/>

Patch 15 represents the top level that glues all of the other components together,
passing arguments between the components.

Patch 16 is a recent effort to extend v6 for advanced camera features like
Continuous View Finder (CVF) and Snapshot During Video(SDV) support.

Link to user space implementation:

git clone https://chromium.googlesource.com/chromiumos/platform/arc-camera

ImgU media topology print:

# media-ctl -d /dev/media0 -p
Media controller API version 4.19.0

Media device information
------------------------
driver          ipu3-imgu
model           ipu3-imgu
serial          
bus info        PCI:0000:00:05.0
hw revision     0x80862015
driver version  4.19.0

Device topology
- entity 1: ipu3-imgu 0 (5 pads, 5 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
	pad0: Sink
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
		 crop:(0,0)/1920x1080
		 compose:(0,0)/1920x1080]
		<- "ipu3-imgu 0 input":0 []
	pad1: Sink
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		<- "ipu3-imgu 0 parameters":0 []
	pad2: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "ipu3-imgu 0 output":0 []
	pad3: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "ipu3-imgu 0 viewfinder":0 []
	pad4: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "ipu3-imgu 0 3a stat":0 []

- entity 7: ipu3-imgu 1 (5 pads, 5 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
	pad0: Sink
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
		 crop:(0,0)/1920x1080
		 compose:(0,0)/1920x1080]
		<- "ipu3-imgu 1 input":0 []
	pad1: Sink
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		<- "ipu3-imgu 1 parameters":0 []
	pad2: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "ipu3-imgu 1 output":0 []
	pad3: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "ipu3-imgu 1 viewfinder":0 []
	pad4: Source
		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
		-> "ipu3-imgu 1 3a stat":0 []

- entity 17: ipu3-imgu 0 input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video0
	pad0: Source
		-> "ipu3-imgu 0":0 []

- entity 23: ipu3-imgu 0 parameters (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
	pad0: Source
		-> "ipu3-imgu 0":1 []

- entity 29: ipu3-imgu 0 output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video2
	pad0: Sink
		<- "ipu3-imgu 0":2 []

- entity 35: ipu3-imgu 0 viewfinder (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video3
	pad0: Sink
		<- "ipu3-imgu 0":3 []

- entity 41: ipu3-imgu 0 3a stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video4
	pad0: Sink
		<- "ipu3-imgu 0":4 []

- entity 47: ipu3-imgu 1 input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Source
		-> "ipu3-imgu 1":0 []

- entity 53: ipu3-imgu 1 parameters (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Source
		-> "ipu3-imgu 1":1 []

- entity 59: ipu3-imgu 1 output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video7
	pad0: Sink
		<- "ipu3-imgu 1":2 []

- entity 65: ipu3-imgu 1 viewfinder (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video8
	pad0: Sink
		<- "ipu3-imgu 1":3 []

- entity 71: ipu3-imgu 1 3a stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video9
	pad0: Sink
		<- "ipu3-imgu 1":4 []


v4l2-compliance utility is built with Sakari's patches for meta data
output support(rebased):

<URL:https://patchwork.linuxtv.org/patch/43370/>
<URL:https://patchwork.linuxtv.org/patch/43369/>

The test (v4l2-compliance -m 0) passes without error, outputs are appended at
the end of revision history.

Note:

1. Link pad flag of video nodes (i.e. ipu3-imgu 0 output) need to be enabled
   prior to the test.
2. Stream tests are not performed since it requires pre-configuration for each case.

===========
= history =
===========

v7 update:

1. Add driver and uAPI documentation.

Update based on v1 review from Tomasz, Hans, Sokari and Mauro:
https://patchwork.kernel.org/patch/10465663/
https://patchwork.kernel.org/patch/10465665/

2. Add dual pipe support which includes:
-  Extend current IMGU device to contain 2 subdevs and two groups of video nodes.
-  Add a v4l2 ctrl to allow user to specify the mode(video or still) of the pipe.

3. Kconfig
-  Restrict build for X86 arch to fix build error for ia64/sparc.
   (fatal error: asm/set_memory.h: No such file or directory)

4. ipu3-abi.h
-  Change __u32 to u32.
-  Use generic __attribute__((aligned(x))) format. (Mauro/Hans)
-  Split abi to 2 patches, one for register defines, enums, the other for structs. (Tomasz)

5. ipu3-mmu.c
-  Fix ipu3-mmu/dmamap exit functions. (Tomasz)
   (Port from https://chromium-review.googlesource.com/1084522)
-  Use free_page instead of kfree. (Tomasz)
-  document struct ipu3_mmu_info.
-  Fix copyright information.

6. ipu3-dmamap.c (Tomasz)
-  Update APIs based on v6 review.
-  Replace sizeof(struct page *) with sizeof(*pages).
-  Remove un-needed (WARN_ON(!dev)) inside void *ipu3_dmamap_alloc().

7. ipu3.c (Tomasz)
-  imgu_video_nodes_init()
   Fix the missing call to ipu3_v4l2_unregister() in the error path of
   imgu_dummybufs_preallocate().
-  imgu_queue_buffers()
   Evaluate loop condition explicitly for code clarity and simplicity.
   FW requires all output buffers to be queued at start, so adjust the order of
   buffer queuing accordingly. (bufix by Tianshu)
-  imgu_isr_threaded()
   Fix interrupt handler return value.
   (Port from https://chromium-review.googlesource.com/1088539)
-  Add back the buf_drain_wq from ("avoid sleep in wait_event condition")'
   (Port from https://chromium-review.googlesource.com/875420)

8. ipu3-v4l2.c
-  ipu3_v4l2_register(). (Tomasz)
   Split media initialization and registration, also change media device
   register/un-register order.

-  Fix v4l2-compliance fail on sub-devicef for VIDIOC_CREATE_BUFS and
   VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT.

9. ipu3-css.c, ipu3-css.h, ipu3-css-fw.h, ipu3-abi.h
-  Convert macros in structs to enums. (Tomasz)

10. ipu3-css-pool.c, ipu3-css-pool.h, ipu3.c
-   Document the structs. (Hans/Maruo)

11. ipu3-css-params.c
-   Fixup for noise reduction parameters processing. (bug fixing)

version 6:

- intel-ipu3.h uAPI
  Move out the definitions not used by user space. (suggested by Sakari)
- ipu3-abi.h, ipu3-css-fw.h
  Clean up the header files.
  Remove enum type from ABI structs.
- ipu3-css.h and ipu3-css.c
  Disable DVS support and remove related code.
- ipu3-v4l2.c
  Fixes of v4l2_compliance test fails on ImgU sub-dev.
- ipu3-css-params.c
  Refactor awb/awb_fr/af_ops_calc() functions. (Sakari)
- Build mmu and dmamap driver as part of ImgU ko module; (Sakari)
- Add "ipu3-imgu" prefix to media entity names; (Sakari)
- Fix indentation and white space; (Sakari)
- Rebase to kernel v4.16;
- Use SPDX license identifiers in all drivers; (Sakari)
- Internal fix and performance improvements such as:
  Stop fw gracefully during stream off.
  Enable irq only after start streaming to avoid unexpected interrupt.
  Use spinlock to protect IPU3_CSS_QUEUES access.
  Return NULL when dequeuing buffer before streaming.

TODOs:
- Documentation on ImgU driver programming interface to configure and enable
  ISP HW,  which will include details on complete V4L2 Kernel driver interface
  and IO-Control parameters, except for the ISP internal algorithm and its 
  parameters (which is Intel proprietary IP).

version 5:
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

--------------------------------------------------------------------------------

v4l2-compliance test output:

./v4l2-compliance -m 0

v4l2-compliance SHA: 7aa151889ffe89b1cd94a8198b0caba1a8c70398, 64 bits

Compliance test for device /dev/media0:

Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0

Required ioctls:
	test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
	test second /dev/media0 open: OK
	test MEDIA_IOC_DEVICE_INFO: OK
	test for unlimited opens: OK

Media Controller ioctls:
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 12 Interfaces: 12 Pads: 20 Links: 22
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/v4l-subdev0:

Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x0300000d
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000001 (1)
	Name             : ipu3-imgu 0
	Function         : Video Statistics
	Pad 0x01000002   : 0: Sink
	  Link 0x02000015: from remote pad 0x1000012 of entity 'ipu3-imgu 0 input': Data, Enabled
	Pad 0x01000003   : 1: Sink
	  Link 0x0200001b: from remote pad 0x1000018 of entity 'ipu3-imgu 0 parameters': Data
	Pad 0x01000004   : 2: Source
	  Link 0x02000021: to remote pad 0x100001e of entity 'ipu3-imgu 0 output': Data, Enabled
	Pad 0x01000005   : 3: Source
	  Link 0x02000027: to remote pad 0x1000024 of entity 'ipu3-imgu 0 viewfinder': Data, Enabled
	Pad 0x01000006   : 4: Source
	  Link 0x0200002d: to remote pad 0x100002a of entity 'ipu3-imgu 0 3a stat': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev0 open: OK
	test for unlimited opens: OK

Debug ioctls:
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

Sub-Device ioctls (Sink Pad 0):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Sink Pad 1):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 2):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 3):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 4):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 1 Private Controls: 1

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------
Compliance test for device /dev/v4l-subdev1:

Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x0300000f
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000007 (7)
	Name             : ipu3-imgu 1
	Function         : Video Statistics
	Pad 0x01000008   : 0: Sink
	  Link 0x02000033: from remote pad 0x1000030 of entity 'ipu3-imgu 1 input': Data, Enabled
	Pad 0x01000009   : 1: Sink
	  Link 0x02000039: from remote pad 0x1000036 of entity 'ipu3-imgu 1 parameters': Data
	Pad 0x0100000a   : 2: Source
	  Link 0x0200003f: to remote pad 0x100003c of entity 'ipu3-imgu 1 output': Data, Enabled
	Pad 0x0100000b   : 3: Source
	  Link 0x02000045: to remote pad 0x1000042 of entity 'ipu3-imgu 1 viewfinder': Data, Enabled
	Pad 0x0100000c   : 4: Source
	  Link 0x0200004b: to remote pad 0x1000048 of entity 'ipu3-imgu 1 3a stat': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev1 open: OK
	test for unlimited opens: OK

Debug ioctls:
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

Sub-Device ioctls (Sink Pad 0):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Sink Pad 1):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 2):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 3):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 4):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 1 Private Controls: 1

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------
Compliance test for device /dev/video0:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:input
	Driver version   : 4.19.0
	Capabilities     : 0x84202000
		Video Output Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04202000
		Video Output Multiplanar
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x03000013
	Type             : V4L Video
Entity Info:
	ID               : 0x00000011 (17)
	Name             : ipu3-imgu 0 input
	Function         : V4L2 I/O
	Pad 0x01000012   : 0: Source
	  Link 0x02000015: to remote pad 0x1000002 of entity 'ipu3-imgu 0': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video0 open: OK
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

Control ioctls (Output 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
	test VIDIOC_QUERYCTRL: OK (Not Supported)
	test VIDIOC_G/S_CTRL: OK (Not Supported)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls (Output 0):
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

Codec ioctls (Output 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Output 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video1:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:parameters
	Driver version   : 4.19.0
	Capabilities     : 0x8c200000
		Metadata Output
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x0c200000
		Metadata Output
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x03000019
	Type             : V4L Video
Entity Info:
	ID               : 0x00000017 (23)
	Name             : ipu3-imgu 0 parameters
	Function         : V4L2 I/O
	Pad 0x01000018   : 0: Source
	  Link 0x0200001b: to remote pad 0x1000003 of entity 'ipu3-imgu 0': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video1 open: OK
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

--------------------------------------------------------------------------------
Compliance test for device /dev/video2:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:output
	Driver version   : 4.19.0
	Capabilities     : 0x84201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x0300001f
	Type             : V4L Video
Entity Info:
	ID               : 0x0000001d (29)
	Name             : ipu3-imgu 0 output
	Function         : V4L2 I/O
	Pad 0x0100001e   : 0: Sink
	  Link 0x02000021: from remote pad 0x1000004 of entity 'ipu3-imgu 0': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video2 open: OK
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
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

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

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
	test VIDIOC_QUERYCTRL: OK (Not Supported)
	test VIDIOC_G/S_CTRL: OK (Not Supported)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls (Input 0):
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

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video3:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:viewfinder
	Driver version   : 4.19.0
	Capabilities     : 0x84201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x03000025
	Type             : V4L Video
Entity Info:
	ID               : 0x00000023 (35)
	Name             : ipu3-imgu 0 viewfinder
	Function         : V4L2 I/O
	Pad 0x01000024   : 0: Sink
	  Link 0x02000027: from remote pad 0x1000005 of entity 'ipu3-imgu 0': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video3 open: OK
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
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

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

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
	test VIDIOC_QUERYCTRL: OK (Not Supported)
	test VIDIOC_G/S_CTRL: OK (Not Supported)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls (Input 0):
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

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video4:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:3a stat
	Driver version   : 4.19.0
	Capabilities     : 0x84a00000
		Metadata Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04a00000
		Metadata Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x0300002b
	Type             : V4L Video
Entity Info:
	ID               : 0x00000029 (41)
	Name             : ipu3-imgu 0 3a stat
	Function         : V4L2 I/O
	Pad 0x0100002a   : 0: Sink
	  Link 0x0200002d: from remote pad 0x1000006 of entity 'ipu3-imgu 0': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video4 open: OK
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

--------------------------------------------------------------------------------
Compliance test for device /dev/video5:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:input
	Driver version   : 4.19.0
	Capabilities     : 0x84202000
		Video Output Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04202000
		Video Output Multiplanar
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x03000031
	Type             : V4L Video
Entity Info:
	ID               : 0x0000002f (47)
	Name             : ipu3-imgu 1 input
	Function         : V4L2 I/O
	Pad 0x01000030   : 0: Source
	  Link 0x02000033: to remote pad 0x1000008 of entity 'ipu3-imgu 1': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video5 open: OK
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

Control ioctls (Output 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
	test VIDIOC_QUERYCTRL: OK (Not Supported)
	test VIDIOC_G/S_CTRL: OK (Not Supported)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls (Output 0):
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

Codec ioctls (Output 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Output 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video6:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:parameters
	Driver version   : 4.19.0
	Capabilities     : 0x8c200000
		Metadata Output
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x0c200000
		Metadata Output
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x03000037
	Type             : V4L Video
Entity Info:
	ID               : 0x00000035 (53)
	Name             : ipu3-imgu 1 parameters
	Function         : V4L2 I/O
	Pad 0x01000036   : 0: Source
	  Link 0x02000039: to remote pad 0x1000009 of entity 'ipu3-imgu 1': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video6 open: OK
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

--------------------------------------------------------------------------------
Compliance test for device /dev/video7:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:output
	Driver version   : 4.19.0
	Capabilities     : 0x84201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x0300003d
	Type             : V4L Video
Entity Info:
	ID               : 0x0000003b (59)
	Name             : ipu3-imgu 1 output
	Function         : V4L2 I/O
	Pad 0x0100003c   : 0: Sink
	  Link 0x0200003f: from remote pad 0x100000a of entity 'ipu3-imgu 1': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video7 open: OK
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
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

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

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
	test VIDIOC_QUERYCTRL: OK (Not Supported)
	test VIDIOC_G/S_CTRL: OK (Not Supported)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls (Input 0):
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

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video8:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:viewfinder
	Driver version   : 4.19.0
	Capabilities     : 0x84201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x03000043
	Type             : V4L Video
Entity Info:
	ID               : 0x00000041 (65)
	Name             : ipu3-imgu 1 viewfinder
	Function         : V4L2 I/O
	Pad 0x01000042   : 0: Sink
	  Link 0x02000045: from remote pad 0x100000b of entity 'ipu3-imgu 1': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video8 open: OK
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
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

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

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
	test VIDIOC_QUERYCTRL: OK (Not Supported)
	test VIDIOC_G/S_CTRL: OK (Not Supported)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls (Input 0):
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

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video9:

Driver Info:
	Driver name      : ipu3-imgu
	Card type        : ipu3-imgu
	Bus info         : PCI:3a stat
	Driver version   : 4.19.0
	Capabilities     : 0x84a00000
		Metadata Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04a00000
		Metadata Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : ipu3-imgu
	Model            : ipu3-imgu
	Serial           : 
	Bus info         : PCI:0000:00:05.0
	Media version    : 4.19.0
	Hardware revision: 0x80862015 (2156273685)
	Driver version   : 4.19.0
Interface Info:
	ID               : 0x03000049
	Type             : V4L Video
Entity Info:
	ID               : 0x00000047 (71)
	Name             : ipu3-imgu 1 3a stat
	Function         : V4L2 I/O
	Pad 0x01000048   : 0: Sink
	  Link 0x0200004b: from remote pad 0x100000c of entity 'ipu3-imgu 1': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video9 open: OK
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

Total: 597, Succeeded: 597, Failed: 0, Warnings: 0

--------------------------------------------------------------------------------

Thanks,

Yong

Cao,Bing Bu (1):
  intel-ipu3: add dual pipe support

Rajmohan Mani (1):
  doc-rst: Add Intel IPU3 documentation

Tomasz Figa (2):
  intel-ipu3: mmu: Implement driver
  intel-ipu3: Implement DMA mapping functions

Yong Zhi (12):
  v4l: Add Intel IPU3 meta buffer formats
  v4l: Add Intel IPU3 meta data uAPI
  intel-ipu3: abi: Add register definitions and enum
  intel-ipu3: abi: Add structs
  intel-ipu3: css: Add dma buff pool utility functions
  intel-ipu3: css: Add support for firmware management
  intel-ipu3: css: Add static settings for image pipeline
  intel-ipu3: css: Compute and program ccs
  intel-ipu3: css: Initialize css hardware
  intel-ipu3: Add css pipeline programming
  intel-ipu3: Add v4l2 driver based on media framework
  intel-ipu3: Add imgu top level pci device driver

 Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
 .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  181 +
 Documentation/media/v4l-drivers/index.rst          |    1 +
 Documentation/media/v4l-drivers/ipu3.rst           |  326 +
 drivers/media/pci/intel/ipu3/Kconfig               |   16 +
 drivers/media/pci/intel/ipu3/Makefile              |   12 +
 drivers/media/pci/intel/ipu3/ipu3-abi.h            | 2011 ++++
 drivers/media/pci/intel/ipu3/ipu3-css-fw.c         |  265 +
 drivers/media/pci/intel/ipu3/ipu3-css-fw.h         |  188 +
 drivers/media/pci/intel/ipu3/ipu3-css-params.c     | 2936 ++++++
 drivers/media/pci/intel/ipu3/ipu3-css-params.h     |   28 +
 drivers/media/pci/intel/ipu3/ipu3-css-pool.c       |  136 +
 drivers/media/pci/intel/ipu3/ipu3-css-pool.h       |   56 +
 drivers/media/pci/intel/ipu3/ipu3-css.c            | 2407 +++++
 drivers/media/pci/intel/ipu3/ipu3-css.h            |  215 +
 drivers/media/pci/intel/ipu3/ipu3-dmamap.c         |  270 +
 drivers/media/pci/intel/ipu3/ipu3-dmamap.h         |   22 +
 drivers/media/pci/intel/ipu3/ipu3-mmu.c            |  560 ++
 drivers/media/pci/intel/ipu3/ipu3-mmu.h            |   35 +
 drivers/media/pci/intel/ipu3/ipu3-tables.c         | 9609 ++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-tables.h         |   66 +
 drivers/media/pci/intel/ipu3/ipu3-v4l2.c           | 1436 +++
 drivers/media/pci/intel/ipu3/ipu3.c                |  830 ++
 drivers/media/pci/intel/ipu3/ipu3.h                |  169 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
 include/uapi/linux/intel-ipu3.h                    | 2827 ++++++
 include/uapi/linux/videodev2.h                     |    4 +
 27 files changed, 24609 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
 create mode 100644 Documentation/media/v4l-drivers/ipu3.rst
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
