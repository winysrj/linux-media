Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36575 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbcCPNLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 09:11:14 -0400
Received: by mail-io0-f196.google.com with SMTP id m184so3939378iof.3
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 06:11:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cdba12a00adbecabb66a662982991178383917b2.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
	<cdba12a00adbecabb66a662982991178383917b2.1458129823.git.mchehab@osg.samsung.com>
Date: Wed, 16 Mar 2016 10:11:13 -0300
Message-ID: <CABxcv==nkXsn2QbvXpv95aO9wcR4C3opi+VTzWwqZ+fwaboyow@mail.gmail.com>
Subject: Re: [PATCH 3/5] [media] au0828: Unregister notifiers
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=C3=A7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Patch looks good to me, I just have a minor comment:

On Wed, Mar 16, 2016 at 9:04 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> If au0828 gets removed, we need to remove the notifiers.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-core.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 2fcd17d9b1a6..06da73f1ff22 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -131,21 +131,35 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>         return status;
>  }
>
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +static void au0828_media_graph_notify(struct media_entity *new,
> +                                     void *notify_data);
> +#endif
> +

I would rather move the au0828_media_graph_notify() function
definition before au0828_unregister_media_device() instead of adding
this function forward declaration. Specially since requires ifdef
guards which makes it even harder to read.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
