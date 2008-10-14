Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ECmaKL028334
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:36 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ECm02C005686
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:25 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2182413rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 05:48:25 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 14 Oct 2008 21:47:09 +0900
Message-Id: <20081014124709.5194.70486.sendpatchset@rx1.opensource.se>
In-Reply-To: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
References: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH 02/05] video: Teach vivi about multiple pixel formats
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Magnus Damm <damm@igel.co.jp>

This patch contains the ground work to add support for multiple
pixel formats to vivi.c

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/vivi.c |   97 ++++++++++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 30 deletions(-)

--- 0016/drivers/media/video/vivi.c
+++ work/drivers/media/video/vivi.c	2008-10-10 16:31:24.000000000 +0900
@@ -128,12 +128,31 @@ struct vivi_fmt {
 	int   depth;
 };
 
-static struct vivi_fmt format = {
-	.name     = "4:2:2, packed, YUYV",
-	.fourcc   = V4L2_PIX_FMT_YUYV,
-	.depth    = 16,
+static struct vivi_fmt formats[] = {
+	{
+		.name     = "4:2:2, packed, YUYV",
+		.fourcc   = V4L2_PIX_FMT_YUYV,
+		.depth    = 16,
+	},
 };
 
+static struct vivi_fmt *get_format(struct v4l2_format *f)
+{
+	struct vivi_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < ARRAY_SIZE(formats); k++) {
+		fmt = &formats[k];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			break;
+	}
+
+	if (k == ARRAY_SIZE(formats))
+		return NULL;
+
+	return &formats[k];
+}
+
 struct sg_to_addr {
 	int pos;
 	struct scatterlist *sg;
@@ -248,16 +267,20 @@ static void gen_twopix(struct vivi_fh *f
 	for (color = 0; color < 4; color++) {
 		p = buf + color;
 
-		switch (color) {
-		case 0:
-		case 2:
-			*p = r_y;
-			break;
-		case 1:
-			*p = g_u;
-			break;
-		case 3:
-			*p = b_v;
+		switch (fh->fmt->fourcc) {
+		case V4L2_PIX_FMT_YUYV:
+			switch (color) {
+			case 0:
+			case 2:
+				*p = r_y;
+				break;
+			case 1:
+				*p = g_u;
+				break;
+			case 3:
+				*p = b_v;
+				break;
+			}
 			break;
 		}
 	}
@@ -622,11 +645,15 @@ static int vidioc_querycap(struct file *
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
-	if (f->index > 0)
+	struct vivi_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats))
 		return -EINVAL;
 
-	strlcpy(f->description, format.name, sizeof(f->description));
-	f->pixelformat = format.fourcc;
+	fmt = &formats[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
 	return 0;
 }
 
@@ -656,13 +683,12 @@ static int vidioc_try_fmt_vid_cap(struct
 	enum v4l2_field field;
 	unsigned int maxw, maxh;
 
-	if (format.fourcc != f->fmt.pix.pixelformat) {
-		dprintk(dev, 1, "Fourcc format (0x%08x) invalid. "
-			"Driver accepts only 0x%08x\n",
-			f->fmt.pix.pixelformat, format.fourcc);
+	fmt = get_format(f);
+	if (!fmt) {
+		dprintk(dev, 1, "Fourcc format (0x%08x) invalid.\n",
+			f->fmt.pix.pixelformat);
 		return -EINVAL;
 	}
-	fmt = &format;
 
 	field = f->fmt.pix.field;
 
@@ -701,7 +727,7 @@ static int vidioc_s_fmt_vid_cap(struct f
 	struct vivi_fh  *fh = priv;
 	struct videobuf_queue *q = &fh->vb_vidq;
 	unsigned char r, g, b;
-	int k;
+	int k, is_yuv;
 
 	int ret = vidioc_try_fmt_vid_cap(file, fh, f);
 	if (ret < 0)
@@ -715,7 +741,7 @@ static int vidioc_s_fmt_vid_cap(struct f
 		goto out;
 	}
 
-	fh->fmt           = &format;
+	fh->fmt           = get_format(f);
 	fh->width         = f->fmt.pix.width;
 	fh->height        = f->fmt.pix.height;
 	fh->vb_vidq.field = f->fmt.pix.field;
@@ -726,10 +752,23 @@ static int vidioc_s_fmt_vid_cap(struct f
 		r = bars[k][0];
 		g = bars[k][1];
 		b = bars[k][2];
+		is_yuv = 0;
+
+		switch (fh->fmt->fourcc) {
+		case V4L2_PIX_FMT_YUYV:
+			is_yuv = 1;
+			break;
+		}
 
-		fh->bars[k][0] = TO_Y(r, g, b);	/* Luma */
-		fh->bars[k][1] = TO_U(r, g, b);	/* Cb */
-		fh->bars[k][2] = TO_V(r, g, b);	/* Cr */
+		if (is_yuv) {
+			fh->bars[k][0] = TO_Y(r, g, b);	/* Luma */
+			fh->bars[k][1] = TO_U(r, g, b);	/* Cb */
+			fh->bars[k][2] = TO_V(r, g, b);	/* Cr */
+		} else {
+			fh->bars[k][0] = r;
+			fh->bars[k][1] = g;
+			fh->bars[k][2] = b;
+		}
 	}
 
 	ret = 0;
@@ -885,8 +924,6 @@ static int vidioc_s_ctrl(struct file *fi
 	File operations for the device
    ------------------------------------------------------------------*/
 
-#define line_buf_size(norm) (norm_maxw(norm)*(format.depth+7)/8)
-
 static int vivi_open(struct inode *inode, struct file *file)
 {
 	int minor = iminor(inode);
@@ -931,7 +968,7 @@ unlock:
 	fh->dev      = dev;
 
 	fh->type     = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	fh->fmt      = &format;
+	fh->fmt      = &formats[0];
 	fh->width    = 640;
 	fh->height   = 480;
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
