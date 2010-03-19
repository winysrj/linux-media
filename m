Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60480 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0CSJmz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 05:42:55 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, m-karicheri2@ti.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [Resubmit: PATCH-V6 0/2] OMAP3: Add V4L2 display driver support
Date: Fri, 19 Mar 2010 15:12:47 +0530
Message-Id: <1268991769-7368-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Refreshed on top of latest linuxtv/master repository and
resubmitting the patch series again.

Please note that this patch is dependent on patch which add "ti-media"
directory (submitted earlier to this patch series).

Vaibhav Hiremath (2):
  OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2
  OMAP2/3: Add V4L2 DSS driver support in device.c

 arch/arm/mach-omap2/devices.c               |   28 +
 drivers/media/video/ti-media/Kconfig        |   12 +
 drivers/media/video/ti-media/Makefile       |    4 +
 drivers/media/video/ti-media/omap_vout.c    | 2655 +++++++++++++++++++++++++++
 drivers/media/video/ti-media/omap_voutdef.h |  148 ++
 drivers/media/video/ti-media/omap_voutlib.c |  258 +++
 drivers/media/video/ti-media/omap_voutlib.h |   34 +
 7 files changed, 3139 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/ti-media/omap_vout.c
 create mode 100644 drivers/media/video/ti-media/omap_voutdef.h
 create mode 100644 drivers/media/video/ti-media/omap_voutlib.c
 create mode 100644 drivers/media/video/ti-media/omap_voutlib.h

