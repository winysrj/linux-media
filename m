Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVvLx022651
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:57 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVj9g027179
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:45 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:38 +0100
Message-Id: <1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 07/13] soc-camera: initialise fields on device-registration,
	more formatting cleanup
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

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Camera devices typically allocate their struct soc_camera_device objects per
kzalloc(), but soc_camera.c shall not rely on that and shall initialise
host_priv and use_count explicitly. Many camera and host methods are called
without being checked for NULL, let's check them at registration. Also merge
broken lines, that no longer exceed 80 characters.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |   53 ++++++++++++++++---------------------
 drivers/media/video/soc_camera.c |   54 ++++++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index f7f621c..56aeb07 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -143,8 +143,7 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
 	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
@@ -170,8 +169,7 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int i;
@@ -247,8 +245,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		struct videobuf_buffer *vb, enum v4l2_field field)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	int ret;
@@ -367,8 +364,7 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 			       struct videobuf_buffer *vb)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	struct pxa_buffer *active;
@@ -772,8 +768,7 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 
 static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long dw, bpp, bus_flags, camera_flags, common_flags;
 	u32 cicr0, cicr1, cicr4 = 0;
@@ -890,8 +885,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long bus_flags, camera_flags;
 	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
@@ -931,7 +925,8 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
 	const struct soc_camera_data_format *cam_fmt;
-	int ret = pxa_camera_try_bus_param(icd, f->fmt.pix.pixelformat);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret = pxa_camera_try_bus_param(icd, pix->pixelformat);
 
 	if (ret < 0)
 		return ret;
@@ -940,24 +935,24 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	 * TODO: find a suitable supported by the SoC output format, check
 	 * whether the sensor supports one of acceptable input formats.
 	 */
-	cam_fmt = soc_camera_format_by_fourcc(icd, f->fmt.pix.pixelformat);
+	cam_fmt = soc_camera_format_by_fourcc(icd, pix->pixelformat);
 	if (!cam_fmt)
 		return -EINVAL;
 
 	/* limit to pxa hardware capabilities */
-	if (f->fmt.pix.height < 32)
-		f->fmt.pix.height = 32;
-	if (f->fmt.pix.height > 2048)
-		f->fmt.pix.height = 2048;
-	if (f->fmt.pix.width < 48)
-		f->fmt.pix.width = 48;
-	if (f->fmt.pix.width > 2048)
-		f->fmt.pix.width = 2048;
-	f->fmt.pix.width &= ~0x01;
-
-	f->fmt.pix.bytesperline = f->fmt.pix.width *
+	if (pix->height < 32)
+		pix->height = 32;
+	if (pix->height > 2048)
+		pix->height = 2048;
+	if (pix->width < 48)
+		pix->width = 48;
+	if (pix->width > 2048)
+		pix->width = 2048;
+	pix->width &= ~0x01;
+
+	pix->bytesperline = pix->width *
 		DIV_ROUND_UP(cam_fmt->depth, 8);
-	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	pix->sizeimage = pix->height * pix->bytesperline;
 
 	/* limit to sensor capabilities */
 	return icd->ops->try_fmt(icd, f);
@@ -1028,8 +1023,7 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 
 static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
 {
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int i = 0, ret = 0;
 
@@ -1047,8 +1041,7 @@ static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
 
 static int pxa_camera_resume(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int i = 0, ret = 0;
 
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index f5a1a86..a63738c 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -52,8 +52,7 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	enum v4l2_field field;
 	int ret;
 
@@ -117,8 +116,7 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 	int ret;
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -282,8 +280,7 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	if (list_empty(&icf->vb_vidq.stream)) {
 		dev_err(&icd->dev, "Trying to poll with no queued buffers!\n");
@@ -309,8 +306,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int ret;
 	struct v4l2_rect rect;
 
@@ -355,8 +351,7 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -388,8 +383,7 @@ static int soc_camera_querycap(struct file *file, void  *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -540,8 +534,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int ret;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -665,13 +658,9 @@ static int scan_add_device(struct soc_camera_device *icd)
 static int soc_camera_probe(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int ret;
 
-	if (!icd->ops->probe)
-		return -ENODEV;
-
 	/* We only call ->add() here to activate and probe the camera.
 	 * We shall ->remove() and deactivate it immediately afterwards. */
 	ret = ici->ops->add(icd);
@@ -752,7 +741,17 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	int ret;
 	struct soc_camera_host *ix;
 
-	if (!ici->ops->init_videobuf || !ici->ops->add || !ici->ops->remove)
+	if (!ici || !ici->ops ||
+	    !ici->ops->try_fmt ||
+	    !ici->ops->set_fmt ||
+	    !ici->ops->enum_fmt ||
+	    !ici->ops->set_bus_param ||
+	    !ici->ops->querycap ||
+	    !ici->ops->init_videobuf ||
+	    !ici->ops->reqbufs ||
+	    !ici->ops->add ||
+	    !ici->ops->remove ||
+	    !ici->ops->poll)
 		return -EINVAL;
 
 	/* Number might be equal to the platform device ID */
@@ -820,7 +819,16 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 	struct soc_camera_device *ix;
 	int num = -1, i;
 
-	if (!icd)
+	if (!icd || !icd->ops ||
+	    !icd->ops->probe ||
+	    !icd->ops->init ||
+	    !icd->ops->release ||
+	    !icd->ops->start_capture ||
+	    !icd->ops->stop_capture ||
+	    !icd->ops->set_fmt ||
+	    !icd->ops->try_fmt ||
+	    !icd->ops->query_bus_param ||
+	    !icd->ops->set_bus_param)
 		return -EINVAL;
 
 	for (i = 0; i < 256 && num < 0; i++) {
@@ -843,7 +851,9 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 	snprintf(icd->dev.bus_id, sizeof(icd->dev.bus_id),
 		 "%u-%u", icd->iface, icd->devnum);
 
-	icd->dev.release = dummy_release;
+	icd->dev.release	= dummy_release;
+	icd->use_count		= 0;
+	icd->host_priv		= NULL;
 
 	return scan_add_device(icd);
 }
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
