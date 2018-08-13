Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47027 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbeHMRdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:33:05 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 00/14] staging: media: tegra-vdea: Add Tegra124 support
Date: Mon, 13 Aug 2018 16:50:13 +0200
Message-Id: <20180813145027.16346-1-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

Hi,

this set of patches perform a bit of cleanup and extend support to the
VDE implementation found on Tegra114 and Tegra124. This requires adding
handling for a clock and a reset for the BSEV block that is separate
from the main VDE block. The new VDE revision also supports reference
picture marking, which requires that the BSEV writes out some related
data to a memory location. Since the supported tiling layouts have been
changed in Tegra124, which supports only block-linear and no pitch-
linear layouts, a new way is added to request a specific layout for the
decoded frames. Both of the above changes require breaking the ABI to
accomodate for the new data in the custom IOCTL.

Finally this set also adds support for dealing with an IOMMU, which
makes it more convenient to deal with imported buffers since they no
longer need to be physically contiguous.

Userspace changes for the updated ABI are available here:

	https://cgit.freedesktop.org/~tagr/libvdpau-tegra/commit/

Mauro, I'm sending the device tree changes as part of the series for
completeness, but I expect to pick those up into the Tegra tree once
this has been reviewed and you've applied the driver changes.

Thanks,
Thierry

Thierry Reding (14):
  staging: media: tegra-vde: Support BSEV clock and reset
  staging: media: tegra-vde: Support reference picture marking
  staging: media: tegra-vde: Prepare for interlacing support
  staging: media: tegra-vde: Use DRM/KMS framebuffer modifiers
  staging: media: tegra-vde: Properly mark invalid entries
  staging: media: tegra-vde: Print out invalid FD
  staging: media: tegra-vde: Add some clarifying comments
  staging: media: tegra-vde: Track struct device *
  staging: media: tegra-vde: Add IOMMU support
  staging: media: tegra-vde: Keep VDE in reset when unused
  ARM: tegra: Enable VDE on Tegra124
  ARM: tegra: Add BSEV clock and reset for VDE on Tegra20
  ARM: tegra: Add BSEV clock and reset for VDE on Tegra30
  ARM: tegra: Enable SMMU for VDE on Tegra124

 arch/arm/boot/dts/tegra124.dtsi             |  42 ++
 arch/arm/boot/dts/tegra20.dtsi              |  10 +-
 arch/arm/boot/dts/tegra30.dtsi              |  10 +-
 drivers/staging/media/tegra-vde/tegra-vde.c | 528 +++++++++++++++++---
 drivers/staging/media/tegra-vde/uapi.h      |   6 +-
 5 files changed, 511 insertions(+), 85 deletions(-)

-- 
2.17.0
