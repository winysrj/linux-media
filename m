Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:37845 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753251AbeBIXmO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 18:42:14 -0500
Received: by mail-io0-f194.google.com with SMTP id f89so11466294ioj.4
        for <linux-media@vger.kernel.org>; Fri, 09 Feb 2018 15:42:14 -0800 (PST)
Subject: Re: [PATCH v2] media: imx-media-internal-sd: Use empty initializer
To: Fabio Estevam <festevam@gmail.com>, mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        ian.arkver.dev@gmail.com, hans.verkuil@cisco.com,
        p.zabel@pengutronix.de, Fabio Estevam <fabio.estevam@nxp.com>
References: <1518217876-7037-1-git-send-email-festevam@gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1b6777bf-3467-2875-baab-505898ff8318@gmail.com>
Date: Fri, 9 Feb 2018 15:42:07 -0800
MIME-Version: 1.0
In-Reply-To: <1518217876-7037-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,


On 02/09/2018 03:11 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
>
> When building with W=1 the following warning shows up:
>
> drivers/staging/media/imx/imx-media-internal-sd.c:274:49: warning: Using plain integer as NULL pointer
>
> Fix this problem by using an empty initializer, which guarantees that all
> struct members are zero-cleared.

There is one other case of the use of "{0}" to initialize a stack/local
struct, in prp_enum_frame_size(). It should be fixed there as well, to
be consistent.

Steve

>
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> ---
> Changes since v1:
> - Use empty initializer insted of memset() - Ian
>
>   drivers/staging/media/imx/imx-media-internal-sd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
> index 70833fe..daf66c2 100644
> --- a/drivers/staging/media/imx/imx-media-internal-sd.c
> +++ b/drivers/staging/media/imx/imx-media-internal-sd.c
> @@ -271,7 +271,7 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
>   			       int ipu_id)
>   {
>   	struct imx_media_internal_sd_platformdata pdata;
> -	struct platform_device_info pdevinfo = {0};
> +	struct platform_device_info pdevinfo = {};
>   	struct platform_device *pdev;
>   
>   	pdata.grp_id = isd->id->grp_id;
