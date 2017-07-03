Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38813 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752479AbdGCLg7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 07:36:59 -0400
Subject: Re: [PATCH v2 00/19] Qualcomm 8x16 Camera Subsystem driver
To: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1848c19e-d953-3a1a-ae64-2559a022f17e@xs4all.nl>
Date: Mon, 3 Jul 2017 13:36:51 +0200
MIME-Version: 1.0
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2017 04:48 PM, Todor Tomov wrote:
> This patchset adds basic support for the Qualcomm Camera Subsystem found
> on Qualcomm MSM8916 and APQ8016 processors.
> 
> The driver implements V4L2, Media controller and V4L2 subdev interfaces.
> Camera sensor using V4L2 subdev interface in the kernel is supported.
> 
> The driver is implemented using as a reference the Qualcomm Camera
> Subsystem driver for Android as found in Code Aurora [1].
> 
> The driver is tested on Dragonboard 410C (APQ8016) with one and two
> OV5645 camera sensors. media-ctl [2] and yavta [3] applications were
> used for testing. Also Gstreamer 1.10.4 with v4l2src plugin is supported.
> 
> More information is present in the document added by the third patch.
> 
> -------------------------------------------------------------------------------
> 
> Patchset Changelog:
> 
> Version 2:
> - patches 01-10 are updated from v1 following the review received and bugs
>    and limitaitons found after v1 was posted. The updates include:
>    - return buffers on unsuccessful stream on;
>    - fill device capabilities in struct video_device;
>    - simplify v4l2 file handle usage - no custom struct for file handle;
>    - use vb2_fop_poll and vb2_fop_mmap v4l2 file operations;
>    - add support for read/write I/O;
>    - add support for DMABUF streaming I/O;
>    - add support for EXPBUF and PREPARE_BUF ioctl;
>    - avoid a race condition between device unbind and userspace access
>      to the video node;
>    - use non-contiguous memory for video buffers;
>    - switch to V4L2 multi-planar API;
>    - add useful error messages in case of an overflow in ISPIF;
>    - other small and style fixes.
> 
> - patches 11-19 are new (they were not ready/posted with v1). I'm including
>    these in this patchset as they add valuable features and may be desired
>    for a real world usage of the driver.
> 
> -------------------------------------------------------------------------------
> 
> The patchset depends on:
> v4l: Add packed Bayer raw12 pixel formats [4]
> 
> -------------------------------------------------------------------------------
> 
> V4L2 compliance test result:
> 
> $ v4l2-compliance -s -d /dev/video0
> v4l2-compliance SHA   : ce237eefc1f6dafafc0e1fe3a5fd9f075d3fd066
> 
> Driver Info:
>          Driver name   : qcom-camss
>          Card type     : Qualcomm Camera Subsystem
>          Bus info      : platform:1b0ac00.camss
>          Driver version: 4.9.27
>          Capabilities  : 0x85201000
>                  Video Capture Multiplanar
>                  Read/Write
>                  Streaming
>                  Extended Pix Format
>                  Device Capabilities
>          Device Caps   : 0x05201000
>                  Video Capture Multiplanar
>                  Read/Write
>                  Streaming
>                  Extended Pix Format
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
>          test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>          test second video open: OK
>          test VIDIOC_QUERYCAP: OK
>          test VIDIOC_G/S_PRIORITY: OK
>          test for unlimited opens: OK
> 
> Debug ioctls:
>          test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>          test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>          test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>          test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>          test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>          test VIDIOC_ENUMAUDIO: OK (Not Supported)
>          test VIDIOC_G/S/ENUMINPUT: OK
>          test VIDIOC_G/S_AUDIO: OK (Not Supported)
>          Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>          test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>          test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>          test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>          test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>          test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>          Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>          test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>          test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>          test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>          test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>          Control ioctls:
>                  test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>                  test VIDIOC_QUERYCTRL: OK (Not Supported)
>                  test VIDIOC_G/S_CTRL: OK (Not Supported)
>                  test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>                  test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>                  test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                  Standard Controls: 0 Private Controls: 0
> 
>          Format ioctls:
>                  test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                  test VIDIOC_G/S_PARM: OK (Not Supported)
>                  test VIDIOC_G_FBUF: OK (Not Supported)
>                  test VIDIOC_G_FMT: OK
>                  test VIDIOC_TRY_FMT: OK
>                  test VIDIOC_S_FMT: OK
>                  test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                  test Cropping: OK (Not Supported)
>                  test Composing: OK (Not Supported)
>                  test Scaling: OK (Not Supported)
> 
>          Codec ioctls:
>                  test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                  test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                  test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>          Buffer ioctls:
>                  test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                  test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Streaming ioctls:
>          test read/write: OK
>          test MMAP: OK
>          test USERPTR: OK (Not Supported)
>          test DMABUF: Cannot test, specify --expbuf-device
> 
> 
> Total: 46, Succeeded: 46, Failed: 0, Warnings: 0
> 
> -------------------------------------------------------------------------------
> 
> [1] https://source.codeaurora.org/quic/la/kernel/msm-3.10/
> [2] https://git.linuxtv.org//v4l-utils.git
> [3] http://git.ideasonboard.org/yavta.git
> [4] https://git.linuxtv.org/sailus/media_tree.git/commit/?h=packed12-postponed&id=549c02da6eed8dc4566632a9af9233bf99ba99d8
> 
> Todor Tomov (19):
>    doc: DT: camss: Binding document for Qualcomm Camera subsystem driver
>    MAINTAINERS: Add Qualcomm Camera subsystem driver
>    doc: media/v4l-drivers: Add Qualcomm Camera Subsystem driver document
>    media: camss: Add CSIPHY files
>    media: camss: Add CSID files
>    media: camss: Add ISPIF files
>    media: camss: Add VFE files
>    media: camss: Add files which handle the video device nodes
>    media: camms: Add core files
>    media: camss: Enable building
>    camss: vfe: Format conversion support using PIX interface
>    doc: media/v4l-drivers: Qualcomm Camera Subsystem - PIX Interface
>    camss: vfe: Support for frame padding
>    camss: vfe: Add interface for scaling
>    camss: vfe: Configure scaler module in VFE
>    camss: vfe: Add interface for cropping
>    camss: vfe: Configure crop module in VFE
>    doc: media/v4l-drivers: Qualcomm Camera Subsystem - Scale and crop
>    camss: Use optimal clock frequency rates
> 
>   .../devicetree/bindings/media/qcom,camss.txt       |  196 ++
>   Documentation/media/v4l-drivers/qcom_camss.rst     |  157 +
>   MAINTAINERS                                        |    8 +
>   drivers/media/platform/Kconfig                     |    6 +
>   drivers/media/platform/Makefile                    |    2 +
>   drivers/media/platform/qcom/camss-8x16/Makefile    |   11 +
>   drivers/media/platform/qcom/camss-8x16/camss.c     |  724 +++++
>   drivers/media/platform/qcom/camss-8x16/camss.h     |  105 +
>   drivers/media/platform/qcom/camss-8x16/csid.c      | 1141 ++++++++
>   drivers/media/platform/qcom/camss-8x16/csid.h      |   82 +
>   drivers/media/platform/qcom/camss-8x16/csiphy.c    |  821 ++++++
>   drivers/media/platform/qcom/camss-8x16/csiphy.h    |   77 +
>   drivers/media/platform/qcom/camss-8x16/ispif.c     | 1137 ++++++++
>   drivers/media/platform/qcom/camss-8x16/ispif.h     |   85 +
>   drivers/media/platform/qcom/camss-8x16/vfe.c       | 3046 ++++++++++++++++++++
>   drivers/media/platform/qcom/camss-8x16/vfe.h       |  123 +
>   drivers/media/platform/qcom/camss-8x16/video.c     |  842 ++++++
>   drivers/media/platform/qcom/camss-8x16/video.h     |   72 +

Can you add a 'camss-' prefix to these filenames? Except for the camss.c/h of
course :-)

It's good practice to make the filenames unique.

Thanks,

	Hans

>   18 files changed, 8635 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt
>   create mode 100644 Documentation/media/v4l-drivers/qcom_camss.rst
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/csid.c
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/csid.h
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/csiphy.c
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/csiphy.h
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/ispif.c
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/ispif.h
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/vfe.c
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/vfe.h
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h
> 
