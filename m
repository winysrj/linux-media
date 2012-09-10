Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47334 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab2IJPaK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 11:30:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH v4 0/16] Initial i.MX5/CODA7 support for the CODA driver 
Date: Mon, 10 Sep 2012 17:29:44 +0200
Message-Id: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches contain initial firmware loading and encoding support for the
CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some multi-instance
issues. Patches 13 and 14, touching files in arch/arm/*, are included for
illustration purposes.

Changes since v3:
 - Remove iram_vaddr from struct coda_dev, and use temporary
   void __iomem *iram_vaddr instead.
 - Rename framebuffers array to internal_frames to avoid confusion with
   v4l2/vb2 frame buffers.
 - Add struct coda_dev *dev pointer in coda_start_streaming.
 - Call cancel_delayed_work in coda_stop_streaming and in coda_irq_handler.
 - Lock the device mutex in coda_timeout to avoid a race with coda_release.
 - Complete dev->done in coda_timeout.

regards
Philipp

---
 arch/arm/boot/dts/imx51.dtsi        |    6 +
 arch/arm/boot/dts/imx53.dtsi        |    6 +
 arch/arm/mach-imx/clk-imx51-imx53.c |    4 +-
 drivers/media/platform/Kconfig      |    3 +-
 drivers/media/platform/coda.c       |  433 +++++++++++++++++++++++++----------
 drivers/media/platform/coda.h       |   33 ++-
 6 files changed, 358 insertions(+), 127 deletions(-)

