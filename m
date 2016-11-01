Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57245 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1168083AbcKAIwS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 Nov 2016 04:52:18 -0400
Subject: Re: [PATCH] [media] atmel-isc: release the filehandle if it's not the
 only one.
To: Songjun Wu <songjun.wu@microchip.com>, nicolas.ferre@atmel.com
References: <1477987726-4257-1-git-send-email-songjun.wu@microchip.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c90098d4-4d53-d2e1-2d3e-e38e7d548f45@xs4all.nl>
Date: Tue, 1 Nov 2016 09:52:13 +0100
MIME-Version: 1.0
In-Reply-To: <1477987726-4257-1-git-send-email-songjun.wu@microchip.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/11/16 09:08, Songjun Wu wrote:
> Release the filehandle in 'isc_open' if it's not the only filehandle
> opened for the associated video_device.

What's wrong with that? You should always be able to open the device
multiple times. v4l2-compliance will fail after this patch. I'm not sure
what you intended to do here, but this patch is wrong.

Regards,

	Hans

>
> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
> ---
>
>  drivers/media/platform/atmel/atmel-isc.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index 8e25d3f..5e08404 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -926,21 +926,21 @@ static int isc_open(struct file *file)
>  	if (ret < 0)
>  		goto unlock;
>
> -	if (!v4l2_fh_is_singular_file(file))
> -		goto unlock;
> +	ret = !v4l2_fh_is_singular_file(file);
> +	if (ret)
> +		goto fh_rel;
>
>  	ret = v4l2_subdev_call(sd, core, s_power, 1);
> -	if (ret < 0 && ret != -ENOIOCTLCMD) {
> -		v4l2_fh_release(file);
> -		goto unlock;
> -	}
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto fh_rel;
>
>  	ret = isc_set_fmt(isc, &isc->fmt);
> -	if (ret) {
> +	if (ret)
>  		v4l2_subdev_call(sd, core, s_power, 0);
> -		v4l2_fh_release(file);
> -	}
>
> +fh_rel:
> +	if (ret)
> +		v4l2_fh_release(file);
>  unlock:
>  	mutex_unlock(&isc->lock);
>  	return ret;
>
