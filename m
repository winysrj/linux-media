Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:49610 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbeBJRuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 12:50:54 -0500
Subject: Re: [PATCH v2] media: imx-media-internal-sd: Use empty initializer
To: Fabio Estevam <festevam@gmail.com>, <mchehab@kernel.org>
CC: <slongerbeam@gmail.com>, <gregkh@linuxfoundation.org>,
        <linux-media@vger.kernel.org>, <ian.arkver.dev@gmail.com>,
        <hans.verkuil@cisco.com>, <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>
References: <1518217876-7037-1-git-send-email-festevam@gmail.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <6e179cde-defc-b14d-b077-340869abcdc8@mentor.com>
Date: Sat, 10 Feb 2018 09:50:41 -0800
MIME-Version: 1.0
In-Reply-To: <1518217876-7037-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 02/09/2018 03:11 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
>
> When building with W=1 the following warning shows up:
>
> drivers/staging/media/imx/imx-media-internal-sd.c:274:49: warning: Using plain integer as NULL pointer
>
> Fix this problem by using an empty initializer, which guarantees that all
> struct members are zero-cleared.
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
