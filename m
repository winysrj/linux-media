Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:35754 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbcHNTaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 15:30:07 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 11/14] media: platform: pxa_camera: make a standalone v4l2 device
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
	<1470684652-16295-12-git-send-email-robert.jarzmik@free.fr>
	<c51a3d10-58d5-ef7c-ec9c-60dc70e124f3@xs4all.nl>
Date: Sun, 14 Aug 2016 21:30:04 +0200
Message-ID: <87a8gfrvwj.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 08/08/2016 09:30 PM, Robert Jarzmik wrote:
>
>> +	pcdev->sensor = subdev;
>> +	pcdev->vdev.queue = &pcdev->vb2_vq;
>> +	pcdev->vdev.v4l2_dev = &pcdev->v4l2_dev;
>
> You're missing this line here:
>
> 	pcdev->vdev.ctrl_handler = subdev->ctrl_handler;
>
> This ensures that the sensor's controls are exposed to the video device node.
Okay, I'm on it, for v4.

>> +	video_set_drvdata(&pcdev->vdev, pcdev);
>> +
>> +	v4l2_disable_ioctl(vdev, VIDIOC_G_STD);
>> +	v4l2_disable_ioctl(vdev, VIDIOC_S_STD);
>
> Since you don't implement vidioc_g/s_std these two lines can be removed.
Okay, for v4.

Cheers.

-- 
Robert
