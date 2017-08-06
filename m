Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:49372
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751272AbdHFIu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Aug 2017 04:50:57 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] [media] V4L2: platform: rcar_jpu: constify v4l2_m2m_ops structures
Date: Sun,  6 Aug 2017 10:25:13 +0200
Message-Id: <1502007921-22968-5-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1502007921-22968-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1502007921-22968-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_m2m_ops structures are only passed as the only
argument to v4l2_m2m_init, which is declared as const.
Thus the v4l2_m2m_ops structures themselves can be const.

Done with the help of Coccinelle.

// <smpl>
@r disable optional_qualifier@
identifier i;
position p;
@@
static struct v4l2_m2m_ops i@p = { ... };

@ok1@
identifier r.i;
position p;
@@
v4l2_m2m_init(&i@p)

@bad@
position p != {r.p,ok1.p};
identifier r.i;
struct v4l2_m2m_ops e;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct v4l2_m2m_ops i = { ... };
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/rcar_jpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index d1746ec..070bac3 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1506,7 +1506,7 @@ static void jpu_job_abort(void *priv)
 		jpu_cleanup(ctx, true);
 }
 
-static struct v4l2_m2m_ops jpu_m2m_ops = {
+static const struct v4l2_m2m_ops jpu_m2m_ops = {
 	.device_run	= jpu_device_run,
 	.job_ready	= jpu_job_ready,
 	.job_abort	= jpu_job_abort,
