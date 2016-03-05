Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36371 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759566AbcCEAep (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 19:34:45 -0500
Subject: Re: [PATCH] [media] hide unused functions for !MEDIA_CONTROLLER
To: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457136410-2234001-1-git-send-email-arnd@arndb.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56DA29A3.5000300@osg.samsung.com>
Date: Fri, 4 Mar 2016 17:34:43 -0700
MIME-Version: 1.0
In-Reply-To: <1457136410-2234001-1-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/2016 05:06 PM, Arnd Bergmann wrote:
> Some functions in the au0828 driver are only used when CONFIG_MEDIA_CONTROLLER
> is enabled, and otherwise defined as empty functions:
> 
> media/usb/au0828/au0828-core.c:208:13: error: 'au0828_media_graph_notify' defined but not used [-Werror=unused-function]
> media/usb/au0828/au0828-core.c:262:12: error: 'au0828_enable_source' defined but not used [-Werror=unused-function]
> media/usb/au0828/au0828-core.c:412:13: error: 'au0828_disable_source' defined but not used [-Werror=unused-function]
> 
> This moves the #ifdef so the entire definitions are hidden in this case.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for fixing this.

Comments below:

> ---
>  drivers/media/usb/au0828/au0828-core.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 4ffaa3b2e905..d312098720a8 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -205,10 +205,10 @@ static int au0828_media_device_init(struct au0828_dev *dev,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_MEDIA_CONTROLLER
>  static void au0828_media_graph_notify(struct media_entity *new,
>  				      void *notify_data)
>  {
> -#ifdef CONFIG_MEDIA_CONTROLLER
>  	struct au0828_dev *dev = (struct au0828_dev *) notify_data;
>  	int ret;
>  	struct media_entity *entity, *mixer = NULL, *decoder = NULL;
> @@ -256,13 +256,11 @@ create_link:
>  			dev_err(&dev->usbdev->dev,
>  				"Mixer Pad Link Create Error: %d\n", ret);
>  	}
> -#endif
>  }
>  
>  static int au0828_enable_source(struct media_entity *entity,
>  				struct media_pipeline *pipe)
>  {
> -#ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_entity  *source, *find_source;
>  	struct media_entity *sink;
>  	struct media_link *link, *found_link = NULL;
> @@ -405,13 +403,11 @@ end:
>  	pr_debug("au0828_enable_source() end %s %d %d\n",
>  		 entity->name, entity->function, ret);
>  	return ret;
> -#endif
>  	return 0;

The above return 0 isn't needed with the change you made.


>  }
>  
>  static void au0828_disable_source(struct media_entity *entity)
>  {
> -#ifdef CONFIG_MEDIA_CONTROLLER
>  	int ret = 0;
>  	struct media_device *mdev = entity->graph_obj.mdev;
>  	struct au0828_dev *dev;
> @@ -453,8 +449,8 @@ static void au0828_disable_source(struct media_entity *entity)
>  
>  end:
>  	mutex_unlock(&mdev->graph_mutex);
> -#endif
>  }
> +#endif
>  
>  static int au0828_media_device_register(struct au0828_dev *dev,
>  					struct usb_device *udev)
> 

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
