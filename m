Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43545 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756156AbZFSGyv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 02:54:51 -0400
Date: Fri, 19 Jun 2009 08:54:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2] soc-camera: fix missing clean up on error path
In-Reply-To: <uvdmt9iy9.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0906190847480.4204@axis700.grange>
References: <ud49domlx.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0906091057120.4085@axis700.grange> <ubpoxoelq.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0906181722460.7460@axis700.grange> <uvdmt9iy9.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc-camera: fix missing clean up on error path

If soc_camera_init_user_formats() fails in soc_camera_probe(), we have to call
client's .remove() method to unregister the video device.

Reported-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
(please use the new V4L Mailing List)

On Fri, 19 Jun 2009, Kuninori Morimoto wrote:

> > If soc_camera_init_user_formats() fails in soc_camera_probe(), we have to call
> > client's .remove() method to unregister the video device.
> > 
> > Reported-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > Hi Morimoto-san
> (snip)
> > Could you please verify that this patch fixed your problem?
> 
> Thank you nice patch.
> I tried this, but kernel stoped in boot.
> 
> soc_camera_video_stop is called from icd->ops->remove 
> I think it have dead lock by icd->video_lock.
> 
> my kernel is from Paul's git and it's Makefile said 2.6.30-rc6

Yes, you're right. Please, try this version, but this is a bigger change, 
also affecting the regular (not error) path, so, I will have to test it 
too.

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 78010ab..9f5ae81 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -877,8 +877,11 @@ static int soc_camera_probe(struct device *dev)
 			(unsigned short)~0;
 
 		ret = soc_camera_init_user_formats(icd);
-		if (ret < 0)
+		if (ret < 0) {
+			if (icd->ops->remove)
+				icd->ops->remove(icd);
 			goto eiufmt;
+		}
 
 		icd->height	= DEFAULT_HEIGHT;
 		icd->width	= DEFAULT_WIDTH;
@@ -902,8 +905,10 @@ static int soc_camera_remove(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
 
+	mutex_lock(&icd->video_lock);
 	if (icd->ops->remove)
 		icd->ops->remove(icd);
+	mutex_unlock(&icd->video_lock);
 
 	soc_camera_free_user_formats(icd);
 
@@ -1145,6 +1150,7 @@ evidallocd:
 }
 EXPORT_SYMBOL(soc_camera_video_start);
 
+/* Called from client .remove() methods with .video_lock held */
 void soc_camera_video_stop(struct soc_camera_device *icd)
 {
 	struct video_device *vdev = icd->vdev;
@@ -1154,10 +1160,8 @@ void soc_camera_video_stop(struct soc_camera_device *icd)
 	if (!icd->dev.parent || !vdev)
 		return;
 
-	mutex_lock(&icd->video_lock);
 	video_unregister_device(vdev);
 	icd->vdev = NULL;
-	mutex_unlock(&icd->video_lock);
 }
 EXPORT_SYMBOL(soc_camera_video_stop);
 
