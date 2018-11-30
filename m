Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60154 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbeLAEoq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 23:44:46 -0500
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v11 0/4] Add Rockchip VPU JPEG encoder
Date: Fri, 30 Nov 2018 14:34:29 -0300
Message-Id: <20181130173433.24185-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nothing like sending a new round on a Friday,
so people can test and review during the weekend! ;-)

As before, this series is based on Mauro's master branch,
with the following patch applied:

https://patchwork.kernel.org/patch/10676149/

On this new round, I've addressed all the feedback
provided by Tomasz on v10.

As always, any additional feedback is well received.

This patchset has been tested on RK3288 and RK3399
using bleeding-edge Gstreamer, with these pipelines:

function gst_kms {
        gst-launch-1.0 -v videotestsrc num-buffers=${4} ! video/x-raw,width=${1},height=${2},format=${3}! v4l2jpegenc extra-controls="c,compression_quality=100" ! jpegdec ! videoconvert ! video/x-raw,format=BGRx ! queue leaky=1 ! kmssink sync=0
}

gst_kms 640 480 YUY2 30
gst_kms 640 480 NV12 30
gst_kms 640 480 I420 30
(and more sizes)

There are a few warnings after running check_patch.pl --strict,
but I've chosen not to address them, as it would reducely
readability.

Also, v4l2-compliance -s passes on both platforms, as has
been the case for the past submissions.

v11:
 * Update TODO file
 * Make macroblock alignment codec specific
 * Rename VEPU_REG_ADDR_IN_LUMA,CR,CB to
   VEPU_REG_ADDR_IN_PLANE_0,12,
 * Only write plane address (VEPU_REG_ADDR_IN_PLANE_0,1,2)
   when needed.
 * s/rockchip_vpu_jpeg_render/rockchip_vpu_jpeg_header_assemble
 * Drop wmb() and use a writel, which has an implicit barrier.
 * Added missing documentation for all structs.
 * Removed unused struct fields.
 * Simplified xfer_func et al usage.
 * Reworked vepu_debug for i/o
 * Explicitly enabled/disabled clocks before/after work,
   instead of via the PM runtime infra.
 * Copy buffer timecode only when required 
 * Bound check the amount of bytes transferred by the hardware.
 * Remove useless void * cast.
 * Fix race condition between top half and watchdog .
 * Drop redundant check for v4l2_ctrl errors.
 * Add rounding up in fill_fmt helpers.
 * Remove unneeded DMA alignment implementation (needed only for
 * USERPTR).
 * Add check for different width and height in CAPTURE S_FMT.
 * Remove check for peer busy queue in OUTPUT S_FMT.
 * Remove double whitespace.
 * Multi-line comments fixed.
 * Google copyright fixed.
 * Typos fixed.

v10:
 * Fix SPDX syntax
 * Add missing patch with binding documentation
 * Remove white line in Kconfig

v9:
 * Address some style comments from Hans.
 * Fix TODO file

v8:
 * Drop new JPEG_RAW format.
 * Drop quantization table user controls.
 * Add JPEG headers to produce JPEG frames.

Ezequiel Garcia (4):
  media: dt-bindings: Document the Rockchip VPU bindings
  ARM: dts: rockchip: add VPU device node for RK3288
  arm64: dts: rockchip: add VPU device node for RK3399
  media: add Rockchip VPU JPEG encoder driver

 .../bindings/media/rockchip-vpu.txt           |  29 +
 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/rk3288.dtsi                 |  14 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |  14 +-
 drivers/staging/media/Kconfig                 |   2 +
 drivers/staging/media/Makefile                |   1 +
 drivers/staging/media/rockchip/vpu/Kconfig    |  13 +
 drivers/staging/media/rockchip/vpu/Makefile   |  10 +
 drivers/staging/media/rockchip/vpu/TODO       |  13 +
 .../media/rockchip/vpu/rk3288_vpu_hw.c        | 118 +++
 .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     | 130 ++++
 .../media/rockchip/vpu/rk3288_vpu_regs.h      | 442 ++++++++++++
 .../media/rockchip/vpu/rk3399_vpu_hw.c        | 118 +++
 .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     | 164 +++++
 .../media/rockchip/vpu/rk3399_vpu_regs.h      | 600 ++++++++++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu.h | 232 ++++++
 .../media/rockchip/vpu/rockchip_vpu_common.h  |  29 +
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 531 ++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_enc.c     | 676 ++++++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_hw.h      |  58 ++
 .../media/rockchip/vpu/rockchip_vpu_jpeg.c    | 290 ++++++++
 .../media/rockchip/vpu/rockchip_vpu_jpeg.h    |  14 +
 22 files changed, 3503 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
 create mode 100644 drivers/staging/media/rockchip/vpu/Kconfig
 create mode 100644 drivers/staging/media/rockchip/vpu/Makefile
 create mode 100644 drivers/staging/media/rockchip/vpu/TODO
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h

-- 
2.20.0.rc1
