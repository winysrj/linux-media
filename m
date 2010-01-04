Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49293 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0ADOmO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 09:42:14 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl, tony@atomide.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/2] OMAP3: Add V4L2 display driver support
Date: Mon,  4 Jan 2010 20:12:07 +0530
Message-Id: <1262616129-23373-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

This series of patch-set adds support for V4L2 display driver
ontop of DSS2 framework.

Please note that this patch is dependent on patch which add
"ti-media" directory (submitted earlier to this patch series)

Vaibhav Hiremath (2):
  OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2
  OMAP2/3: Add V4L2 DSS driver support in device.c

 arch/arm/plat-omap/devices.c                |   29 +
 drivers/media/video/ti-media/Kconfig        |   10 +
 drivers/media/video/ti-media/Makefile       |    4 +
 drivers/media/video/ti-media/omap_vout.c    | 2654 +++++++++++++++++++++++++++
 drivers/media/video/ti-media/omap_voutdef.h |  148 ++
 drivers/media/video/ti-media/omap_voutlib.c |  258 +++
 drivers/media/video/ti-media/omap_voutlib.h |   34 +
 7 files changed, 3137 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/ti-media/omap_vout.c
 create mode 100644 drivers/media/video/ti-media/omap_voutdef.h
 create mode 100644 drivers/media/video/ti-media/omap_voutlib.c
 create mode 100644 drivers/media/video/ti-media/omap_voutlib.h

