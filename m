Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:14580 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaDHOiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 10:38:22 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: kishon@ti.com, t.figa@samsung.com, kyungmin.park@samsung.com,
	sylvester.nawrocki@gmail.com, robh+dt@kernel.org,
	inki.dae@samsung.com, rahul.sharma@samsung.com,
	grant.likely@linaro.org, kgene.kim@samsung.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 0/3] phy: Add exynos-simple-phy driver
Date: Tue, 08 Apr 2014 16:37:33 +0200
Message-id: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

The Samsung SoCs from Exynos family are enhanced with a bunch of devices that
provide functionality of a physical layer for interfaces like USB, HDMI, SATA,
etc. They are controlled by a simple interface, often a single bit that enables
and/or resets the physical layer.

An IP driver should to control such a controller in an abstract manner.
Therefore, such 'enablers' were implemented as clocks in older versions of
Linux kernel.  With the dawn of PHY subsystems, PHYs become a natural way of
exporting the 'enabler' functionality to drivers.  However, there is an
unexpected consequence. Some of those 1-bit PHYs were implemented as separate
drivers.  This means that one has to create a struct device, struct phy, its
phy provider and 100-150 lines of driver code to basically set one bit.

The DP phy driver is a good example:
https://lkml.org/lkml/2013/7/18/53

And simple-phy RFC (shares only driver code but not other resources):
https://lkml.org/lkml/2013/10/21/313

To avoid waste of resources I propose to create all such 1-bit phys from Exynos
SoC using a single device, driver and phy provider.

This patchset contains a proposed solution.

All comment are welcome.

Hopefully in future the functionality introduced by this patch may be merged
into a larger Power Management Unit (PMU) gluer driver.  On Samsusng SoC , the
PMU part contains a number of register barely linked to power management (like
clock gating, clock dividers, CPU resetting, etc.).  It may be tempting to
create a hybrid driver that export clocks/phys/etc that are controlled by PMU
unit.

Alternative solutions might be:
* exporting a regmap to the IP driver and allow the driver to control the PHY layer
  like in the patch:
  http://thread.gmane.org/gmane.linux.kernel.samsung-soc/28617/focus=28648

* create a dedicated power domain for hdmiphy

Regards,
Tomasz Stanislawski

Changelog:
v2:
	* rename to exynos-simple-phy
	* fix usage of devm_ioremap()
	* add documentation for DT bindings
	* add patches to client drivers

v1: initial version

Tomasz Stanislawski (3):
  phy: Add exynos-simple-phy driver
  drm: exynos: hdmi: use hdmiphy as PHY
  s5p-tv: hdmi: use hdmiphy as PHY

 .../devicetree/bindings/phy/samsung-phy.txt        |   24 +++
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   11 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   11 +-
 drivers/phy/Kconfig                                |    5 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/exynos-simple-phy.c                    |  154 ++++++++++++++++++++
 6 files changed, 196 insertions(+), 10 deletions(-)
 create mode 100644 drivers/phy/exynos-simple-phy.c

-- 
1.7.9.5

