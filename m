Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:54721 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbcLZNcT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Dec 2016 08:32:19 -0500
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Kieran Bingham <kieran@ksquared.org.uk>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] [media] v4l: rcar_fdp1: use %4.4s to format a 4-byte string
Date: Mon, 26 Dec 2016 14:31:39 +0100
Message-Id: <20161226133139.3775-1-nicolas.iooss_linux@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using %4s to format f->fmt.pix_mp.pixelformat in fdp1_try_fmt() and
fdp1_s_fmt() may lead to more characters being printed (when the byte
following field pixelformat is not zero).

Add ".4" to the format specifier to limit the number of printed
characters to four. The resulting format specifier "%4.4s" is also used
by other media drivers to print pixelformat value.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/media/platform/rcar_fdp1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 674cc1309b43..42f25d241edd 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -1596,7 +1596,7 @@ static int fdp1_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	else
 		fdp1_try_fmt_capture(ctx, NULL, &f->fmt.pix_mp);
 
-	dprintk(ctx->fdp1, "Try %s format: %4s (0x%08x) %ux%u field %u\n",
+	dprintk(ctx->fdp1, "Try %s format: %4.4s (0x%08x) %ux%u field %u\n",
 		V4L2_TYPE_IS_OUTPUT(f->type) ? "output" : "capture",
 		(char *)&f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.pixelformat,
 		f->fmt.pix_mp.width, f->fmt.pix_mp.height, f->fmt.pix_mp.field);
@@ -1671,7 +1671,7 @@ static int fdp1_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 
 	fdp1_set_format(ctx, &f->fmt.pix_mp, f->type);
 
-	dprintk(ctx->fdp1, "Set %s format: %4s (0x%08x) %ux%u field %u\n",
+	dprintk(ctx->fdp1, "Set %s format: %4.4s (0x%08x) %ux%u field %u\n",
 		V4L2_TYPE_IS_OUTPUT(f->type) ? "output" : "capture",
 		(char *)&f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.pixelformat,
 		f->fmt.pix_mp.width, f->fmt.pix_mp.height, f->fmt.pix_mp.field);
-- 
2.11.0

