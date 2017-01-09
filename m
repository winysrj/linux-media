Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34971 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938904AbdAINSd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 08:18:33 -0500
Received: by mail-wm0-f42.google.com with SMTP id a197so97852482wmd.0
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2017 05:18:32 -0800 (PST)
Subject: Re: [PATCH 00/10] Qualcomm 8x16 Camera Subsystem driver
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        javier@osg.samsung.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1480085793-28193-1-git-send-email-todor.tomov@linaro.org>
 <1a19217d-74b4-e3f5-4ab6-dc15360b1fe1@xs4all.nl>
Cc: bjorn.andersson@linaro.org, srinivas.kandagatla@linaro.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <58738DA4.8050209@linaro.org>
Date: Mon, 9 Jan 2017 15:18:28 +0200
MIME-Version: 1.0
In-Reply-To: <1a19217d-74b4-e3f5-4ab6-dc15360b1fe1@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 01/09/2017 03:08 PM, Hans Verkuil wrote:
> Hi Todor,
> 
> What is the status of this patch series? There were comments for patch 1/10 and 8/10,
> and I haven't seen a v2 of this patch series.

And Happy new year!

I'm just starting today for the new year and this is the first thing to do - go over the comments received.
I'll reply for each of them.
Thank you for your notification and the also for the review done!

Best regards,
Todor

> 
> Regards,
> 
> 	Hans
> 
> On 11/25/2016 03:56 PM, Todor Tomov wrote:
>> This patchset adds basic support for the Qualcomm Camera Subsystem found
>> on Qualcomm MSM8916 and APQ8016 processors.
>>
>> The driver implements V4L2, Media controller and V4L2 subdev interfaces.
>> Camera sensor using V4L2 subdev interface in the kernel is supported.
>>
>> The driver is implemented using as a reference the Qualcomm Camera
>> Subsystem driver for Android as found in Code Aurora [1].
>>
>> The driver supports raw dump of the input data to memory. ISP processing
>> is not supported.
>>
>> The driver is tested on Dragonboard 410C (APQ8016) with one and two
>> OV5645 camera sensors. media-ctl [2] and yavta [3] applications were
>> used for testing. Also Gstreamer 1.4.4 with v4l2src plugin is supported.
>>
>> More information is present in the document added by the third patch.
>>
>>
>> The patchset depends on:
>> v4l: Add packed Bayer raw12 pixel formats [4]
>> media: venus: enable building of Venus video codec driver [5]
>>
>>
>> V4L2 compliance test result:
>>
>> root@linaro-alip:~/v4l-utils/utils/v4l2-compliance# ./v4l2-compliance -s -d /dev/video0
>> v4l2-compliance SHA   : 6a760145f1a6809591a1cb17ee1b06913e4fddd1
>>
>> Driver Info:
>>         Driver name   : qcom-camss
>>         Card type     : Qualcomm Camera Subsystem
>>         Bus info      : platform:qcom-camss
>>         Driver version: 4.9.0
>>         Capabilities  : 0x84200001
>>                 Video Capture
>>                 Streaming
>>                 Extended Pix Format
>>                 Device Capabilities
>>         Device Caps   : 0x04200001
>>                 Video Capture
>>                 Streaming
>>                 Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>>         test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>         test second video open: OK
>>         test VIDIOC_QUERYCAP: OK
>>         test VIDIOC_G/S_PRIORITY: OK
>>         test for unlimited opens: OK
>>
>> Debug ioctls:
>>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>         test VIDIOC_LOG_STATUS: OK (Not Supported)
>>
>> Input ioctls:
>>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>         test VIDIOC_G/S/ENUMINPUT: OK
>>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>         Inputs: 1 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>         Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>         test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>> Test input 0:
>>
>>         Control ioctls:
>>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>>                 test VIDIOC_QUERYCTRL: OK (Not Supported)
>>                 test VIDIOC_G/S_CTRL: OK (Not Supported)
>>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>                 Standard Controls: 0 Private Controls: 0
>>
>>         Format ioctls:
>>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>>                 test VIDIOC_G_FBUF: OK (Not Supported)
>>                 test VIDIOC_G_FMT: OK
>>                 test VIDIOC_TRY_FMT: OK
>>                 test VIDIOC_S_FMT: OK
>>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>                 test Cropping: OK (Not Supported)
>>                 test Composing: OK (Not Supported)
>>                 test Scaling: OK (Not Supported)
>>
>>         Codec ioctls:
>>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>>         Buffer ioctls:
>>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>                 test VIDIOC_EXPBUF: OK (Not Supported)
>>
>> Test input 0:
>>
>> Streaming ioctls:
>>         test read/write: OK (Not Supported)
>>         test MMAP: OK                                     
>>         test USERPTR: OK (Not Supported)
>>         test DMABUF: OK (Not Supported)
>>
>>
>> Total: 47, Succeeded: 47, Failed: 0, Warnings: 0
>>
>>
>> [1] https://source.codeaurora.org/quic/la/kernel/msm-3.10/
>> [2] https://git.linuxtv.org//v4l-utils.git
>> [3] http://git.ideasonboard.org/yavta.git
>> [4] http://www.spinics.net/lists/linux-media/msg107494.html
>> [5] http://www.spinics.net/lists/linux-media/msg104013.html
>>
>>
>> Todor Tomov (10):
>>   doc: DT: camss: Binding document for Qualcomm Camera subsystem driver
>>   MAINTAINERS: Add Qualcomm Camera subsystem driver
>>   doc: media/v4l-drivers: Add Qualcomm Camera Subsystem driver document
>>   media: camss: Add CSIPHY files
>>   media: camss: Add CSID files
>>   media: camss: Add ISPIF files
>>   media: camss: Add VFE files
>>   media: camss: Add files which handle the video device nodes
>>   media: camms: Add core files
>>   media: camss: Add Makefiles and Kconfig files
>>
>>  .../devicetree/bindings/media/qcom,camss.txt       |  196 ++
>>  Documentation/media/v4l-drivers/index.rst          |    1 +
>>  Documentation/media/v4l-drivers/qcom_camss.rst     |  124 ++
>>  MAINTAINERS                                        |    8 +
>>  drivers/media/platform/qcom/Kconfig                |    5 +
>>  drivers/media/platform/qcom/Makefile               |    1 +
>>  drivers/media/platform/qcom/camss-8x16/Makefile    |   12 +
>>  drivers/media/platform/qcom/camss-8x16/camss.c     |  603 +++++++
>>  drivers/media/platform/qcom/camss-8x16/camss.h     |   93 +
>>  drivers/media/platform/qcom/camss-8x16/csid.c      | 1071 +++++++++++
>>  drivers/media/platform/qcom/camss-8x16/csid.h      |   82 +
>>  drivers/media/platform/qcom/camss-8x16/csiphy.c    |  685 +++++++
>>  drivers/media/platform/qcom/camss-8x16/csiphy.h    |   77 +
>>  drivers/media/platform/qcom/camss-8x16/ispif.c     | 1105 ++++++++++++
>>  drivers/media/platform/qcom/camss-8x16/ispif.h     |   85 +
>>  drivers/media/platform/qcom/camss-8x16/vfe.c       | 1877 ++++++++++++++++++++
>>  drivers/media/platform/qcom/camss-8x16/vfe.h       |  112 ++
>>  drivers/media/platform/qcom/camss-8x16/video.c     |  597 +++++++
>>  drivers/media/platform/qcom/camss-8x16/video.h     |   67 +
>>  19 files changed, 6801 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt
>>  create mode 100644 Documentation/media/v4l-drivers/qcom_camss.rst
>>  create mode 100644 drivers/media/platform/qcom/Kconfig
>>  create mode 100644 drivers/media/platform/qcom/Makefile
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/csid.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/csid.h
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/csiphy.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/csiphy.h
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/ispif.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/ispif.h
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/vfe.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/vfe.h
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h
>>
> 

-- 
Best regards,
Todor Tomov
