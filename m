Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36984 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2HaIL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 04:11:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH v3 0/16] Initial i.MX5/CODA7 support for the CODA driver
Date: Fri, 31 Aug 2012 10:10:54 +0200
Message-Id: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches contain initial firmware loading and encoding support for the
CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some multi-instance
issues. Patches 13 and 14, touching files in arch/arm/*, are included for
illustration purposes.

Changes since v2:
 - Rebase onto media_tree.git staging/for_v3.7 branch.
 - Stop calling cancel_delayed_work in the coda_irq_handler.
 - Fix a memory leak in patch 09/16.
 - Add a patch to fix buffer sizes for userptr mode.
 - Add a patch to allow >PAL resolutions.

regards
Philipp

---
 arch/arm/boot/dts/imx51.dtsi        |    6 +
 arch/arm/boot/dts/imx53.dtsi        |    6 +
 arch/arm/mach-imx/clk-imx51-imx53.c |    4 +-
 drivers/media/platform/Kconfig      |    3 +-
 drivers/media/platform/coda.c       |  423 +++++++++++++++++++++++++----------
 drivers/media/platform/coda.h       |   33 ++-
 6 files changed, 348 insertions(+), 127 deletions(-)

