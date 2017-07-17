Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:36025 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751279AbdGQKfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 06:35:00 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 00/23] Qualcomm 8x16 Camera Subsystem driver
Date: Mon, 17 Jul 2017 13:33:26 +0300
Message-Id: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds basic support for the Qualcomm Camera Subsystem found
on Qualcomm MSM8916 and APQ8016 processors.

The driver implements V4L2, Media controller and V4L2 subdev interfaces.
Camera sensor using V4L2 subdev interface in the kernel is supported.

The driver is implemented using as a reference the Qualcomm Camera
Subsystem driver for Android as found in Code Aurora [1].

The driver is tested on Dragonboard 410C (APQ8016) with one and two
OV5645 camera sensors. media-ctl [2] and yavta [3] applications were
used for testing. Also Gstreamer 1.10.4 with v4l2src plugin is supported.

More information is present in the document added by the third patch.

[1] https://source.codeaurora.org/quic/la/kernel/msm-3.10/
[2] https://git.linuxtv.org//v4l-utils.git
[3] http://git.ideasonboard.org/yavta.git

-------------------------------------------------------------------------------

Patchset Changelog:

Version 3:
- use V4L2 fwnode framework;
- remove settle count parameter from DT and add logic to calculate it instead;
- refactor video device node format initialization;
- fixed copyright information;
- shorter clock names;
- remove redundant memset usage;
- print error code when error happens;
- do not check format type on g_fmt/s_fmt;
- add busy check on s_fmt;
- rename files to add camss- prefix;
- other small code fixes.

Version 2:
- patches 01-10 are updated from v1 following the review received and bugs
  and limitaitons found after v1 was posted. The updates include:
  - return buffers on unsuccessful stream on;
  - fill device capabilities in struct video_device;
  - simplify v4l2 file handle usage - no custom struct for file handle;
  - use vb2_fop_poll and vb2_fop_mmap v4l2 file operations;
  - add support for read/write I/O;
  - add support for DMABUF streaming I/O;
  - add support for EXPBUF and PREPARE_BUF ioctl;
  - avoid a race condition between device unbind and userspace access
    to the video node;
  - use non-contiguous memory for video buffers;
  - switch to V4L2 multi-planar API;
  - add useful error messages in case of an overflow in ISPIF;
  - other small and style fixes.

- patches 11-19 are new (they were not ready/posted with v1). I'm including
  these in this patchset as they add valuable features and may be desired
  for a real world usage of the driver.

-------------------------------------------------------------------------------

The driver depends on patches:
- [media] media: Make parameter of media_entity_remote_pad() const
- [media] v4l2-mediabus: Add helper functions
- v4l: Add packed Bayer raw12 pixel formats 

They are included in this patchset to ensure successful compilation.

-------------------------------------------------------------------------------

V4L2 compliance test result:

$ v4l2-compliance -d /dev/video1 -s
v4l2-compliance SHA   : 8e68406dae2233e811032dc8e7714c09c818e893

Driver Info:
        Driver name   : qcom-camss
        Card type     : Qualcomm Camera Subsystem
        Bus info      : platform:1b0ac00.camss
        Driver version: 4.9.34
        Capabilities  : 0x85201000
                Video Capture Multiplanar
                Read/Write
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x05201000
                Video Capture Multiplanar
                Read/Write
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
                test Scaling: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:

Streaming ioctls:
        test read/write: OK
        test MMAP: OK                                     
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device


Total: 46, Succeeded: 46, Failed: 0, Warnings: 0 

-------------------------------------------------------------------------------

Sakari Ailus (1):
  v4l: Add packed Bayer raw12 pixel formats

Todor Tomov (22):
  [media] media: Make parameter of media_entity_remote_pad() const
  [media] v4l2-mediabus: Add helper functions
  dt-bindings: media: Binding document for Qualcomm Camera subsystem
    driver
  MAINTAINERS: Add Qualcomm Camera subsystem driver
  doc: media/v4l-drivers: Add Qualcomm Camera Subsystem driver document
  media: camss: Add CSIPHY files
  media: camss: Add CSID files
  media: camss: Add ISPIF files
  media: camss: Add VFE files
  media: camss: Add files which handle the video device nodes
  media: camms: Add core files
  media: camss: Enable building
  camss: vfe: Format conversion support using PIX interface
  doc: media/v4l-drivers: Qualcomm Camera Subsystem - PIX Interface
  camss: vfe: Support for frame padding
  camss: vfe: Add interface for scaling
  camss: vfe: Configure scaler module in VFE
  camss: vfe: Add interface for cropping
  camss: vfe: Configure crop module in VFE
  doc: media/v4l-drivers: Qualcomm Camera Subsystem - Scale and crop
  camss: Use optimal clock frequency rates
  doc: media/v4l-drivers: Qualcomm Camera Subsystem - Media graph

 .../devicetree/bindings/media/qcom,camss.txt       |  191 ++
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst   |  104 +
 Documentation/media/v4l-drivers/qcom_camss.rst     |  150 +
 .../media/v4l-drivers/qcom_camss_graph.dot         |   41 +
 MAINTAINERS                                        |    8 +
 drivers/media/media-entity.c                       |    2 +-
 drivers/media/platform/Kconfig                     |    7 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/qcom/camss-8x16/Makefile    |   11 +
 .../media/platform/qcom/camss-8x16/camss-csid.c    | 1181 ++++++++
 .../media/platform/qcom/camss-8x16/camss-csid.h    |   82 +
 .../media/platform/qcom/camss-8x16/camss-csiphy.c  |  882 ++++++
 .../media/platform/qcom/camss-8x16/camss-csiphy.h  |   77 +
 .../media/platform/qcom/camss-8x16/camss-ispif.c   | 1138 ++++++++
 .../media/platform/qcom/camss-8x16/camss-ispif.h   |   85 +
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 3069 ++++++++++++++++++++
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  123 +
 .../media/platform/qcom/camss-8x16/camss-video.c   |  842 ++++++
 .../media/platform/qcom/camss-8x16/camss-video.h   |   74 +
 drivers/media/platform/qcom/camss-8x16/camss.c     |  736 +++++
 drivers/media/platform/qcom/camss-8x16/camss.h     |  108 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   12 +-
 include/media/media-entity.h                       |    2 +-
 include/media/v4l2-mediabus.h                      |   26 +
 include/uapi/linux/videodev2.h                     |    5 +
 26 files changed, 8953 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss.rst
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss_graph.dot
 create mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csid.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csid.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-ispif.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-ispif.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-video.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-video.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h

-- 
2.7.4
