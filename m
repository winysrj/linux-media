Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37069 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbdHBDUH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 23:20:07 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v5 0/6]  Add Rockchip RGA V4l2 support
Date: Wed,  2 Aug 2017 11:19:41 +0800
Message-Id: <1501643987-27847-1-git-send-email-jacob-chen@iotwrt.com>
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

I have test this driver with gstreamer v4l2transform plugin and it work well.

change in V5:
- v4l2-compliance: handle invalid pxielformat 
- v4l2-compliance: add subscribe_event
- add colorspace support

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
  v4l: add portduff blend modes
  extended-controls.rst: add PorterDuff mode control
  rockchip/rga: v4l2 m2m support
  ARM: dts: rockchip: add RGA device node for RK3288
  ARM: dts: rockchip: add RGA device node for RK3399
  dt-bindings: Document the Rockchip RGA bindings

 .../devicetree/bindings/media/rockchip-rga.txt     |   33 +
 Documentation/media/uapi/v4l/extended-controls.rst |    5 +
 arch/arm/boot/dts/rk3288.dtsi                      |   11 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   11 +
 drivers/media/platform/Kconfig                     |   11 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/rockchip-rga/Makefile       |    3 +
 drivers/media/platform/rockchip-rga/rga-buf.c      |  155 +++
 drivers/media/platform/rockchip-rga/rga-hw.c       |  671 +++++++++++++
 drivers/media/platform/rockchip-rga/rga-hw.h       |  437 +++++++++
 drivers/media/platform/rockchip-rga/rga.c          | 1024 ++++++++++++++++++++
 drivers/media/platform/rockchip-rga/rga.h          |  110 +++
 drivers/media/v4l2-core/v4l2-ctrls.c               |   20 +-
 include/uapi/linux/v4l2-controls.h                 |   20 +-
 14 files changed, 2511 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
 create mode 100644 drivers/media/platform/rockchip-rga/Makefile
 create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
 create mode 100644 drivers/media/platform/rockchip-rga/rga.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga.h

-- 
2.7.4
