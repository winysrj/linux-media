Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44933 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbCKW0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 18:26:12 -0400
Received: by lbvn10 with SMTP id n10so12082106lbv.11
        for <linux-media@vger.kernel.org>; Wed, 11 Mar 2015 15:26:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425950282-30548-3-git-send-email-sakari.ailus@iki.fi>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi> <1425950282-30548-3-git-send-email-sakari.ailus@iki.fi>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 11 Mar 2015 22:25:40 +0000
Message-ID: <CA+V-a8t=XxqjWcQCYwWKYbn3-BKcN2ZTZv_QkMvc-kQjUf7w6A@mail.gmail.com>
Subject: Re: [PATCH 2/3] smiapp: Read link-frequencies property from the
 endpoint node
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tue, Mar 10, 2015 at 1:18 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> The documentation stated that the link-frequencies property belongs to the
> endpoint node, not to the device's of_node. Fix this.
>
> There are no DT board descriptions using the driver yet, so a fix in the
> driver is sufficient.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 565a00c..ecae76b 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -3022,8 +3022,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
>         dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", pdata->xshutdown,
>                 pdata->nvm_size, pdata->ext_clk, pdata->csi_signalling_mode);
>
> -       rval = of_get_property(
> -               dev->of_node, "link-frequencies", &asize) ? 0 : -ENOENT;
> +       rval = of_get_property(ep, "link-frequencies", &asize) ? 0 : -ENOENT;
>         if (rval) {
>                 dev_warn(dev, "can't get link-frequencies array size\n");
>                 goto out_err;
> @@ -3037,7 +3036,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
>
>         asize /= sizeof(*pdata->op_sys_clock);
>         rval = of_property_read_u64_array(
> -               dev->of_node, "link-frequencies", pdata->op_sys_clock, asize);
> +               ep, "link-frequencies", pdata->op_sys_clock, asize);
>         if (rval) {
>                 dev_warn(dev, "can't get link-frequencies\n");
>                 goto out_err;
> --
> 1.7.10.4
>
