Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-111.mail.aliyun.com ([115.124.20.111]:59501 "EHLO
        out20-111.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbdG0Dvn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 23:51:43 -0400
From: Yong Deng <yong.deng@magewell.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Yong Deng <yong.deng@magewell.com>
Subject: [PATCH v2 0/3] Initial Allwinner V3s CSI Support
Date: Thu, 27 Jul 2017 11:51:11 +0800
Message-Id: <1501127474-40895-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset add initial support for Allwinner V3s CSI.

Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
and CSI1 is used for parallel interface. This is not documented in
datasheet but by testing and guess.

This patchset implement a v4l2 framework driver and add a binding 
documentation for it. 

Currently, the driver only support the parallel interface. And has been
tested with a BT1120 signal which generating from FPGA. The following
fetures are not support with this patchset:
  - ISP 
  - MIPI-CSI2
  - Master clock for camera sensor
  - Power regulator for the front end IC

sun6i_csi_ops is still there. I seriously thought about it. Without 
sun6i_csi_ops, the dependency between sun6i_video and sun6i_csi_v3s
will be complicated. Comments and criticisms are welcome.

Changes in v2:
  * Change sunxi-csi to sun6i-csi
  * Rebase to media_tree master branch

Yong Deng (3):
  media: V3s: Add support for Allwinner CSI.
  dt-bindings: media: Add Allwinner V3s Camera Sensor Interface (CSI)
  media: MAINTAINERS: add entries for Allwinner V3s CSI

 .../devicetree/bindings/media/sun6i-csi.txt        |  49 ++
 MAINTAINERS                                        |   8 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/sun6i-csi/Kconfig           |   9 +
 drivers/media/platform/sun6i-csi/Makefile          |   3 +
 drivers/media/platform/sun6i-csi/sun6i_csi.c       | 545 ++++++++++++++
 drivers/media/platform/sun6i-csi/sun6i_csi.h       | 203 +++++
 drivers/media/platform/sun6i-csi/sun6i_csi_v3s.c   | 827 +++++++++++++++++++++
 drivers/media/platform/sun6i-csi/sun6i_csi_v3s.h   | 206 +++++
 drivers/media/platform/sun6i-csi/sun6i_video.c     | 663 +++++++++++++++++
 drivers/media/platform/sun6i-csi/sun6i_video.h     |  61 ++
 12 files changed, 2577 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
 create mode 100644 drivers/media/platform/sun6i-csi/Kconfig
 create mode 100644 drivers/media/platform/sun6i-csi/Makefile
 create mode 100644 drivers/media/platform/sun6i-csi/sun6i_csi.c
 create mode 100644 drivers/media/platform/sun6i-csi/sun6i_csi.h
 create mode 100644 drivers/media/platform/sun6i-csi/sun6i_csi_v3s.c
 create mode 100644 drivers/media/platform/sun6i-csi/sun6i_csi_v3s.h
 create mode 100644 drivers/media/platform/sun6i-csi/sun6i_video.c
 create mode 100644 drivers/media/platform/sun6i-csi/sun6i_video.h

-- 
1.8.3.1
