Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:2434 "EHLO
        mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751334AbdHELMo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 07:12:44 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] [media] media: blackfin: bfin_capture: constify vb2_ops structures
Date: Sat,  5 Aug 2017 12:47:11 +0200
Message-Id: <1501930033-18249-5-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/platform/blackfin/bfin_capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 294d696..41f1791 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -375,7 +375,7 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 	}
 }
 
-static struct vb2_ops bcap_video_qops = {
+static const struct vb2_ops bcap_video_qops = {
 	.queue_setup            = bcap_queue_setup,
 	.buf_prepare            = bcap_buffer_prepare,
 	.buf_cleanup            = bcap_buffer_cleanup,
