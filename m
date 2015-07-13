Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37823 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbbGMJU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 05:20:57 -0400
Message-ID: <55A382C0.6070703@xs4all.nl>
Date: Mon, 13 Jul 2015 11:20:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Benoit Parrot <bparrot@ti.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [Patch v3 1/1] media: am437x-vpfe: Requested frame size and fmt
 overwritten by current sensor setting
References: <1435612746-3999-1-git-send-email-bparrot@ti.com>
In-Reply-To: <1435612746-3999-1-git-send-email-bparrot@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/29/2015 11:19 PM, Benoit Parrot wrote:
> Upon a S_FMT the input/requested frame size and pixel format is
> overwritten by the current sub-device settings.
> Fix this so application can actually set the frame size and format.
> 
> Fixes: 417d2e507edc ("[media] media: platform: add VPFE capture driver support for AM437X")
> Cc: <stable@vger.kernel.org> # v4.0+
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
> Changes since v2:
> - fix the stable commit reference syntax
> 
>  drivers/media/platform/am437x/am437x-vpfe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index eb25c43da126..0fa62c50f62d 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -1584,7 +1584,7 @@ static int vpfe_s_fmt(struct file *file, void *priv,
>  		return -EBUSY;
>  	}
>  
> -	ret = vpfe_try_fmt(file, priv, fmt);
> +	ret = vpfe_try_fmt(file, priv, &format);
>  	if (ret)
>  		return ret;
>  
> 

I'm sorry, but this is wrong. The actual bug is not in s_fmt but in try_fmt.

try_fmt is not actually attempting to 'try' the format, but it just gets the
current subdev settings.

Instead it should do what s_fmt is doing, except for actually setting the format.

Frankly the am437x code is a bit of a mess in how it implements try and s_fmt.

Now, I am going to merge this patch anyway since it is clear from the code
that &format was intended. But this code certainly needs some more TLC since
this patch only addresses a small part of a much bigger problem.

Regards,

	Hans
