Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10125 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbbKKTut (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 14:50:49 -0500
From: Bryan Wu <pengw@nvidia.com>
To: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<treding@nvidia.com>, <linux-tegra@vger.kernel.org>
CC: <ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <bmurthyv@nvidia.com>
Subject: [PATCH 0/3 RFC v5] media: platform: add NVIDIA Tegra VI driver
Date: Wed, 11 Nov 2015 11:50:45 -0800
Message-ID: <1447271448-30056-1-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset add and enable V4L2 driver for latest NVIDIA Tegra
Video Input hardware controller.

It's based on the staging/work branch of Thierry Reding Tegra
upstream kernel github repo, which is based on 4.3.0-next-20151106.
(https://github.com/thierryreding/linux/tree/staging/work)

v5:
  - Introduce 2 kthreads for capture
    Use one kthread to start capture a frame and wait for next frame
    start. Before waiting, it will move the current buffer to another queue
    which will be handled by the second kthread.
    
    The second kthread (capture_done) will wait for memory output done
    sync point event and hand over the buffer to videobuffer2 framework as
    capture done.

  - Fix building issue after upstream V4L2 API changed

  - Fix one potential race condition
    Increase syncpoint max value before arming syncshot capture

  - Remove freezer in kthread since it's problematic according latest
    discussion in 2015 Kernel Summit
  - Verify with a real sensor module (OV5693)

v4:
  - fix all the coding style issues
  - solve all the minor problems pointed out by Hans Verkuil

v3:
  - rework on the locking code related to kthread
  - remove some dead code
  - other fixes

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

 .../display/tegra/nvidia,tegra20-host1x.txt        | 211 ++++-
 arch/arm64/boot/dts/nvidia/tegra210-p2571.dts      |   8 +
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           | 174 ++++-
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/tegra/Kconfig               |  10 +
 drivers/media/platform/tegra/Makefile              |   3 +
 drivers/media/platform/tegra/tegra-channel.c       | 849 +++++++++++++++++++++
 drivers/media/platform/tegra/tegra-core.c          | 254 ++++++
 drivers/media/platform/tegra/tegra-core.h          | 162 ++++
 drivers/media/platform/tegra/tegra-csi.c           | 560 ++++++++++++++
 drivers/media/platform/tegra/tegra-vi.c            | 732 ++++++++++++++++++
 drivers/media/platform/tegra/tegra-vi.h            | 213 ++++++
 13 files changed, 3172 insertions(+), 7 deletions(-)
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

