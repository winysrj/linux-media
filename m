Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18410 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbIPBfc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 21:35:32 -0400
From: Bryan Wu <pengw@nvidia.com>
To: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<treding@nvidia.com>
CC: <ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <gerrit2@nvidia.com>
Subject: [PATCH 0/3 RFC v2] media: platform: add NVIDIA Tegra VI driver
Date: Tue, 15 Sep 2015 18:35:28 -0700
Message-ID: <1442367331-20046-1-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset add and enable V4L2 driver for latest NVIDIA Tegra
Video Input hardware controller.

It's based on the staging/work branch of Thierry Reding Tegra
upstream kernel github repo, which is based on 4.2-rc1.
(https://github.com/thierryreding/linux/tree/staging/work) 

v2:
  - allocate kthread for each channel instead of workqueue
  - create tegra-csi as a separated V4L2 subdevice
  - define all the register bits needed in this driver
  - add device tree binding document
  - update things according to Hans and Thierry's review.

Bryan Wu (3):
  [media] v4l: tegra: Add NVIDIA Tegra VI driver
  ARM64: add tegra-vi support in T210 device-tree
  Documentation: DT bindings: add VI and CSI bindings

 .../bindings/gpu/nvidia,tegra20-host1x.txt         | 211 +++++-
 arch/arm64/boot/dts/nvidia/tegra210-p2571-e01.dts  |   8 +
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           | 174 ++++-
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/tegra/Kconfig               |  10 +
 drivers/media/platform/tegra/Makefile              |   3 +
 drivers/media/platform/tegra/tegra-channel.c       | 802 +++++++++++++++++++++
 drivers/media/platform/tegra/tegra-core.c          | 252 +++++++
 drivers/media/platform/tegra/tegra-core.h          | 162 +++++
 drivers/media/platform/tegra/tegra-csi.c           | 566 +++++++++++++++
 drivers/media/platform/tegra/tegra-vi.c            | 581 +++++++++++++++
 drivers/media/platform/tegra/tegra-vi.h            | 213 ++++++
 13 files changed, 2978 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/platform/tegra/Kconfig
 create mode 100644 drivers/media/platform/tegra/Makefile
 create mode 100644 drivers/media/platform/tegra/tegra-channel.c
 create mode 100644 drivers/media/platform/tegra/tegra-core.c
 create mode 100644 drivers/media/platform/tegra/tegra-core.h
 create mode 100644 drivers/media/platform/tegra/tegra-csi.c
 create mode 100644 drivers/media/platform/tegra/tegra-vi.c
 create mode 100644 drivers/media/platform/tegra/tegra-vi.h

-- 
2.1.4


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
