Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46151 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbbHSLOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 07:14:15 -0400
Message-ID: <55D4646D.6080909@xs4all.nl>
Date: Wed, 19 Aug 2015 13:11:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 6/8] [media] media: add messages when media device
 gets (un)registered
References: <cover.1439981515.git.mchehab@osg.samsung.com> <f07fdec54485863d0db5710845d680f34709686b.1439981515.git.mchehab@osg.samsung.com>
In-Reply-To: <f07fdec54485863d0db5710845d680f34709686b.1439981515.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/15 13:01, Mauro Carvalho Chehab wrote:
> We can only free the media device after being sure that no
> graph object is used.
> 
> In order to help tracking it, let's add debug messages
> that will print when the media controller gets registered
> or unregistered.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans

> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 065f6f08da37..0f3844470147 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -359,6 +359,7 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
>  
>  static void media_device_release(struct media_devnode *mdev)
>  {
> +	dev_dbg(mdev->parent, "Media device released\n");
>  }
>  
>  /**
> @@ -397,6 +398,8 @@ int __must_check __media_device_register(struct media_device *mdev,
>  		return ret;
>  	}
>  
> +	dev_dbg(mdev->dev, "Media device registered\n");
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(__media_device_register);
> @@ -416,6 +419,8 @@ void media_device_unregister(struct media_device *mdev)
>  
>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
>  	media_devnode_unregister(&mdev->devnode);
> +
> +	dev_dbg(mdev->dev, "Media device unregistered\n");
>  }
>  EXPORT_SYMBOL_GPL(media_device_unregister);
>  
> 
