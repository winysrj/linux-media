Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F71C65BAF
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 01:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 346E0208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 01:03:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 346E0208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbeLGBDy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 20:03:54 -0500
Received: from mga04.intel.com ([192.55.52.120]:47492 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbeLGBDy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 20:03:54 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2018 17:03:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,324,1539673200"; 
   d="scan'208";a="127821822"
Received: from twiley-mobl.amr.corp.intel.com (HELO yzhi-desktop.amr.corp.intel.com) ([10.254.183.51])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2018 17:03:52 -0800
From:   Yong Zhi <yong.zhi@intel.com>
To:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc:     tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com,
        tian.shu.qiu@intel.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, mchehab@kernel.org, bingbu.cao@intel.com,
        jian.xu.zheng@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v8 00/17] Intel IPU3 ImgU patchset
Date:   Thu,  6 Dec 2018 19:03:25 -0600
Message-Id: <1544144622-29791-1-git-send-email-yong.zhi@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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
functions are implemented in patch 8.

All IPU3 pipeline default settings can be found in patch 7.

To access DDR via ImgU's own memory space, IPU3 is also equipped with
its own MMU unit, the driver is implemented in patch 3.

Patch 4 uses above driver for DMA mapping operation.

The communication between IPU3 firmware and driver is implemented with circular
queues in patch 5.

Patch 6 provide some utility functions and manage IPU3 fw download and
install.

The firmware which is called ipu3-fw.bin can be downloaded from:

git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
(commit 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f)

Firmware ABI is defined in patches 1 and 2.

Patches 9 and 10 are of the same file, the former contains all h/w programming
related code, the latter implements interface functions for access fw & hw
capabilities.

Patch 11 implements a v4l2 media framework driver.

Patch 12 represents the top level that glues all of the other components together,
passing arguments between the components.

Patch 14 is a recent effort to extend v6 for advanced camera features like
Continuous View Finder (CVF) and Snapshot During Video(SDV) support.

The whole series has a dependency on Sakari's work:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=meta-output>

Patches not to be merged with staging:

Patch 15 Add v4l IPU3 meta formats.
Patch 16 Reserve v4l2 controls for IPU3 ImgU driver.
Patch 17 Documentation of ImgU driver.

Link to user space implementation:

git clone https://chromium.googlesource.com/chromiumos/platform/arc-camera

ImgU media topology print:

# media-ctl -d /dev/media0 -p
Media controller API version 4.20.0

Media device information
------------------------
driver          ipu3-imgu
model           ipu3-imgu
serial          
bus info        PCI:0000:00:05.0
hw revision     0x80862015
driver version  4.20.0

Device topology
- entity 1: ipu3-imgu 0 (5 pads, 5 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
	pad0: Sink
		[fmt:FIXED/1920x1080 field:none colorspace:raw
		 crop:(0,0)/1920x1080
		 compose:(0,0)/1920x1080]
		<- "ipu3-imgu 0 input":0 []
	pad1: Sink
		[fmt:FIXED/1920x1080 field:none colorspace:raw]
		<- "ipu3-imgu 0 parameters":0 []
	pad2: Source
		[fmt:FIXED/1920x1080 field:none colorspace:raw]
		-> "ipu3-imgu 0 output":0 []
	pad3: Source
		[fmt:FIXED/1920x1080 field:none colorspace:raw]
		-> "ipu3-imgu 0 viewfinder":0 []
	pad4: Source
		[fmt:FIXED/1920x1080 field:none colorspace:raw]
		-> "ipu3-imgu 0 3a stat":0 []

- entity 7: ipu3-imgu 0 input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
	pad0: Source
		-> "ipu3-imgu 0":0 []

- entity 13: ipu3-imgu 0 parameters (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
	pad0: Source
		-> "ipu3-imgu 0":1 []

- entity 19: ipu3-imgu 0 output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video2
	pad0: Sink
		<- "ipu3-imgu 0":2 []

- entity 25: ipu3-imgu 0 viewfinder (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video3
	pad0: Sink
		<- "ipu3-imgu 0":3 []

- entity 31: ipu3-imgu 0 3a stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video4
	pad0: Sink
		<- "ipu3-imgu 0":4 []

- entity 37: ipu3-imgu 1 (5 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev1
	pad0: Sink
		[fmt:FIXED/1920x1080 field:none colorspace:raw
		 crop:(0,0)/1920x1080
		 compose:(0,0)/1920x1080]
		<- "ipu3-imgu 1 input":0 []
	pad1: Sink
		[fmt:FIXED/1920x1080 field:none colorspace:raw]
		<- "ipu3-imgu 1 parameters":0 []
	pad2: Source
		[fmt:FIXED/1920x1080 field:none colorspace:raw]
		-> "ipu3-imgu 1 output":0 []
	pad3: Source
		[fmt:FIXED/1920x1080 field:none colorspace:raw]
		-> "ipu3-imgu 1 viewfinder":0 []
	pad4: Source
		[fmt:FIXED/1920x1080 field:none colorspace:raw]
		-> "ipu3-imgu 1 3a stat":0 []

- entity 43: ipu3-imgu 1 input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Source
		-> "ipu3-imgu 1":0 []

- entity 49: ipu3-imgu 1 parameters (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Source
		-> "ipu3-imgu 1":1 []

- entity 55: ipu3-imgu 1 output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video7
	pad0: Sink
		<- "ipu3-imgu 1":2 []

- entity 61: ipu3-imgu 1 viewfinder (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video8
	pad0: Sink
		<- "ipu3-imgu 1":3 []

- entity 67: ipu3-imgu 1 3a stat (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video9
	pad0: Sink
		<- "ipu3-imgu 1":4 []

v4l2-compliance utility is built with Sakari's patches for meta data
output support(rebased):

<URL:https://patchwork.linuxtv.org/patch/43370/>
<URL:https://patchwork.linuxtv.org/patch/43369/>

The test (v4l2-compliance -m 0) results are the same as v7, so the output are
omitted here.

Note:

1. Link pad flag of video nodes (i.e. ipu3-imgu 0 output) need to be enabled
   prior to the test.
2. Stream tests are not performed since it requires pre-configuration for each case.

===========
= history =
===========

version 8:

1. ipu3-abi.h
- Replace all __attribute__((aligned(n))) wth __aligned(n).
- Replace all __reserved to reserved.

2. ipu3-v4l2.c
- Create each pipe followed by its video nodes to make device topology
  easier to read.
- Update ipu3_subdev_open() to use default values to initialize pad config's
  try_fmt, similarly add default compose rect for pad config's try_compose.
- Change ipu3-imgu bus format code to MEDIA_BUS_FMT_FIXED as it's not
  configurable.
- Use static allocation for struct imgu_v4l2_subdev.subdev_pads.
- Remove EXPORT_SYMBOL_GPL() which is of no use after v5.
- Prefix public api with imgu, i.e. change ipu3_v4l2_register() to
  imgu_v4l2_register().

3. ipu3-css-pool.c, ipu3-css-pool.h
- Simplify the logic for ipu3_css_pool_get().
- Use u32 instead of long at ipu3_css_pool.last.
- Replace ipu3_css_pool.entry[].framenum with a flag to mark whether the entry
  has valid data.

4. ipu3-css-params.c
- Address kernel panic on css ouput system error path.

5. Misc style related changes:
- Remove unused member of struct imgu_video_device.
- Use ipu3_uapi_stats_3a to compute the CSS_QUEUE_STAT_3A_BUF_SIZE.
- Change video4linux2 to Video4Linux2 in Kconfig.
- Replace strlcpy() with strscpy() at all places.

6. uAPI and documentation.
- Remove acronyms from intel-ipu3.h
- Renaming all __reserved fields to reserved.
- Fix typo such as  _plain_color.
- Direct use struct for meta_data.
- Fix unclear or incorrect data type, range in the description.

7. Move driver code to /driver/staging/media/ipu3/
- Temporarily move intel-ipu3.h to ipu3/include.
- Temporarily add V4L2_META_FMT_IPU3_PARAMS and V4L2_META_FMT_IPU3_STAT_3A
  to intel-ipu3.h for staging build.

8. Regroup and re-order the patchset.
- Make uAPI intel-ipu3.h as separate patch.
- Add single patch to reserve v4l2 controls for ImgU driver.

version 7:

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

Cao,Bing Bu (2):
  media: staging/intel-ipu3: Add dual pipe support
  media: v4l2-ctrls: Reserve controls for IPU3 ImgU

Rajmohan Mani (1):
  doc-rst: Add Intel IPU3 documentation

Tomasz Figa (2):
  media: staging/intel-ipu3: mmu: Implement driver
  media: staging/intel-ipu3: Implement DMA mapping functions

Yong Zhi (12):
  media: staging/intel-ipu3: abi: Add register definitions and enum
  media: staging/intel-ipu3: abi: Add structs
  media: staging/intel-ipu3: css: Add dma buff pool utility functions
  media: staging/intel-ipu3: css: Add support for firmware management
  media: staging/intel-ipu3: css: Add static settings for image pipeline
  media: staging/intel-ipu3: css: Compute and program ccs
  media: staging/intel-ipu3: css: Initialize css hardware
  media: staging/intel-ipu3: Add css pipeline programming
  media: staging/intel-ipu3: Add v4l2 driver based on media framework
  media: staging/intel-ipu3: Add imgu top level pci device driver
  media: staging/intel-ipu3: Add Intel IPU3 meta data uAPI
  media: v4l: Add Intel IPU3 meta buffer formats

 Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
 .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  178 +
 Documentation/media/v4l-drivers/index.rst          |    1 +
 Documentation/media/v4l-drivers/ipu3.rst           |  326 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/ipu3/Kconfig                 |   14 +
 drivers/staging/media/ipu3/Makefile                |   11 +
 drivers/staging/media/ipu3/TODO                    |   23 +
 drivers/staging/media/ipu3/include/intel-ipu3.h    | 2785 ++++++
 drivers/staging/media/ipu3/ipu3-abi.h              | 2011 ++++
 drivers/staging/media/ipu3/ipu3-css-fw.c           |  265 +
 drivers/staging/media/ipu3/ipu3-css-fw.h           |  188 +
 drivers/staging/media/ipu3/ipu3-css-params.c       | 2943 ++++++
 drivers/staging/media/ipu3/ipu3-css-params.h       |   28 +
 drivers/staging/media/ipu3/ipu3-css-pool.c         |  100 +
 drivers/staging/media/ipu3/ipu3-css-pool.h         |   55 +
 drivers/staging/media/ipu3/ipu3-css.c              | 2391 +++++
 drivers/staging/media/ipu3/ipu3-css.h              |  213 +
 drivers/staging/media/ipu3/ipu3-dmamap.c           |  270 +
 drivers/staging/media/ipu3/ipu3-dmamap.h           |   22 +
 drivers/staging/media/ipu3/ipu3-mmu.c              |  561 ++
 drivers/staging/media/ipu3/ipu3-mmu.h              |   35 +
 drivers/staging/media/ipu3/ipu3-tables.c           | 9609 ++++++++++++++++++++
 drivers/staging/media/ipu3/ipu3-tables.h           |   66 +
 drivers/staging/media/ipu3/ipu3-v4l2.c             | 1419 +++
 drivers/staging/media/ipu3/ipu3.c                  |  830 ++
 drivers/staging/media/ipu3/ipu3.h                  |  168 +
 include/uapi/linux/v4l2-controls.h                 |    4 +
 include/uapi/linux/videodev2.h                     |    4 +
 31 files changed, 24526 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
 create mode 100644 Documentation/media/v4l-drivers/ipu3.rst
 create mode 100644 drivers/staging/media/ipu3/Kconfig
 create mode 100644 drivers/staging/media/ipu3/Makefile
 create mode 100644 drivers/staging/media/ipu3/TODO
 create mode 100644 drivers/staging/media/ipu3/include/intel-ipu3.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-abi.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-fw.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-fw.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-params.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-params.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-pool.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-pool.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-css.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-dmamap.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-dmamap.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-mmu.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-mmu.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-tables.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-tables.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-v4l2.c
 create mode 100644 drivers/staging/media/ipu3/ipu3.c
 create mode 100644 drivers/staging/media/ipu3/ipu3.h

-- 
2.7.4

