Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-98.mail.aliyun.com ([115.124.20.98]:57136 "EHLO
        out20-98.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753084AbeAKDCX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 22:02:23 -0500
From: Yong Deng <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, megous@megous.com,
        Yong Deng <yong.deng@magewell.com>
Subject: [PATCH v5 0/2] Initial Allwinner V3s CSI Support
Date: Thu, 11 Jan 2018 11:01:10 +0800
Message-Id: <1515639670-34046-1-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset add initial support for Allwinner V3s CSI.

Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
interface and CSI1 is used for parallel interface. This is not
documented in datasheet but by test and guess.

This patchset implement a v4l2 framework driver and add a binding 
documentation for it. 

Currently, the driver only support the parallel interface. And has been
tested with a BT1120 signal which generating from FPGA. The following
fetures are not support with this patchset:
  - ISP 
  - MIPI-CSI2
  - Master clock for camera sensor
  - Power regulator for the front end IC

Changes in v5:
  * Using the new SPDX tags.
  * Fix MODULE_LICENSE.
  * Add many default cases and warning messages.
  * Detail the parallel bus properties
  * Fix some spelling and syntax mistakes.

Changes in v4:
  * Deal with the CSI 'INNER QUEUE'.
    CSI will lookup the next dma buffer for next frame before the
    the current frame done IRQ triggered. This is not documented
    but reported by Ondřej Jirman.
    The BSP code has workaround for this too. It skip to mark the
    first buffer as frame done for VB2 and pass the second buffer
    to CSI in the first frame done ISR call. Then in second frame
    done ISR call, it mark the first buffer as frame done for VB2
    and pass the third buffer to CSI. And so on. The bad thing is
    that the first buffer will be written twice and the first frame
    is dropped even the queued buffer is sufficient.
    So, I make some improvement here. Pass the next buffer to CSI
    just follow starting the CSI. In this case, the first frame
    will be stored in first buffer, second frame in second buffer.
    This mothed is used to avoid dropping the first frame, it
    would also drop frame when lacking of queued buffer.
  * Fix: using a wrong mbus_code when getting the supported formats
  * Change all fourcc to pixformat
  * Change some function names

Changes in v3:
  * Get rid of struct sun6i_csi_ops
  * Move sun6i-csi to new directory drivers/media/platform/sunxi
  * Merge sun6i_csi.c and sun6i_csi_v3s.c into sun6i_csi.c
  * Use generic fwnode endpoints parser
  * Only support a single subdev to make things simple
  * Many complaintion fix

Changes in v2: 
  * Change sunxi-csi to sun6i-csi
  * Rebase to media_tree master branch 

Following is the 'v4l2-compliance -s -f' output, I have test this
with both interlaced and progressive signal:

# ./v4l2-compliance -s -f
v4l2-compliance SHA   : 6049ea8bd64f9d78ef87ef0c2b3dc9b5de1ca4a1

Driver Info:
        Driver name   : sun6i-video
        Card type     : sun6i-csi
        Bus info      : platform:csi
        Driver version: 4.15.0
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
        test read/write: OK (Not Supported)
        test MMAP: OK                                     
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device

Stream using all formats:
        test MMAP for Format HM12, Frame Size 1280x720:
                Stride 1920, Field None: OK                                 
        test MMAP for Format NV12, Frame Size 1280x720:
                Stride 1920, Field None: OK                                 
        test MMAP for Format NV21, Frame Size 1280x720:
                Stride 1920, Field None: OK                                 
        test MMAP for Format YU12, Frame Size 1280x720:
                Stride 1920, Field None: OK                                 
        test MMAP for Format YV12, Frame Size 1280x720:
                Stride 1920, Field None: OK                                 
        test MMAP for Format NV16, Frame Size 1280x720:
                Stride 2560, Field None: OK                                 
        test MMAP for Format NV61, Frame Size 1280x720:
                Stride 2560, Field None: OK                                 
        test MMAP for Format 422P, Frame Size 1280x720:
                Stride 2560, Field None: OK                                 

Total: 54, Succeeded: 54, Failed: 0, Warnings: 0

Yong Deng (2):
  dt-bindings: media: Add Allwinner V3s Camera Sensor Interface (CSI)
  media: V3s: Add support for Allwinner CSI.

 .../devicetree/bindings/media/sun6i-csi.txt        |  59 ++
 MAINTAINERS                                        |   8 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   9 +
 drivers/media/platform/sunxi/sun6i-csi/Makefile    |   3 +
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 908 +++++++++++++++++++++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 143 ++++
 .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h | 196 +++++
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   | 741 +++++++++++++++++
 .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |  53 ++
 11 files changed, 2123 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Makefile
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h

-- 
1.8.3.1
