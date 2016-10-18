Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51614 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935358AbcJRUqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 25/58] s5p-mfc: don't break long lines
Date: Tue, 18 Oct 2016 18:45:37 -0200
Message-Id: <51f236263e90bbedcfc3c91522ee1d3ed7f53326.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 13 ++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  7 ++-----
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 52081ddc9bf2..cf787eae11b7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -793,18 +793,17 @@ static int vidioc_g_crop(struct file *file, void *priv,
 		cr->c.top = top;
 		cr->c.width = ctx->img_width - left - right;
 		cr->c.height = ctx->img_height - top - bottom;
-		mfc_debug(2, "Cropping info [h264]: l=%d t=%d "
-			"w=%d h=%d (r=%d b=%d fw=%d fh=%d\n", left, top,
-			cr->c.width, cr->c.height, right, bottom,
-			ctx->buf_width, ctx->buf_height);
+		mfc_debug(2, "Cropping info [h264]: l=%d t=%d w=%d h=%d (r=%d b=%d fw=%d fh=%d\n",
+			  left, top, cr->c.width, cr->c.height, right, bottom,
+			  ctx->buf_width, ctx->buf_height);
 	} else {
 		cr->c.left = 0;
 		cr->c.top = 0;
 		cr->c.width = ctx->img_width;
 		cr->c.height = ctx->img_height;
-		mfc_debug(2, "Cropping info: w=%d h=%d fw=%d "
-			"fh=%d\n", cr->c.width,	cr->c.height, ctx->buf_width,
-							ctx->buf_height);
+		mfc_debug(2, "Cropping info: w=%d h=%d fw=%d fh=%d\n",
+			  cr->c.width,	cr->c.height, ctx->buf_width,
+			  ctx->buf_height);
 	}
 	return 0;
 }
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


