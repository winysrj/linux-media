Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:50387 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3FDIt2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 04:49:28 -0400
Received: by mail-ob0-f171.google.com with SMTP id dn14so8959512obc.30
        for <linux-media@vger.kernel.org>; Tue, 04 Jun 2013 01:49:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369394707-13049-1-git-send-email-sachin.kamat@linaro.org>
References: <1369394707-13049-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 4 Jun 2013 14:19:27 +0530
Message-ID: <CAK9yfHyUqpF4d_cuwPo-fA5UuCQzfG4-ktyOA716CfN3QgtHLg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] soc_camera: mt9t112: Remove empty function
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24 May 2013 16:55, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> After the switch to devm_* functions, the 'remove' function does
> not do anything. Delete it.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/i2c/soc_camera/mt9t112.c |    6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
> index a7256b7..0af29a4 100644
> --- a/drivers/media/i2c/soc_camera/mt9t112.c
> +++ b/drivers/media/i2c/soc_camera/mt9t112.c
> @@ -1118,11 +1118,6 @@ static int mt9t112_probe(struct i2c_client *client,
>         return ret;
>  }
>
> -static int mt9t112_remove(struct i2c_client *client)
> -{
> -       return 0;
> -}
> -
>  static const struct i2c_device_id mt9t112_id[] = {
>         { "mt9t112", 0 },
>         { }
> @@ -1134,7 +1129,6 @@ static struct i2c_driver mt9t112_i2c_driver = {
>                 .name = "mt9t112",
>         },
>         .probe    = mt9t112_probe,
> -       .remove   = mt9t112_remove,
>         .id_table = mt9t112_id,
>  };
>
> --
> 1.7.9.5
>

Gentle ping on this series  :)


-- 
With warm regards,
Sachin
