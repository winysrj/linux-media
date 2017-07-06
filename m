Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.186.5]:49552 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751887AbdGFU2O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 16:28:14 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 63FA74359A329
        for <linux-media@vger.kernel.org>; Thu,  6 Jul 2017 15:05:20 -0500 (CDT)
Date: Thu, 6 Jul 2017 15:05:17 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] stm32-dcmi: constify vb2_ops structure
Message-ID: <20170706200517.GA5886@embeddedgus>
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
 drivers/media/platform/stm32/stm32-dcmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 83d32a5..24ef888 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -662,7 +662,7 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 		dcmi->errors_count, dcmi->buffers_count);
 }
 
-static struct vb2_ops dcmi_video_qops = {
+static const struct vb2_ops dcmi_video_qops = {
 	.queue_setup		= dcmi_queue_setup,
 	.buf_init		= dcmi_buf_init,
 	.buf_prepare		= dcmi_buf_prepare,
-- 
2.5.0
