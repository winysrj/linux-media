Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33103 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbcGTSny (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 14:43:54 -0400
Date: Wed, 20 Jul 2016 13:47:37 -0500
From: Jeremiah Goerdt <jeremiah.goerdt@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, hverkuil@xs4all.nl,
	richard@puffinpack.se, k.kozlowski@samsung.com,
	jeremiah.goerdt@gmail.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: timblogiw: File cleanup.
Message-ID: <20160720184737.GA6101@arch-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleaned up checkpatch.pl warnings and checks.

Signed-off-by: Jeremiah Goerdt <jeremiah.goerdt@gmail.com>
---
 drivers/staging/media/timb/timblogiw.c | 134 ++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/media/timb/timblogiw.c b/drivers/staging/media/timb/timblogiw.c
index 113c9f3..66d2898 100644
--- a/drivers/staging/media/timb/timblogiw.c
+++ b/drivers/staging/media/timb/timblogiw.c
@@ -10,10 +10,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 /* Supports:
@@ -43,7 +39,6 @@
 
 #define TIMBLOGIW_HAS_DECODER(lw)	(lw->pdata.encoder.module_name)
 
-
 struct timblogiw {
 	struct video_device		video_dev;
 	struct v4l2_device		v4l2_dev; /* mutual exclusion */
@@ -98,7 +93,6 @@ static int timblogiw_bytes_per_line(const struct timblogiw_tvnorm *norm)
 	return norm->width * 2;
 }
 
-
 static int timblogiw_frame_size(const struct timblogiw_tvnorm *norm)
 {
 	return norm->height * timblogiw_bytes_per_line(norm);
@@ -107,6 +101,7 @@ static int timblogiw_frame_size(const struct timblogiw_tvnorm *norm)
 static const struct timblogiw_tvnorm *timblogiw_get_norm(const v4l2_std_id std)
 {
 	int i;
+
 	for (i = 0; i < ARRAY_SIZE(timblogiw_tvnorms); i++)
 		if (timblogiw_tvnorms[i].std & std)
 			return timblogiw_tvnorms + i;
@@ -138,8 +133,8 @@ static void timblogiw_dma_cb(void *data)
 	}
 
 	if (!list_empty(&fh->capture)) {
-		vb = list_entry(fh->capture.next, struct videobuf_buffer,
-			queue);
+		vb = list_entry(
+			fh->capture.next, struct videobuf_buffer, queue);
 		vb->state = VIDEOBUF_ACTIVE;
 	}
 
@@ -153,8 +148,8 @@ static bool timblogiw_dma_filter_fn(struct dma_chan *chan, void *filter_param)
 
 /* IOCTL functions */
 
-static int timblogiw_g_fmt(struct file *file, void  *priv,
-	struct v4l2_format *format)
+static int timblogiw_g_fmt(
+	struct file *file, void *priv, struct v4l2_format *format)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw *lw = video_get_drvdata(vdev);
@@ -179,8 +174,8 @@ static int timblogiw_g_fmt(struct file *file, void  *priv,
 	return 0;
 }
 
-static int timblogiw_try_fmt(struct file *file, void  *priv,
-	struct v4l2_format *format)
+static int timblogiw_try_fmt(
+	struct file *file, void *priv, struct v4l2_format *format)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_pix_format *pix = &format->fmt.pix;
@@ -204,8 +199,8 @@ static int timblogiw_try_fmt(struct file *file, void  *priv,
 	return 0;
 }
 
-static int timblogiw_s_fmt(struct file *file, void  *priv,
-	struct v4l2_format *format)
+static int timblogiw_s_fmt(
+	struct file *file, void *priv, struct v4l2_format *format)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw *lw = video_get_drvdata(vdev);
@@ -233,15 +228,17 @@ out:
 	return err;
 }
 
-static int timblogiw_querycap(struct file *file, void  *priv,
-	struct v4l2_capability *cap)
+static int timblogiw_querycap(
+	struct file *file, void *priv, struct v4l2_capability *cap)
 {
 	struct video_device *vdev = video_devdata(file);
 
 	dev_dbg(&vdev->dev, "%s: Entry\n",  __func__);
-	strncpy(cap->card, TIMBLOGIWIN_NAME, sizeof(cap->card)-1);
+	strncpy(cap->card, TIMBLOGIWIN_NAME, sizeof(cap->card) - 1);
 	strncpy(cap->driver, DRIVER_NAME, sizeof(cap->driver) - 1);
-	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s", vdev->name);
+	snprintf(
+		cap->bus_info, sizeof(cap->bus_info),
+		"platform:%s", vdev->name);
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -249,8 +246,8 @@ static int timblogiw_querycap(struct file *file, void  *priv,
 	return 0;
 }
 
-static int timblogiw_enum_fmt(struct file *file, void  *priv,
-	struct v4l2_fmtdesc *fmt)
+static int timblogiw_enum_fmt(
+	struct file *file, void *priv, struct v4l2_fmtdesc *fmt)
 {
 	struct video_device *vdev = video_devdata(file);
 
@@ -261,15 +258,16 @@ static int timblogiw_enum_fmt(struct file *file, void  *priv,
 	memset(fmt, 0, sizeof(*fmt));
 	fmt->index = 0;
 	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	strncpy(fmt->description, "4:2:2, packed, YUYV",
-		sizeof(fmt->description)-1);
+	strncpy(
+		fmt->description, "4:2:2, packed, YUYV",
+		sizeof(fmt->description) - 1);
 	fmt->pixelformat = V4L2_PIX_FMT_UYVY;
 
 	return 0;
 }
 
-static int timblogiw_g_parm(struct file *file, void *priv,
-	struct v4l2_streamparm *sp)
+static int timblogiw_g_parm(
+	struct file *file, void *priv, struct v4l2_streamparm *sp)
 {
 	struct timblogiw_fh *fh = priv;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
@@ -281,8 +279,8 @@ static int timblogiw_g_parm(struct file *file, void *priv,
 	return 0;
 }
 
-static int timblogiw_reqbufs(struct file *file, void  *priv,
-	struct v4l2_requestbuffers *rb)
+static int timblogiw_reqbufs(
+	struct file *file, void *priv, struct v4l2_requestbuffers *rb)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -292,8 +290,8 @@ static int timblogiw_reqbufs(struct file *file, void  *priv,
 	return videobuf_reqbufs(&fh->vb_vidq, rb);
 }
 
-static int timblogiw_querybuf(struct file *file, void  *priv,
-	struct v4l2_buffer *b)
+static int timblogiw_querybuf(
+	struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -303,7 +301,8 @@ static int timblogiw_querybuf(struct file *file, void  *priv,
 	return videobuf_querybuf(&fh->vb_vidq, b);
 }
 
-static int timblogiw_qbuf(struct file *file, void  *priv, struct v4l2_buffer *b)
+static int timblogiw_qbuf(
+	struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -313,8 +312,8 @@ static int timblogiw_qbuf(struct file *file, void  *priv, struct v4l2_buffer *b)
 	return videobuf_qbuf(&fh->vb_vidq, b);
 }
 
-static int timblogiw_dqbuf(struct file *file, void  *priv,
-	struct v4l2_buffer *b)
+static int timblogiw_dqbuf(
+	struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -324,7 +323,7 @@ static int timblogiw_dqbuf(struct file *file, void  *priv,
 	return videobuf_dqbuf(&fh->vb_vidq, b, file->f_flags & O_NONBLOCK);
 }
 
-static int timblogiw_g_std(struct file *file, void  *priv, v4l2_std_id *std)
+static int timblogiw_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -335,7 +334,7 @@ static int timblogiw_g_std(struct file *file, void  *priv, v4l2_std_id *std)
 	return 0;
 }
 
-static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id std)
+static int timblogiw_s_std(struct file *file, void *priv, v4l2_std_id std)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw *lw = video_get_drvdata(vdev);
@@ -357,8 +356,8 @@ static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id std)
 	return err;
 }
 
-static int timblogiw_enuminput(struct file *file, void  *priv,
-	struct v4l2_input *inp)
+static int timblogiw_enuminput(
+	struct file *file, void *priv, struct v4l2_input *inp)
 {
 	struct video_device *vdev = video_devdata(file);
 	int i;
@@ -380,8 +379,8 @@ static int timblogiw_enuminput(struct file *file, void  *priv,
 	return 0;
 }
 
-static int timblogiw_g_input(struct file *file, void  *priv,
-	unsigned int *input)
+static int timblogiw_g_input(
+	struct file *file, void *priv, unsigned int *input)
 {
 	struct video_device *vdev = video_devdata(file);
 
@@ -392,7 +391,8 @@ static int timblogiw_g_input(struct file *file, void  *priv,
 	return 0;
 }
 
-static int timblogiw_s_input(struct file *file, void  *priv, unsigned int input)
+static int timblogiw_s_input(
+	struct file *file, void *priv, unsigned int input)
 {
 	struct video_device *vdev = video_devdata(file);
 
@@ -403,7 +403,8 @@ static int timblogiw_s_input(struct file *file, void  *priv, unsigned int input)
 	return 0;
 }
 
-static int timblogiw_streamon(struct file *file, void  *priv, enum v4l2_buf_type type)
+static int timblogiw_streamon(
+	struct file *file, void *priv, enum v4l2_buf_type type)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -419,8 +420,8 @@ static int timblogiw_streamon(struct file *file, void  *priv, enum v4l2_buf_type
 	return videobuf_streamon(&fh->vb_vidq);
 }
 
-static int timblogiw_streamoff(struct file *file, void  *priv,
-	enum v4l2_buf_type type)
+static int timblogiw_streamoff(
+	struct file *file, void *priv, enum v4l2_buf_type type)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -433,7 +434,7 @@ static int timblogiw_streamoff(struct file *file, void  *priv,
 	return videobuf_streamoff(&fh->vb_vidq);
 }
 
-static int timblogiw_querystd(struct file *file, void  *priv, v4l2_std_id *std)
+static int timblogiw_querystd(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw *lw = video_get_drvdata(vdev);
@@ -443,14 +444,13 @@ static int timblogiw_querystd(struct file *file, void  *priv, v4l2_std_id *std)
 
 	if (TIMBLOGIW_HAS_DECODER(lw))
 		return v4l2_subdev_call(lw->sd_enc, video, querystd, std);
-	else {
-		*std = fh->cur_norm->std;
-		return 0;
-	}
+
+	*std = fh->cur_norm->std;
+	return 0;
 }
 
-static int timblogiw_enum_framesizes(struct file *file, void  *priv,
-	struct v4l2_frmsizeenum *fsize)
+static int timblogiw_enum_framesizes(
+	struct file *file, void *priv, struct v4l2_frmsizeenum *fsize)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -458,8 +458,7 @@ static int timblogiw_enum_framesizes(struct file *file, void  *priv,
 	dev_dbg(&vdev->dev, "%s - index: %d, format: %d\n",  __func__,
 		fsize->index, fsize->pixel_format);
 
-	if ((fsize->index != 0) ||
-		(fsize->pixel_format != V4L2_PIX_FMT_UYVY))
+	if ((fsize->index != 0) || (fsize->pixel_format != V4L2_PIX_FMT_UYVY))
 		return -EINVAL;
 
 	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
@@ -471,8 +470,8 @@ static int timblogiw_enum_framesizes(struct file *file, void  *priv,
 
 /* Video buffer functions */
 
-static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
-	unsigned int *size)
+static int buffer_setup(
+	struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
 {
 	struct timblogiw_fh *fh = vq->priv_data;
 
@@ -487,7 +486,8 @@ static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
 	return 0;
 }
 
-static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
+static int buffer_prepare(
+	struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	enum v4l2_field field)
 {
 	struct timblogiw_fh *fh = vq->priv_data;
@@ -563,9 +563,9 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 	spin_unlock_irq(&fh->queue_lock);
 
-	desc = dmaengine_prep_slave_sg(fh->chan,
-		buf->sg, sg_elems, DMA_DEV_TO_MEM,
-		DMA_PREP_INTERRUPT);
+	desc = dmaengine_prep_slave_sg(
+		fh->chan, buf->sg, sg_elems,
+		DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
 	if (!desc) {
 		spin_lock_irq(&fh->queue_lock);
 		list_del_init(&vb->queue);
@@ -581,8 +581,8 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	spin_lock_irq(&fh->queue_lock);
 }
 
-static void buffer_release(struct videobuf_queue *vq,
-	struct videobuf_buffer *vb)
+static void buffer_release(
+	struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
 	struct timblogiw_fh *fh = vq->priv_data;
 	struct timblogiw_buffer *buf = container_of(vb, struct timblogiw_buffer,
@@ -676,10 +676,10 @@ static int timblogiw_open(struct file *file)
 	}
 
 	file->private_data = fh;
-	videobuf_queue_dma_contig_init(&fh->vb_vidq,
-		&timblogiw_video_qops, lw->dev, &fh->queue_lock,
-		V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-		sizeof(struct timblogiw_buffer), fh, NULL);
+	videobuf_queue_dma_contig_init(
+		&fh->vb_vidq, &timblogiw_video_qops, lw->dev,
+		&fh->queue_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		V4L2_FIELD_NONE, sizeof(struct timblogiw_buffer), fh, NULL);
 
 	lw->opened = true;
 out:
@@ -709,8 +709,8 @@ static int timblogiw_close(struct file *file)
 	return 0;
 }
 
-static ssize_t timblogiw_read(struct file *file, char __user *data,
-	size_t count, loff_t *ppos)
+static ssize_t timblogiw_read(
+	struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = file->private_data;
@@ -721,8 +721,8 @@ static ssize_t timblogiw_read(struct file *file, char __user *data,
 		file->f_flags & O_NONBLOCK);
 }
 
-static unsigned int timblogiw_poll(struct file *file,
-	struct poll_table_struct *wait)
+static unsigned int timblogiw_poll(
+	struct file *file, struct poll_table_struct *wait)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = file->private_data;
@@ -867,4 +867,4 @@ module_platform_driver(timblogiw_platform_driver);
 MODULE_DESCRIPTION(TIMBLOGIWIN_NAME);
 MODULE_AUTHOR("Pelagicore AB <info@pelagicore.com>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:"DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
2.9.0

