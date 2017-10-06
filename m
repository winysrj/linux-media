Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51160 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752982AbdJFXjQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 19:39:16 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: hans.verkuil@cisco.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, hyungwoo.yang@intel.com,
        ramya.vijaykumar@intel.com, chiranjeevi.rapolu@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v5 0/3] [media] add IPU3 CIO2 CSI2 driver
Date: Fri,  6 Oct 2017 18:38:58 -0500
Message-Id: <1507333141-28242-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CIO2 driver exposes V4L2, V4L2 sub-device and Media controller interfaces
to the user space.

This series was tested on Kaby Lake based platform with 2 sensor configurations,
media topology was pasted at end for reference.

===========
= history =
===========

Version 5:
- cio2_vb2_start_streaming():
- cio2_vb2_stop_streaming(): removed redundant call of csi2 sub-dev for s_stream.
- cio2_vb2_buf_queue(): disabled interrupts for the duration of the buf queue,
  to prevent this code from being pre-empted, as suggested by Tomasz Figa,
  to mitigate the effects of race conditions around vb2 buf queuing code.
  Switched to a finite loop to check for the first free buffer and errored
  out, when there are no buffers available. Removed calls to vb2_plane_vaddr()
  Maintain correct buf queued count, in error cases.
- Implemented system sleep pm ops to support cio2 driver suspend/resume.
- Made the v4l2 buffer and SOF event use sequence from same source.
- cio2_vb2_queue_setup(): remove validating pixelformat suggested by Tomasz
  Figa.
- cio2_v4l2_g_fmt()/cio2_v4l2_s_fmt(): seperated formats on sub-dev and video
  device suggested by Sakari Ailus.
- cio2_v4l2_try_fmt(): seperated video node and subdev format in the get_fmt,
  try_fmt and set_fmt callbacks.
- cio2_queue_event_sof(): added comments suggested by Hans Verkuil
- cio2_queue_init(): re-ordered q->subdev_pads settings. remove 4 lines for
  quantization init.
- cio2_subdev_get_fmt(): get colorspace/xfer_func/ycbcr_enc/quantization
  from sensor suggested by Hans Verkuil.
- cio2_fbpt_entry_init_buf(): stored offset of the first sg_list entry to
  remove calls to vb2_plane_vaddr().
- cio2_subdev_open(): added new callback to intialize the try format.
- cio2_subdev_video_ops(): removed empty implementation suggested by Sakari Ailus.
- cio2_notifier_init(): added fwnode binding support for subdevices using
  v4l2_async_notifier_parse_fwnode_endpoints()
  Patch series v15 Unified fwnode endpoint parser, async sub-device notifier
  support, N9 flash DTS is needed for the fwnode binding code to compile.
  https://www.mail-archive.com/linux-media@vger.kernel.org/msg120239.html
  This also requires the following patch (v1) for the fwnode binding to work
  https://patchwork.kernel.org/patch/9986445/
- cio2_notifier_complete(): removed redundant call of
  fwnode_graph_get_remote_endpoint() and fwnode_graph_parse_endpoint().
- Switched to Multi Plane APIs suggested by Tomasz Figa.
  User space changes supporting multi plane APIs can be found here
  https://chromium-review.googlesource.com/c/chromiumos/platform/arc-camera/+/683802
- ipu3-cio.h: moved macros out of struct cio2_fbpt_entry suggested by Hans Verkuil.
- cio2_hw_mbus_to_mipicode(): replaced with cio2_find_format().
- cio2_pci_probe(): cleaned up goto logic on error conditions suggested by Tomasz Figa.
- Fixed v4l2_compliance test failures
  added 3 dummy function to pass v4l2_compliance test.
- Extended format example in pixfmt-srggb10-ipu3.rst to show DMA word boundary.

version 4:
- add cio2_video_link_validate() for video entity suggested by Sakari Ailus
- cio2_notifier_complete(): fix comments suggested by Sakari Ailus
- cio2_vb2_buf_queue(): fix the forever loop suggested by Tomasz Figa
- cio2_v4l2_querycap(): use vdev device_caps commented by Hans Verkuil
- cio2_vb2_buf_init(): allocate LOP table per page suggested by Tomasz Figa
- cio2_hw_init(): call cio2_csi2_calc_timing() earlier suggested by Tomasz Figa
- cio2_csi2_calc_timing(): add defalt settings for rx term/settle
- cio2_vb2_queue_setup(): remove num_planes checking suggested by Tomasz Figa
- cio2_buffer_done(): remove setting b->vbb.flags to V4L2_BUF_FLAG_DONE and
  memset of vbb.timecode, also move vb2_set_plane_payload() to
  cio2_vb2_buf_queue() suggested by Sakari Ailus
- cio2_queue_init(): export VB2_DMABUF io_modes suggested by Tomasz Figa
- cio2_vb2_return_all_buffers(): remove state from param list
  suggested by Tomasz Figa
- cio2_vb2_buf_queue(): use vb2_is_streaming() instead of
  vb2_start_streaming_called() suggested by Tomasz Figa
- cio2_pci_probe(): replace hard-coded linux driver version
  suggested by Hans Verkuil
- ipu3-cio2.h: re-order the reg macros suggested by Sakari Ailus
- ipu3-cio2.h: add inline vb2q_to_cio2_queue() suggested by Sakari Ailus
- ipu3-cio2.h: add comments for CIO2_INT_IOC suggested by Tomasz Figa
- ipu3-cio2.h: adjust PBM watermark threshold from 53 to 48 (internal bugfix)
- run v4l2_compliance suggested by Hans Verkuil

Todo list:

- fix possible racy code in cio2_vb2_buf_queue()
- fix v4l2_compliance test failure
- switch to v4l2_pix_format_mplane API if future needs arise

version 3:
- remove cio2_set_power().
- replace dma_alloc_noncoherent() with dma_alloc_coherent().
- apply ffs tricks at possible places.
- change sensor_vc to local variable.
- move ktime_get_ns() a little earlier in the calling order.
- fix multiple assignments(I.e a = b =c)
- define CIO2_PAGE_SIZE for CIO2 PAGE_SIZE, SENSOR_VIR_CH_DFLT for default sensor virtual ch.
- rework cio2_csi2_calc_timing().
- update v4l2 async subdev field name from match.fwnode.fwn
   to match.fwnode.fwnode.
- cherry-pick internal fix for triggering different irq on SOF and EOF.
- return -ENOMEM for vb2_dma_sg_plane_desc() in cio2_vb2_buf_init().
- add cio2_link_validate() placeholder for vdev.

version 2:
- remove all explicit DMA flush operations
- change dma_free_noncoherent() to dma_free_coherent()
- remove cio2_hw_mipi_lanes()
- replace v4l2_g_ext_ctrls() with v4l2_ctrl_g_ctrl()
  in cio2_csi2_calc_timing().
- use ffs() to iterate the port_status in cio2_irq()
- add static inline file_to_cio2_queue() function
- comment dma_wmb(), cio2_rx_timing() and few other places
- use ktime_get_ns() for vb2_buf.timestamp in cio2_buffer_done()
- use of SET_RUNTIME_PM_OPS() macro for cio2_pm_ops
- use BIT() macro for bit difinitions
- remove un-used macros such as CIO2_QUEUE_WIDTH() in ipu3-cio2.h
- move the MODULE_AUTHOR() to the end of the file
- change file path to drivers/media/pci/intel/ipu3

version 1:
- Initial submission

Media device topology:

localhost bin # ./media-ctl -d /dev/media0 -p
Media controller API version 4.14.0

Media device information
------------------------
driver          ipu3-cio2
model           Intel IPU3 CIO2
serial          
bus info        PCI:0000:00:14.3
hw revision     0x0
driver version  4.14.0

Device topology
- entity 1: ipu3-csi2:0 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
	pad0: Sink
		[fmt:SGRBG10_1X10/1936x1096 field:none]
		<- "ov5670 10-0036":0 []
	pad1: Source
		[fmt:SGRBG10_1X10/1936x1096 field:none]
		-> "ipu3-cio2:0":0 [ENABLED,IMMUTABLE]

- entity 4: ipu3-cio2:0 (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
	pad0: Sink
		<- "ipu3-csi2:0":1 [ENABLED,IMMUTABLE]

- entity 10: ipu3-csi2:1 (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev2
	pad0: Sink
		[fmt:SGRBG10_1X10/4224x3136 field:none]
		<- "ov13858 8-0010":0 [ENABLED]
	pad1: Source
		[fmt:SGRBG10_1X10/4224x3136 field:none]
		-> "ipu3-cio2:1":0 [ENABLED,IMMUTABLE]

- entity 13: ipu3-cio2:1 (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
	pad0: Sink
		<- "ipu3-csi2:1":1 [ENABLED,IMMUTABLE]

- entity 19: ov5670 10-0036 (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev3
	pad0: Source
		[fmt:SGRBG10_1X10/2592x1944 field:none]
		-> "ipu3-csi2:0":0 []

- entity 21: ov13858 8-0010 (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev4
	pad0: Source
		[fmt:SGRBG10_1X10/4224x3136 field:none]
		-> "ipu3-csi2:1":0 [ENABLED]

- entity 23: dw9714 8-000c (0 pad, 0 link)
             type V4L2 subdev subtype Lens flags 0
             device node name /dev/v4l-subdev5

v4l2-compliance test results:

localhost bin # ./v4l2-compliance -d /dev/video0     
v4l2-compliance SHA   : not available

Driver Info:
	Driver name   : ipu3-cio2
	Card type     : Intel IPU3 CIO2
	Bus info      : PCI:0000:00:14.3
	Driver version: 4.14.0
	Capabilities  : 0x84201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04201000
		Video Capture Multiplanar
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

Test input 0:

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

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

Note:

Running v4l2_compliance test with -f option will fail, we can only run
stream test with the help of media controller to link, configure and enable the
sub-dev/pads first.

Yong Zhi (3):
  videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
  doc-rst: add IPU3 raw10 bayer pixel format definitions
  intel-ipu3: cio2: Add new MIPI-CSI2 driver

 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |  166 ++
 drivers/media/pci/Kconfig                          |    2 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/intel/Makefile                   |    5 +
 drivers/media/pci/intel/ipu3/Kconfig               |   19 +
 drivers/media/pci/intel/ipu3/Makefile              |    1 +
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 2052 ++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  452 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
 include/uapi/linux/videodev2.h                     |    6 +
 11 files changed, 2710 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
 create mode 100644 drivers/media/pci/intel/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
 create mode 100644 drivers/media/pci/intel/ipu3/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h

-- 
2.7.4
