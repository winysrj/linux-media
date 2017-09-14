Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36917 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdINBTc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 21:19:32 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        heiko@sntech.de, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v9 0/4]  Add Rockchip RGA V4l2 support
Date: Thu, 14 Sep 2017 09:19:13 +0800
Message-Id: <1505351957-14479-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add a v4l2 m2m drvier for rockchip RGA direct rendering based 2d graphics acceleration module.

Recently I tried to add protduff support for gstreamer on rockchip platform, and i found that API 
were not very suitable for my purpose. 
It shouldn't go upstream until we can figure out what people need, 

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
 drivers/media/platform/Kconfig                     |   11 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/rockchip-rga/Makefile       |    3 +
 drivers/media/platform/rockchip-rga/rga-buf.c      |  156 +++
 drivers/media/platform/rockchip-rga/rga-hw.c       |  435 +++++++++
 drivers/media/platform/rockchip-rga/rga-hw.h       |  437 +++++++++
 drivers/media/platform/rockchip-rga/rga.c          | 1030 ++++++++++++++++++++
 drivers/media/platform/rockchip-rga/rga.h          |  110 +++
 11 files changed, 2239 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
 create mode 100644 drivers/media/platform/rockchip-rga/Makefile
 create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
 create mode 100644 drivers/media/platform/rockchip-rga/rga.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga.h

-- 
2.7.4
