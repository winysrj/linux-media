Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33339 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2ILPCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:02:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH v5 0/13] Initial i.MX5/CODA7 support for the CODA driver
Date: Wed, 12 Sep 2012 17:02:25 +0200
Message-Id: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches contain initial firmware loading and encoding support for the
CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some multi-instance
issues.

Changes since v4:
 - Added Javier's Tested/Reviewed/Acked-by.
 - Fixed menu_skip_mask for V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE v4l2_ctrl.
 - Dropped the ARM patches, those should not go through the media tree.
 - Dropped the 1080p frame size limit patch for now.

I'll add support for larger than PAL sized frames properly in the next patch
series, together with decoder support for i.MX5/CODA7 and i.MX6/CODA960.

regards
Philipp

---
 drivers/media/platform/Kconfig |    3 +-
 drivers/media/platform/coda.c  |  422 +++++++++++++++++++++++++++++-----------
 drivers/media/platform/coda.h  |   30 ++-
 3 files changed, 337 insertions(+), 118 deletions(-)

