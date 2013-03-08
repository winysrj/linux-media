Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:15125 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517Ab3CHQqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 11:46:24 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJC00IWEP98S540@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:23 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MJC00BU5P8ZM870@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:23 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v5 0/5] Device tree support for Exynos SoC camera subsystem
Date: Fri, 08 Mar 2013 17:46:00 +0100
Message-id: <1362761166-5285-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
References: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Here is an updated version of my patch series adding device tree support
for the Samsung S5P/Exynos SoC series camera subsystem. Previous version
can be found at [1]. Still it doesn't include asynchronous subdev 
registration support as I have been focused on the Exynos4x12 SoC camera 
ISP driver recently.

Changes in this series are mostly addressed review comments from Stephen 
Warren. Thank you for taking time to review!

Detailed changes are listed in each patch.

[1] http://www.spinics.net/lists/arm-kernel/msg222071.html

Thanks,
Sylwester

Sylwester Nawrocki (6):
  s5p-csis: Add device tree support
  s5p-fimc: Add device tree support for FIMC device driver
  s5p-fimc: Add device tree support for FIMC-LITE device driver
  s5p-fimc: Add device tree support for the media device driver
  s5p-fimc: Add device tree based sensors registration
  s5p-fimc: Use pinctrl API for camera ports configuration

 .../devicetree/bindings/media/exynos-fimc-lite.txt |   13 +
 .../devicetree/bindings/media/samsung-fimc.txt     |  186 ++++++++++
 .../bindings/media/samsung-mipi-csis.txt           |   80 +++++
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    6 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |  231 +++++++------
 drivers/media/platform/s5p-fimc/fimc-core.h        |   21 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   63 +++-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  358 +++++++++++++++++---
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   16 +
 drivers/media/platform/s5p-fimc/fimc-reg.c         |    6 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  160 +++++++--
 drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
 include/media/s5p_fimc.h                           |   17 +
 14 files changed, 957 insertions(+), 203 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-fimc.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-mipi-csis.txt

-- 
1.7.9.5

