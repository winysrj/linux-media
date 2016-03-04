Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36306 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758765AbcCDUUa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 15:20:30 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 0/2] [media] exynos4-is: Trivial fixes for DT port/endpoint parse logic
Date: Fri,  4 Mar 2016 17:20:11 -0300
Message-Id: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series have two trivial fixes for issues that I noticed while
reading as a reference the driver's functions that parse the graph
port and endpoints nodes.

It was only compile tested because I don't have access to a Exynos4
hardware to test the DT parsing, but the patches are very simple.

Best regards,
Javier


Javier Martinez Canillas (2):
  [media] exynos4-is: Put node before s5pcsis_parse_dt() return error
  [media] exynos4-is: FIMC port parse should fail if there's no endpoint

 drivers/media/platform/exynos4-is/media-dev.c | 2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.5.0

