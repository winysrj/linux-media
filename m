Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35124 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbcEJG3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 02:29:10 -0400
Subject: Re: [PATCH] [media] stk1160: Check *nplanes in queue_setup
To: Helen Koike <helen.koike@collabora.co.uk>,
	linux-media@vger.kernel.org, ezequiel@vanguardiasur.com.ar,
	hans.verkuil@cisco.com, mchehab@osg.samsung.com
References: <1462849574-15334-1-git-send-email-helen.koike@collabora.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57317FAE.1030207@xs4all.nl>
Date: Tue, 10 May 2016 08:29:02 +0200
MIME-Version: 1.0
In-Reply-To: <1462849574-15334-1-git-send-email-helen.koike@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/10/2016 05:06 AM, Helen Koike wrote:
> If *nplanes is not zero, it should use the requested size if valid

*nplanes is never 0 since the create_buffers ioctl isn't implemented in
this driver.

Adding support for it (simply use vb2_create_buffers) would make sense.

Regards,

	Hans

> 
> Signed-off-by: Helen Koike <helen.koike@collabora.co.uk>
> ---
>  drivers/media/usb/stk1160/stk1160-v4l.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
> index 77131fd..7ddbc02 100644
> --- a/drivers/media/usb/stk1160/stk1160-v4l.c
> +++ b/drivers/media/usb/stk1160/stk1160-v4l.c
> @@ -680,6 +680,9 @@ static int queue_setup(struct vb2_queue *vq,
>  	*nbuffers = clamp_t(unsigned int, *nbuffers,
>  			STK1160_MIN_VIDEO_BUFFERS, STK1160_MAX_VIDEO_BUFFERS);
>  
> +	if (*nplanes)
> +		return sizes[0] < size ? -EINVAL : 0;
> +
>  	/* This means a packed colorformat */
>  	*nplanes = 1;
>  
> 
