Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway09.websitewelcome.com ([67.18.125.14]:59996 "EHLO
	gateway09.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750Ab2BQXmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 18:42:38 -0500
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway09.websitewelcome.com (Postfix) with ESMTP id B38B7E0A5F44D
	for <linux-media@vger.kernel.org>; Fri, 17 Feb 2012 17:14:53 -0600 (CST)
Message-ID: <4F3EDF62.9090005@sensoray.com>
Date: Fri, 17 Feb 2012 15:14:42 -0800
From: dean anderson <linux-dev@sensoray.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dean Anderson <linux-dev@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pete Eberlein <pete@sensoray.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/2] [media] s2255drv: cleanup vidioc_enum_fmt_cap()
References: <20120217064327.GA3666@elgon.mountain>
In-Reply-To: <20120217064327.GA3666@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Dan,

I can sign off on this.  The check isn't required.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

On 2/16/2012 10:43 PM, Dan Carpenter wrote:
> "f" wasn't checked consistently, so static checkers complain.  This
> function is always called with a valid "f" pointer, so I have removed
> the check.
>
> Also the indenting was messed up.
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
> index c1bef61..3505242 100644
> --- a/drivers/media/video/s2255drv.c
> +++ b/drivers/media/video/s2255drv.c
> @@ -852,15 +852,13 @@ static int vidioc_querycap(struct file *file, void *priv,
>   static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
>   			       struct v4l2_fmtdesc *f)
>   {
> -	int index = 0;
> -	if (f)
> -		index = f->index;
> +	int index = f->index;
>
>   	if (index>= ARRAY_SIZE(formats))
>   		return -EINVAL;
> -    if (!jpeg_enable&&  ((formats[index].fourcc == V4L2_PIX_FMT_JPEG) ||
> -			 (formats[index].fourcc == V4L2_PIX_FMT_MJPEG)))
> -	return -EINVAL;
> +	if (!jpeg_enable&&  ((formats[index].fourcc == V4L2_PIX_FMT_JPEG) ||
> +			(formats[index].fourcc == V4L2_PIX_FMT_MJPEG)))
> +		return -EINVAL;
>   	dprintk(4, "name %s\n", formats[index].name);
>   	strlcpy(f->description, formats[index].name, sizeof(f->description));
>   	f->pixelformat = formats[index].fourcc;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

