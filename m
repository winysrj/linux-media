Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15376 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbbHUAwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 20:52:22 -0400
From: Bryan Wu <pengw@nvidia.com>
To: <hansverk@cisco.com>, <linux-media@vger.kernel.org>
CC: <ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<treding@nvidia.com>, <wenjiaz@nvidia.com>, <davidw@nvidia.com>,
	<gfitzer@nvidia.com>
Subject: [PATCH RFC 0/2] NVIDIA Tegra VI V4L2 driver 
Date: Thu, 20 Aug 2015 17:51:35 -0700
Message-ID: <1440118300-32491-1-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NVIDIA Tegra SoC includes a Video Input controller, which can talk
with external camera sensors.

This patch set is still under development, since it's based on some
out of tree Tegra patches. And media controller part still needs some
rework after upstream finalize the MC redesign work.

Currently it's tested with Tegra X1 built-in test pattern generator.

Bryan Wu (2):
  [media] v4l: tegra: Add NVIDIA Tegra VI driver
  ARM64: add tegra-vi support in T210 device-tree

 arch/arm64/boot/dts/nvidia/tegra210-p2571-e01.dts |    8 +
 arch/arm64/boot/dts/nvidia/tegra210.dtsi          |   13 +
 drivers/media/platform/Kconfig                    |    1 +
 drivers/media/platform/Makefile                   |    2 +
 drivers/media/platform/tegra/Kconfig              |    9 +
 drivers/media/platform/tegra/Makefile             |    3 +
 drivers/media/platform/tegra/tegra-channel.c      | 1074 +++++++++++++++++++++
 drivers/media/platform/tegra/tegra-core.c         |  295 ++++++
 drivers/media/platform/tegra/tegra-core.h         |  134 +++
 drivers/media/platform/tegra/tegra-vi.c           |  585 +++++++++++
 drivers/media/platform/tegra/tegra-vi.h           |  224 +++++
 include/dt-bindings/media/tegra-vi.h              |   35 +
 12 files changed, 2383 insertions(+)
 create mode 100644 drivers/media/platform/tegra/Kconfig
 create mode 100644 drivers/media/platform/tegra/Makefile
 create mode 100644 drivers/media/platform/tegra/tegra-channel.c
 create mode 100644 drivers/media/platform/tegra/tegra-core.c
 create mode 100644 drivers/media/platform/tegra/tegra-core.h
 create mode 100644 drivers/media/platform/tegra/tegra-vi.c
 create mode 100644 drivers/media/platform/tegra/tegra-vi.h
 create mode 100644 include/dt-bindings/media/tegra-vi.h

-- 
2.1.4


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
