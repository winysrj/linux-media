Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48982 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751187AbdGOMr5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 08:47:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/4] tegra-cec: add Tegra HDMI CEC support
Date: Sat, 15 Jul 2017 14:47:49 +0200
Message-Id: <20170715124753.43714-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the Tegra CEC functionality.

It has two prerequisites:

this cec-notifier patch: https://patchwork.linuxtv.org/patch/42521/

and this workaround: http://www.spinics.net/lists/dri-devel/msg147038.html

A proper fix needs to be found for that workaround, but it is good
enough for testing this patch series.

The first patch documents the CEC bindings, the second adds support
for this to tegra124.dtsi and enables it for the Jetson TK1.

The third patch adds the CEC driver itself and the final patch adds
the cec notifier support to the drm/tegra driver in order to notify
the CEC driver whenever the physical address changes.

I expect that the dts changes apply as well to the Tegra X1/X2 and possibly
other Tegra SoCs, but I can only test this with my Jetson TK1 board.

The dt-bindings and the tegra-cec driver would go in through the media
subsystem, the drm/tegra part through the drm subsystem and the dts
changes through (I guess) the linux-tegra developers. Luckily they are
all independent of one another.

To test this you need the CEC utilities from git://linuxtv.org/v4l-utils.git.

To build this:

git clone git://linuxtv.org/v4l-utils.git
cd v4l-utils
./bootstrap.sh; ./configure
make
sudo make install	# optional, you really only need utils/cec*

To test:

cec-ctl --playback	# configure as playback device
cec-ctl -S		# detect all connected CEC devices

See here for the public CEC API:

https://hverkuil.home.xs4all.nl/spec/uapi/cec/cec-api.html

Regards,

	Hans

Hans Verkuil (4):
  dt-bindings: document the tegra CEC bindings
  ARM: tegra: add CEC support to tegra124.dtsi
  tegra-cec: add Tegra HDMI CEC driver
  drm/tegra: add cec-notifier support

 .../devicetree/bindings/media/tegra-cec.txt        |  26 ++
 MAINTAINERS                                        |   8 +
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   4 +
 arch/arm/boot/dts/tegra124.dtsi                    |  12 +-
 drivers/gpu/drm/tegra/drm.h                        |   3 +
 drivers/gpu/drm/tegra/hdmi.c                       |   9 +
 drivers/gpu/drm/tegra/output.c                     |   6 +
 drivers/media/platform/Kconfig                     |  11 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/tegra-cec/Makefile          |   1 +
 drivers/media/platform/tegra-cec/tegra_cec.c       | 506 +++++++++++++++++++++
 drivers/media/platform/tegra-cec/tegra_cec.h       | 127 ++++++
 12 files changed, 714 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/tegra-cec.txt
 create mode 100644 drivers/media/platform/tegra-cec/Makefile
 create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.c
 create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.h

-- 
2.11.0
