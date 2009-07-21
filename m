Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:49192 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbZGUWmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 18:42:14 -0400
Received: by gxk9 with SMTP id 9so5865320gxk.13
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2009 15:42:13 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Antoine Jacquet <royale@zerezo.com>
Subject: Re: [PATCH] Implement changing resolution on the fly for zr364xx driver
Date: Tue, 21 Jul 2009 19:42:01 -0300
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
References: <200907152054.56581.lamarque@gmail.com> <4A65D0E2.4060108@zerezo.com> <200907211214.46226.lamarque@gmail.com>
In-Reply-To: <200907211214.46226.lamarque@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211942.02503.lamarque@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hi,

	I have made some changes to the patch:

. added code to print an error message when buffer is too small to hold frame 
data, that is better than just a hard crash. Tested using MAX_FRAME_SIZE = 
50000, lots of error messages appeared in /var/log/messages but no crash.

. removed line "f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;" in 
zr364xx_vidioc_try_fmt_vid_cap, it should not be there.

. changes to improve performance (or at least not hurt it): removed some 
unneeded debug messages; added macro FULL_DEBUG to enable debug messages in 
performance critical places, this macro is disabled by default; removed "if 
(frm->lpvbits == NULL)..." in zr364xx_read_video_callback because after 
analisying the source code I concluded it will always results to false, so it 
is not needed.

. some small code reorganization.

	There is an incremental version of the last patch I sent in 
http://bach.metasys.com.br/~lamarque/zr364xx/zr364xx.c-resolution.patch-
incremental-v4l-dvb-20090721

Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
---

diff -r 6477aa1782d5 linux/drivers/media/video/zr364xx.c
--- a/linux/drivers/media/videon/zr364xx.c	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/drivers/media/video/zr364xx.c	Tue Jul 21 19:00:52 2009 -0300
@@ -44,14 +44,14 @@
 
 /* Version Information */
 #define DRIVER_VERSION "v0.73"
-#define ZR364_VERSION_CODE KERNEL_VERSION(0, 7, 3)
+#define ZR364XX_VERSION_CODE KERNEL_VERSION(0, 7, 3)
 #define DRIVER_AUTHOR "Antoine Jacquet, http://royale.zerezo.com/"
 #define DRIVER_DESC "Zoran 364xx"
 
 
 /* Camera */
 #define FRAMES 1
-#define MAX_FRAME_SIZE 100000
+#define MAX_FRAME_SIZE 200000
 #define BUFFER_SIZE 0x1000
 #define CTRL_TIMEOUT 500
 
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
+				 "frame data\n",
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
@@ -735,7 +743,7 @@
 	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
 	strlcpy(cap->bus_info, dev_name(&cam->udev->dev),
 		sizeof(cap->bus_info));
-	cap->version = ZR364_VERSION_CODE;
+	cap->version = ZR364XX_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_READWRITE |
 			    V4L2_CAP_STREAMING;
@@ -875,9 +883,13 @@
 		return -EINVAL;
 	}
 
+	if (!(f->fmt.pix.width == 160 && f->fmt.pix.height == 120) &&
+	    !(f->fmt.pix.width == 640 && f->fmt.pix.height == 480)) {
+		f->fmt.pix.width = 320;
+		f->fmt.pix.height = 240;
+	}
+
 	f->fmt.pix.field = V4L2_FIELD_NONE;
-	f->fmt.pix.width = cam->width;
-	f->fmt.pix.height = cam->height;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
@@ -908,7 +920,6 @@
 	return 0;
 }
 
-/* Lamarque TODO: implement changing resolution on the fly */
 static int zr364xx_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				    struct v4l2_format *f)
 {
@@ -916,6 +927,7 @@
 	struct videobuf_queue *q = &cam->vb_vidq;
 	char pixelformat_name[5];
 	int ret = zr364xx_vidioc_try_fmt_vid_cap(file, cam, f);
+	int i;
 
 	if (ret < 0)
 		return ret;
@@ -928,15 +940,55 @@
 		goto out;
 	}
 
-	f->fmt.pix.field = V4L2_FIELD_NONE;
-	f->fmt.pix.width = cam->width;
-	f->fmt.pix.height = cam->height;
+	if (res_check(cam)) {
+		DBG("%s can't change format after started\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	cam->width = f->fmt.pix.width;
+	cam->height = f->fmt.pix.height;
+	dev_info(&cam->udev->dev, "%s: %dx%d mode selected\n", __func__,
+		 cam->width, cam->height);
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
 	f->fmt.pix.priv = 0;
 	cam->vb_vidq.field = f->fmt.pix.field;
 	cam->mode.color = V4L2_PIX_FMT_JPEG;
+
+	if (f->fmt.pix.width == 160 && f->fmt.pix.height == 120)
+		mode = 1;
+	else if (f->fmt.pix.width == 640 && f->fmt.pix.height == 480)
+		mode = 2;
+	else
+		mode = 0;
+
+	m0d1[0] = mode;
+	m1[2].value = 0xf000 + mode;
+	m2[1].value = 0xf000 + mode;
+	header2[437] = cam->height / 256;
+	header2[438] = cam->height % 256;
+	header2[439] = cam->width / 256;
+	header2[440] = cam->width % 256;
+
+	for (i = 0; init[cam->method][i].size != -1; i++) {
+		ret =
+		    send_control_msg(cam->udev, 1, init[cam->method][i].value,
+				     0, init[cam->method][i].bytes,
+				     init[cam->method][i].size);
+		if (ret < 0) {
+			dev_err(&cam->udev->dev,
+			   "error during resolution change sequence: %d\n", i);
+			goto out;
+		}
+	}
+
+	/* Added some delay here, since opening/closing the camera quickly,
+	 * like Ekiga does during its startup, can crash the webcam
+	 */
+	mdelay(100);
+	cam->skip = 2;
 	ret = 0;
 
 out:
@@ -973,7 +1025,7 @@
 {
 	int rc;
 	struct zr364xx_camera *cam = video_drvdata(file);
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 	rc = videobuf_qbuf(&cam->vb_vidq, p);
 	return rc;
 }
@@ -984,7 +1036,7 @@
 {
 	int rc;
 	struct zr364xx_camera *cam = video_drvdata(file);
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 	rc = videobuf_dqbuf(&cam->vb_vidq, p, file->f_flags & O_NONBLOCK);
 	return rc;
 }
@@ -996,7 +1048,7 @@
 	int pipe;
 
 	pipe_info = purb->context;
-	/*DBG("%s %p, status %d\n", __func__, purb, purb->status);*/
+	_DBG("%s %p, status %d\n", __func__, purb, purb->status);
 	if (pipe_info == NULL) {
 		printk(KERN_ERR KBUILD_MODNAME ": no context!\n");
 		return;
@@ -1107,7 +1159,6 @@
 			pipe_info->stream_urb = NULL;
 		}
 	}
-	DBG("stop read pipe\n");
 	return;
 }
 
@@ -1124,6 +1175,7 @@
 		cam->buffer.frame[j].ulState = ZR364XX_READ_IDLE;
 		cam->buffer.frame[j].cur_size = 0;
 	}
+	cam->b_acquire = 1;
 	return 0;
 }
 
@@ -1166,11 +1218,9 @@
 	res = videobuf_streamon(&cam->vb_vidq);
 	if (res == 0) {
 		zr364xx_start_acquire(cam);
-		cam->b_acquire = 1;
 	} else {
 		res_free(cam);
 	}
-	DBG("%s: %d\n", __func__, res);
 	return res;
 }
 
@@ -1282,8 +1332,6 @@
 	/* release transfer buffer */
 	kfree(cam->pipe->transfer_buffer);
 	cam->pipe->transfer_buffer = NULL;
-
-	DBG("%s\n", __func__);
 	mutex_unlock(&cam->open_lock);
 	kfree(cam);
 	cam = NULL;
@@ -1364,7 +1412,7 @@
 {
 	struct zr364xx_camera *cam = video_drvdata(file);
 	struct videobuf_queue *q = &cam->vb_vidq;
-	DBG("%s\n", __func__);
+	_DBG("%s\n", __func__);
 
 	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return POLLERR;

