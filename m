Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59538 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbcANHxx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 02:53:53 -0500
Subject: Re: [PATCH] media: v4l2-compat-ioctl32: fix missing length copy in
 put_v4l2_buffer32
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1452757045-34051-1-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56975409.3090801@xs4all.nl>
Date: Thu, 14 Jan 2016 08:53:45 +0100
MIME-Version: 1.0
In-Reply-To: <1452757045-34051-1-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

Good catch! But looking through the compat code I noticed that in the
single-planar DMABUF case the length field is also never copied. I think
it would be much simpler if the length field is just always copied instead
of in each multiplanar or singleplanar mmap/userptr/dmabuf case. It will
simplify the code and prevent such mistakes in the future.

Can you make a v2 that makes that change?

Thanks!

	Hans

On 01/14/2016 08:37 AM, Tiffany Lin wrote:
> In v4l2-compliance utility, test QUERYBUF required correct length
> value to go through each planar to check planar's length in multi-planar
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 327e83a..5ba932a 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -521,6 +521,9 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		if (num_planes == 0)
>  			return 0;
>  
> +		if (put_user(kp->length, &up->length))
> +			return -EFAULT;
> +
>  		uplane = (__force struct v4l2_plane __user *)kp->m.planes;
>  		if (get_user(p, &up->m.planes))
>  			return -EFAULT;
> 

