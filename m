Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51608 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0DAJ6U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 05:58:20 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, mchehab@redhat.com,
	linux-omap@vger.kernel.org, tony@atomide.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [RESEND: PATCH-V6 0/2] OMAP2/3: Add V4L2 display driver support
Date: Thu,  1 Apr 2010 15:27:58 +0530
Message-Id: <1270115880-21404-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

The previous patch submission had a dependancy on "ti-media" directory patch,
and since we were not having any conclusion on that patch, I have created
"omap" directory (device specific name) and moved V4L2 driver
(as of now applicable to OMAP2/3 devices) to this new
directory so that atleast v4l2 display driver can be unblocked and get
merged to main-line.

Vaibhav Hiremath (2):
  OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2
  OMAP2/3: Add V4L2 DSS driver support in device.c

 arch/arm/mach-omap2/devices.c           |   28 +
 drivers/media/video/Kconfig             |    2 +
 drivers/media/video/Makefile            |    2 +
 drivers/media/video/omap/Kconfig        |   11 +
 drivers/media/video/omap/Makefile       |    7 +
 drivers/media/video/omap/omap_vout.c    | 2655 +++++++++++++++++++++++++++++++
 drivers/media/video/omap/omap_voutdef.h |  148 ++
 drivers/media/video/omap/omap_voutlib.c |  258 +++
 drivers/media/video/omap/omap_voutlib.h |   34 +
 9 files changed, 3145 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/omap/Kconfig
 create mode 100644 drivers/media/video/omap/Makefile
 create mode 100644 drivers/media/video/omap/omap_vout.c
 create mode 100644 drivers/media/video/omap/omap_voutdef.h
 create mode 100644 drivers/media/video/omap/omap_voutlib.c
 create mode 100644 drivers/media/video/omap/omap_voutlib.h

