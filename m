Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:35659 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbDJVyk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 17:54:40 -0400
Received: by labbd9 with SMTP id bd9so22368952lab.2
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2015 14:54:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428614706-8367-5-git-send-email-sakari.ailus@iki.fi>
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi> <1428614706-8367-5-git-send-email-sakari.ailus@iki.fi>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 10 Apr 2015 22:54:08 +0100
Message-ID: <CA+V-a8uUTTzwP=hOiPAacT33K0cXDoy_gGNB5JAHSsY_LeHL_Q@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] smiapp: Use v4l2_of_alloc_parse_endpoint()
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thu, Apr 9, 2015 at 10:25 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Instead of parsing the link-frequencies property in the driver, let
> v4l2_of_alloc_parse_endpoint() do it.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |   40 ++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 557f25d..4a2e8d3 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2975,9 +2975,9 @@ static int smiapp_resume(struct device *dev)
>  static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
>  {
>         struct smiapp_platform_data *pdata;
> -       struct v4l2_of_endpoint bus_cfg;
> +       struct v4l2_of_endpoint *bus_cfg;
>         struct device_node *ep;
> -       uint32_t asize;
> +       int i;
>         int rval;
>
>         if (!dev->of_node)
> @@ -2987,13 +2987,17 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
>         if (!ep)
>                 return NULL;
>
> +       bus_cfg = v4l2_of_alloc_parse_endpoint(ep);
> +       if (IS_ERR(bus_cfg)) {
> +               rval = PTR_ERR(bus_cfg);

this assignment  is not required.

Apart from that the patch looks good.

Reviewed-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
