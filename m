Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:38813 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbCKWYp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 18:24:45 -0400
Received: by lbiz12 with SMTP id z12so12130149lbi.5
        for <linux-media@vger.kernel.org>; Wed, 11 Mar 2015 15:24:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425950282-30548-2-git-send-email-sakari.ailus@iki.fi>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi> <1425950282-30548-2-git-send-email-sakari.ailus@iki.fi>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 11 Mar 2015 22:24:14 +0000
Message-ID: <CA+V-a8tqgrkcRpdSj-cZHwy3PdafPnqnPXXUm4b0qrkZA325Pw@mail.gmail.com>
Subject: Re: [PATCH 1/3] smiapp: Clean up smiapp_get_pdata()
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tue, Mar 10, 2015 at 1:18 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Don't set rval when it's not used (the function returns a pointer to struct
> smiapp_platform_data).
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index b1f566b..565a00c 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2988,10 +2988,8 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
>                 return NULL;
>
>         pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> -       if (!pdata) {
> -               rval = -ENOMEM;
> +       if (!pdata)
>                 goto out_err;
> -       }
>
>         v4l2_of_parse_endpoint(ep, &bus_cfg);
>
> @@ -3001,7 +2999,6 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
>                 break;
>                 /* FIXME: add CCP2 support. */
>         default:
> -               rval = -EINVAL;
>                 goto out_err;
>         }
>
> --
> 1.7.10.4
>
