Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44765 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbbCNKBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 06:01:00 -0400
Message-ID: <550406D0.5070705@xs4all.nl>
Date: Sat, 14 Mar 2015 11:00:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, Julia.Lawall@lip6.fr,
	laurent.pinchart@ideasonboard.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: au0828 - add vidq busy checks to s_std and s_input
References: <1426299523-14718-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <1426299523-14718-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/14/2015 03:18 AM, Shuah Khan wrote:
> au0828 s_std and s_input are missing queue busy checks. Add
> vb2_is_busy() calls to s_std and s_input and return -EBUSY
> if found busy.

I agree with Devin that for this particular driver this patch isn't necessary.

Regards,

	Hans

> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-video.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index f47ee90..42c49c2 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1214,6 +1214,11 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  	if (norm == dev->std)
>  		return 0;
>  
> +	if (vb2_is_busy(&dev->vb_vidq)) {
> +		pr_info("%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
>  	if (dev->streaming_users > 0)
>  		return -EBUSY;
>  
> @@ -1364,6 +1369,14 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
>  		return -EINVAL;
>  	if (AUVI_INPUT(index).type == 0)
>  		return -EINVAL;
> +	/*
> +	 * Changing the input implies a format change, which is not allowed
> +	 * while buffers for use with streaming have already been allocated.
> +	*/
> +	if (vb2_is_busy(&dev->vb_vidq)) {
> +		pr_info("%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
>  	dev->ctrl_input = index;
>  	au0828_s_input(dev, index);
>  	return 0;
> 

