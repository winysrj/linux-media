Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59203 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757085AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 27/57] [media] s5p-mfc: don't break long lines
Date: Fri, 14 Oct 2016 17:20:15 -0300
Message-Id: <acf4a56412e5aa0c9bc4d8e75714eb38fa7f4f28.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 6 ++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 7 ++-----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 52081ddc9bf2..c0e464dcc7d0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -793,8 +793,7 @@ static int vidioc_g_crop(struct file *file, void *priv,
 		cr->c.top = top;
 		cr->c.width = ctx->img_width - left - right;
 		cr->c.height = ctx->img_height - top - bottom;
-		mfc_debug(2, "Cropping info [h264]: l=%d t=%d "
-			"w=%d h=%d (r=%d b=%d fw=%d fh=%d\n", left, top,
+		mfc_debug(2, "Cropping info [h264]: l=%d t=%d w=%d h=%d (r=%d b=%d fw=%d fh=%d\n", left, top,
 			cr->c.width, cr->c.height, right, bottom,
 			ctx->buf_width, ctx->buf_height);
 	} else {
@@ -802,8 +801,7 @@ static int vidioc_g_crop(struct file *file, void *priv,
 		cr->c.top = 0;
 		cr->c.width = ctx->img_width;
 		cr->c.height = ctx->img_height;
-		mfc_debug(2, "Cropping info: w=%d h=%d fw=%d "
-			"fh=%d\n", cr->c.width,	cr->c.height, ctx->buf_width,
+		mfc_debug(2, "Cropping info: w=%d h=%d fw=%d fh=%d\n", cr->c.width,	cr->c.height, ctx->buf_width,
 							ctx->buf_height);
 	}
 	return 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 81e1e4ce6c24..f4301d5bbd32 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1293,14 +1293,11 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 	 * First set the output frame buffers
 	 */
 	if (ctx->capture_state != QUEUE_BUFS_MMAPED) {
-		mfc_err("It seems that not all destionation buffers were "
-			"mmaped\nMFC requires that all destination are mmaped "
-			"before starting processing\n");
+		mfc_err("It seems that not all destionation buffers were mmaped\nMFC requires that all destination are mmaped before starting processing\n");
 		return -EAGAIN;
 	}
 	if (list_empty(&ctx->src_queue)) {
-		mfc_err("Header has been deallocated in the middle of"
-			" initialization\n");
+		mfc_err("Header has been deallocated in the middle of initialization\n");
 		return -EIO;
 	}
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-- 
2.7.4


