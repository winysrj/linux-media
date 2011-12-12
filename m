Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54571 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1LLRpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:10 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW3000C7QN3JX@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3003LFQN2H0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:55 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 11/14] m5mols: Do not reset the configured pixel format when
 unexpected
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-12-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize default pixel format in driver probe() rather than in
s_power handler. This also prevents resetting the configuration
applied before the device was powered on.

Acked-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_core.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 8a935a3..2f544cb 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -877,13 +877,6 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 		ret = m5mols_sensor_power(info, true);
 		if (!ret)
 			ret = m5mols_fw_start(sd);
-		if (ret)
-			return ret;
-
-		info->ffmt[M5MOLS_RESTYPE_MONITOR] =
-			m5mols_default_ffmt[M5MOLS_RESTYPE_MONITOR];
-		info->ffmt[M5MOLS_RESTYPE_CAPTURE] =
-			m5mols_default_ffmt[M5MOLS_RESTYPE_CAPTURE];
 		return ret;
 	}
 
@@ -1020,6 +1013,9 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 		goto out_me;
 	}
 	info->res_type = M5MOLS_RESTYPE_MONITOR;
+	info->ffmt[0] = m5mols_default_ffmt[0];
+	info->ffmt[1] =	m5mols_default_ffmt[1];
+
 	atomic_set(&info->irq_done, 0);
 
 	ret = m5mols_sensor_power(info, true);
-- 
1.7.8

