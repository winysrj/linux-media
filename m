Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2858 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZGkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 02:40:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mem2mem_testdev: fix missing v4l2_dev assignment
Date: Wed, 26 Jun 2013 08:40:37 +0200
Cc: Kamil Debski <k.debski@samsung.com>,
	Fengguang Wu <fengguang.wu@intel.com>
References: <201306260831.14370.hverkuil@xs4all.nl>
In-Reply-To: <201306260831.14370.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306260840.37988.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed June 26 2013 08:31:14 Hans Verkuil wrote:
> Hi Kamil,
> 
> This patch adds the missing v4l2_dev assignment as reported by Fengguang.
> 
> It also fixes a poorly formatted message:
> 
> m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as /dev/video0
> 
> Is it OK if I take this through my tree? I have similar fix as well in another
> driver.

Urgh, two more that make exactly the same mistake (copied-and-pasted from the
mem2mem driver, actually).

	Hans

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 7585646..540516c 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -1033,6 +1033,7 @@ static int deinterlace_probe(struct platform_device *pdev)
 
 	*vfd = deinterlace_videodev;
 	vfd->lock = &pcdev->dev_mutex;
+	vfd->v4l2_dev = &pcdev->v4l2_dev;
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index f7440e5..c690435 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -937,6 +937,7 @@ static int emmaprp_probe(struct platform_device *pdev)
 
 	*vfd = emmaprp_videodev;
 	vfd->lock = &pcdev->dev_mutex;
+	vfd->v4l2_dev = &pcdev->v4l2_dev;
 
 	video_set_drvdata(vfd, pcdev);
 	snprintf(vfd->name, sizeof(vfd->name), "%s", emmaprp_videodev.name);


> 
> Regards,
> 
> 	Hans
> 
> diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
> index 4cc7f65d..6a17676 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -1051,6 +1051,7 @@ static int m2mtest_probe(struct platform_device *pdev)
>  
>  	*vfd = m2mtest_videodev;
>  	vfd->lock = &dev->dev_mutex;
> +	vfd->v4l2_dev = &dev->v4l2_dev;
>  
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>  	if (ret) {
> @@ -1061,7 +1062,7 @@ static int m2mtest_probe(struct platform_device *pdev)
>  	video_set_drvdata(vfd, dev);
>  	snprintf(vfd->name, sizeof(vfd->name), "%s", m2mtest_videodev.name);
>  	dev->vfd = vfd;
> -	v4l2_info(&dev->v4l2_dev, MEM2MEM_TEST_MODULE_NAME
> +	v4l2_info(&dev->v4l2_dev,
>  			"Device registered as /dev/video%d\n", vfd->num);
>  
>  	setup_timer(&dev->timer, device_isr, (long)dev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
