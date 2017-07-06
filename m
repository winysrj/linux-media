Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.58.11]:32967 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751873AbdGFU4y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 16:56:54 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 20429400F2CD8
        for <linux-media@vger.kernel.org>; Thu,  6 Jul 2017 15:35:54 -0500 (CDT)
Date: Thu, 6 Jul 2017 15:35:53 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] davinci: vpif_display: constify vb2_ops structure
Message-ID: <20170706203553.GA15159@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for vb2_ops structures that are only stored in the ops field of a
vb2_queue structure. That field is declared const, so vb2_ops structures
that have this property can be declared as const also.

This issue was detected using Coccinelle and the following semantic patch:

@r disable optional_qualifier@
identifier i;
position p;
@@
static struct vb2_ops i@p = { ... };

@ok@
identifier r.i;
struct vb2_queue e;
position p;
@@
e.ops = &i@p;

@bad@
position p != {r.p,ok.p};
identifier r.i;
struct vb2_ops e;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
struct vb2_ops i = { ... };

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/platform/davinci/vpif_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index b5ac6ce..1a494d3 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -290,7 +290,7 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
-static struct vb2_ops video_qops = {
+static const struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
-- 
2.5.0
