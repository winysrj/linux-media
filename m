Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37291 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0DGKAu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 06:00:50 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m-karicheri2@ti.com, hverkuil@xs4all.nl,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V7] OMAP2/3: Add V4L2 display driver support
Date: Wed,  7 Apr 2010 15:30:29 +0530
Message-Id: <1270634430-5549-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Changes from last version (V6):
	- Fixed comments from Murali, Hans and Vladimir.
	- Also dropped board hook-up patch, since we can add it
	  once this patch goes in.
	  (Actually unnecessarily that patch is floating all
	   around with this patch.)
	  And anyway it has to go through linux-omap list.

 Tested-on:
 	- OMAP3EVM
	- AM3517EVM

Vaibhav Hiremath (1):
  OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2

 drivers/media/video/Kconfig             |    2 +
 drivers/media/video/Makefile            |    2 +
 drivers/media/video/omap/Kconfig        |   11 +
 drivers/media/video/omap/Makefile       |    7 +
 drivers/media/video/omap/omap_vout.c    | 2644 +++++++++++++++++++++++++++++++
 drivers/media/video/omap/omap_voutdef.h |  147 ++
 drivers/media/video/omap/omap_voutlib.c |  293 ++++
 drivers/media/video/omap/omap_voutlib.h |   34 +
 8 files changed, 3140 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/omap/Kconfig
 create mode 100644 drivers/media/video/omap/Makefile
 create mode 100644 drivers/media/video/omap/omap_vout.c
 create mode 100644 drivers/media/video/omap/omap_voutdef.h
 create mode 100644 drivers/media/video/omap/omap_voutlib.c
 create mode 100644 drivers/media/video/omap/omap_voutlib.h

