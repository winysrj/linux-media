Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:50274 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751215AbdH2FeI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 01:34:08 -0400
Subject: [PATCH 3/4] [media] zr364xx: Adjust ten checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Message-ID: <8a949a7b-f42a-f875-d4d7-4e0bc1f39102@users.sourceforge.net>
Date: Tue, 29 Aug 2017 07:34:01 +0200
MIME-Version: 1.0
In-Reply-To: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 22:40:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/zr364xx/zr364xx.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 37cd6e20e68a..4cc6d2a9d91f 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -385,9 +385,9 @@ static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 						  vb);
 	int rc;
 
-	DBG("%s, field=%d, fmt name = %s\n", __func__, field, cam->fmt != NULL ?
-	    cam->fmt->name : "");
-	if (cam->fmt == NULL)
+	DBG("%s, field=%d, fmt name = %s\n", __func__, field,
+	    cam->fmt ? cam->fmt->name : "");
+	if (!cam->fmt)
 		return -EINVAL;
 
 	buf->vb.size = cam->width * cam->height * (cam->fmt->depth >> 3);
@@ -787,7 +787,7 @@ static int zr364xx_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	struct zr364xx_camera *cam = video_drvdata(file);
 	char pixelformat_name[5];
 
-	if (cam == NULL)
+	if (!cam)
 		return -ENODEV;
 
 	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_JPEG) {
@@ -817,7 +817,7 @@ static int zr364xx_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct zr364xx_camera *cam;
 
-	if (file == NULL)
+	if (!file)
 		return -ENODEV;
 	cam = video_drvdata(file);
 
@@ -979,13 +979,13 @@ static void read_pipe_completion(struct urb *purb)
 
 	pipe_info = purb->context;
 	_DBG("%s %p, status %d\n", __func__, purb, purb->status);
-	if (pipe_info == NULL) {
+	if (!pipe_info) {
 		printk(KERN_ERR KBUILD_MODNAME ": no context!\n");
 		return;
 	}
 
 	cam = pipe_info->cam;
-	if (cam == NULL) {
+	if (!cam) {
 		printk(KERN_ERR KBUILD_MODNAME ": no context!\n");
 		return;
 	}
@@ -1069,7 +1069,7 @@ static void zr364xx_stop_readpipe(struct zr364xx_camera *cam)
 {
 	struct zr364xx_pipeinfo *pipe_info;
 
-	if (cam == NULL) {
+	if (!cam) {
 		printk(KERN_ERR KBUILD_MODNAME ": invalid device\n");
 		return;
 	}
@@ -1273,7 +1273,7 @@ static int zr364xx_mmap(struct file *file, struct vm_area_struct *vma)
 	struct zr364xx_camera *cam = video_drvdata(file);
 	int ret;
 
-	if (cam == NULL) {
+	if (!cam) {
 		DBG("%s: cam == NULL\n", __func__);
 		return -ENODEV;
 	}
@@ -1357,7 +1357,7 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 
 	pipe->transfer_buffer = kzalloc(pipe->transfer_size,
 					GFP_KERNEL);
-	if (pipe->transfer_buffer == NULL) {
+	if (!pipe->transfer_buffer) {
 		DBG("out of memory!\n");
 		return -ENOMEM;
 	}
@@ -1373,7 +1373,7 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 		DBG("valloc %p, idx %lu, pdata %p\n",
 			&cam->buffer.frame[i], i,
 			cam->buffer.frame[i].lpvbits);
-		if (cam->buffer.frame[i].lpvbits == NULL) {
+		if (!cam->buffer.frame[i].lpvbits) {
 			printk(KERN_INFO KBUILD_MODNAME ": out of memory. Using less frames\n");
 			break;
 		}
-- 
2.14.1
