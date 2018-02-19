Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:41647 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbeBSRGf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 12:06:35 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 00/11] Renesas Capture Engine Unit (CEU) V4L2 driver
Date: Mon, 19 Feb 2018 17:59:33 +0100
Message-Id: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   finally I addressed Laurent's comment on ov772x frame rate handling, which
I almost forgot about :)

Also, Sergei reported that the ceu node name should be generic, so I changed it
to "ceu: camera@e8210000".

All patches but the trivial [11/11] one are now reviewed/acked. Hope this is
last iteration for CEU!

Series based on top of Hans':
[PATCHv2 0/9] media: replace g/s_parm by g/s_frame_interval
and makes use of newly introduced v4l2_g/s_parm_cap() functions from v4l2-common
in CEU's g/s_parm() callbacks.

A branch for testing is available at:
git://jmondi.org/linux ceu/media-tree-parm/v9
with few patches for Migo-R and GR-Peach applied on top of Hans' media-tree/parm
branch.

------------------------------------------------------------------------------
Copying from v7 cover letter:

The 2 new patches in the series:
[11/11] has been added to silence a v4l2-compliance error, and modifies
ov7670 driver to set all fields of 'struct v4l2_mbus_format' during set_format
operation, including ycbcr_enc, quantization and xfer_func. As the patch commit
reports, this suppresses the following v4l2-compliance error:
fail: v4l2-test-formats.cpp(335): ycbcr_enc >= 0xff
v8/v9: Did the same for ov772x

[7/11] has been required by Hans to add frame interval handling to ov772x
driver. As this is quite a big change I kept it in a separate patch to ease
review, it can eventually be squashed on [6/11] if accepted.
v8: Calculate PLL divider/multiplier in place of using static tables.
v9: Address Laurent's comment on frame rate handling patch

If for TW9910 video decoder the same is required (frame interval handling) I'm
in favour of moving that driver to staging as it was proposed for ov772x before
this series.

------------------------------------------------------------------------------
v4l2-compliance:

v4l2-compliance requires a fix to relax buffer type check on s/g_parm
(see Hans' "[PATCHv2 9/9] vidioc-g-parm.rst: also allow _MPLANE buffer types")
Issue is addressed by patch
"[PATCH] v4l2-compliance: Relax g/s_parm type check"
just sent to linux-media mailing list.

With that fixed, I have v4l2-compliance exhausting my tiny GR-Peach 6MB of
available system, and thus failing when allocating buffers to test "Buffer
IOCTLs":

renesas-ceu e8210000.camera: dma_alloc_coherent of size 307200 failed
Unable to request buffers: Cannot allocate memory (12).

Also, Hans, you asked me to run v4l2-compliance with the -f option, I cannot do
that on my tiny GR-Peach as with its limited available system memory it cannot
allocate the number of requested buffers for that test.
I won't stress here why I cannot do that on Migo-R, long story short: I need a
special compiler with DSP support to run anything but the little
initramfs I have received for SH7722. I've been able to tweak yavta to work and
test capture and frame rate handling with it, but v4l2-compliance is much more
complex and I don't think I'll be able run it on that platform.

I have verified capture still works properly in all supported image formats.
Below v4l2-compliance output, with 2 errors due to memory constraints on my
test platform. Hope this won't cause issues with ceu driver acceptance now
that we're so close to have it finalized :)

------------------------------------------------------------------------------
v4l2-compliance SHA   : 372109e86a4de045c642a808fc97b2e7ca5e6c93

Driver Info:
        Driver name   : renesas-ceu
        Card type     : Renesas CEU
        Bus info      : platform:renesas-ceu-e8210000.c
        Driver version: 4.15.0
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
        test VIDIOC_DBG_G/S_REGISTER: OK
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
                info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
                info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
                info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
                info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
                info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
                info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
                info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
                info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
                info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
                info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
                info: checking v4l2_queryctrl of control 'Camera Controls' (0x009a0001)
                info: checking v4l2_queryctrl of control 'Auto Exposure' (0x009a0901)
                info: checking v4l2_queryctrl of control 'Image Processing Controls' (0x009f0001)
                info: checking v4l2_queryctrl of control 'Test Pattern' (0x009f0903)
                info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
                info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
                info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
                info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
                info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
                info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
                info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
                info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
                info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                info: checking control 'User Controls' (0x00980001)
                info: checking control 'Brightness' (0x00980900)
                info: checking control 'Contrast' (0x00980901)
                info: checking control 'Saturation' (0x00980902)
                info: checking control 'Hue' (0x00980903)
                info: checking control 'Exposure' (0x00980911)
                info: checking control 'Gain, Automatic' (0x00980912)
                info: checking control 'Gain' (0x00980913)
                info: checking control 'Horizontal Flip' (0x00980914)
                info: checking control 'Vertical Flip' (0x00980915)
                info: checking control 'Camera Controls' (0x009a0001)
                info: checking control 'Auto Exposure' (0x009a0901)
                info: checking control 'Image Processing Controls' (0x009f0001)
                info: checking control 'Test Pattern' (0x009f0903)
                test VIDIOC_G/S_CTRL: OK
                info: checking extended control 'User Controls' (0x00980001)
                info: checking extended control 'Brightness' (0x00980900)
                info: checking extended control 'Contrast' (0x00980901)
                info: checking extended control 'Saturation' (0x00980902)
                info: checking extended control 'Hue' (0x00980903)
                info: checking extended control 'Exposure' (0x00980911)
                info: checking extended control 'Gain, Automatic' (0x00980912)
                info: checking extended control 'Gain' (0x00980913)
                info: checking extended control 'Horizontal Flip' (0x00980914)
                info: checking extended control 'Vertical Flip' (0x00980915)
                info: checking extended control 'Camera Controls' (0x009a0001)
                info: checking extended control 'Auto Exposure' (0x009a0901)
                info: checking extended control 'Image Processing Controls' (0x009f0001)
                info: checking extended control 'Test Pattern' (0x009f0903)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                info: checking control event 'User Controls' (0x00980001)
                info: checking control event 'Brightness' (0x00980900)
                info: checking control event 'Contrast' (0x00980901)
                info: checking control event 'Saturation' (0x00980902)
                info: checking control event 'Hue' (0x00980903)
                info: checking control event 'Exposure' (0x00980911)
                info: checking control event 'Gain, Automatic' (0x00980912)
                info: checking control event 'Gain' (0x00980913)
                info: checking control event 'Horizontal Flip' (0x00980914)
                info: checking control event 'Vertical Flip' (0x00980915)
                info: checking control event 'Camera Controls' (0x009a0001)
                info: checking control event 'Auto Exposure' (0x009a0901)
                info: checking control event 'Image Processing Controls' (0x009f0001)
                info: checking control event 'Test Pattern' (0x009f0903)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 14 Private Controls: 0

        Format ioctls:
                info: found 5 frameintervals for pixel format 3631564e (NV16) and size 640x480
                info: found 5 frameintervals for pixel format 3631564e (NV16) and size 352x288
                info: found 5 frameintervals for pixel format 3631564e (NV16) and size 320x240
                info: found 5 frameintervals for pixel format 3631564e (NV16) and size 176x144
                info: found 4 framesizes for pixel format 3631564e (NV16)
                info: found 5 frameintervals for pixel format 3136564e (NV61) and size 640x480
                info: found 5 frameintervals for pixel format 3136564e (NV61) and size 352x288
                info: found 5 frameintervals for pixel format 3136564e (NV61) and size 320x240
                info: found 5 frameintervals for pixel format 3136564e (NV61) and size 176x144
                info: found 4 framesizes for pixel format 3136564e (NV61)
                info: found 5 frameintervals for pixel format 3231564e (NV12) and size 640x480
                info: found 5 frameintervals for pixel format 3231564e (NV12) and size 352x288
                info: found 5 frameintervals for pixel format 3231564e (NV12) and size 320x240
                info: found 5 frameintervals for pixel format 3231564e (NV12) and size 176x144
                info: found 4 framesizes for pixel format 3231564e (NV12)
                info: found 5 frameintervals for pixel format 3132564e (NV21) and size 640x480
                info: found 5 frameintervals for pixel format 3132564e (NV21) and size 352x288
                info: found 5 frameintervals for pixel format 3132564e (NV21) and size 320x240
                info: found 5 frameintervals for pixel format 3132564e (NV21) and size 176x144
                info: found 4 framesizes for pixel format 3132564e (NV21)
                info: found 5 frameintervals for pixel format 56595559 (YUYV) and size 640x480
                info: found 5 frameintervals for pixel format 56595559 (YUYV) and size 352x288
                info: found 5 frameintervals for pixel format 56595559 (YUYV) and size 320x240
                info: found 5 frameintervals for pixel format 56595559 (YUYV) and size 176x144
                info: found 4 framesizes for pixel format 56595559 (YUYV)
                info: found 5 formats for buftype 9
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                info: Global format check succeeded for type 9
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
                info: test buftype Video Capture Multiplanar
                fail: v4l2-test-buffers.cpp(525): q2.reqbufs(node->node2, 1)
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
                fail: v4l2-test-buffers.cpp(590): q.reqbufs(node, 2)
                test VIDIOC_EXPBUF: FAIL

Test input 0:


Total: 43, Succeeded: 41, Failed: 2, Warnings: 0
------------------------------------------------------------------------------

Thanks
   j

v8->v9:
- Address Laurent's review of ov772x frame rate
- Address Sergei comment on ceu node name

v7->v8:
- Calculate PLL divider/multiplier and do not use static tables
- Change RZ/A1-H to RZ/A1H (same for L) in bindings documentation
- Use rounded clock rate in Migo-R board code as SH clk_set_clk()
  implementation does not perform rounding
- Set ycbcr_enc and other fields of v4l2_mbus_format for ov772x as patch
  [11/11] does for ov7670

v6->v7:
- Add patch to handle ycbr_enc and other fields of v4l2_mbus_format for ov7670
- Add patch to handle frame interval for ov772x
- Rebased on Hans' media-tree/parm branch with v4l2_g/s_parm_cap
- Drop const modifier in CEU releated fields of Migo-R setup.c board file
  to silence complier warnings.

v5->v6:
- Add Hans' Acked-by to most patches
- Fix a bad change in ov772x get_selection
- Add .buf_prepare callack to CEU and verify plane sizes there
- Remove VB2_USERPTR from supported io_modes in CEU driver
- Remove read() fops in CEU driver

v4->v5:
- Added Rob's and Laurent's Reviewed-by tag to DT bindings
- Change CEU driver module license to "GPL v2" to match SPDX identifier as
  suggested by Philippe Ombredanne
- Make struct ceu_data static as suggested by Laurent and add his
  Reviewed-by to CEU driver.

v3->v4:
- Drop generic fallback compatible string "renesas,ceu"
- Addressed Laurent's comments on [3/9]
  - Fix error messages on irq get/request
  - Do not leak ceudev if irq_get fails
  - Make irq_mask a const field

v2->v3:
- Improved DT bindings removing standard properties (pinctrl- ones and
  remote-endpoint) not specific to this driver and improved description of
  compatible strings
- Remove ov772x's xlkc_rate property and set clock rate in Migo-R board file
- Made 'xclk' clock private to ov772x driver in Migo-R board file
- Change 'rstb' GPIO active output level and changed ov772x and tw9910 drivers
  accordingly as suggested by Fabio
- Minor changes in CEU driver to address Laurent's comments
- Moved Migo-R setup patch to the end of the series to silence 0-day bot
- Renamed tw9910 clock to 'xti' as per video decoder manual
- Changed all SPDX identifiers to GPL-2.0 from previous GPL-2.0+

v1->v2:
 - DT
 -- Addressed Geert's comments and added clocks for CEU to mstp6 clock source
 -- Specified supported generic video iterfaces properties in dt-bindings and
    simplified example

 - CEU driver
 -- Re-worked interrupt handler, interrupt management, reset(*) and capture
    start operation
 -- Re-worked querycap/enum_input/enum_frameintervals to fix some
    v4l2_compliance failures
 -- Removed soc_camera legacy operations g/s_mbus_format
 -- Update to new notifier implementation
 -- Fixed several comments from Hans, Laurent and Sakari

 - Migo-R
 -- Register clocks and gpios for sensor drivers in Migo-R setup
 -- Updated sensors (tw9910 and ov772x) drivers headers and drivers to close
    remarks from Hans and Laurent:
 --- Removed platform callbacks and handle clocks and gpios from sensor drivers
 --- Remove g/s_mbus_config operations

Jacopo Mondi (11):
  dt-bindings: media: Add Renesas CEU bindings
  include: media: Add Renesas CEU driver interface
  media: platform: Add Renesas CEU driver
  ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
  media: i2c: Copy ov772x soc_camera sensor driver
  media: i2c: ov772x: Remove soc_camera dependencies
  media: i2c: ov772x: Support frame interval handling
  media: i2c: Copy tw9910 soc_camera sensor driver
  media: i2c: tw9910: Remove soc_camera dependencies
  arch: sh: migor: Use new renesas-ceu camera driver
  media: i2c: ov7670: Fully set mbus frame fmt

 .../devicetree/bindings/media/renesas,ceu.txt      |   81 +
 arch/arm/boot/dts/r7s72100.dtsi                    |   15 +-
 arch/sh/boards/mach-migor/setup.c                  |  225 ++-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |    2 +-
 drivers/media/i2c/Kconfig                          |   20 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ov7670.c                         |    4 +
 drivers/media/i2c/ov772x.c                         | 1364 ++++++++++++++++
 drivers/media/i2c/tw9910.c                         | 1039 ++++++++++++
 drivers/media/platform/Kconfig                     |    9 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/renesas-ceu.c               | 1661 ++++++++++++++++++++
 include/media/drv-intf/renesas-ceu.h               |   26 +
 include/media/i2c/ov772x.h                         |    6 +-
 include/media/i2c/tw9910.h                         |    9 +
 15 files changed, 4333 insertions(+), 131 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
 create mode 100644 drivers/media/i2c/ov772x.c
 create mode 100644 drivers/media/i2c/tw9910.c
 create mode 100644 drivers/media/platform/renesas-ceu.c
 create mode 100644 include/media/drv-intf/renesas-ceu.h

--
2.7.4
