Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58294 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab0FCGmU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 02:42:20 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m-karicheri2@ti.com,
	linux-omap@vger.kernel.org, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V1 0/2] Add support for AM3517 VPFE Capture module
Date: Thu,  3 Jun 2010 12:11:59 +0530
Message-Id: <1275547321-31406-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

AM3517 uses similar VPFE-CCDC hardware IP as in Davinci, so reusing the driver.
Currently the davinci driver is hardly tied with ARCH_DAVINCI, which was
limiting AM3517 to reuse the driver. So created seperate Kconfig file for
davinci and added AM3517 to dependancy.

Also added board hook up code to board-am3517evm.c file.

Changes from last version:
	- Typo mistake in board-am3517evm.c file fixed
	- Added DM365 platform support in Kconfig help option

Vaibhav Hiremath (2):
  Davinci: Create seperate Kconfig file for davinci devices
  AM3517: Add VPFE Capture driver support to board file

 arch/arm/mach-omap2/board-am3517evm.c |  161 +++++++++++++++++++++++++++++++++
 drivers/media/video/Kconfig           |   61 +------------
 drivers/media/video/Makefile          |    2 +-
 drivers/media/video/davinci/Kconfig   |   93 +++++++++++++++++++
 4 files changed, 256 insertions(+), 61 deletions(-)
 create mode 100644 drivers/media/video/davinci/Kconfig

