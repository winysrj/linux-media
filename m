Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:43405 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757506AbdJQRVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 13:21:55 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH] staging: media: imx: fix inconsistent IS_ERR and PTR_ERR
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
References: <20171017171907.GA3957@embeddedor.com>
Message-ID: <f843da31-9b94-7344-1111-a1aaf861ad4c@gmail.com>
Date: Tue, 17 Oct 2017 10:21:52 -0700
MIME-Version: 1.0
In-Reply-To: <20171017171907.GA3957@embeddedor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/17/2017 10:19 AM, Gustavo A. R. Silva wrote:
> Fix inconsistent IS_ERR and PTR_ERR in csi_link_validate.
> The proper pointer to be passed as argument is sensor.
>
> This issue was detected with the help of Coccinelle.
>
> Reported-by: Julia Lawall<julia.lawall@lip6.fr>
> Signed-off-by: Gustavo A. R. Silva<garsilva@embeddedor.com>
> ---
> This code was tested by compilation only.
>
>   drivers/staging/media/imx/imx-media-csi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 6d85611..2fa72c1 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -989,7 +989,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
>   	sensor = __imx_media_find_sensor(priv->md, &priv->sd.entity);
>   	if (IS_ERR(sensor)) {
>   		v4l2_err(&priv->sd, "no sensor attached\n");
> -		return PTR_ERR(priv->sensor);
> +		return PTR_ERR(sensor);
>   	}
>   
>   	mutex_lock(&priv->lock);

Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>
