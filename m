Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34DfY9B005688
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 09:41:34 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m34DfGFW031194
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 09:41:17 -0400
Date: Fri, 4 Apr 2008 15:41:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0804041537100.5438@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] soc-camera: extract function pointers from host object into
 operations
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

Function pointers and the driver owner are not expected to change 
throughout soc-camera host's life. Extract them into an operations struct.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 4756699..9758f7e 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -803,20 +803,25 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
-/* Should beallocated dynamically too, but we have only one. */
+static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
+	.owner		= THIS_MODULE,
+	.add		= pxa_camera_add_device,
+	.remove		= pxa_camera_remove_device,
+	.set_fmt_cap	= pxa_camera_set_fmt_cap,
+	.try_fmt_cap	= pxa_camera_try_fmt_cap,
+	.reqbufs	= pxa_camera_reqbufs,
+	.poll		= pxa_camera_poll,
+	.querycap	= pxa_camera_querycap,
+	.try_bus_param	= pxa_camera_try_bus_param,
+	.set_bus_param	= pxa_camera_set_bus_param,
+};
+
+/* Should be allocated dynamically too, but we have only one. */
 static struct soc_camera_host pxa_soc_camera_host = {
 	.drv_name		= PXA_CAM_DRV_NAME,
 	.vbq_ops		= &pxa_videobuf_ops,
-	.add			= pxa_camera_add_device,
-	.remove			= pxa_camera_remove_device,
 	.msize			= sizeof(struct pxa_buffer),
-	.set_fmt_cap		= pxa_camera_set_fmt_cap,
-	.try_fmt_cap		= pxa_camera_try_fmt_cap,
-	.reqbufs		= pxa_camera_reqbufs,
-	.poll			= pxa_camera_poll,
-	.querycap		= pxa_camera_querycap,
-	.try_bus_param		= pxa_camera_try_bus_param,
-	.set_bus_param		= pxa_camera_set_bus_param,
+	.ops			= &pxa_soc_camera_host_ops,
 };
 
 static int pxa_camera_probe(struct platform_device *pdev)
@@ -912,7 +917,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pxa_soc_camera_host.priv	= pcdev;
 	pxa_soc_camera_host.dev.parent	= &pdev->dev;
 	pxa_soc_camera_host.nr		= pdev->id;
-	err = soc_camera_host_register(&pxa_soc_camera_host, THIS_MODULE);
+	err = soc_camera_host_register(&pxa_soc_camera_host);
 	if (err)
 		goto exit_free_irq;
 
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 4af38d4..43c8110 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -76,12 +76,12 @@ static int soc_camera_try_fmt_cap(struct file *file, void *priv,
 	}
 
 	/* test physical bus parameters */
-	ret = ici->try_bus_param(icd, f->fmt.pix.pixelformat);
+	ret = ici->ops->try_bus_param(icd, f->fmt.pix.pixelformat);
 	if (ret)
 		return ret;
 
 	/* limit format to hardware capabilities */
-	ret = ici->try_fmt_cap(icd, f);
+	ret = ici->ops->try_fmt_cap(icd, f);
 
 	/* calculate missing fields */
 	f->fmt.pix.field = field;
@@ -143,7 +143,7 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	return ici->reqbufs(icf, p);
+	return ici->ops->reqbufs(icf, p);
 
 	return ret;
 }
@@ -203,7 +203,7 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 		goto emgd;
 	}
 
-	if (!try_module_get(ici->owner)) {
+	if (!try_module_get(ici->ops->owner)) {
 		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
 		ret = -EINVAL;
 		goto emgi;
@@ -215,7 +215,7 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
-		ret = ici->add(icd);
+		ret = ici->ops->add(icd);
 		if (ret < 0) {
 			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
 			icd->use_count--;
@@ -238,7 +238,7 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* All errors are entered with the video_lock held */
 eiciadd:
-	module_put(ici->owner);
+	module_put(ici->ops->owner);
 emgi:
 	module_put(icd->ops->owner);
 emgd:
@@ -257,9 +257,9 @@ static int soc_camera_close(struct inode *inode, struct file *file)
 	mutex_lock(&video_lock);
 	icd->use_count--;
 	if (!icd->use_count)
-		ici->remove(icd);
+		ici->ops->remove(icd);
 	module_put(icd->ops->owner);
-	module_put(ici->owner);
+	module_put(ici->ops->owner);
 	mutex_unlock(&video_lock);
 
 	vfree(file->private_data);
@@ -312,7 +312,7 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 		return POLLERR;
 	}
 
-	return ici->poll(file, pt);
+	return ici->ops->poll(file, pt);
 }
 
 
@@ -356,7 +356,7 @@ static int soc_camera_s_fmt_cap(struct file *file, void *priv,
 	rect.top	= icd->y_current;
 	rect.width	= f->fmt.pix.width;
 	rect.height	= f->fmt.pix.height;
-	ret = ici->set_fmt_cap(icd, f->fmt.pix.pixelformat, &rect);
+	ret = ici->ops->set_fmt_cap(icd, f->fmt.pix.pixelformat, &rect);
 	if (ret < 0)
 		return ret;
 
@@ -372,7 +372,7 @@ static int soc_camera_s_fmt_cap(struct file *file, void *priv,
 		icd->width, icd->height);
 
 	/* set physical bus parameters */
-	return ici->set_bus_param(icd, f->fmt.pix.pixelformat);
+	return ici->ops->set_bus_param(icd, f->fmt.pix.pixelformat);
 }
 
 static int soc_camera_enum_fmt_cap(struct file *file, void  *priv,
@@ -426,7 +426,7 @@ static int soc_camera_querycap(struct file *file, void  *priv,
 	WARN_ON(priv != file->private_data);
 
 	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
-	return ici->querycap(ici, cap);
+	return ici->ops->querycap(ici, cap);
 }
 
 static int soc_camera_streamon(struct file *file, void *priv,
@@ -579,7 +579,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	ret = ici->set_fmt_cap(icd, 0, &a->c);
+	ret = ici->ops->set_fmt_cap(icd, 0, &a->c);
 	if (!ret) {
 		icd->width	= a->c.width;
 		icd->height	= a->c.height;
@@ -706,7 +706,7 @@ static int soc_camera_probe(struct device *dev)
 
 	/* We only call ->add() here to activate and probe the camera.
 	 * We shall ->remove() and deactivate it immediately afterwards. */
-	ret = ici->add(icd);
+	ret = ici->ops->add(icd);
 	if (ret < 0)
 		return ret;
 
@@ -720,7 +720,7 @@ static int soc_camera_probe(struct device *dev)
 		icd->exposure = qctrl ? qctrl->default_value :
 			(unsigned short)~0;
 	}
-	ici->remove(icd);
+	ici->ops->remove(icd);
 
 	return ret;
 }
@@ -762,12 +762,12 @@ static void dummy_release(struct device *dev)
 {
 }
 
-int soc_camera_host_register(struct soc_camera_host *ici, struct module *owner)
+int soc_camera_host_register(struct soc_camera_host *ici)
 {
 	int ret;
 	struct soc_camera_host *ix;
 
-	if (!ici->vbq_ops || !ici->add || !ici->remove || !owner)
+	if (!ici->vbq_ops || !ici->ops->add || !ici->ops->remove)
 		return -EINVAL;
 
 	/* Number might be equal to the platform device ID */
@@ -785,7 +785,6 @@ int soc_camera_host_register(struct soc_camera_host *ici, struct module *owner)
 	list_add_tail(&ici->list, &hosts);
 	mutex_unlock(&list_lock);
 
-	ici->owner = owner;
 	ici->dev.release = dummy_release;
 
 	ret = device_register(&ici->dev);
@@ -819,7 +818,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 		if (icd->dev.parent == &ici->dev) {
 			device_unregister(&icd->dev);
 			/* Not before device_unregister(), .remove
-			 * needs parent to call ici->remove() */
+			 * needs parent to call ici->ops->remove() */
 			icd->dev.parent = NULL;
 			memset(&icd->dev.kobj, 0, sizeof(icd->dev.kobj));
 		}
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 7a2fa3e..80e1193 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -56,9 +56,13 @@ struct soc_camera_host {
 	unsigned char nr;				/* Host number */
 	size_t msize;
 	struct videobuf_queue_ops *vbq_ops;
-	struct module *owner;
 	void *priv;
 	char *drv_name;
+	struct soc_camera_host_ops *ops;
+};
+
+struct soc_camera_host_ops {
+	struct module *owner;
 	int (*add)(struct soc_camera_device *);
 	void (*remove)(struct soc_camera_device *);
 	int (*set_fmt_cap)(struct soc_camera_device *, __u32,
@@ -88,8 +92,7 @@ static inline struct soc_camera_host *to_soc_camera_host(struct device *dev)
 	return container_of(dev, struct soc_camera_host, dev);
 }
 
-extern int soc_camera_host_register(struct soc_camera_host *ici,
-				     struct module *owner);
+extern int soc_camera_host_register(struct soc_camera_host *ici);
 extern void soc_camera_host_unregister(struct soc_camera_host *ici);
 extern int soc_camera_device_register(struct soc_camera_device *icd);
 extern void soc_camera_device_unregister(struct soc_camera_device *icd);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
