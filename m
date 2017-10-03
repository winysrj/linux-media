Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35843 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbdJCJ2u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 05:28:50 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v10 0/4] Add Rockchip RGA V4l2 support
Date: Tue,  3 Oct 2017 17:28:35 +0800
Message-Id: <20171003092839.26236-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add a v4l2 m2m drvier for rockchip RGA direct rendering based 2d graphics acceleration module.

change in V10:
- move to rockchip/rga
- changes according to comments
- some style changes

change in V9:
- remove protduff things
- test with the latest v4l2-compliance

change in V8:
- remove protduff things

change in V6,V7:
- correct warning in checkpatch.pl

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

Jacob Chen (4):
  rockchip/rga: v4l2 m2m support
  ARM: dts: rockchip: add RGA device node for RK3288
  arm64: dts: rockchip: add RGA device node for RK3399
  dt-bindings: Document the Rockchip RGA bindings

 .../devicetree/bindings/media/rockchip-rga.txt     |   33 +
 arch/arm/boot/dts/rk3288.dtsi                      |   11 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   11 +
 drivers/media/platform/Kconfig                     |   15 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/rockchip/rga/Makefile       |    3 +
 drivers/media/platform/rockchip/rga/rga-buf.c      |  154 +++
 drivers/media/platform/rockchip/rga/rga-hw.c       |  421 ++++++++
 drivers/media/platform/rockchip/rga/rga-hw.h       |  437 +++++++++
 drivers/media/platform/rockchip/rga/rga.c          | 1012 ++++++++++++++++++++
 drivers/media/platform/rockchip/rga/rga.h          |  123 +++
 11 files changed, 2222 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
 create mode 100644 drivers/media/platform/rockchip/rga/Makefile
 create mode 100644 drivers/media/platform/rockchip/rga/rga-buf.c
 create mode 100644 drivers/media/platform/rockchip/rga/rga-hw.c
 create mode 100644 drivers/media/platform/rockchip/rga/rga-hw.h
 create mode 100644 drivers/media/platform/rockchip/rga/rga.c
 create mode 100644 drivers/media/platform/rockchip/rga/rga.h

-- 
2.14.1
