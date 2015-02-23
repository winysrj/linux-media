Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59793 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbbBWPbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:31:18 -0500
Received: by mail-wi0-f175.google.com with SMTP id r20so18353715wiv.2
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2015 07:31:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424702961-2349-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1424702961-2349-1-git-send-email-laurent.pinchart@ideasonboard.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 23 Feb 2015 15:30:46 +0000
Message-ID: <CA+V-a8vqQmSmVGdGYw18xQeGAxvH3j4-n78c+dnvPFekD6uHcQ@mail.gmail.com>
Subject: Re: [PATCH] media: am437x: Don't release OF node reference twice
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Mon, Feb 23, 2015 at 2:49 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The remote port reference is released both at the end of the OF graph
> parsing loop, and in the error code path at the end of the function.
> Those two calls will release the same reference, causing the reference
> count to go negative.
>
> Fix the problem by removing the second call.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad

> ---
>  drivers/media/platform/am437x/am437x-vpfe.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> I've found this issue while reading the code, the patch hasn't been tested.
>
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index 56a5cb0..ce273b2 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -2425,7 +2425,7 @@ static int vpfe_async_complete(struct v4l2_async_notifier *notifier)
>  static struct vpfe_config *
>  vpfe_get_pdata(struct platform_device *pdev)
>  {
> -       struct device_node *endpoint = NULL, *rem = NULL;
> +       struct device_node *endpoint = NULL;
>         struct v4l2_of_endpoint bus_cfg;
>         struct vpfe_subdev_info *sdinfo;
>         struct vpfe_config *pdata;
> @@ -2443,6 +2443,8 @@ vpfe_get_pdata(struct platform_device *pdev)
>                 return NULL;
>
>         for (i = 0; ; i++) {
> +               struct device_node *rem;
> +
>                 endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
>                                                       endpoint);
>                 if (!endpoint)
> @@ -2513,7 +2515,6 @@ vpfe_get_pdata(struct platform_device *pdev)
>
>  done:
>         of_node_put(endpoint);
> -       of_node_put(rem);
>         return NULL;
>  }
>
> --
> Regards,
>
> Laurent Pinchart
>
