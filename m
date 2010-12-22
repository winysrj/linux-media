Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:36038 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab0LVOZZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 09:25:25 -0500
Message-ID: <4D1207D9.2050000@linuxtv.org>
Date: Wed, 22 Dec 2010 15:14:49 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] drivers/media/video/v4l2-compat-ioctl32.c: Check the
 return value of copy_to_user
References: <201012212003.11446.arnd@arndb.de> <83948188cda2388c2e22a50119dfb0023fba759a.1292975147.git.tfransosi@gmail.com>
In-Reply-To: <83948188cda2388c2e22a50119dfb0023fba759a.1292975147.git.tfransosi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/22/2010 12:48 AM, Thiago Farina wrote:
> This fix the following warning:
> drivers/media/video/v4l2-compat-ioctl32.c: In function ‘get_microcode32’:
> drivers/media/video/v4l2-compat-ioctl32.c:209: warning: ignoring return value of ‘copy_to_user’, declared with attribute warn_unused_result
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  Changes from v1:
>  - Check the return code of put_user too.
>  - Remove the obsolete comment.
> 
>  drivers/media/video/v4l2-compat-ioctl32.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index e30e8df..6f2a022 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -201,14 +201,12 @@ static struct video_code __user *get_microcode32(struct video_code32 *kp)
>  
>  	up = compat_alloc_user_space(sizeof(*up));

I don't know anything about that code, but I assume that "up" should be
checked for NULL before use and should be freed in case an error occurs
below.

>  
> -	/*
> -	 * NOTE! We don't actually care if these fail. If the
> -	 * user address is invalid, the native ioctl will do
> -	 * the error handling for us
> -	 */
> -	(void) copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat));
> -	(void) put_user(kp->datasize, &up->datasize);
> -	(void) put_user(compat_ptr(kp->data), &up->data);
> +	if (copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat)))
> +		return NULL;
> +	if (put_user(kp->datasize, &up->datasize))
> +		return NULL;
> +	if (put_user(compat_ptr(kp->data), &up->data))
> +		return NULL;
>  	return up;
>  }
>  

