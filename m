Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2OCJ1GT003901
	for <video4linux-list@redhat.com>; Mon, 24 Mar 2008 08:19:01 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2OCITk3026290
	for <video4linux-list@redhat.com>; Mon, 24 Mar 2008 08:18:29 -0400
Date: Mon, 24 Mar 2008 13:18:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0803241309500.4176@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] soc-camera: improve separation between soc_camera_ops and
 soc_camera_device
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

In case of muliple cameras, handled by the same driver, they can support 
different picture formats, therefore formats and num_formats cannot belong 
to soc_camera_ops, which is only one per driver, move them to 
soc_camera_device, which is one per device instance. OTOH, probe and 
remove methods are always the same, move them to soc_camera_ops.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

Thanks to Eric Miao for making me look at this code again:-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index acb5454..2ea133e 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -410,11 +410,15 @@ const struct v4l2_queryctrl mt9m001_controls[] = {
 	}
 };
 
-static int mt9m001_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl);
-static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl);
+static int mt9m001_video_probe(struct soc_camera_device *);
+static void mt9m001_video_remove(struct soc_camera_device *);
+static int mt9m001_get_control(struct soc_camera_device *, struct v4l2_control *);
+static int mt9m001_set_control(struct soc_camera_device *, struct v4l2_control *);
 
 static struct soc_camera_ops mt9m001_ops = {
 	.owner			= THIS_MODULE,
+	.probe			= mt9m001_video_probe,
+	.remove			= mt9m001_video_remove,
 	.init			= mt9m001_init,
 	.release		= mt9m001_release,
 	.start_capture		= mt9m001_start_capture,
@@ -423,8 +427,6 @@ static struct soc_camera_ops mt9m001_ops = {
 	.try_fmt_cap		= mt9m001_try_fmt_cap,
 	.set_bus_param		= mt9m001_set_bus_param,
 	.query_bus_param	= mt9m001_query_bus_param,
-	.formats		= NULL, /* Filled in later depending on the */
-	.num_formats		= 0,	/* camera type and data widths */
 	.controls		= mt9m001_controls,
 	.num_controls		= ARRAY_SIZE(mt9m001_controls),
 	.get_control		= mt9m001_get_control,
@@ -573,19 +575,19 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	case 0x8411:
 	case 0x8421:
 		mt9m001->model = V4L2_IDENT_MT9M001C12ST;
-		mt9m001_ops.formats = mt9m001_colour_formats;
+		icd->formats = mt9m001_colour_formats;
 		if (mt9m001->client->dev.platform_data)
-			mt9m001_ops.num_formats = ARRAY_SIZE(mt9m001_colour_formats);
+			icd->num_formats = ARRAY_SIZE(mt9m001_colour_formats);
 		else
-			mt9m001_ops.num_formats = 1;
+			icd->num_formats = 1;
 		break;
 	case 0x8431:
 		mt9m001->model = V4L2_IDENT_MT9M001C12STM;
-		mt9m001_ops.formats = mt9m001_monochrome_formats;
+		icd->formats = mt9m001_monochrome_formats;
 		if (mt9m001->client->dev.platform_data)
-			mt9m001_ops.num_formats = ARRAY_SIZE(mt9m001_monochrome_formats);
+			icd->num_formats = ARRAY_SIZE(mt9m001_monochrome_formats);
 		else
-			mt9m001_ops.num_formats = 1;
+			icd->num_formats = 1;
 		break;
 	default:
 		ret = -ENODEV;
@@ -646,8 +648,6 @@ static int mt9m001_probe(struct i2c_client *client)
 
 	/* Second stage probe - when a capture adapter is there */
 	icd = &mt9m001->icd;
-	icd->probe	= mt9m001_video_probe;
-	icd->remove	= mt9m001_video_remove;
 	icd->ops	= &mt9m001_ops;
 	icd->control	= &client->dev;
 	icd->x_min	= 20;
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index a2f161d..d4b9e27 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -506,13 +506,15 @@ const struct v4l2_queryctrl mt9v022_controls[] = {
 	}
 };
 
-static int mt9v022_get_control(struct soc_camera_device *icd,
-			       struct v4l2_control *ctrl);
-static int mt9v022_set_control(struct soc_camera_device *icd,
-			       struct v4l2_control *ctrl);
+static int mt9v022_video_probe(struct soc_camera_device *);
+static void mt9v022_video_remove(struct soc_camera_device *);
+static int mt9v022_get_control(struct soc_camera_device *, struct v4l2_control *);
+static int mt9v022_set_control(struct soc_camera_device *, struct v4l2_control *);
 
 static struct soc_camera_ops mt9v022_ops = {
 	.owner			= THIS_MODULE,
+	.probe			= mt9v022_video_probe,
+	.remove			= mt9v022_video_remove,
 	.init			= mt9v022_init,
 	.release		= mt9v022_release,
 	.start_capture		= mt9v022_start_capture,
@@ -521,8 +523,6 @@ static struct soc_camera_ops mt9v022_ops = {
 	.try_fmt_cap		= mt9v022_try_fmt_cap,
 	.set_bus_param		= mt9v022_set_bus_param,
 	.query_bus_param	= mt9v022_query_bus_param,
-	.formats		= NULL, /* Filled in later depending on the */
-	.num_formats		= 0,	/* sensor type and data widths */
 	.controls		= mt9v022_controls,
 	.num_controls		= ARRAY_SIZE(mt9v022_controls),
 	.get_control		= mt9v022_get_control,
@@ -705,19 +705,19 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 			    !strcmp("color", sensor_type))) {
 		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
-		mt9v022_ops.formats = mt9v022_colour_formats;
+		icd->formats = mt9v022_colour_formats;
 		if (mt9v022->client->dev.platform_data)
-			mt9v022_ops.num_formats = ARRAY_SIZE(mt9v022_colour_formats);
+			icd->num_formats = ARRAY_SIZE(mt9v022_colour_formats);
 		else
-			mt9v022_ops.num_formats = 1;
+			icd->num_formats = 1;
 	} else {
 		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATM;
-		mt9v022_ops.formats = mt9v022_monochrome_formats;
+		icd->formats = mt9v022_monochrome_formats;
 		if (mt9v022->client->dev.platform_data)
-			mt9v022_ops.num_formats = ARRAY_SIZE(mt9v022_monochrome_formats);
+			icd->num_formats = ARRAY_SIZE(mt9v022_monochrome_formats);
 		else
-			mt9v022_ops.num_formats = 1;
+			icd->num_formats = 1;
 	}
 
 	if (ret >= 0)
@@ -773,8 +773,6 @@ static int mt9v022_probe(struct i2c_client *client)
 	i2c_set_clientdata(client, mt9v022);
 
 	icd = &mt9v022->icd;
-	icd->probe	= mt9v022_video_probe;
-	icd->remove	= mt9v022_video_remove;
 	icd->ops	= &mt9v022_ops;
 	icd->control	= &client->dev;
 	icd->x_min	= 1;
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index bd8677c..75d1e88 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -38,9 +38,9 @@ format_by_fourcc(struct soc_camera_device *icd, unsigned int fourcc)
 {
 	unsigned int i;
 
-	for (i = 0; i < icd->ops->num_formats; i++)
-		if (icd->ops->formats[i].fourcc == fourcc)
-			return icd->ops->formats + i;
+	for (i = 0; i < icd->num_formats; i++)
+		if (icd->formats[i].fourcc == fourcc)
+			return icd->formats + i;
 	return NULL;
 }
 
@@ -384,10 +384,10 @@ static int soc_camera_enum_fmt_cap(struct file *file, void  *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	if (f->index >= icd->ops->num_formats)
+	if (f->index >= icd->num_formats)
 		return -EINVAL;
 
-	format = &icd->ops->formats[f->index];
+	format = &icd->formats[f->index];
 
 	strlcpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
@@ -701,7 +701,7 @@ static int soc_camera_probe(struct device *dev)
 		to_soc_camera_host(icd->dev.parent);
 	int ret;
 
-	if (!icd->probe)
+	if (!icd->ops->probe)
 		return -ENODEV;
 
 	/* We only call ->add() here to activate and probe the camera.
@@ -710,7 +710,7 @@ static int soc_camera_probe(struct device *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = icd->probe(icd);
+	ret = icd->ops->probe(icd);
 	if (ret >= 0) {
 		const struct v4l2_queryctrl *qctrl;
 
@@ -731,8 +731,8 @@ static int soc_camera_remove(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
 
-	if (icd->remove)
-		icd->remove(icd);
+	if (icd->ops->remove)
+		icd->ops->remove(icd);
 
 	return 0;
 }
@@ -928,7 +928,7 @@ int soc_camera_video_start(struct soc_camera_device *icd)
 	vdev->vidioc_s_register	= soc_camera_s_register;
 #endif
 
-	icd->current_fmt = &icd->ops->formats[0];
+	icd->current_fmt = &icd->formats[0];
 
 	err = video_register_device(vdev, VFL_TYPE_GRABBER, vdev->minor);
 	if (err < 0) {
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 3e48e43..7a2fa3e 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -38,8 +38,8 @@ struct soc_camera_device {
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
 	const struct soc_camera_data_format *current_fmt;
-	int (*probe)(struct soc_camera_device *icd);
-	void (*remove)(struct soc_camera_device *icd);
+	const struct soc_camera_data_format *formats;
+	int num_formats;
 	struct module *owner;
 	/* soc_camera.c private count. Only accessed with video_lock held */
 	int use_count;
@@ -106,6 +106,8 @@ struct soc_camera_data_format {
 
 struct soc_camera_ops {
 	struct module *owner;
+	int (*probe)(struct soc_camera_device *);
+	void (*remove)(struct soc_camera_device *);
 	int (*init)(struct soc_camera_device *);
 	int (*release)(struct soc_camera_device *);
 	int (*start_capture)(struct soc_camera_device *);
@@ -121,8 +123,6 @@ struct soc_camera_ops {
 	int (*get_register)(struct soc_camera_device *, struct v4l2_register *);
 	int (*set_register)(struct soc_camera_device *, struct v4l2_register *);
 #endif
-	const struct soc_camera_data_format *formats;
-	int num_formats;
 	int (*get_control)(struct soc_camera_device *, struct v4l2_control *);
 	int (*set_control)(struct soc_camera_device *, struct v4l2_control *);
 	const struct v4l2_queryctrl *controls;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
