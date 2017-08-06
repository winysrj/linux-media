Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:45144
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751179AbdHFIuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Aug 2017 04:50:55 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] [media] st-delta: constify v4l2_m2m_ops structures
Date: Sun,  6 Aug 2017 10:25:10 +0200
Message-Id: <1502007921-22968-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/platform/sti/delta/delta-v4l2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index ff9850e..b2dc3d2 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -1095,7 +1095,7 @@ static int delta_job_ready(void *priv)
 }
 
 /* mem-to-mem ops */
-static struct v4l2_m2m_ops delta_m2m_ops = {
+static const struct v4l2_m2m_ops delta_m2m_ops = {
 	.device_run     = delta_device_run,
 	.job_ready	= delta_job_ready,
 	.job_abort      = delta_job_abort,
