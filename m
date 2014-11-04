Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50285 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaKDK0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 05:26:46 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] MAINTAINERS: add maintainer for CODA video4linux mem2mem driver
Date: Tue,  4 Nov 2014 11:26:35 +0100
Message-Id: <1415096795-15440-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add myself as maintainer for the CODA V4L2 mem2mem driver.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c64271..34d3671 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2487,6 +2487,13 @@ F:	fs/coda/
 F:	include/linux/coda*.h
 F:	include/uapi/linux/coda*.h
 
+CODA V4L2 MEM2MEM DRIVER
+M:	Philipp Zabel <p.zabel@pengutronix.de>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/coda.txt
+F:	drivers/media/platform/coda/
+
 COMMON CLK FRAMEWORK
 M:	Mike Turquette <mturquette@linaro.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.1.1

