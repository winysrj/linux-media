Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13183 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755112AbdGJXno (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 19:43:44 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: hans.verkuil@cisco.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, hyungwoo.yang@intel.com,
        ramya.vijaykumar@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v4 0/3] [media] add IPU3 CIO2 CSI2 driver
Date: Mon, 10 Jul 2017 18:43:31 -0500
Message-Id: <1499730214-9005-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds the driver for the CIO2 device found in some
Skylake and Kaby Lake SoCs. The CIO2 consists of four D-PHY receivers.

The CIO2 driver exposes V4L2, V4L2 sub-device and Media controller
interfaces to the user space.

This series was tested on Kaby Lake based platform with 2 sensor
configurations, media topology was pasted at end for reference.

===========
= history =
===========

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
- define CIO2_PAGE_SIZE for CIO2 PAGE_SIZE, SENSOR_VIR_CH_DFLT
for default sensor virtual ch.
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

v4l2-compliance test results:

./v4l2-compliance -f
v4l2-compliance SHA   : 1ae9a7adea3766879935dfede90d5aefd954c786

Driver Info:
        Driver name   : ipu3-cio2
        Card type     : Intel IPU3 CIO2
        Bus info      : PCI:0000:00:14.3
        Driver version: 4.12.0
        Capabilities  : 0x84200001
                Video Capture
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04200001
                Video Capture
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
                fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
        test VIDIOC_G/S/ENUMINPUT: FAIL
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

Stream using all formats:
        test MMAP for Format ip3r, Frame Size 1920x1080:
                Stride 2496, Field None: OK
        test MMAP for Format ip3g, Frame Size 1920x1080:
                Stride 2496, Field None: OK
        test MMAP for Format ip3G, Frame Size 1920x1080:
                Stride 2496, Field None: OK
        test MMAP for Format ip3b, Frame Size 1920x1080:
                Stride 2496, Field None: OK

Total: 47, Succeeded: 46, Failed: 1, Warnings: 0

localhost root # ./v4l2-compliance -d /dev/video1
v4l2-compliance SHA   : 1ae9a7adea3766879935dfede90d5aefd954c786

Driver Info:
        Driver name   : ipu3-cio2
        Card type     : Intel IPU3 CIO2
        Bus info      : PCI:0000:00:14.3
        Driver version: 4.12.0
        Capabilities  : 0x84200001
                Video Capture
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04200001
                Video Capture
                Streaming
                Extended Pix Format

Compliance test for device /dev/video1 (not using libv4l2):

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
                fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
        test VIDIOC_G/S/ENUMINPUT: FAIL
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


Total: 43, Succeeded: 42, Failed: 1, Warnings: 0

./tools/media-ctl -d /dev/media0 -p
Media controller API version 0.1.0

Media device information
------------------------
driver          ipu3-cio2
model           Intel IPU3 CIO2
serial          
bus info        PCI:0000:00:14.3
hw revision     0x0
driver version  4.12.0

Device topology
- entity 1: ipu3-csi2:0 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
        pad0:Sink
                stream:0[fmt:SGRBG10/1920x1080]
                link: 
                <- "ov13850 binner 8-0010":1 [ENABLED]
        pad1:Source
                stream:0[fmt:SGRBG10/1920x1080]
                link: 
                -> "ipu3-cio2:0":0 [ENABLED,IMMUTABLE]

- entity 4: ipu3-cio2:0 (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0:Sink
                link: 
                <- "ipu3-csi2:0":1 [ENABLED,IMMUTABLE]

- entity 10: ipu3-csi2:1 (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev2
        pad0:Sink
                stream:0[fmt:SRGGB10/1936x1096]
                link: 
                <- "ov5670 11-0010":0 []
        pad1:Source
                stream:0[fmt:SRGGB10/1936x1096]
                link: 
                -> "ipu3-cio2:1":0 [ENABLED,IMMUTABLE]

- entity 13: ipu3-cio2:1 (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
        pad0:Sink
                link: 
                <- "ipu3-csi2:1":1 [ENABLED,IMMUTABLE]

- entity 19: ov13850 binner 8-0010 (2 pads, 2 links)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev4
        pad0:Sink
                stream:0[fmt:SGRBG10/4224x3136]

                 compose.bounds:(0,0)/4224x3136
                 compose:(0,0)/1920x1080                link: 
                <- "ov13850 pixel array 8-0010":0 [ENABLED,IMMUTABLE]
        pad1:Source
                stream:0[fmt:SGRBG10/1920x1080]
                link: 
                -> "ipu3-csi2:0":0 [ENABLED]

- entity 22: ov13850 pixel array 8-0010 (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev3
        pad0:Source
                stream:0[fmt:SGRBG10/4224x3136]

                 crop.bounds:(0,0)/4224x3136
                 crop:(0,0)/4224x3136           link: 
                -> "ov13850 binner 8-0010":0 [ENABLED,IMMUTABLE]

- entity 26: ov5670 11-0010 (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev5
        pad0:Source
                stream:0[fmt:SGRBG10/648x486]
                link: 
                -> "ipu3-csi2:1":0 []

Yong Zhi (3):
  videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
  doc-rst: add IPU3 raw10 bayer pixel format definitions
  intel-ipu3: cio2: Add new MIPI-CSI2 driver

 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |   62 +
 drivers/media/pci/Kconfig                          |    2 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/intel/Makefile                   |    5 +
 drivers/media/pci/intel/ipu3/Kconfig               |   17 +
 drivers/media/pci/intel/ipu3/Makefile              |    1 +
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 1873 ++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  442 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
 include/uapi/linux/videodev2.h                     |    5 +
 11 files changed, 2414 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
 create mode 100644 drivers/media/pci/intel/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
 create mode 100644 drivers/media/pci/intel/ipu3/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h

--
2.7.4
