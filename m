Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:59840 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbcARQKs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:10:48 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1500W4LOXZND20@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:10:47 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] exynos4-is: Wait for 100us before opening sensor
Date: Mon, 18 Jan 2016 17:10:27 +0100
Message-id: <1453133427-20793-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133427-20793-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133427-20793-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some user space use cases result in kernel hangup on the HIC_OPEN_SENSOR
command write. In case when a minimalistic application is used for setting
up the streaming, the hangups occur only occasionally. In case of GStreamer
use cases it is always the case.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 123772f..3f50856 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -631,6 +631,12 @@ static int fimc_is_hw_open_sensor(struct fimc_is *is,
 
 	fimc_is_mem_barrier();
 
+	/*
+	 * Some user space use cases hang up here without this
+	 * empirically chosen delay.
+	 */
+	udelay(100);
+
 	mcuctl_write(HIC_OPEN_SENSOR, is, MCUCTL_REG_ISSR(0));
 	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
 	mcuctl_write(sensor->drvdata->id, is, MCUCTL_REG_ISSR(2));
-- 
1.7.9.5

