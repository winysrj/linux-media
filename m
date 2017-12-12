Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34974 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdLLA0k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 19:26:40 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Vladimir Zapolskiy <vz@mleia.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/4] NVIDIA Tegra video decoder driver
Date: Tue, 12 Dec 2017 03:26:06 +0300
Message-Id: <cover.1513038011.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VDE driver provides accelerated video decoding to NVIDIA Tegra SoC's,
it is a result of reverse-engineering efforts. Driver has been tested on
Toshiba AC100 and Acer A500, it should work on any Tegra20 device.

In userspace this driver is utilized by libvdpau-tegra [0] that implements
VDPAU interface, so any video player that supports VDPAU can provide
accelerated video decoding on Tegra20 on Linux.

[0] https://github.com/grate-driver/libvdpau-tegra

Change log:
v5:
	- Moved driver to staging/media as per Hans's Verkuil request
	- Addressed review comments to v4 from Vladimir Zapolskiy and
	  Dan Carpenter
	- Updated 'TODO', reflecting that this driver require upcoming
	  support of stateless decoders by V4L2
	- Dropped patch that enabled VDE driver in tegra_defconfig for now
	  as I realized that Tegra's DRM staging config is disabled there
	  and right now we are relying on it in libvdpau-tegra
	- Added myself to MAINTAINERS in the "Introduce driver" patch as per
	  Vladimir's suggestion

v4:
	- Added mmio-sram "IRAM DT node" patch from Vladimir Zapolskiy to
	  the series, I modified it to cover all Tegra's and not only Tegra20
	- Utilized genalloc for the reservation of IRAM region as per
	  Vladimir's suggestion, VDE driver now selects SRAM driver in Kconfig
	- Added defconfig patch to the series
	- Described VDE registers in DT per HW unit, excluding BSE-A / UCQ
	  and holes between the units
	- Extended DT compatibility property with Tegra30/114/124/132 in the
	  binding doc.
	- Removed BSE-A interrupt from the DT binding because it's very
	  likely that Audio Bitstream Engine isn't integrated with VDE
	- Removed UCQ interrupt from the DT binding because in TRM it is
	  represented as a distinct HW block that probably should have
	  its own driver
	- Addressed v3 review comments: factored out DT binding addition
	  into a standalone patch, moved binding to media/, removed
	  clocks/resets-names

v3:
	- Suppressed compilation warnings reported by 'kbuild test robot'

v2:
	- Addressed v1 review comments from Stephen Warren and Dan Carpenter
	- Implemented runtime PM
	- Miscellaneous code cleanups
	- Changed 'TODO'
	- CC'd media maintainers for the review as per Greg's K-H request,
	  v1 can be viewed at https://lkml.org/lkml/2017/9/25/606

Dmitry Osipenko (3):
  media: dt: bindings: Add binding for NVIDIA Tegra Video Decoder Engine
  staging: media: Introduce NVIDIA Tegra video decoder driver
  ARM: dts: tegra20: Add video decoder node

Vladimir Zapolskiy (1):
  ARM: dts: tegra20: Add device tree node to describe IRAM

 .../devicetree/bindings/media/nvidia,tegra-vde.txt |   55 +
 MAINTAINERS                                        |    9 +
 arch/arm/boot/dts/tegra20.dtsi                     |   35 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/tegra-vde/Kconfig            |    7 +
 drivers/staging/media/tegra-vde/Makefile           |    1 +
 drivers/staging/media/tegra-vde/TODO               |    4 +
 drivers/staging/media/tegra-vde/tegra-vde.c        | 1213 ++++++++++++++++++++
 drivers/staging/media/tegra-vde/uapi.h             |   78 ++
 10 files changed, 1405 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
 create mode 100644 drivers/staging/media/tegra-vde/Kconfig
 create mode 100644 drivers/staging/media/tegra-vde/Makefile
 create mode 100644 drivers/staging/media/tegra-vde/TODO
 create mode 100644 drivers/staging/media/tegra-vde/tegra-vde.c
 create mode 100644 drivers/staging/media/tegra-vde/uapi.h

-- 
2.15.1
