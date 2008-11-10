Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAACbYn1028361
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 07:37:35 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAACanVi012135
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 07:37:06 -0500
Date: Mon, 10 Nov 2008 13:37:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811101335170.4248@axis700.grange>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 5/5] pxa-camera: framework to handle camera-native and
 synthesized formats
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

This creates the framework, necessary to handle pixel formats, provided by the
camera, and formats, synthesized by the Quick Capture Interface. Now we just
have to handle each specific format individually.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |  211 +++++++++++++++++++++++++++++++++++---
 1 files changed, 194 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 56aeb07..00eebf1 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/clk.h>
+#include <linux/vmalloc.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -132,6 +133,21 @@ struct pxa_camera_dev {
 	u32			save_cicr[5];
 };
 
+/**
+ * @camera_formats:	pointer to an array of links to supported camera
+ *			formats.
+ * @camera_formats_num:	size of the above array.
+ * @extra_formats:	formats we support by converting a different camera
+ *			format.
+ * @extra_formats_num:	size of the above array.
+ */
+struct camera_data {
+	int					camera_formats_num;
+	const struct soc_camera_data_format	**camera_formats;
+	int					extra_formats_num;
+	struct soc_camera_data_format		extra_formats[];
+};
+
 static const char *pxa_cam_driver_description = "PXA_Camera";
 
 static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
@@ -673,6 +689,104 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static bool depth_supported(struct soc_camera_device *icd, int i)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+
+	switch (icd->formats[i].depth) {
+	case 8:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
+			return true;
+		return false;
+	case 9:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9)
+			return true;
+		return false;
+	case 10:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
+			return true;
+		return false;
+	}
+	return false;
+}
+
+static bool format_supported(struct soc_camera_device *icd, int i)
+{
+	if (!depth_supported(icd, i))
+		return false;
+
+	/* To be implemented - verify fourcc */
+	return true;
+}
+
+/**
+ * @icd:	camera device
+ * @i:		index of the camera format to be considered
+ * @fmt:	if (fmt != NULL) it points to the beginning of an area,
+ *		sufficient for all extra formats, that the i's camera format
+ *		can be converted to, and this area has to be filled in
+ * @return:	number of extra formats found for this camera format
+ */
+static int format_extras(struct soc_camera_device *icd, int i,
+			 const struct soc_camera_data_format *fmt)
+{
+	if (!depth_supported(icd, i))
+		return 0;
+
+	/* To be implemented */
+	return 0;
+}
+
+static int init_formats(struct soc_camera_device *icd)
+{
+	int cam_fmts = 0, extra_fmts = 0, i;
+	int cam_idx = 0, extra_idx = 0;
+	struct camera_data *cam_data;
+
+	for (i = 0; i < icd->num_formats; i++) {
+		if (format_supported(icd, i))
+			cam_fmts++;
+
+		/*
+		 * Even formats we cannot pass to the user might be suitable
+		 * for conversion
+		 */
+		extra_fmts += format_extras(icd, i, NULL);
+	}
+
+	dev_dbg(&icd->dev, "Found %d native and %d synthesized formats\n",
+		cam_fmts, extra_fmts);
+
+	icd->host_priv = vmalloc(sizeof(struct camera_data) +
+				 sizeof(struct soc_camera_data_format) *
+				 extra_fmts + sizeof(void *) * cam_fmts);
+	if (!icd->host_priv)
+		return -ENOMEM;
+
+	/*
+	 * Layout:
+	 * struct camera_data
+	 * extra_formats[extra_fmts]
+	 * camera_formats[cam_fmts]
+	 */
+	cam_data = icd->host_priv;
+
+	cam_data->camera_formats_num	= cam_fmts;
+	cam_data->camera_formats	= icd->host_priv + sizeof(struct camera_data) +
+		sizeof(struct soc_camera_data_format) * extra_fmts;
+	cam_data->extra_formats_num	= extra_fmts;
+
+	for (i = 0; i < icd->num_formats; i++) {
+		if (format_supported(icd, i))
+			cam_data->camera_formats[cam_idx++] = icd->formats + i;
+
+		extra_idx += format_extras(icd, i, cam_data->extra_formats + extra_idx);
+	}
+
+	return 0;
+}
+
 /* The following two functions absolutely depend on the fact, that
  * there can be only one camera on PXA quick capture interface */
 static int pxa_camera_add_device(struct soc_camera_device *icd)
@@ -693,10 +807,30 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 
 	pxa_camera_activate(pcdev);
 	ret = icd->ops->init(icd);
+	if (ret < 0)
+		goto einit;
+
+	pcdev->icd = icd;
+
+	/*
+	 * We're either called during probing or during open under video_lock.
+	 * During probe we don't need to initialise the formats, and during
+	 * open video_lock is held, so, it is safe to use the use_count
+	 */
+	if (icd->use_count) {
+		ret = init_formats(icd);
+		if (ret < 0)
+			goto eifmt;
+	}
 
-	if (!ret)
-		pcdev->icd = icd;
+	mutex_unlock(&camera_lock);
+
+	return 0;
 
+eifmt:
+	icd->ops->release(icd);
+einit:
+	pxa_camera_deactivate(pcdev);
 ebusy:
 	mutex_unlock(&camera_lock);
 
@@ -713,6 +847,8 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 	dev_info(&icd->dev, "PXA Camera driver detached from camera %d\n",
 		 icd->devnum);
 
+	mutex_lock(&camera_lock);
+
 	/* disable capture, disable interrupts */
 	CICR0 = 0x3ff;
 
@@ -725,7 +861,12 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 
 	pxa_camera_deactivate(pcdev);
 
+	vfree(icd->host_priv);
+	icd->host_priv = NULL;
+
 	pcdev->icd = NULL;
+
+	mutex_unlock(&camera_lock);
 }
 
 static int test_platform_param(struct pxa_camera_dev *pcdev,
@@ -901,15 +1042,33 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 			      __u32 pixfmt, struct v4l2_rect *rect)
 {
-	const struct soc_camera_data_format *cam_fmt;
+	const struct soc_camera_data_format *cam_fmt = NULL;
 	int ret;
 
-	/*
-	 * TODO: find a suitable supported by the SoC output format, check
-	 * whether the sensor supports one of acceptable input formats.
-	 */
 	if (pixfmt) {
-		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+		struct camera_data *cam_data = icd->host_priv;
+		int i;
+
+		/* First check camera native formats */
+		for (i = 0; i < cam_data->camera_formats_num; i++)
+			if (cam_data->camera_formats[i]->fourcc == pixfmt) {
+				cam_fmt = cam_data->camera_formats[i];
+				break;
+			}
+
+		/* Next, if failed, check synthesized formats */
+		if (!cam_fmt)
+			for (i = 0; i < cam_data->extra_formats_num; i++)
+				if (cam_data->extra_formats[i].fourcc ==
+				    pixfmt) {
+					cam_fmt = cam_data->extra_formats + i;
+					/* TODO: synthesize... */
+					dev_err(&icd->dev,
+						"Cannot provide format 0x%x\n",
+						pixfmt);
+					return -EOPNOTSUPP;
+				}
+
 		if (!cam_fmt)
 			return -EINVAL;
 	}
@@ -924,18 +1083,31 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	const struct soc_camera_data_format *cam_fmt;
+	struct camera_data *cam_data = icd->host_priv;
+	const struct soc_camera_data_format *cam_fmt = NULL;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	int ret = pxa_camera_try_bus_param(icd, pix->pixelformat);
+	__u32 pixfmt = pix->pixelformat;
+	int ret = pxa_camera_try_bus_param(icd, pixfmt);
+	int i;
 
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * TODO: find a suitable supported by the SoC output format, check
-	 * whether the sensor supports one of acceptable input formats.
-	 */
-	cam_fmt = soc_camera_format_by_fourcc(icd, pix->pixelformat);
+	/* First check camera native formats */
+	for (i = 0; i < cam_data->camera_formats_num; i++)
+		if (cam_data->camera_formats[i]->fourcc == pixfmt) {
+			cam_fmt = cam_data->camera_formats[i];
+			break;
+		}
+
+	/* Next, if failed, check synthesized formats */
+	if (!cam_fmt)
+		for (i = 0; i < cam_data->extra_formats_num; i++)
+			if (cam_data->extra_formats[i].fourcc == pixfmt) {
+				cam_fmt = cam_data->extra_formats + i;
+				break;
+			}
+
 	if (!cam_fmt)
 		return -EINVAL;
 
@@ -962,11 +1134,16 @@ static int pxa_camera_enum_fmt(struct soc_camera_device *icd,
 			       struct v4l2_fmtdesc *f)
 {
 	const struct soc_camera_data_format *format;
+	struct camera_data *cam_data = icd->host_priv;
 
-	if (f->index >= icd->num_formats)
+	if (f->index >= cam_data->camera_formats_num + cam_data->extra_formats_num)
 		return -EINVAL;
 
-	format = &icd->formats[f->index];
+	if (f->index < cam_data->camera_formats_num)
+		format = cam_data->camera_formats[f->index];
+	else
+		format = &cam_data->extra_formats[f->index -
+						  cam_data->camera_formats_num];
 
 	strlcpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
