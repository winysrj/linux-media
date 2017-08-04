Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:42617
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752184AbdHDMfQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 08:35:16 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Andy Walls <awalls@md.metrocast.net>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] [media] cx18: constify videobuf_queue_ops structures
Date: Fri,  4 Aug 2017 14:09:44 +0200
Message-Id: <1501848588-22628-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1501848588-22628-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1501848588-22628-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These videobuf_queue_ops structures are only passed as the second
argument to videobuf_queue_vmalloc_init, which is declared as const.
Thus the videobuf_queue_ops structures themselves can be const.

Done with the help of Coccinelle.

// <smpl>
@r disable optional_qualifier@
identifier i;
position p;
@@
static struct videobuf_queue_ops i@p = { ... };

@ok1@
identifier r.i;
expression e1;
position p;
@@
videobuf_queue_vmalloc_init(e1,&i@p,...)

@bad@
position p != {r.p,ok1.p};
identifier r.i;
struct videobuf_queue_ops e;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct videobuf_queue_ops i = { ... };
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/cx18/cx18-streams.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index 3c45e007..81d06c1 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -240,7 +240,7 @@ static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	list_add_tail(&buf->vb.queue, &s->vb_capture);
 }
 
-static struct videobuf_queue_ops cx18_videobuf_qops = {
+static const struct videobuf_queue_ops cx18_videobuf_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
