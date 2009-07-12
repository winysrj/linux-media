Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:32853 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbZGLUyd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 16:54:33 -0400
Date: Sun, 12 Jul 2009 22:47:44 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: moinejf@free.fr, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/media/video/gspca: Add kmalloc NULL tests
Message-ID: <Pine.LNX.4.64.0907122247090.22658@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc is not NULL before passing it to other
functions.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/gspca/conex.c   |    2 ++
 drivers/media/video/gspca/mars.c    |    2 ++
 drivers/media/video/gspca/sonixj.c  |    2 ++
 drivers/media/video/gspca/spca500.c |    2 ++
 drivers/media/video/gspca/stk014.c  |    2 ++
 drivers/media/video/gspca/sunplus.c |    2 ++
 drivers/media/video/gspca/zc3xx.c   |    2 ++
 7 files changed, 14 insertions(+)

diff --git a/drivers/media/video/gspca/conex.c b/drivers/media/video/gspca/conex.c
index 219cfa6..8d48ea1 100644
--- a/drivers/media/video/gspca/conex.c
+++ b/drivers/media/video/gspca/conex.c
@@ -846,6 +846,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* create the JPEG header */
 	sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	if (!sd->jpeg_hdr)
+		return -ENOMEM;
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x22);		/* JPEG 411 */
 	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
diff --git a/drivers/media/video/gspca/mars.c b/drivers/media/video/gspca/mars.c
index 75e8d14..de769ca 100644
--- a/drivers/media/video/gspca/mars.c
+++ b/drivers/media/video/gspca/mars.c
@@ -201,6 +201,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* create the JPEG header */
 	sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	if (!sd->jpeg_hdr)
+		return -ENOMEM;
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);		/* JPEG 422 */
 	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 0d02f41..db425cc 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -1735,6 +1735,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* create the JPEG header */
 	sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	if (!sd->jpeg_hdr)
+		return -ENOMEM;
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);		/* JPEG 422 */
 	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
diff --git a/drivers/media/video/gspca/spca500.c b/drivers/media/video/gspca/spca500.c
index 8806b2f..fab7ef8 100644
--- a/drivers/media/video/gspca/spca500.c
+++ b/drivers/media/video/gspca/spca500.c
@@ -670,6 +670,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* create the JPEG header */
 	sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	if (!sd->jpeg_hdr)
+		return -ENOMEM;
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x22);		/* JPEG 411 */
 	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
diff --git a/drivers/media/video/gspca/stk014.c b/drivers/media/video/gspca/stk014.c
index f25be20..4762896 100644
--- a/drivers/media/video/gspca/stk014.c
+++ b/drivers/media/video/gspca/stk014.c
@@ -333,6 +333,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* create the JPEG header */
 	sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	if (!sd->jpeg_hdr)
+		return -ENOMEM;
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x22);		/* JPEG 411 */
 	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
diff --git a/drivers/media/video/gspca/sunplus.c b/drivers/media/video/gspca/sunplus.c
index 9623f29..5127bbf 100644
--- a/drivers/media/video/gspca/sunplus.c
+++ b/drivers/media/video/gspca/sunplus.c
@@ -973,6 +973,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* create the JPEG header */
 	sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	if (!sd->jpeg_hdr)
+		return -ENOMEM;
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x22);		/* JPEG 411 */
 	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 08422d3..3d2756f 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -7243,6 +7243,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* create the JPEG header */
 	sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	if (!sd->jpeg_hdr)
+		return -ENOMEM;
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);		/* JPEG 422 */
 	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
