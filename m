Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36342 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdFZOvD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 10:51:03 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        heiko@sntech.de, jacob-chen@iotwrt.com, mchehab@kernel.org,
        hans.verkuil@cisco.com
Subject: [PATCH 0/5] Add Rockchip RGA V4l2 support
Date: Mon, 26 Jun 2017 22:50:42 +0800
Message-Id: <1498488642-27830-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add a v4l2 m2m drvier for rockchip RGA direct rendering based 2d graphics acceleration module. 

Before, my colleague yakir have write a drm RGA drvier and send it to the lists.
http://lists.infradead.org/pipermail/linux-arm-kernel/2016-March/416769.html
I have been asked to find a userspace user("compositor") for it, but after some studys, my conclusion is that unlike exynos g2d,
rockchip rga are not suitable for compositor. Rockchip RGA have a limited MMU, which means it can only hold several buffers in the same time.
When it was used in compositor, it will waste a lot of time to import/export/flush buffer, resulting in a bad performance.

A few months ago, i saw a discussion in dri-devel@lists.freedesktop.org. 
It remind that we could write a v4l2 m2m RGA driver, since we usually use RGA for streaming purpose.
https://patches.linaro.org/cover/97727/

I have test this driver with gstreamer v4l2transform plugin and it seems work well.
It could work without any modify in existing plugin and it have no buffer cahce flush problem which we have meet in drm. 
https://github.com/GStreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2transform.c

Jacob Chen (5):
  [media] rockchip/rga: v4l2 m2m support
  ARM: dts: rockchip: add RGA device node for RK3288
  ARM: dts: rockchip: add RGA device node for RK3399
  ARM: dts: rockchip: enable RGA for rk3288 devices
  dt-bindings: Document the Rockchip RGA bindings

 .../devicetree/bindings/media/rockchip-rga.txt     |  36 +
 arch/arm/boot/dts/rk3288-evb.dtsi                  |   4 +
 arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi  |   4 +
 arch/arm/boot/dts/rk3288-firefly.dtsi              |   4 +
 arch/arm/boot/dts/rk3288-miqi.dts                  |   4 +
 arch/arm/boot/dts/rk3288-popmetal.dts              |   4 +
 arch/arm/boot/dts/rk3288-tinker.dts                |   4 +
 arch/arm/boot/dts/rk3288.dtsi                      |  13 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  13 +
 drivers/media/platform/Kconfig                     |  11 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/rockchip-rga/Makefile       |   3 +
 drivers/media/platform/rockchip-rga/rga-buf.c      | 176 ++++
 drivers/media/platform/rockchip-rga/rga-hw.c       | 456 ++++++++++
 drivers/media/platform/rockchip-rga/rga-hw.h       | 434 +++++++++
 drivers/media/platform/rockchip-rga/rga.c          | 979 +++++++++++++++++++++
 drivers/media/platform/rockchip-rga/rga.h          | 133 +++
 17 files changed, 2280 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
 create mode 100644 drivers/media/platform/rockchip-rga/Makefile
 create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
 create mode 100644 drivers/media/platform/rockchip-rga/rga.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga.h

-- 
2.7.4
