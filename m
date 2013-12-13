Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65176 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3LMFMw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 00:12:52 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, mark.rutland@arm.com,
	shaik.ameer@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v10 0/2] Exynos5 Camera driver
Date: Fri, 13 Dec 2013 10:42:41 +0530
Message-Id: <1386911563-26236-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is part of Exynos5 IS driver series with review comments from Mark Rutland
addressed for media device driver DT binding part. Only the media driver part
of the full series is included in this patchset.

Changes from v9
---------------
- Addressed review comments from Mark Rutland
http://www.spinics.net/lists/devicetree/msg11550.html

Shaik Ameer Basha (2):
  [media] exynos5-is: Adds DT binding documentation
  [media] exynos5-is: Add media device driver for exynos5 SoCs camera
    subsystem

 .../bindings/media/exynos5250-camera.txt           |  136 +++
 drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1211 ++++++++++++++++++++
 drivers/media/platform/exynos5-is/exynos5-mdev.h   |  126 ++
 3 files changed, 1473 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5250-camera.txt
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h

-- 
1.7.9.5

