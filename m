Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2940 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaIAN3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 09:29:41 -0400
Message-ID: <540474AE.4070706@xs4all.nl>
Date: Mon, 01 Sep 2014 15:29:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Nicolas Dufresne <nicolas.dufresne@collabora.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] videobuf: Allow reqbufs(0) to free current buffers
References: <1409480361-12821-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1409480361-12821-1-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

At first glance this looks fine. But making changes in videobuf is always scary :-)
so I hope Marek can look at this as well.

How well was this tested?

I'll try do test this as well.

Regards,

	Hans

On 08/31/2014 12:19 PM, Hans de Goede wrote:
> All the infrastructure for this is already there, and despite our desires for
> the old videobuf code to go away, it is currently still in use in 18 drivers.
> 
> Allowing reqbufs(0) makes these drivers behave consistent with modern drivers,
> making live easier for userspace, see e.g. :
> https://bugzilla.gnome.org/show_bug.cgi?id=735660
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/v4l2-core/videobuf-core.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
> index fb5ee5d..b91a266 100644
> --- a/drivers/media/v4l2-core/videobuf-core.c
> +++ b/drivers/media/v4l2-core/videobuf-core.c
> @@ -441,11 +441,6 @@ int videobuf_reqbufs(struct videobuf_queue *q,
>  	unsigned int size, count;
>  	int retval;
>  
> -	if (req->count < 1) {
> -		dprintk(1, "reqbufs: count invalid (%d)\n", req->count);
> -		return -EINVAL;
> -	}
> -
>  	if (req->memory != V4L2_MEMORY_MMAP     &&
>  	    req->memory != V4L2_MEMORY_USERPTR  &&
>  	    req->memory != V4L2_MEMORY_OVERLAY) {
> @@ -471,6 +466,12 @@ int videobuf_reqbufs(struct videobuf_queue *q,
>  		goto done;
>  	}
>  
> +	if (req->count == 0) {
> +		dprintk(1, "reqbufs: count invalid (%d)\n", req->count);
> +		retval = __videobuf_free(q);
> +		goto done;
> +	}
> +
>  	count = req->count;
>  	if (count > VIDEO_MAX_FRAME)
>  		count = VIDEO_MAX_FRAME;
> 

