Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56049 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbcCVTzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 15:55:45 -0400
Subject: Re: [PATCH 3/5] [media] au0828: Unregister notifiers
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
 <cdba12a00adbecabb66a662982991178383917b2.1458129823.git.mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56F1A33E.10403@osg.samsung.com>
Date: Tue, 22 Mar 2016 13:55:42 -0600
MIME-Version: 1.0
In-Reply-To: <cdba12a00adbecabb66a662982991178383917b2.1458129823.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2016 06:04 AM, Mauro Carvalho Chehab wrote:
> If au0828 gets removed, we need to remove the notifiers.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Tested bind_unbind au0828 loop 1000 times, followed by bind_unbind
snd_usb_audio loop 1000 times. Didn't see any lock warnings on a
KASAN enabled kernel (lock testing enabled). No use-after-free errors
during these runs.

Ran device removal test and rmmod and modprobe tests on both drivers.

Generated graph after the runs and the graph looks good.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Tested-by: Shuah Khan <shuahkh@osg.samsung.com>

thanks,
-- Shuah

> ---
>  drivers/media/usb/au0828/au0828-core.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 2fcd17d9b1a6..06da73f1ff22 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -131,21 +131,35 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>  	return status;
>  }
>  
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +static void au0828_media_graph_notify(struct media_entity *new,
> +				      void *notify_data);
> +#endif
> +
>  static void au0828_unregister_media_device(struct au0828_dev *dev)
>  {
> -
>  #ifdef CONFIG_MEDIA_CONTROLLER
> -	if (dev->media_dev &&
> -		media_devnode_is_registered(&dev->media_dev->devnode)) {
> -		/* clear enable_source, disable_source */
> -		dev->media_dev->source_priv = NULL;
> -		dev->media_dev->enable_source = NULL;
> -		dev->media_dev->disable_source = NULL;
> +	struct media_device *mdev = dev->media_dev;
> +	struct media_entity_notify *notify, *nextp;
>  
> -		media_device_unregister(dev->media_dev);
> -		media_device_cleanup(dev->media_dev);
> -		dev->media_dev = NULL;
> +	if (!mdev || !media_devnode_is_registered(&mdev->devnode))
> +		return;
> +
> +	/* Remove au0828 entity_notify callbacks */
> +	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list) {
> +		if (notify->notify != au0828_media_graph_notify)
> +			continue;
> +		media_device_unregister_entity_notify(mdev, notify);
>  	}
> +
> +	/* clear enable_source, disable_source */
> +	dev->media_dev->source_priv = NULL;
> +	dev->media_dev->enable_source = NULL;
> +	dev->media_dev->disable_source = NULL;
> +
> +	media_device_unregister(dev->media_dev);
> +	media_device_cleanup(dev->media_dev);
> +	dev->media_dev = NULL;
>  #endif
>  }
>  
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
