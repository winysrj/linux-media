Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36137 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbJBObc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 10:31:32 -0400
Received: by oibi136 with SMTP id i136so58792436oib.3
        for <linux-media@vger.kernel.org>; Fri, 02 Oct 2015 07:31:32 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Fri, 2 Oct 2015 16:31:12 +0200
Message-ID: <CAH-u=82892OHC6BzkB0z+Rc=ig7FiAZfOz6Y7WboNWq2+nxuZw@mail.gmail.com>
Subject: Coda encoder stop
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

I have tried to implement V4L2_ENC_CMD_STOP command in coda encoder
but can't make it work with gstreamer (I have modified my gst element
to use the correct command, based on your work on bug
https://bugzilla.gnome.org/show_bug.cgi?id=733864).

Here is what I have tried :

>From 1dd2f797b2b368d44c1a1bd992379c252e1b57e1 Mon Sep 17 00:00:00 2001
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Fri, 2 Oct 2015 11:18:27 +0200
Subject: [PATCH] coda: Add support for [try]encoder_cmd ioctl

This allows userspace to ask for the encoder to stop.
When last buffer is received it sends a EOS event.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
---
 drivers/media/platform/coda/coda-common.c | 58 ++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c
b/drivers/media/platform/coda/coda-common.c
index a4654e0..7dd7bd9 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -686,12 +686,23 @@ static int coda_qbuf(struct file *file, void *priv,
 static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
                       struct vb2_buffer *buf)
 {
-    struct vb2_queue *src_vq;
-
-    src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+    int ret = false;

-    return ((ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) &&
-        (buf->v4l2_buf.sequence == (ctx->qsequence - 1)));
+    if (ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) {
+        switch (ctx->inst_type) {
+        case CODA_INST_DECODER:
+            if (buf->v4l2_buf.sequence == (ctx->qsequence - 1))
+                ret = true;
+            break;
+        case CODA_INST_ENCODER:
+            if (buf->v4l2_buf.sequence == (ctx->osequence - 1))
+                ret = true;
+            break;
+        default:
+            break;
+        }
+    }
+    return ret;
 }

 void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_buffer *buf,
@@ -702,6 +713,7 @@ void coda_m2m_buf_done(struct coda_ctx *ctx,
struct vb2_buffer *buf,
     };

     if (coda_buf_is_end_of_stream(ctx, buf)) {
+        v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "send EOS");
         buf->v4l2_buf.flags |= V4L2_BUF_FLAG_LAST;

         v4l2_event_queue_fh(&ctx->fh, &eos_event);
@@ -791,6 +803,40 @@ static int coda_decoder_cmd(struct file *file, void *fh,
     return 0;
 }

+static int coda_try_encoder_cmd(struct file *file, void *fh,
+                struct v4l2_encoder_cmd *ec)
+{
+    if (ec->cmd != V4L2_ENC_CMD_STOP)
+        return -EINVAL;
+
+    if (ec->flags & V4L2_ENC_CMD_STOP_AT_GOP_END)
+        return -EINVAL;
+
+    return 0;
+}
+
+static int coda_encoder_cmd(struct file *file, void *fh,
+                struct v4l2_encoder_cmd *ec)
+{
+    struct coda_ctx *ctx = fh_to_ctx(fh);
+    int ret;
+
+    ret = coda_try_encoder_cmd(file, fh, ec);
+    if (ret < 0)
+        return ret;
+
+    /* Ignore encoder stop command silently in decoder context */
+    if (ctx->inst_type != CODA_INST_ENCODER)
+        return 0;
+
+    /* Set the stream-end flag on this context */
+    coda_bit_stream_end_flag(ctx);
+    ctx->hold = false;
+    v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
+
+    return 0;
+}
+
 static int coda_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
     struct coda_ctx *ctx = fh_to_ctx(fh);
@@ -928,6 +974,8 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {

     .vidioc_try_decoder_cmd    = coda_try_decoder_cmd,
     .vidioc_decoder_cmd    = coda_decoder_cmd,
+    .vidioc_try_encoder_cmd    = coda_try_encoder_cmd,
+    .vidioc_encoder_cmd    = coda_encoder_cmd,

     .vidioc_g_parm        = coda_g_parm,
     .vidioc_s_parm        = coda_s_parm,
-- 
2.6.0
