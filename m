Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab2FGKAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 06:00:04 -0400
Date: Thu, 7 Jun 2012 11:59:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: What should CREATE_BUFS do if count == 0?
In-Reply-To: <201206070009.27409.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1206071152160.21581@axis700.grange>
References: <201206070009.27409.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Thu, 7 Jun 2012, Hans Verkuil wrote:

> Hi all,
> 
> I'm extending v4l2-compliance with support for VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS,
> and I ran into an undefined issue: what happens if VIDIOC_CREATE_BUFS is called with
> count set to 0?
> 
> I think there should be a separate test for that. Right now queue_setup will receive
> a request for 0 buffers, and I don't know if drivers expect a zero value there.
> 
> I suggest that CREATE_BUFS with a count of 0 will only check whether memory and
> format.type are valid, and if they are it will just return 0 and do nothing.

Sounds good to me.

> Also note that this code in vb2_create_bufs is wrong:
> 
>         ret = __vb2_queue_alloc(q, create->memory, num_buffers,
>                                 num_planes);
>         if (ret < 0) {
>                 dprintk(1, "Memory allocation failed with error: %d\n", ret);
>                 return ret;
>         }
> 
> It should be:
> 
> 		if (ret == 0) {

Indeed you're right. But then the return above should be "return -ENOMEM," 
shouldn't it?

> 
> __vb2_queue_alloc() returns the number of buffers it managed to allocate,
> which is never < 0.
> 
> I propose to add the patch included below.
> 
> Comments are welcome!
> 
> Regards,
> 
> 	Hans
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index a0702fd..01a8312 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -647,6 +647,9 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
>  		return -EINVAL;
>  	}
>  
> +	if (create->count == 0)
> +		return 0;
> +
>  	if (q->num_buffers == VIDEO_MAX_FRAME) {
>  		dprintk(1, "%s(): maximum number of buffers already allocated\n",
>  			__func__);
> @@ -675,7 +678,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
>  	/* Finally, allocate buffers and video memory */
>  	ret = __vb2_queue_alloc(q, create->memory, num_buffers,
>  				num_planes);
> -	if (ret < 0) {
> +	if (ret == 0) {
>  		dprintk(1, "Memory allocation failed with error: %d\n", ret);
>  		return ret;

See above, should return an error code here.

>  	}
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
