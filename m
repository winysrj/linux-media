Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:54774 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdJSVhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 17:37:31 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] NVIDIA Tegra20 video decoder driver
Date: Fri, 20 Oct 2017 00:34:20 +0300
Message-Id: <cover.1508448293.git.digetx@gmail.com>
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

Dmitry Osipenko (4):
  media: dt: bindings: Add binding for NVIDIA Tegra Video Decoder Engine
  staging: Introduce NVIDIA Tegra video decoder driver
  ARM: dts: tegra20: Add video decoder node
  ARM: defconfig: tegra: Enable Video Decoder driver

Vladimir Zapolskiy (1):
  ARM: tegra: Add device tree node to describe IRAM

 .../devicetree/bindings/media/nvidia,tegra-vde.txt |   55 +
 arch/arm/boot/dts/tegra114.dtsi                    |    8 +
 arch/arm/boot/dts/tegra124.dtsi                    |    8 +
 arch/arm/boot/dts/tegra20.dtsi                     |   35 +
 arch/arm/boot/dts/tegra30.dtsi                     |    8 +
 arch/arm/configs/tegra_defconfig                   |    2 +-
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/tegra-vde/Kconfig                  |    7 +
 drivers/staging/tegra-vde/Makefile                 |    1 +
 drivers/staging/tegra-vde/TODO                     |    5 +
 drivers/staging/tegra-vde/uapi.h                   |  101 ++
 drivers/staging/tegra-vde/vde.c                    | 1209 ++++++++++++++++++++
 13 files changed, 1441 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
 create mode 100644 drivers/staging/tegra-vde/Kconfig
 create mode 100644 drivers/staging/tegra-vde/Makefile
 create mode 100644 drivers/staging/tegra-vde/TODO
 create mode 100644 drivers/staging/tegra-vde/uapi.h
 create mode 100644 drivers/staging/tegra-vde/vde.c

-- 
2.14.2
