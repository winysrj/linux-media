Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53091 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754532Ab0BDT2k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 14:28:40 -0500
Date: Thu, 4 Feb 2010 20:28:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] MT9T031: write xskip and yskip at each set_params call
In-Reply-To: <4B580FE8.8080203@epfl.ch>
Message-ID: <Pine.LNX.4.64.1002041514490.19438@axis700.grange>
References: <1264013696-11315-1-git-send-email-valentin.longchamp@epfl.ch>
 <Pine.LNX.4.64.1001202010190.4151@axis700.grange> <4B580FE8.8080203@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added two more persons to CC, because I think, this discussion can be 
interesting for them too)

On Thu, 21 Jan 2010, Valentin Longchamp wrote:

> Guennadi Liakhovetski wrote:
> > On Wed, 20 Jan 2010, Valentin Longchamp wrote:
> > 
> > > This prevents the registers to be different to the computed values
> > > the second time you open the same camera with the sames parameters.
> > > 
> > > The images were different between the first device open and the
> > > second one with the same parameters.
> > 
> > But why they were different? Weren't xskip and yskip preserved from the
> > previous S_CROP / S_FMT configuration? If so, then, I am afraid, this is the
> > behaviour, mandated by the API, and as such shall not be changed. Or have I
> > misunderstood you?
> 
> Here are more details about what I debugged:

Sorry for taking so long to reply.

> First more details about what I do with the camera: I open the device, issue
> the S_CROP / S_FMT calls and read images, the behaviour is fine, then close
> the device.
> 
> Then if I reopen the device, reissue the S_CROP / S_FMT calls with the same
> params, but the images is not the sames because of different xskip and yskip.
> From what I have debugged in the driver at the second S_CROP /S_FMT, xskip and
> yskip are computed by mt9t031_skip (and have the same value that the one
> stored in the mt9t031 struct) and thus with the current code are not
> rewritten.
> 
> However, if I read the register values containing bin and skip values on the
> camera chip they have been reset (does a open/close do some reset to the cam
> ?) and thus different than the ones that should be written.

Yes, if hooks are provided by the platform, on last close we power down 
cameras, on first open we power on and reset them.

> I hope this clarifies the problem that I am experiencing. I don't think that
> the API wants you to get two different images when you open the device and
> issue the same parameters twice.

Yes, sorry, this is a different issue. The issue is - too crude power 
management in soc-camera. What we should do is implement proper (runtime) 
power-management in soc-camera (ideally, in v4l2-subdev API) and call 
suspend() to save registers before powering down, and resume() after 
powering on and resetting.

I gave it a shot and just posted a patch

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/15686

(hm, would have been smart to cc you, sorry), doing just that. Below is an 
example dummy implementation for mt9v022. Please, use it as example to 
implement suspend / resume for mt9t031, for now, I think, it would suffice 
if you just restore xskip and yskip in restore and skip suspend. If more 
is needed in the future, we can always extend it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

[PATCH] soc-camera: DUMMY runtime power-management for mt9v022 (not for mainline)

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 1a34d29..08a3478 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -8,15 +8,17 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/videodev2.h>
-#include <linux/slab.h>
-#include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/i2c.h>
 #include <linux/log2.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
 
-#include <media/v4l2-subdev.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-subdev.h>
 
 /*
  * mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
@@ -718,6 +720,28 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return 0;
 }
 
+static int mt9v022_runtime_suspend(struct device *dev)
+{
+	dev_info(dev, "%s\n", __func__);
+	return 0;
+}
+
+static int mt9v022_runtime_resume(struct device *dev)
+{
+	dev_info(dev, "%s\n", __func__);
+	return 0;
+}
+
+static struct dev_pm_ops mt9v022_dev_pm_ops = {
+	.runtime_suspend	= mt9v022_runtime_suspend,
+	.runtime_resume		= mt9v022_runtime_resume,
+};
+
+static struct device_type mt9v022_dev_type = {
+	.name		= "MT9V022",
+	.pm		= &mt9v022_dev_pm_ops,
+};
+
 /*
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
@@ -727,6 +751,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 {
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct video_device *vdev = soc_camera_i2c_to_vdev(client);
 	s32 data;
 	int ret;
 	unsigned long flags;
@@ -803,6 +828,8 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 	ret = mt9v022_init(client);
 	if (ret < 0)
 		dev_err(&client->dev, "Failed to initialise the camera\n");
+	else
+		vdev->dev.type = &mt9v022_dev_type;
 
 ei2c:
 	return ret;
