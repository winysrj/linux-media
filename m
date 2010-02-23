Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:39766 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0BWJ1Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 04:27:24 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V6 0/2] OMAP3: Add V4L2 display driver support
Date: Tue, 23 Feb 2010 14:57:17 +0530
Message-Id: <1266917239-7094-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

This is 6th Version of patch-set, adds support for V4L2 display driver
ontop of DSS2 framework.

Please note that this patch is dependent on patch which add
"ti-media" directory (submitted earlier to this patch series).


Vaibhav Hiremath (2):
  OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2
  OMAP2/3: Add V4L2 DSS driver support in device.c

 arch/arm/plat-omap/devices.c                |   29 +
 drivers/media/video/ti-media/Kconfig        |   12 +
 drivers/media/video/ti-media/Makefile       |    4 +
 drivers/media/video/ti-media/omap_vout.c    | 2655 +++++++++++++++++++++++++++
 drivers/media/video/ti-media/omap_voutdef.h |  148 ++
 drivers/media/video/ti-media/omap_voutlib.c |  258 +++
 drivers/media/video/ti-media/omap_voutlib.h |   34 +
 7 files changed, 3140 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/ti-media/omap_vout.c
 create mode 100644 drivers/media/video/ti-media/omap_voutdef.h
 create mode 100644 drivers/media/video/ti-media/omap_voutlib.c
 create mode 100644 drivers/media/video/ti-media/omap_voutlib.h

