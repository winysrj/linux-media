Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:19473 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753120AbeEKPKA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:10:00 -0400
Date: Fri, 11 May 2018 17:09:58 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
cc: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, chen.chenchacha@foxmail.com,
        keescook@chromium.org, arvind.yadav.cs@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] media: staging: atomisp: Fix an error handling path
 in 'lm3554_probe()'
In-Reply-To: <f762630a681c08d9903cf73243dd98416ae96a7c.1526048313.git.christophe.jaillet@wanadoo.fr>
Message-ID: <alpine.DEB.2.20.1805111709390.20118@hadrien>
References: <cover.1526048313.git.christophe.jaillet@wanadoo.fr> <f762630a681c08d9903cf73243dd98416ae96a7c.1526048313.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 11 May 2018, Christophe JAILLET wrote:

> The use of 'fail1' and 'fail2' is not correct. Reorder these calls to
> branch at the right place of the error handling path.

Maybe it would be good to improve the names at the same time?

julia

>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/staging/media/atomisp/i2c/atomisp-lm3554.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
> index 723fa74ff815..1e5f516f6e50 100644
> --- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
> +++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
> @@ -871,7 +871,7 @@ static int lm3554_probe(struct i2c_client *client)
>  				     ARRAY_SIZE(lm3554_controls));
>  	if (err) {
>  		dev_err(&client->dev, "error initialize a ctrl_handler.\n");
> -		goto fail2;
> +		goto fail1;
>  	}
>
>  	for (i = 0; i < ARRAY_SIZE(lm3554_controls); i++)
> @@ -879,7 +879,6 @@ static int lm3554_probe(struct i2c_client *client)
>  				     NULL);
>
>  	if (flash->ctrl_handler.error) {
> -
>  		dev_err(&client->dev, "ctrl_handler error.\n");
>  		goto fail2;
>  	}
> @@ -888,7 +887,7 @@ static int lm3554_probe(struct i2c_client *client)
>  	err = media_entity_pads_init(&flash->sd.entity, 0, NULL);
>  	if (err) {
>  		dev_err(&client->dev, "error initialize a media entity.\n");
> -		goto fail1;
> +		goto fail2;
>  	}
>
>  	flash->sd.entity.function = MEDIA_ENT_F_FLASH;
> --
> 2.17.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
