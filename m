Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33658 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcFIL4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 07:56:39 -0400
Date: Thu, 9 Jun 2016 08:56:34 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 5/6] drivers/media/media-device: add "release" callback
Message-ID: <20160609085634.5c17b2ae@recife.lan>
In-Reply-To: <145856703865.21117.13877102672522214541.stgit@woodpecker.blarg.de>
References: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
	<145856703865.21117.13877102672522214541.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Mar 2016 14:30:38 +0100
Max Kellermann <max@duempel.org> escreveu:

> Allow the client to free its data structures only after all files have
> been closed (fixing use-after-free bugs).

Hmm... Shuah is also working on fixing such issues at the media controller
stuff, and I made a few fix patches myself.

Our work is at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=media_cdev_fix

Please base your changes on it, to avoid conflicting work or rework.

I just rebased it on the top of media_tree (plus the patches for it
that I didn't push yet).


Thanks!
Mauro


> 
> Signed-off-by: Max Kellermann <max@duempel.org>
> ---
>  drivers/media/media-device.c |    9 +++++++--
>  include/media/media-device.h |    2 ++
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 5c4669c..a3901f9 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -551,9 +551,14 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
>   * Registration/unregistration
>   */
>  
> -static void media_device_release(struct media_devnode *mdev)
> +static void media_device_release(struct media_devnode *devnode)
>  {
> -	dev_dbg(mdev->parent, "Media device released\n");
> +	struct media_device *mdev = to_media_device(devnode);
> +
> +	dev_dbg(devnode->parent, "Media device released\n");
> +
> +	if (mdev->release)
> +		mdev->release(mdev);
>  }
>  
>  /**
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index d385589..d184d0c 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -326,6 +326,8 @@ struct media_device {
>  
>  	int (*link_notify)(struct media_link *link, u32 flags,
>  			   unsigned int notification);
> +
> +	void (*release)(struct media_device *mdev);
>  };
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
