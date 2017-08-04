Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:42617
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752453AbdHDMfS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 08:35:18 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] [media] cx231xx: constify videobuf_queue_ops structures
Date: Fri,  4 Aug 2017 14:09:46 +0200
Message-Id: <1501848588-22628-4-git-send-email-Julia.Lawall@lip6.fr>
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

In the first case, there is a second commented call to
videobuf_queue_sg_init with the structure as the second argument.  If that
code will be uncommented, the const will remain correct, because the second
parameter of that function is also const.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/cx231xx/cx231xx-417.c   |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 8d5eb99..d538fa4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1490,7 +1490,7 @@ static void bb_buf_release(struct videobuf_queue *q,
 	free_buffer(q, buf);
 }
 
-static struct videobuf_queue_ops cx231xx_qops = {
+static const struct videobuf_queue_ops cx231xx_qops = {
 	.buf_setup    = bb_buf_setup,
 	.buf_prepare  = bb_buf_prepare,
 	.buf_queue    = bb_buf_queue,
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index f67f868..179b848 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -859,7 +859,7 @@ static void buffer_release(struct videobuf_queue *vq,
 	free_buffer(vq, buf);
 }
 
-static struct videobuf_queue_ops cx231xx_video_qops = {
+static const struct videobuf_queue_ops cx231xx_video_qops = {
 	.buf_setup = buffer_setup,
 	.buf_prepare = buffer_prepare,
 	.buf_queue = buffer_queue,
