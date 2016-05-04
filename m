Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57098 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbcEDMYx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 08:24:53 -0400
Subject: Re: [PATCH v2 3/5] media: Refactor copying IOCTL arguments from and
 to user space
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462360855-23354-4-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5729EA0F.5080402@xs4all.nl>
Date: Wed, 4 May 2016 14:24:47 +0200
MIME-Version: 1.0
In-Reply-To: <1462360855-23354-4-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for working on this!

I've got one comment:

On 05/04/2016 01:20 PM, Sakari Ailus wrote:
> Refactor copying the IOCTL argument structs from the user space and back,
> in order to reduce code copied around and make the implementation more
> robust.
> 
> As a result, the copying is done while not holding the graph mutex.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-device.c | 214 ++++++++++++++++++++++---------------------
>  1 file changed, 110 insertions(+), 104 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 9b5a88d..39fe07f 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c

<snip>

>  static long __media_device_ioctl(
>  	struct file *filp, unsigned int cmd, void __user *arg,
> -	const struct media_ioctl_info *info_array, unsigned int info_array_len)
> +	const struct media_ioctl_info *info_array, unsigned int info_array_len,
> +	unsigned int *max_arg_size)
>  {
>  	struct media_devnode *devnode = media_devnode_data(filp);
>  	struct media_device *dev = to_media_device(devnode);
>  	const struct media_ioctl_info *info;
> +	char karg[media_ioctl_max_arg_size(info_array, info_array_len,
> +					   max_arg_size)];

This isn't going to work. Sparse (and/or smatch) will complain about this. I recommend
doing the same as videodev does: have a fixed array on the stack, and use kmalloc if
more is needed.

I don't like the max_arg_size anyway :-)

>  	long ret;
>  
>  	ret = is_valid_ioctl(info_array, info_array_len, cmd);

Regards,

	Hans
