Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53862
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751930AbdHELMp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 07:12:45 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] [media] media: imx: capture: constify vb2_ops structures
Date: Sat,  5 Aug 2017 12:47:13 +0200
Message-Id: <1501930033-18249-7-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1501930033-18249-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1501930033-18249-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These vb2_ops structures are only stored in the ops field of a
vb2_queue structure, which is declared as const.  Thus the vb2_ops
structures themselves can be const.

Done with the help of Coccinelle.

// <smpl>
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
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/media/imx/imx-media-capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index ddab4c2..ea145ba 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -62,7 +62,7 @@ struct capture_priv {
 /* In bytes, per queue */
 #define VID_MEM_LIMIT	SZ_64M
 
-static struct vb2_ops capture_qops;
+static const struct vb2_ops capture_qops;
 
 /*
  * Video ioctls follow
@@ -503,7 +503,7 @@ static void capture_stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&priv->q_lock, flags);
 }
 
-static struct vb2_ops capture_qops = {
+static const struct vb2_ops capture_qops = {
 	.queue_setup	 = capture_queue_setup,
 	.buf_init        = capture_buf_init,
 	.buf_prepare	 = capture_buf_prepare,
