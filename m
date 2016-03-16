Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:33589 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965315AbcCPNXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 09:23:46 -0400
Received: by mail-ig0-f195.google.com with SMTP id nt3so4348930igb.0
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 06:23:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <82ef082c4de7c0a1c546da1d9e462bc86ab423bf.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
	<82ef082c4de7c0a1c546da1d9e462bc86ab423bf.1458129823.git.mchehab@osg.samsung.com>
Date: Wed, 16 Mar 2016 10:23:45 -0300
Message-ID: <CABxcv=kCTxQ55+54OP4jDGaFW8Qk8EJ88_zXnzGmoq=65G8Dbw@mail.gmail.com>
Subject: Re: [PATCH 4/5] [media] media-device: use kref for media_device instance
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Patch looks almost good to me, I just have a question below:

On Wed, Mar 16, 2016 at 9:04 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Now that the media_device can be used by multiple drivers,
> via devres, we need to be sure that it will be dropped only
> when all drivers stop using it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/media-device.c | 48 +++++++++++++++++++++++++++++++-------------
>  include/media/media-device.h |  3 +++
>  2 files changed, 37 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index c32fa15cc76e..38e6c319fe6e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -721,6 +721,15 @@ int __must_check __media_device_register(struct media_device *mdev,
>  {
>         int ret;
>
> +       /* Check if mdev was ever registered at all */
> +       mutex_lock(&mdev->graph_mutex);
> +       if (media_devnode_is_registered(&mdev->devnode)) {
> +               kref_get(&mdev->kref);
> +               mutex_unlock(&mdev->graph_mutex);
> +               return 0;
> +       }
> +       kref_init(&mdev->kref);
> +
>         /* Register the device node. */
>         mdev->devnode.fops = &media_device_fops;
>         mdev->devnode.parent = mdev->dev;
> @@ -730,8 +739,10 @@ int __must_check __media_device_register(struct media_device *mdev,
>         mdev->topology_version = 0;
>
>         ret = media_devnode_register(&mdev->devnode, owner);
> -       if (ret < 0)
> +       if (ret < 0) {
> +               media_devnode_unregister(&mdev->devnode);

Why are you adding this? If media_devnode_register() failed then the
device node won't be registered so is not correct to call
media_devnode_unregister(). Or maybe I'm missing something.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
