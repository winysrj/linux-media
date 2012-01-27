Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59417 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2A0Uuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 15:50:55 -0500
Received: by eaal13 with SMTP id l13so378830eaa.19
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2012 12:50:54 -0800 (PST)
Message-ID: <4F230E2A.4080203@gmail.com>
Date: Fri, 27 Jan 2012 21:50:50 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] v4l2: standardize log start/end message.
References: <1327687153-14757-1-git-send-email-hverkuil@xs4all.nl> <1844c31eb7b4515904824a6b26994f7bdd7eace8.1327686924.git.hans.verkuil@cisco.com>
In-Reply-To: <1844c31eb7b4515904824a6b26994f7bdd7eace8.1327686924.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 01/27/2012 06:59 PM, Hans Verkuil wrote:
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index d0d7281..2348669 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1911,7 +1911,15 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		if (!ops->vidioc_log_status)
>   			break;
> +		if (vfd->v4l2_dev)
> +			printk(KERN_INFO
> +				"%s: =================  START STATUS  =================\n",
> +				vfd->v4l2_dev->name);
>   		ret = ops->vidioc_log_status(file, fh);
> +		if (vfd->v4l2_dev)
> +			printk(KERN_INFO
> +				"%s: ==================  END STATUS  ==================\n",
> +				vfd->v4l2_dev->name);

Nice cleanup, but wouldn't it be more appropriate to use pr_info() here
instead ? AFAIK this is preferred logging style now.

--

Thanks,
Sylwester
