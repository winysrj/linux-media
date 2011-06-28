Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:61812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab1F1Nrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 09:47:53 -0400
Date: Tue, 28 Jun 2011 15:47:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
In-Reply-To: <Pine.LNX.4.64.0807310008190.26534@axis700.grange>
Message-ID: <Pine.LNX.4.64.1106281515030.30771@axis700.grange>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0807270155020.29126@axis700.grange> <878wvnkd8n.fsf@free.fr>
 <Pine.LNX.4.64.0807271337270.1604@axis700.grange> <87tze997uu.fsf@free.fr>
 <Pine.LNX.4.64.0807291902200.17188@axis700.grange> <87iqun2ge3.fsf@free.fr>
 <Pine.LNX.4.64.0807310008190.26534@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Robert

Hope you don't mind me resuming an almost 3 year old mail thread;) I'm 
referring to your patches to soc-camera core and pxa-camera, adding PM 
support to them. Below is your message again, explaining, why the standard 
pm hooks cannot be used to suspend and resume the camera host and the 
camera sensor. While trying to make soc-camera play nicer with the V4L2 
generic framework, I was trying to eliminate as many redundant pieces from 
soc-camera as possible and replace them with standard methods. This made 
me re-consider those your patches. Let's have a look at your 
argumentation:

On Thu, 31 Jul 2008, Guennadi Liakhovetski wrote:

> On Wed, 30 Jul 2008, Robert Jarzmik wrote:
> 
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> > 
> > >> >> For the camera part, by now, I'm using standard suspend/resume functions of the
> > >> >> platform driver (mt9m111.c). It does work, but it's not clean ATM. The chaining
> > >> >> between the driver resume function and the availability of the I2C bus are not
> > >> >> properly chained. I'm still working on it.
> > >> >
> > >> > Yes, we have to clarify this too.
> > All right, I have my mind clarified, let's discuss now.
> > 
> > >>  - I cook up a clean suspend/resume (unless you did it first of course :)
> > Well, let's expose what we're facing here :
> >  - our video chip driver (ex: mt9m111) is an i2c driver
> >   => its resume function is called when i2c bus is resumed, so all is fine here
> > 
> >  - our video chip needs an external clock to work
> >   => example: mt9m111 needs a clock from pxa camera interface to have its i2c
> >   unit enabled
> >   => the mt9m111 driver resume function is unusable, as pxa_camera is resumed
> >   _after_ mt9m111, and thus mt9m111's i2c unit is not available at that moment
> > 
> >  - a working suspend/resume restores fully the video chip state
> >   => restores width/height/bpp
> >   => restores autoexposure, brightness, etc ...
> >   => all that insures userland is not impacted by suspend/resume
> > 
> > So, the only way I see to have suspend/resume working is :
> >  - modify soc_camera_ops to add suspend and resume functions
> >  - add suspend and resume functions in each chip driver (mt9m001, mt9m111, ...)
> >  - modify soc_camera.c (or pxa_camera.c ?) to call icd->ops->suspend() and
> >  icd->ops->resume()
> >  - modify pxa_camera.c (the patch I sent before)

So, we currently have 3 instances: soc-camera bus, i2c bus, and pxa-camera 
platform device driver. You say, i2c resumes as first, then at some point 
pxa-camera and soc-camera - in this or reverse order. This is why we 
cannoe use i2c-resume to bring the sensor up before pxa-camera has 
restored its master clock. So, currently we hook onto the soc-camera bus, 
which then calls pxa-camera's resume, which then restores camera host's 
state and resumes the sensor. Now, the question: wouldn't this also work, 
if we eliminate the soc-camera resume path? And instead just used 
pxa-camera resume method to bring up the sensor? Coule you please test the 
below patch?

Thanks
Guennadi

> > 
> > Would you find that acceptable, or is there a better way ?
> 
> Ok, you're suggesting to add suspend() and resume() to 
> soc_camera_bus_type, right? But are we sure that its resume will be called 
> after both camera (so far i2c) and host (so far platform, can also be PCI 
> or USB...) busses are resumed? If not, we might have to do something 
> similar to scan_add_host() / scan_add_device() - accept signals from the 
> host and the camera and when both are ready actually resume them...
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Subject: [PATCH] V4L: remove soc-camera PM, use camera host driver PM instead

Using soc-camera bus power management to suspend and resume video devices 
introduces a redundant indirection level. It can easily be removed by 
using camera host driver's own PM hooks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index ebebed9..ec9e829 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -727,7 +727,7 @@ static const struct v4l2_queryctrl mt9m111_controls[] = {
 };
 
 static int mt9m111_resume(struct soc_camera_device *icd);
-static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state);
+static int mt9m111_suspend(struct soc_camera_device *icd);
 
 static struct soc_camera_ops mt9m111_ops = {
 	.suspend		= mt9m111_suspend,
@@ -901,7 +901,7 @@ static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return ret;
 }
 
-static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state)
+static int mt9m111_suspend(struct soc_camera_device *icd)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index b42bfa5..9cbf7f8 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1584,9 +1584,9 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
-static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
+static int pxa_camera_suspend(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int i = 0, ret = 0;
 
@@ -1596,15 +1596,15 @@ static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
-	if ((pcdev->icd) && (pcdev->icd->ops->suspend))
-		ret = pcdev->icd->ops->suspend(pcdev->icd, state);
+	if (pcdev->icd && pcdev->icd->ops->suspend)
+		ret = pcdev->icd->ops->suspend(pcdev->icd);
 
 	return ret;
 }
 
-static int pxa_camera_resume(struct soc_camera_device *icd)
+static int pxa_camera_resume(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int i = 0, ret = 0;
 
@@ -1618,7 +1618,7 @@ static int pxa_camera_resume(struct soc_camera_device *icd)
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
-	if ((pcdev->icd) && (pcdev->icd->ops->resume))
+	if (pcdev->icd && pcdev->icd->ops->resume)
 		ret = pcdev->icd->ops->resume(pcdev->icd);
 
 	/* Restart frame capture if active buffer exists */
@@ -1632,8 +1632,6 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= pxa_camera_add_device,
 	.remove		= pxa_camera_remove_device,
-	.suspend	= pxa_camera_suspend,
-	.resume		= pxa_camera_resume,
 	.set_crop	= pxa_camera_set_crop,
 	.get_formats	= pxa_camera_get_formats,
 	.put_formats	= pxa_camera_put_formats,
@@ -1818,9 +1816,15 @@ static int __devexit pxa_camera_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct dev_pm_ops pxa_camera_pm = {
+	.suspend	= pxa_camera_suspend,
+	.resume		= pxa_camera_resume,
+};
+
 static struct platform_driver pxa_camera_driver = {
 	.driver 	= {
 		.name	= PXA_CAM_DRV_NAME,
+		.pm	= &pxa_camera_pm,
 	},
 	.probe		= pxa_camera_probe,
 	.remove		= __devexit_p(pxa_camera_remove),
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 4e4d412..76fd30f 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1216,36 +1216,10 @@ static int soc_camera_remove(struct device *dev)
 	return 0;
 }
 
-static int soc_camera_suspend(struct device *dev, pm_message_t state)
-{
-	struct soc_camera_device *icd = to_soc_camera_dev(dev);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int ret = 0;
-
-	if (ici->ops->suspend)
-		ret = ici->ops->suspend(icd, state);
-
-	return ret;
-}
-
-static int soc_camera_resume(struct device *dev)
-{
-	struct soc_camera_device *icd = to_soc_camera_dev(dev);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int ret = 0;
-
-	if (ici->ops->resume)
-		ret = ici->ops->resume(icd);
-
-	return ret;
-}
-
 struct bus_type soc_camera_bus_type = {
 	.name		= "soc-camera",
 	.probe		= soc_camera_probe,
 	.remove		= soc_camera_remove,
-	.suspend	= soc_camera_suspend,
-	.resume		= soc_camera_resume,
 };
 EXPORT_SYMBOL_GPL(soc_camera_bus_type);
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 238bd33..a256f74 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -66,8 +66,6 @@ struct soc_camera_host_ops {
 	struct module *owner;
 	int (*add)(struct soc_camera_device *);
 	void (*remove)(struct soc_camera_device *);
-	int (*suspend)(struct soc_camera_device *, pm_message_t);
-	int (*resume)(struct soc_camera_device *);
 	/*
 	 * .get_formats() is called for each client device format, but
 	 * .put_formats() is only called once. Further, if any of the calls to
@@ -207,7 +205,7 @@ struct soc_camera_format_xlate {
 };
 
 struct soc_camera_ops {
-	int (*suspend)(struct soc_camera_device *, pm_message_t state);
+	int (*suspend)(struct soc_camera_device *);
 	int (*resume)(struct soc_camera_device *);
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
