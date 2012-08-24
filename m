Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49274 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655Ab2HXQSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 12:18:07 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 0/12] Initial i.MX5/CODA7 support for the CODA driver 
Date: Fri, 24 Aug 2012 18:17:46 +0200
Message-Id: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches contain initial firmware loading and encoding support for the
CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some multi-instance
issues.

regards
Philipp

---
 arch/arm/boot/dts/imx51.dtsi        |    6 +++++
 arch/arm/boot/dts/imx53.dtsi        |    7 ++++++
 arch/arm/mach-imx/clk-imx51-imx53.c |    4 +--
 drivers/media/video/Kconfig         |    3 ++-
 drivers/media/video/coda.c          |  367 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------
 drivers/media/video/coda.h          |   21 +++++++++++++---
 6 files changed, 305 insertions(+), 103 deletions(-)

