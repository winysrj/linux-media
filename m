Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-62.mail.aliyun.com ([115.124.20.62]:51982 "EHLO
        out20-62.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbeJ3RDp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 13:03:45 -0400
From: Yong Deng <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Deng <yong.deng@magewell.com>
Subject: [PATCH v12 0/2] Initial Allwinner V3s CSI Support
Date: Tue, 30 Oct 2018 16:09:48 +0800
Message-Id: <1540886988-27696-1-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can't make v4l2-compliance always happy.
The V3s CSI support many pixformats. But they are not always available.
It's dependent on the input bus format (MEDIA_BUS_FMT_*). 
Example:
V4L2_PIX_FMT_SBGGR8: MEDIA_BUS_FMT_SBGGR8_1X8
V4L2_PIX_FMT_YUYV: MEDIA_BUS_FMT_YUYV8_2X8
But I can't get the subdev's format code before starting stream as the
subdev may change it. So I can't know which pixformats are available.
So I exports all the pixformats supported by SoC.
The result is the app (v4l2-compliance) is likely to fail on streamon.

This patchset add initial support for Allwinner V3s CSI.

Allwinner V3s SoC features a CSI module with parallel interface.

This patchset implement a v4l2 framework driver and add a binding 
documentation for it. 

Changes in v12:
  * use strscpy instead of strlcpy
  * fix defination of PHYS_OFFSET
  * fix return value in sun6i_video_link_validate
  * fix some missing release functions
  * fix dt documentation

Changes in v11:
  * only check format when starting stream
  * do not check subdev's input status in enum input
  * fix order of v4l2_async_notifier's unregister and cleanup
  * unprepare and disable clks if fails in sun6i_csi_set_power
  * move supported_pixformats to sun6i_video.c
  * fix SPDX-License-Identifier to match MODULE_LICENSE
  * fix capture for interlace signal

Changes in v10:
  * change sun6i_csi_is_format_support to sun6i_csi_is_format_supported
  * using media_entity_get_fwnode_pad to get source pad
  * switch media_entity_call to media_entity_setup_link
  * remove V4L2_INPUT_TYPE_CAMERA

Changes in v9:
  * Merge the patchs from Maxime:
    a. Fill dma_pfn_offset to accomodate for the RAM offset
    b. Reduce the error level
    c. Pass the sun6i_csi_dev pointer to our helpers
    d. Don't emit a warning when the configured format isn't found
    e. Support the YUYV format properly
    f. Invert the polaritie of all signals
    g. Expose controls on the v4l2_device

Changes in v8:
  * Revert to v6 and add 'hack' for PHYS_OFFSET.

Changes in v7:
  * Add 'depends on ARM' in Kconfig to avoid built with non-ARM arch.

Changes in v6:
  * Add Rob Herring's review tag.
  * Fix a NULL pointer dereference by picking Maxime Ripard's patch.
  * Add Maxime Ripard's test tag.

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

Following is the 'v4l2-compliance -s -f' output:

# ./bin/v4l2-compliance -s
v4l2-compliance SHA: c36dbbdfa8b30b2badd4f893b59d0bd4f0bd12aa, 32 bits

Compliance test for device /dev/video0:

Driver Info:
        Driver name      : sun6i-video
        Card type        : sun6i-csi
        Bus info         : platform:csi
        Driver version   : 4.15.0
        Capabilities     : 0x84200001
                Video Capture
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps      : 0x04200001
                Video Capture
                Streaming
                Extended Pix Format
Media Driver Info:
        Driver name      : sun6i-csi
        Model            : Allwinner Video Capture Device
        Serial           : 
        Bus info         : 
        Media version    : 4.15.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.15.0
Interface Info:
        ID               : 0x03000003
        Type             : V4L Video
Entity Info:
        ID               : 0x00000001 (1)
        Name             : sun6i-csi
        Function         : V4L2 I/O
        Pad 0x01000002   : Sink, Must Connect
          Link 0x02000007: from remote pad 0x1000006 of entity 'adv7611 0-004c': Data, Enabled, Immutable

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

Control ioctls (Input 0):
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
        test VIDIOC_G/S_CTRL: OK
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
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

Test input 0:

Streaming ioctls:
        test read/write: OK (Not Supported)
        test blocking wait: OK
                fail: v4l2-test-buffers.cpp(946): node->streamon(q.g_type())
        test MMAP: FAIL
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device

Total: 48, Succeeded: 47, Failed: 1, Warnings: 0

Yong Deng (2):
  dt-bindings: media: Add Allwinner V3s Camera Sensor Interface (CSI)
  media: V3s: Add support for Allwinner CSI.

 .../devicetree/bindings/media/sun6i-csi.txt        |  56 ++
 MAINTAINERS                                        |   8 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   9 +
 drivers/media/platform/sunxi/sun6i-csi/Makefile    |   3 +
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 915 +++++++++++++++++++++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 135 +++
 .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h | 196 +++++
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   | 678 +++++++++++++++
 .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |  38 +
 11 files changed, 2041 insertions(+)
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
