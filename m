Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:58480 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbZGVTzB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 15:55:01 -0400
Received: by qyk3 with SMTP id 3so599886qyk.33
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 12:55:01 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Antoine Jacquet <royale@zerezo.com>
Subject: Re: [PATCH] Implement changing resolution on the fly for zr364xx driver
Date: Wed, 22 Jul 2009 16:54:51 -0300
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
References: <200907152054.56581.lamarque@gmail.com> <200907211942.02503.lamarque@gmail.com> <4A67690C.4030401@zerezo.com>
In-Reply-To: <4A67690C.4030401@zerezo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221654.51859.lamarque@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Quarta-feira 22 Julho 2009, Antoine Jacquet escreveu:
> Hi,
>
> Lamarque Vieira Souza wrote:
> > 	I have made some changes to the patch:
>
> Since I already included your previous patch and sent a pull request to
> Mauro, could you send a patch against my current tree:
> 	http://linuxtv.org/hg/~ajacquet/zr364xx/
>
> Thanks,
>
> Antoine

Here it is

Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
---

diff -r ebb57057cf4d linux/drivers/media/video/zr364xx.c
--- a/linux/drivers/media/video/zr364xx.c	Mon Jul 20 20:46:42 2009 -0300
+++ b/linux/drivers/media/video/zr364xx.c	Wed Jul 22 16:52:30 2009 -0300
@@ -67,6 +67,13 @@
 		} \
 	} while (0)
 
+/*#define FULL_DEBUG 1*/
+#ifdef FULL_DEBUG
+#define _DBG DBG
+#else
+#define _DBG(fmt, args...)
+#endif
+
 /* Init methods, need to find nicer names for these
  * the exact names of the chipsets would be the best if someone finds it */
 #define METHOD0 0
@@ -376,7 +383,7 @@
 
 static void free_buffer(struct videobuf_queue *vq, struct zr364xx_buffer 
*buf)
 {
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 
 	if (in_interrupt())
 		BUG();
@@ -429,7 +436,7 @@
 						  vb);
 	struct zr364xx_camera *cam = vq->priv_data;
 
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 
 	buf->vb.state = VIDEOBUF_QUEUED;
 	list_add_tail(&buf->vb.queue, &cam->vidq.active);
@@ -441,7 +448,7 @@
 	struct zr364xx_buffer *buf = container_of(vb, struct zr364xx_buffer,
 						  vb);
 
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 	free_buffer(vq, buf);
 }
 
@@ -463,7 +470,7 @@
 {
 	struct zr364xx_camera *cam = video_drvdata(file);
 
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 
 	if (!buf)
 		return -EINVAL;
@@ -583,7 +590,7 @@
 	int i = 0;
 	unsigned char *ptr = NULL;
 
-	/*DBG("buffer to user\n");*/
+	_DBG("buffer to user\n");
 	idx = cam->cur_frame;
 	frm = &cam->buffer.frame[idx];
 
@@ -601,12 +608,6 @@
 		return -EINVAL;
 	}
 
-	if (frm->lpvbits == NULL) {
-		DBG("%s: frame buffer == NULL.%p %p %d\n", __func__,
-			frm, cam, idx);
-		return -ENOMEM;
-	}
-
 	psrc = (u8 *)pipe_info->transfer_buffer;
 	ptr = pdest = frm->lpvbits;
 
@@ -614,7 +615,7 @@
 		frm->ulState = ZR364XX_READ_FRAME;
 		frm->cur_size = 0;
 
-		DBG("jpeg header, ");
+		_DBG("jpeg header, ");
 		memcpy(ptr, header1, sizeof(header1));
 		ptr += sizeof(header1);
 		header3 = 0;
@@ -632,21 +633,28 @@
 		memcpy(ptr, psrc + 128,
 		       purb->actual_length - 128);
 		ptr += purb->actual_length - 128;
-		DBG("header : %d %d %d %d %d %d %d %d %d\n",
+		_DBG("header : %d %d %d %d %d %d %d %d %d\n",
 		    psrc[0], psrc[1], psrc[2],
 		    psrc[3], psrc[4], psrc[5],
 		    psrc[6], psrc[7], psrc[8]);
 		frm->cur_size = ptr - pdest;
 	} else {
-		pdest += frm->cur_size;
-		memcpy(pdest, psrc, purb->actual_length);
-		frm->cur_size += purb->actual_length;
+		if (frm->cur_size + purb->actual_length > MAX_FRAME_SIZE) {
+			dev_info(&cam->udev->dev,
+				 "%s: buffer (%d bytes) too small to hold "
+				 "frame data. Discarding frame data.\n",
+				 __func__, MAX_FRAME_SIZE);
+		} else {
+			pdest += frm->cur_size;
+			memcpy(pdest, psrc, purb->actual_length);
+			frm->cur_size += purb->actual_length;
+		}
 	}
-	/*DBG("cur_size %lu urb size %d\n", frm->cur_size,
+	/*_DBG("cur_size %lu urb size %d\n", frm->cur_size,
 		purb->actual_length);*/
 
 	if (purb->actual_length < pipe_info->transfer_size) {
-		DBG("****************Buffer[%d]full*************\n", idx);
+		_DBG("****************Buffer[%d]full*************\n", idx);
 		cam->last_frame = cam->cur_frame;
 		cam->cur_frame++;
 		/* end of system frame ring buffer, start at zero */
@@ -681,7 +689,7 @@
 			if (cam->skip)
 				cam->skip--;
 			else {
-				DBG("jpeg(%lu): %d %d %d %d %d %d %d %d\n",
+				_DBG("jpeg(%lu): %d %d %d %d %d %d %d %d\n",
 				    frm->cur_size,
 				    pdest[0], pdest[1], pdest[2], pdest[3],
 				    pdest[4], pdest[5], pdest[6], pdest[7]);
@@ -708,7 +716,7 @@
 	}
 	/* it's free, grab it */
 	cam->resources = 1;
-	DBG("res: get\n");
+	_DBG("res: get\n");
 	mutex_unlock(&cam->lock);
 	return 1;
 }
@@ -723,7 +731,7 @@
 	mutex_lock(&cam->lock);
 	cam->resources = 0;
 	mutex_unlock(&cam->lock);
-	DBG("res: put\n");
+	_DBG("res: put\n");
 }
 
 static int zr364xx_vidioc_querycap(struct file *file, void *priv,
@@ -882,7 +890,6 @@
 	}
 
 	f->fmt.pix.field = V4L2_FIELD_NONE;
-	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
@@ -1018,7 +1025,7 @@
 {
 	int rc;
 	struct zr364xx_camera *cam = video_drvdata(file);
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 	rc = videobuf_qbuf(&cam->vb_vidq, p);
 	return rc;
 }
@@ -1029,7 +1036,7 @@
 {
 	int rc;
 	struct zr364xx_camera *cam = video_drvdata(file);
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 	rc = videobuf_dqbuf(&cam->vb_vidq, p, file->f_flags & O_NONBLOCK);
 	return rc;
 }
@@ -1041,7 +1048,7 @@
 	int pipe;
 
 	pipe_info = purb->context;
-	/*DBG("%s %p, status %d\n", __func__, purb, purb->status);*/
+	_DBG("%s %p, status %d\n", __func__, purb, purb->status);
 	if (pipe_info == NULL) {
 		printk(KERN_ERR KBUILD_MODNAME ": no context!\n");
 		return;
@@ -1152,7 +1159,6 @@
 			pipe_info->stream_urb = NULL;
 		}
 	}
-	DBG("stop read pipe\n");
 	return;
 }
 
@@ -1215,7 +1221,6 @@
 	} else {
 		res_free(cam);
 	}
-	DBG("%s: %d\n", __func__, res);
 	return res;
 }
 
@@ -1327,8 +1332,6 @@
 	/* release transfer buffer */
 	kfree(cam->pipe->transfer_buffer);
 	cam->pipe->transfer_buffer = NULL;
-
-	DBG("%s\n", __func__);
 	mutex_unlock(&cam->open_lock);
 	kfree(cam);
 	cam = NULL;
@@ -1409,7 +1412,7 @@
 {
 	struct zr364xx_camera *cam = video_drvdata(file);
 	struct videobuf_queue *q = &cam->vb_vidq;
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 
 	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return POLLERR;

