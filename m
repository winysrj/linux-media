Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55809 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab1KDOUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:11 -0400
Date: Fri, 04 Nov 2011 15:20:01 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 7/8] s5p-fimc: Fail driver probing when sensor configuration is
 wrong
In-reply-to: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320416402-22883-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a sensor with MIPI-CSI interface is attached through platform
data definition and the MIPI-CSI receiver is not selected in kernel
configuration s5p-fimc driver probe() will now succeed, issuing only
a warning. It was done this way to allow the driver to work even if
system configuration is not exactly right.

Instead make the driver's probe() fail if a MIPI-CSI sensor was
requested but s5p-csis module is not present.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index fc81f6f..615c862 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -514,7 +514,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 			if (WARN(csis == NULL,
 				 "MIPI-CSI interface specified "
 				 "but s5p-csis module is not loaded!\n"))
-				continue;
+				return -EINVAL;
 
 			ret = media_entity_create_link(&sensor->entity, 0,
 					      &csis->entity, CSIS_PAD_SINK,
-- 
1.7.7.1

