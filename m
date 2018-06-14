Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55328 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755269AbeFNPfv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:35:51 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 3/3] rcar_vpu: Drop unneeded job_ready
Date: Thu, 14 Jun 2018 12:34:05 -0300
Message-Id: <20180614153405.5697-4-ezequiel@collabora.com>
In-Reply-To: <20180614153405.5697-1-ezequiel@collabora.com>
References: <20180614153405.5697-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not required to implement job_ready().
Since this one is dummy, we can drop it.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/rcar_jpu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 10d24ddcea5f..a808258a4180 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1492,14 +1492,8 @@ static void jpu_device_run(void *priv)
 	spin_unlock_irqrestore(&ctx->jpu->lock, flags);
 }
 
-static int jpu_job_ready(void *priv)
-{
-	return 1;
-}
-
 static const struct v4l2_m2m_ops jpu_m2m_ops = {
 	.device_run	= jpu_device_run,
-	.job_ready	= jpu_job_ready,
 };
 
 /*
-- 
2.16.3
