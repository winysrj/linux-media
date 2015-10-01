Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37131 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbbJAMFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 08:05:13 -0400
Received: by wicfx3 with SMTP id fx3so25076406wic.0
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2015 05:05:12 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	mchehab@osg.samsung.com
Cc: laurent.pinchart@ideasonboard.com, j.anaszewski@samsung.com,
	kamil@wypas.org, sergei.shtylyov@cogentembedded.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 2/2] V4L2: platform: rcar_jpu: switch off clock on release later
Date: Thu,  1 Oct 2015 15:03:32 +0300
Message-Id: <1443701012-20730-3-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1443701012-20730-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1443701012-20730-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Give JPU peripheral chance to finish current job.
Don't switch off clock until context release.

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
 drivers/media/platform/rcar_jpu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 039bbbc..aa327e6 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1296,17 +1296,17 @@ static int jpu_release(struct file *file)
 	struct jpu *jpu = video_drvdata(file);
 	struct jpu_ctx *ctx = fh_to_ctx(file->private_data);
 
-	mutex_lock(&jpu->mutex);
-	if (--jpu->ref_count == 0)
-		clk_disable_unprepare(jpu->clk);
-	mutex_unlock(&jpu->mutex);
-
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 
+	mutex_lock(&jpu->mutex);
+	if (--jpu->ref_count == 0)
+		clk_disable_unprepare(jpu->clk);
+	mutex_unlock(&jpu->mutex);
+
 	return 0;
 }
 
-- 
2.5.1

