Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34294 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbcCPM6S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 08:58:18 -0400
Received: by mail-io0-f177.google.com with SMTP id m184so57948254iof.1
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 05:58:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5b7aab28416452575f9b36ea08e7906784a6b8a6.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
	<5b7aab28416452575f9b36ea08e7906784a6b8a6.1458129823.git.mchehab@osg.samsung.com>
Date: Wed, 16 Mar 2016 09:58:17 -0300
Message-ID: <CABxcv=maEoTjdWa2f_tK9ao47kwFU-btnRUhWKoNLHeyhDe_hQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] [media] media-device: Fix a comment
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On Wed, Mar 16, 2016 at 9:04 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> The comment is for the wrong function. Fix it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  include/media/media-device.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 0c2de97181f3..ca3871b853ba 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -490,7 +490,7 @@ int __must_check __media_device_register(struct media_device *mdev,
>  #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
>
>  /**
> - * __media_device_unregister() - Unegisters a media device element
> + *_media_device_unregister() - Unegisters a media device element
>   *

s/_media_device_unregister()/media_device_unregister()

and while being there, you can also fix the "Unegisters" typo.

After those changes:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
