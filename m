Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44508 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab2EYXP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 19:15:27 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so1025024vbb.19
        for <linux-media@vger.kernel.org>; Fri, 25 May 2012 16:15:26 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: kernel@pengutronix.de
Cc: shawn.guo@freescale.com,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>
Subject: [PATCH 08/15] video: mx2_emmaprp: Use clk_prepare_enable/clk_disable_unprepare
Date: Fri, 25 May 2012 20:14:49 -0300
Message-Id: <1337987696-31728-8-git-send-email-festevam@gmail.com>
In-Reply-To: <1337987696-31728-1-git-send-email-festevam@gmail.com>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Prepare the clock before enabling it.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx2_emmaprp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 0bd5815..b364557 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -800,7 +800,7 @@ static int emmaprp_open(struct file *file)
 		return ret;
 	}
 
-	clk_enable(pcdev->clk_emma);
+	clk_prepare_enable(pcdev->clk_emma);
 	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[1];
 	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
 
@@ -816,7 +816,7 @@ static int emmaprp_release(struct file *file)
 
 	dprintk(pcdev, "Releasing instance %p\n", ctx);
 
-	clk_disable(pcdev->clk_emma);
+	clk_disable_unprepare(pcdev->clk_emma);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	kfree(ctx);
 
-- 
1.7.1

