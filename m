Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3863 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3A3R4x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:56:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/3] bw-qcam: convert to videobuf2.
Date: Wed, 30 Jan 2013 18:56:43 +0100
Message-Id: <1439f8bba63fcdb57792517404719a8e89891cc6.1359568453.git.hans.verkuil@cisco.com>
In-Reply-To: <1359568604-27876-1-git-send-email-hverkuil@xs4all.nl>
References: <1359568604-27876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <08f9f5df663bb92eec55c1a5bcfb26c820c2ed8a.1359568453.git.hans.verkuil@cisco.com>
References: <08f9f5df663bb92eec55c1a5bcfb26c820c2ed8a.1359568453.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

I know, nobody really cares about this black-and-white webcam anymore, but
it was fun to do.

Tested with an actual webcam.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/parport/Kconfig   |    1 +
 drivers/media/parport/bw-qcam.c |  157 +++++++++++++++++++++++++++------------
 2 files changed, 112 insertions(+), 46 deletions(-)

diff --git a/drivers/media/parport/Kconfig b/drivers/media/parport/Kconfig
index ece13dc..948c981 100644
--- a/drivers/media/parport/Kconfig
+++ b/drivers/media/parport/Kconfig
@@ -9,6 +9,7 @@ if MEDIA_PARPORT_SUPPORT
 config VIDEO_BWQCAM
 	tristate "Quickcam BW Video For Linux"
 	depends on PARPORT && VIDEO_V4L2
+	select VIDEOBUF2_VMALLOC
 	help
 	  Say Y have if you the black and white version of the QuickCam
 	  camera. See the next option for the color version.
diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index 497b342..d3fe34f 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -80,6 +80,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-vmalloc.h>
 
 /* One from column A... */
 #define QC_NOTSET 0
@@ -107,9 +108,11 @@ struct qcam {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
 	struct v4l2_ctrl_handler hdl;
+	struct vb2_queue vb_vidq;
 	struct pardevice *pdev;
 	struct parport *pport;
 	struct mutex lock;
+	struct mutex queue_lock;
 	int width, height;
 	int bpp;
 	int mode;
@@ -558,7 +561,7 @@ static inline int qc_readbytes(struct qcam *q, char buffer[])
  * n=2^(bit depth)-1.  Ask me for more details if you don't understand
  * this. */
 
-static long qc_capture(struct qcam *q, char __user *buf, unsigned long len)
+static long qc_capture(struct qcam *q, u8 *buf, unsigned long len)
 {
 	int i, j, k, yield;
 	int bytes;
@@ -609,7 +612,7 @@ static long qc_capture(struct qcam *q, char __user *buf, unsigned long len)
 				if (o < len) {
 					u8 ch = invert - buffer[k];
 					got++;
-					put_user(ch << shift, buf + o);
+					buf[o] = ch << shift;
 				}
 			}
 			pixels_read += bytes;
@@ -639,6 +642,67 @@ static long qc_capture(struct qcam *q, char __user *buf, unsigned long len)
 	return len;
 }
 
+/* ------------------------------------------------------------------
+	Videobuf operations
+   ------------------------------------------------------------------*/
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct qcam *dev = vb2_get_drv_priv(vq);
+
+	if (0 == *nbuffers)
+		*nbuffers = 3;
+	*nplanes = 1;
+	mutex_lock(&dev->lock);
+	if (fmt)
+		sizes[0] = fmt->fmt.pix.width * fmt->fmt.pix.height;
+	else
+		sizes[0] = (dev->width / dev->transfer_scale) *
+		   (dev->height / dev->transfer_scale);
+	mutex_unlock(&dev->lock);
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+}
+
+static int buffer_finish(struct vb2_buffer *vb)
+{
+	struct qcam *qcam = vb2_get_drv_priv(vb->vb2_queue);
+	void *vbuf = vb2_plane_vaddr(vb, 0);
+	int size = vb->vb2_queue->plane_sizes[0];
+	int len;
+
+	mutex_lock(&qcam->lock);
+	parport_claim_or_block(qcam->pdev);
+
+	qc_reset(qcam);
+
+	/* Update the camera parameters if we need to */
+	if (qcam->status & QC_PARAM_CHANGE)
+		qc_set(qcam);
+
+	len = qc_capture(qcam, vbuf, size);
+
+	parport_release(qcam->pdev);
+	mutex_unlock(&qcam->lock);
+	if (len != size)
+		vb->state = VB2_BUF_STATE_ERROR;
+	vb2_set_plane_payload(vb, 0, len);
+	return 0;
+}
+
+static struct vb2_ops qcam_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_queue		= buffer_queue,
+	.buf_finish		= buffer_finish,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
 /*
  *	Video4linux interfacing
  */
@@ -651,7 +715,8 @@ static int qcam_querycap(struct file *file, void  *priv,
 	strlcpy(vcap->driver, qcam->v4l2_dev.name, sizeof(vcap->driver));
 	strlcpy(vcap->card, "Connectix B&W Quickcam", sizeof(vcap->card));
 	strlcpy(vcap->bus_info, qcam->pport->name, sizeof(vcap->bus_info));
-	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
+	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+				V4L2_CAP_STREAMING;
 	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
@@ -731,6 +796,8 @@ static int qcam_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 
 	if (ret)
 		return ret;
+	if (vb2_is_busy(&qcam->vb_vidq))
+		return -EBUSY;
 	qcam->width = 320;
 	qcam->height = 240;
 	if (pix->height == 60)
@@ -744,12 +811,10 @@ static int qcam_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 	else
 		qcam->bpp = 4;
 
-	mutex_lock(&qcam->lock);
 	qc_setscanmode(qcam);
 	/* We must update the camera before we grab. We could
 	   just have changed the grab size */
 	qcam->status |= QC_PARAM_CHANGE;
-	mutex_unlock(&qcam->lock);
 	return 0;
 }
 
@@ -794,41 +859,12 @@ static int qcam_enum_framesizes(struct file *file, void *fh,
 	return 0;
 }
 
-static ssize_t qcam_read(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct qcam *qcam = video_drvdata(file);
-	int len;
-	parport_claim_or_block(qcam->pdev);
-
-	mutex_lock(&qcam->lock);
-
-	qc_reset(qcam);
-
-	/* Update the camera parameters if we need to */
-	if (qcam->status & QC_PARAM_CHANGE)
-		qc_set(qcam);
-
-	len = qc_capture(qcam, buf, count);
-
-	mutex_unlock(&qcam->lock);
-
-	parport_release(qcam->pdev);
-	return len;
-}
-
-static unsigned int qcam_poll(struct file *filp, poll_table *wait)
-{
-	return v4l2_ctrl_poll(filp, wait) | POLLIN | POLLRDNORM;
-}
-
 static int qcam_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct qcam *qcam =
 		container_of(ctrl->handler, struct qcam, hdl);
 	int ret = 0;
 
-	mutex_lock(&qcam->lock);
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
 		qcam->brightness = ctrl->val;
@@ -847,17 +883,17 @@ static int qcam_s_ctrl(struct v4l2_ctrl *ctrl)
 		qc_setscanmode(qcam);
 		qcam->status |= QC_PARAM_CHANGE;
 	}
-	mutex_unlock(&qcam->lock);
 	return ret;
 }
 
 static const struct v4l2_file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
 	.open		= v4l2_fh_open,
-	.release	= v4l2_fh_release,
-	.poll		= qcam_poll,
+	.release	= vb2_fop_release,
+	.poll		= vb2_fop_poll,
 	.unlocked_ioctl = video_ioctl2,
-	.read		= qcam_read,
+	.read		= vb2_fop_read,
+	.mmap		= vb2_fop_mmap,
 };
 
 static const struct v4l2_ioctl_ops qcam_ioctl_ops = {
@@ -870,6 +906,14 @@ static const struct v4l2_ioctl_ops qcam_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap 		    = qcam_g_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap  		    = qcam_s_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap  	    = qcam_try_fmt_vid_cap,
+	.vidioc_reqbufs			    = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		    = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf		    = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf		    = vb2_ioctl_querybuf,
+	.vidioc_qbuf			    = vb2_ioctl_qbuf,
+	.vidioc_dqbuf			    = vb2_ioctl_dqbuf,
+	.vidioc_streamon		    = vb2_ioctl_streamon,
+	.vidioc_streamoff		    = vb2_ioctl_streamoff,
 	.vidioc_log_status		    = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
@@ -886,6 +930,8 @@ static struct qcam *qcam_init(struct parport *port)
 {
 	struct qcam *qcam;
 	struct v4l2_device *v4l2_dev;
+	struct vb2_queue *q;
+	int err;
 
 	qcam = kzalloc(sizeof(struct qcam), GFP_KERNEL);
 	if (qcam == NULL)
@@ -909,31 +955,45 @@ static struct qcam *qcam_init(struct parport *port)
 			  V4L2_CID_GAMMA, 0, 255, 1, 105);
 	if (qcam->hdl.error) {
 		v4l2_err(v4l2_dev, "couldn't register controls\n");
-		v4l2_ctrl_handler_free(&qcam->hdl);
-		kfree(qcam);
-		return NULL;
+		goto exit;
+	}
+
+	mutex_init(&qcam->lock);
+	mutex_init(&qcam->queue_lock);
+
+	/* initialize queue */
+	q = &qcam->vb_vidq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	q->drv_priv = qcam;
+	q->ops = &qcam_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	err = vb2_queue_init(q);
+	if (err < 0) {
+		v4l2_err(v4l2_dev, "couldn't init vb2_queue for %s.\n", port->name);
+		goto exit;
 	}
+	qcam->vdev.queue = q;
+	qcam->vdev.queue->lock = &qcam->queue_lock;
+
 	qcam->pport = port;
 	qcam->pdev = parport_register_device(port, v4l2_dev->name, NULL, NULL,
 			NULL, 0, NULL);
 	if (qcam->pdev == NULL) {
 		v4l2_err(v4l2_dev, "couldn't register for %s.\n", port->name);
-		v4l2_ctrl_handler_free(&qcam->hdl);
-		kfree(qcam);
-		return NULL;
+		goto exit;
 	}
 
 	strlcpy(qcam->vdev.name, "Connectix QuickCam", sizeof(qcam->vdev.name));
 	qcam->vdev.v4l2_dev = v4l2_dev;
 	qcam->vdev.ctrl_handler = &qcam->hdl;
 	qcam->vdev.fops = &qcam_fops;
+	qcam->vdev.lock = &qcam->lock;
 	qcam->vdev.ioctl_ops = &qcam_ioctl_ops;
 	set_bit(V4L2_FL_USE_FH_PRIO, &qcam->vdev.flags);
 	qcam->vdev.release = video_device_release_empty;
 	video_set_drvdata(&qcam->vdev, qcam);
 
-	mutex_init(&qcam->lock);
-
 	qcam->port_mode = (QC_ANY | QC_NOTSET);
 	qcam->width = 320;
 	qcam->height = 240;
@@ -947,6 +1007,11 @@ static struct qcam *qcam_init(struct parport *port)
 	qcam->mode = -1;
 	qcam->status = QC_PARAM_CHANGE;
 	return qcam;
+
+exit:
+	v4l2_ctrl_handler_free(&qcam->hdl);
+	kfree(qcam);
+	return NULL;
 }
 
 static int qc_calibrate(struct qcam *q)
-- 
1.7.10.4

