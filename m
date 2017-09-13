Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:51115 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751258AbdIMPtk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 11:49:40 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8DFmSu6014915
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 16:49:39 +0100
Received: from mail-pg0-f72.google.com (mail-pg0-f72.google.com [74.125.83.72])
        by mx07-00252a01.pphosted.com with ESMTP id 2cv5pysy3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 16:49:38 +0100
Received: by mail-pg0-f72.google.com with SMTP id p5so855751pgn.7
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 08:49:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
References: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Wed, 13 Sep 2017 16:49:35 +0100
Message-ID: <CAAoAYcM6puYbYTzyjqzmOzMPQMDZRENZskbvwgqQsuEFDNAU6A@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] BCM283x Camera Receiver driver
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(dropping to linux-media and linux-rpi-kernel mailing lists as the
device tree folk aren't going to be bothered by v4l2-compliance
results)

v4l2-compliance results:

TC358743 (having loaded an EDID config)

v4l2-compliance SHA   : f6ecbc90656815d91dc6ba90aac0ad8193a14b38

Driver Info:
    Driver name   : unicam
    Card type     : unicam
    Bus info      : platform:unicam 3f801000.csi1
    Driver version: 4.13.0
    Capabilities  : 0x85200001
        Video Capture
        Read/Write
        Streaming
        Extended Pix Format
        Device Capabilities
    Device Caps   : 0x05200001
        Video Capture
        Read/Write
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
    test VIDIOC_LOG_STATUS: OK

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
    test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
    test VIDIOC_DV_TIMINGS_CAP: OK
    test VIDIOC_G/S_EDID: OK

Test input 0:

    Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
        test VIDIOC_G/S_CTRL: OK
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 3 Private Controls: 2

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
    test MMAP for Format RGB3, Frame Size 1920x1080:
        Stride 5760, Field None: OK
        Stride 5824, Field None: OK
    test MMAP for Format UYVY, Frame Size 1920x1080:
        Stride 3840, Field None: OK
        Stride 3904, Field None: OK

Total: 47, Succeeded: 47, Failed: 0, Warnings: 0

------
ADV7282-M
Minor hack required to select the first valid input (in my case
CVBS_AIN1). The hardware default is DIFF_CVBS_AIN1_AIN2.

v4l2-compliance SHA   : f6ecbc90656815d91dc6ba90aac0ad8193a14b38

Driver Info:
    Driver name   : unicam
    Card type     : unicam
    Bus info      : platform:unicam 3f801000.csi1
    Driver version: 4.13.0
    Capabilities  : 0x85200001
        Video Capture
        Read/Write
        Streaming
        Extended Pix Format
        Device Capabilities
    Device Caps   : 0x05200001
        Video Capture
        Read/Write
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
    test VIDIOC_LOG_STATUS: OK

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
    test VIDIOC_ENUM/G/S/QUERY_STD: OK
    test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
    test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
    test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

    Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
        test VIDIOC_G/S_CTRL: OK
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 5 Private Controls: 1

    Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
        test VIDIOC_G/S_PARM: OK
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
Retrieved std of 0000B000
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
        test VIDIOC_EXPBUF: OK

Test input 0:

Stream using all formats:
    test MMAP for Format UYVY, Frame Size 720x480:
        Stride 1440, Field None: OK
        Stride 1504, Field None: OK

Total: 45, Succeeded: 45, Failed: 0, Warnings: 0

-------
OV5647

v4l2-compliance SHA   : f6ecbc90656815d91dc6ba90aac0ad8193a14b38

Driver Info:
    Driver name   : unicam
    Card type     : unicam
    Bus info      : platform:unicam 3f801000.csi1
    Driver version: 4.13.0
    Capabilities  : 0x85200001
        Video Capture
        Read/Write
        Streaming
        Extended Pix Format
        Device Capabilities
    Device Caps   : 0x05200001
        Video Capture
        Read/Write
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
    test VIDIOC_LOG_STATUS: OK

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
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
        test VIDIOC_G/S_CTRL: OK
        fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not
support count == 0
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
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
    test MMAP for Format BA81, Frame Size 640x480:
        Stride 640, Field None: OK
        Stride 704, Field None: OK
    test MMAP for Format pBAA, Frame Size 640x480:
        Stride 800, Field None: OK
        Stride 864, Field None: OK
    test MMAP for Format BG12, Frame Size 640x480:
        Stride 960, Field None: OK
        Stride 1024, Field None: OK
    test MMAP for Format BYR2, Frame Size 640x480:
        Stride 1280, Field None: OK
        Stride 1344, Field None: OK

Total: 51, Succeeded: 50, Failed: 1, Warnings: 0


Hans previously requested the output of "v4l2-ctl -l" for this case:
pi@raspberrypi:~/v4l-utils/utils/v4l2-ctl $ ./v4l2-ctl -l
pi@raspberrypi:~/v4l-utils/utils/v4l2-ctl $
ie nothing - the sub device driver has no controls registered, and
that is what causes the failure:
        fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not
support count == 0
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
I don't know what the correct behaviour should be in those
circumstances, but it isn't really a failure of this driver.

  Dave

On 13 September 2017 at 16:07, Dave Stevenson
<dave.stevenson@raspberrypi.org> wrote:
> Hi All.
>
> This is v2 for adding a V4L2 subdevice driver for the CSI2/CCP2 camera
> receiver peripheral on BCM283x, as used on Raspberry Pi.
> Sorry for the delay since v1 - other tasks assigned, got sucked
> into investigating why some devices were misbehaving, and
> picking up on new features that had been added to the tree (eg CCP2).
>
> v4l2-compliance results depend on the sensor subdevice connected to.
> I have results for TC358743, ADV7282M, and OV5647 that I'll
> send them as a follow up email.
>
> OV647 and ADV7282M are now working with this driver, as well as TC358743.
> v1 of the driver only supported continuous clock mode which Unicam was
> failing to lock on to correctly.
> The driver now checks the clock mode and adjusts termination accordingly.
> Something is still a little off for OV5647, but I'll investigate that
> later.
>
> As per the v1 discussion with Hans, I have added text describing the
> differences between this driver and the one in staging/vc04_service.
> Addressing some of the issues in the bcm2835-camera driver is on my to-do
> list, and I'll add similar text there when I'm dealing with that.
>
> For those wanting to see the driver in context,
> https://github.com/6by9/upstream-linux/tree/unicam is the linux-media
> tree with my mods on top. It also includes a couple of TC358743 and
> OV5647 driver updates that I'll send to the list in the next few days.
>
> Thanks in advance.
>   Dave
>
> Changes from v1 to v2:
> - Broken out a new helper function v4l2_fourcc2s as requested by Hans.
> - Documented difference between this driver and the bcm2835-camera driver
>   in staging/vc04_services.
> - Corrected handling of s_dv_timings and s_std to update the current format
>   but only if not streaming. This refactored some of the s_fmt code to
>   remove duplication.
> - Updated handling of sizeimage to include vertical padding. (Not updated
>   the bytesperline calcs as the app can override).
> - Added support for continuous clock mode (requires changes to lane
>   termination configuration).
> - Add support for CCP2 as Sakari's patches to support it have now been merged.
>   I don't have a suitable sensor to test it with at present, but all settings
>   have been taken from a known working configuration. If people would prefer
>   I remove this until it has been proved against hardware then I'm happy to
>   do so.
> - Updated DT bindings to use <data-lanes> on the Unicam node to set the
>   maximum number of lanes present instead of a having a custom property.
>   Documents the mandatory endpoint properties.
> - Removed RAW16 from the list of input formats as it isn't defined in the
>   CSI-2 spec. The peripheral can still unpack the other Bayer formats to
>   a 16 bit/pixel packing though.
> - Added a log-status handler to get the status from the sensor.
> - Automatically switch away from any interlaced formats reported via g_fmt,
>   or that are attempted to be set via try/s_fmt.
> - Addressed other more minor code review comments from v1.
>
> Dave Stevenson (4):
>   [media] v4l2-common: Add helper function for fourcc to string
>   [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
>   [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface
>   MAINTAINERS: Add entry for BCM2835 camera driver
>
>  .../devicetree/bindings/media/bcm2835-unicam.txt   |  107 +
>  MAINTAINERS                                        |    7 +
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/bcm2835/Kconfig             |   14 +
>  drivers/media/platform/bcm2835/Makefile            |    3 +
>  drivers/media/platform/bcm2835/bcm2835-unicam.c    | 2192 ++++++++++++++++++++
>  drivers/media/platform/bcm2835/vc4-regs-unicam.h   |  264 +++
>  drivers/media/v4l2-core/v4l2-common.c              |   18 +
>  include/media/v4l2-common.h                        |    3 +
>  10 files changed, 2610 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>  create mode 100644 drivers/media/platform/bcm2835/Kconfig
>  create mode 100644 drivers/media/platform/bcm2835/Makefile
>  create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
>  create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h
>
> --
> 2.7.4
>
