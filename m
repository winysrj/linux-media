Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34580 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752429AbdGaPdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 11:33:16 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v4 0/5] Add Rockchip RGA V4l2 support
Date: Mon, 31 Jul 2017 23:32:56 +0800
Message-Id: <1501515182-26705-1-git-send-email-jacob-chen@iotwrt.com>
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

change in V4:
- document the controls.
- change according to Hans's comments

change in V3:
- rename the controls.
- add pm_runtime support.
- enable node by default.
- correct spelling in documents.

change in V2:
- generalize the controls.
- map buffers (10-50 us) in every cmd-run rather than in buffer-import to avoid get_free_pages failed on
actively used systems.
- remove status in dt-bindings examples.

Jacob Chen (6):
  [media] v4l: add portduff blend modes
  [media] extended-controls.rst: add PorterDuff mode control
  [media]: rockchip/rga: v4l2 m2m support
  ARM: dts: rockchip: add RGA device node for RK3288
  ARM: dts: rockchip: add RGA device node for RK3399
  dt-bindings: Document the Rockchip RGA bindings

 .../devicetree/bindings/media/rockchip-rga.txt     |  33 +
 Documentation/media/uapi/v4l/extended-controls.rst |   4 +
 arch/arm/boot/dts/rk3288.dtsi                      |  11 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  11 +
 drivers/media/platform/Kconfig                     |  11 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/rockchip-rga/Makefile       |   3 +
 drivers/media/platform/rockchip-rga/rga-buf.c      | 153 ++++
 drivers/media/platform/rockchip-rga/rga-hw.c       | 650 ++++++++++++++
 drivers/media/platform/rockchip-rga/rga-hw.h       | 437 +++++++++
 drivers/media/platform/rockchip-rga/rga.c          | 975 +++++++++++++++++++++
 drivers/media/platform/rockchip-rga/rga.h          | 109 +++
 drivers/media/v4l2-core/v4l2-ctrls.c               |  20 +-
 include/uapi/linux/v4l2-controls.h                 |  20 +-
 14 files changed, 2437 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
 create mode 100644 drivers/media/platform/rockchip-rga/Makefile
 create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
 create mode 100644 drivers/media/platform/rockchip-rga/rga.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga.h

-- 
2.7.4
