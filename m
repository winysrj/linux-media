Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48344 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2H1KyK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 06:54:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH v2 0/14] Initial i.MX5/CODA7 support for the CODA driver
Date: Tue, 28 Aug 2012 12:53:47 +0200
Message-Id: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches contain initial firmware loading and encoding support for the
CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some multi-instance
issues. The last two patches touching files in arch/arm/* are included for
illustration purposes.

Changes since v1:
 - Use iram_alloc/iram_free instead of the genalloc API.
 - Add a patch to add byte size slice limit control.
 - Add a patch to enable flipping controls.
 - Do not allocate extra frame buffer space for CODA7 on i.MX27.
 - Removed JPEG from the coda7_formats, will be added again
   with the JPEG support patch.

regards
Philipp

---
 arch/arm/boot/dts/imx51.dtsi        |    6 +
 arch/arm/boot/dts/imx53.dtsi        |    6 +
 arch/arm/mach-imx/clk-imx51-imx53.c |    4 +-
 drivers/media/video/Kconfig         |    3 +-
 drivers/media/video/coda.c          |  399 ++++++++++++++++++++++++++---------
 drivers/media/video/coda.h          |   30 ++-
 6 files changed, 338 insertions(+), 110 deletions(-)

