Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57936 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbcEML4L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 07:56:11 -0400
Date: Fri, 13 May 2016 08:56:04 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Junghak Sung <jh1009.sung@samsung.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [PATCH] media: v4l-utils: dvbv5: Streaming I/O for DVB
Message-ID: <20160513085604.1f662135@recife.lan>
In-Reply-To: <1444125542-1256-3-git-send-email-jh1009.sung@samsung.com>
References: <1444125542-1256-1-git-send-email-jh1009.sung@samsung.com>
	<1444125542-1256-3-git-send-email-jh1009.sung@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 06 Oct 2015 18:59:02 +0900
Junghak Sung <jh1009.sung@samsung.com> escreveu:

> Add a new scenario to use streaming I/O for TS recording.
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>


Due to some changes that happened after the VB2 split changes got merged,
this patch doesn't compile anymore.

The enclosed diff should make it build yet.

I intend to fold it with the original patch and do some tests,
in order to make this work merged some day upstream.

Regards,
Mauro

diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 1a2dc5516c4e..5b1bcc80880f 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -27,7 +27,7 @@ module_param(vb2_debug, int, 0644);
 			pr_info("vb2: %s: " fmt, __func__, ## arg); \
 	} while (0)
 
-static int _queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
+static int _queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -120,7 +120,7 @@ static const struct vb2_ops dvb_vb2_qops = {
 	.wait_finish		= _dmxdev_lock,
 };
 
-static int _fill_dmx_buffer(struct vb2_buffer *vb, void *pb)
+static void _fill_dmx_buffer(struct vb2_buffer *vb, void *pb)
 {
 	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct dmx_buffer *b = pb;
@@ -131,8 +131,6 @@ static int _fill_dmx_buffer(struct vb2_buffer *vb, void *pb)
 	b->offset = vb->planes[0].m.offset;
 	memset(b->reserved, 0, sizeof(b->reserved));
 	dprintk(3, "[%s]\n", ctx->name);
-
-	return 0;
 }
 
 static int _fill_vb2_buffer(struct vb2_buffer *vb,
@@ -335,14 +333,7 @@ int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req)
 
 int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
-	int ret;
-
-	ret = vb2_core_querybuf(&ctx->vb_q, b->index, b);
-	if (ret) {
-		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
-				b->index, ret);
-		return ret;
-	}
+	vb2_core_querybuf(&ctx->vb_q, b->index, b);
 	dprintk(3, "[%s] index=%d\n", ctx->name, b->index);
 
 	return 0;
@@ -384,7 +375,7 @@ int dvb_vb2_dqbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
 	int ret;
 
-	ret = vb2_core_dqbuf(&ctx->vb_q, b, ctx->nonblocking);
+	ret = vb2_core_dqbuf(&ctx->vb_q, NULL, b, ctx->nonblocking);
 	if (ret) {
 		dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
 		return ret;
