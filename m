Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34153 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757692AbcHYJkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 05:40:03 -0400
From: Florent Revest <florent.revest@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: florent.revest@free-electrons.com, linux-sunxi@googlegroups.com,
        maxime.ripard@free-electrons.com, posciak@chromium.org,
        hans.verkuil@cisco.com, thomas.petazzoni@free-electrons.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org, wens@csie.org
Subject: [RFC 00/10] Add Sunxi Cedrus Video Decoder Driver
Date: Thu, 25 Aug 2016 11:39:39 +0200
Message-Id: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series adds a v4l2 memory2memory decoder driver for Allwinner's
VPU found in the A13 SoC. It follows the reverse engineering effort
of the Cedrus [1] project.

The VPU is able to decode a bunch of formats but currently only MPEG2
and a subset of MPEG4 are supported by the driver, more will come
eventually.

This VPU needs a frame-by-frame registers programming and implements
the idea of "Frame API" [2] proposed by Pawel Osciak. (i.e: binding
standard frame headers with frames via the "Request API") The patchset
includes both a new control for MPEG2 and MPEG4 frame headers. The
MPEG2 control should be generic enough for every other drivers but the
MPEG4 control sticks to the bare minimum needed by sunxi-cedrus.

The "Frame API" relies on the controls features of the "Request API".
[3] Since the latest Request API RFCs don't support controls and
given the time I had to work on this driver, I chose to use an older
RFC from Hans. [4] Of course, this is definitely not meant to be kept
and as soon as a newer Request API will support controls I'll stick
to the newest code base.

If you are interested in testing this driver, you can find a recently
(v4.8rc3) rebased version of this request API along my patchset in
this repository. [5] I also developed a libVA backend interfacing
with my proposal of MPEG2 and MPEG4 Frame API. [6] It's called 
"sunxi-cedrus-drv-video" but the only sunxi-cedrus specific part is
the format conversion code. Overall it should be generic enough for
any other v4l driver using the Frame API and as soon as the support
of DRM planes for this pixel format will be added it could be
renamed to something more generic.

[1] http://linux-sunxi.org/Cedrus
[2] https://docs.google.com/presentation/d/1RLkH3QxdmrcW_t41KllEvUmVsrHMbMOgd6CqAgzR7U4/pub?slide=id.p
[3] https://lwn.net/Articles/688585/
[4] https://lwn.net/Articles/641204/
[5] https://github.com/FlorentRevest/linux-sunxi-cedrus
[6] https://github.com/FlorentRevest/sunxi-cedrus-drv-video

Florent Revest (9):
  clk: sunxi-ng: Add a couple of A13 clocks
  v4l: Add sunxi Video Engine pixel format
  v4l: Add MPEG2 low-level decoder API control
  v4l: Add MPEG4 low-level decoder API control
  media: platform: Add Sunxi Cedrus decoder driver
  sunxi-cedrus: Add a MPEG 2 codec
  sunxi-cedrus: Add a MPEG 4 codec
  ARM: dts: sun5i: Use video-engine node
  sunxi-cedrus: Add device tree binding document

Pawel Osciak (1):
  v4l: Add private compound control type.

 .../devicetree/bindings/clock/sunxi-ccu.txt        |   1 +
 .../devicetree/bindings/media/sunxi-cedrus.txt     |  44 ++
 arch/arm/boot/dts/sun5i-a13.dtsi                   |  42 ++
 drivers/clk/sunxi-ng/Kconfig                       |  11 +
 drivers/clk/sunxi-ng/Makefile                      |   1 +
 drivers/clk/sunxi-ng/ccu-sun5i-a13.c               |  80 +++
 drivers/clk/sunxi-ng/ccu-sun5i-a13.h               |  25 +
 drivers/media/platform/Kconfig                     |  13 +
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/sunxi-cedrus/Makefile       |   3 +
 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c | 285 ++++++++++
 .../platform/sunxi-cedrus/sunxi_cedrus_common.h    | 101 ++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.c | 588 +++++++++++++++++++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.h |  33 ++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.c  | 166 ++++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.h  |  39 ++
 .../platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c     | 152 ++++++
 .../platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c     | 140 +++++
 .../platform/sunxi-cedrus/sunxi_cedrus_regs.h      | 170 ++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |  23 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
 include/dt-bindings/clock/sun5i-a13-ccu.h          |  49 ++
 include/dt-bindings/reset/sun5i-a13-ccu.h          |  48 ++
 include/uapi/linux/v4l2-controls.h                 |  68 +++
 include/uapi/linux/videodev2.h                     |   9 +
 25 files changed, 2094 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt
 create mode 100644 drivers/clk/sunxi-ng/ccu-sun5i-a13.c
 create mode 100644 drivers/clk/sunxi-ng/ccu-sun5i-a13.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/Makefile
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_regs.h
 create mode 100644 include/dt-bindings/clock/sun5i-a13-ccu.h
 create mode 100644 include/dt-bindings/reset/sun5i-a13-ccu.h

-- 
2.7.4

