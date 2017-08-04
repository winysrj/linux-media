Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:46357
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752219AbdHDMfR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 08:35:17 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] [media] atomisp: constify videobuf_queue_ops structures
Date: Fri,  4 Aug 2017 14:09:45 +0200
Message-Id: <1501848588-22628-3-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index c151c84..d8cfed3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -643,14 +643,14 @@ static void atomisp_buf_release_output(struct videobuf_queue *vq,
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }
 
-static struct videobuf_queue_ops videobuf_qops = {
+static const struct videobuf_queue_ops videobuf_qops = {
 	.buf_setup	= atomisp_buf_setup,
 	.buf_prepare	= atomisp_buf_prepare,
 	.buf_queue	= atomisp_buf_queue,
 	.buf_release	= atomisp_buf_release,
 };
 
-static struct videobuf_queue_ops videobuf_qops_output = {
+static const struct videobuf_queue_ops videobuf_qops_output = {
 	.buf_setup	= atomisp_buf_setup_output,
 	.buf_prepare	= atomisp_buf_prepare_output,
 	.buf_queue	= atomisp_buf_queue_output,
