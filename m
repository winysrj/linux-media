Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21545 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3FZI4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 04:56:00 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOZ0088BSHQ2DC0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Jun 2013 09:55:58 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'linux-media' <linux-media@vger.kernel.org>
Cc: 'Fengguang Wu' <fengguang.wu@intel.com>
References: <201306260831.14370.hverkuil@xs4all.nl>
In-reply-to: <201306260831.14370.hverkuil@xs4all.nl>
Subject: RE: [PATCH] mem2mem_testdev: fix missing v4l2_dev assignment
Date: Wed, 26 Jun 2013 10:55:51 +0200
Message-id: <00d501ce724a$f706d6d0$e5148470$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Wednesday, June 26, 2013 8:31 AM
> 
> Hi Kamil,
> 
> This patch adds the missing v4l2_dev assignment as reported by
> Fengguang.
> 
> It also fixes a poorly formatted message:
> 
> m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as
> /dev/video0
> 
> Is it OK if I take this through my tree? I have similar fix as well in
> another driver.

Go ahead :)

Best wishes,
Kamil

> 
> Regards,
> 
> 	Hans
> 
> diff --git a/drivers/media/platform/mem2mem_testdev.c
> b/drivers/media/platform/mem2mem_testdev.c
> index 4cc7f65d..6a17676 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -1051,6 +1051,7 @@ static int m2mtest_probe(struct platform_device
> *pdev)
> 
>  	*vfd = m2mtest_videodev;
>  	vfd->lock = &dev->dev_mutex;
> +	vfd->v4l2_dev = &dev->v4l2_dev;
> 
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>  	if (ret) {
> @@ -1061,7 +1062,7 @@ static int m2mtest_probe(struct platform_device
> *pdev)
>  	video_set_drvdata(vfd, dev);
>  	snprintf(vfd->name, sizeof(vfd->name), "%s",
> m2mtest_videodev.name);
>  	dev->vfd = vfd;
> -	v4l2_info(&dev->v4l2_dev, MEM2MEM_TEST_MODULE_NAME
> +	v4l2_info(&dev->v4l2_dev,
>  			"Device registered as /dev/video%d\n", vfd->num);
> 
>  	setup_timer(&dev->timer, device_isr, (long)dev);


