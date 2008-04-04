Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34DkbtB010689
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 09:46:37 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m34DkPtO002666
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 09:46:26 -0400
Date: Fri, 4 Apr 2008 15:46:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <20080329035953.GA10356@plankton.ifup.org>
Message-ID: <Pine.LNX.4.64.0804041541440.5438@axis700.grange>
References: <7876c2bc2446dc3e3630.1206699512@localhost>
	<Pine.LNX.4.64.0803282114540.22651@axis700.grange>
	<20080329035953.GA10356@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] soc-camera: use a spinlock for videobuffer queue
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

All drivers should provide a spinlock to be used in videobuf operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

On Fri, 28 Mar 2008, Brandon Philips wrote:

> On 21:53 Fri 28 Mar 2008, Guennadi Liakhovetski wrote:
> 
> > OTOH, at least the PXA270 hardware needs a more global protection - to 
> > protect the DMA channel setup. And this is hardware specific. We can just 
> > assume that (imaginary) systems with multiple camera busses will have an 
> > own DMA channel per bus and will allow their concurrent onfiguration... 
> > Maybe we should let the hardware host driver decide on spinlock locality 
> > and just use whatever it provides?
> 
> I don't know enough about the hardware to comment.

How about this one? Mauro, note: it should be applied after the previous 
patch, introducing soc_camera_host_ops.

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 9758f7e..bef3c9c 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -803,6 +803,15 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
+static spinlock_t *pxa_camera_spinlock_alloc(struct soc_camera_file *icf)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icf->icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+
+	return &pcdev->lock;
+}
+
 static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= pxa_camera_add_device,
@@ -814,6 +823,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.querycap	= pxa_camera_querycap,
 	.try_bus_param	= pxa_camera_try_bus_param,
 	.set_bus_param	= pxa_camera_set_bus_param,
+	.spinlock_alloc	= pxa_camera_spinlock_alloc,
 };
 
 /* Should be allocated dynamically too, but we have only one. */
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 43c8110..1e92157 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -184,6 +184,7 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 	struct soc_camera_device *icd;
 	struct soc_camera_host *ici;
 	struct soc_camera_file *icf;
+	spinlock_t *lock;
 	int ret;
 
 	icf = vmalloc(sizeof(*icf));
@@ -209,10 +210,16 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 		goto emgi;
 	}
 
-	icd->use_count++;
-
 	icf->icd = icd;
 
+	icf->lock = ici->ops->spinlock_alloc(icf);
+	if (!icf->lock) {
+		ret = -ENOMEM;
+		goto esla;
+	}
+
+	icd->use_count++;
+
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
 		ret = ici->ops->add(icd);
@@ -229,8 +236,8 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 	dev_dbg(&icd->dev, "camera device open\n");
 
 	/* We must pass NULL as dev pointer, then all pci_* dma operations
-	 * transform to normal dma_* ones. Do we need an irqlock? */
-	videobuf_queue_sg_init(&icf->vb_vidq, ici->vbq_ops, NULL, NULL,
+	 * transform to normal dma_* ones. */
+	videobuf_queue_sg_init(&icf->vb_vidq, ici->vbq_ops, NULL, icf->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
 				ici->msize, icd);
 
@@ -238,6 +245,11 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* All errors are entered with the video_lock held */
 eiciadd:
+	lock = icf->lock;
+	icf->lock = NULL;
+	if (ici->ops->spinlock_free)
+		ici->ops->spinlock_free(lock);
+esla:
 	module_put(ici->ops->owner);
 emgi:
 	module_put(icd->ops->owner);
@@ -253,16 +265,20 @@ static int soc_camera_close(struct inode *inode, struct file *file)
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct video_device *vdev = icd->vdev;
+	spinlock_t *lock = icf->lock;
 
 	mutex_lock(&video_lock);
 	icd->use_count--;
 	if (!icd->use_count)
 		ici->ops->remove(icd);
+	icf->lock = NULL;
+	if (ici->ops->spinlock_free)
+		ici->ops->spinlock_free(lock);
 	module_put(icd->ops->owner);
 	module_put(ici->ops->owner);
 	mutex_unlock(&video_lock);
 
-	vfree(file->private_data);
+	vfree(icf);
 
 	dev_dbg(vdev->dev, "camera device close\n");
 
@@ -762,6 +778,21 @@ static void dummy_release(struct device *dev)
 {
 }
 
+static spinlock_t *spinlock_alloc(struct soc_camera_file *icf)
+{
+	spinlock_t *lock = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
+
+	if (lock)
+		spin_lock_init(lock);
+
+	return lock;
+}
+
+static void spinlock_free(spinlock_t *lock)
+{
+	kfree(lock);
+}
+
 int soc_camera_host_register(struct soc_camera_host *ici)
 {
 	int ret;
@@ -792,6 +823,11 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	if (ret)
 		goto edevr;
 
+	if (!ici->ops->spinlock_alloc) {
+		ici->ops->spinlock_alloc = spinlock_alloc;
+		ici->ops->spinlock_free = spinlock_free;
+	}
+
 	scan_add_host(ici);
 
 	return 0;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 80e1193..6a8c8be 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -48,6 +48,7 @@ struct soc_camera_device {
 struct soc_camera_file {
 	struct soc_camera_device *icd;
 	struct videobuf_queue vb_vidq;
+	spinlock_t *lock;
 };
 
 struct soc_camera_host {
@@ -73,6 +74,8 @@ struct soc_camera_host_ops {
 	int (*try_bus_param)(struct soc_camera_device *, __u32);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
 	unsigned int (*poll)(struct file *, poll_table *);
+	spinlock_t* (*spinlock_alloc)(struct soc_camera_file *);
+	void (*spinlock_free)(spinlock_t *);
 };
 
 struct soc_camera_link {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
