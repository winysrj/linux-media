Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:43648 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932250AbeAYAO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 19:14:26 -0500
Subject: Re: [PATCH] staging: imx-media-vdic: fix inconsistent IS_ERR and
 PTR_ERR
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
References: <20180124004340.GA25212@embeddedgus>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5e53d6d8-d336-da37-fe12-0638904e1799@gmail.com>
Date: Wed, 24 Jan 2018 16:14:19 -0800
MIME-Version: 1.0
In-Reply-To: <20180124004340.GA25212@embeddedgus>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 01/23/2018 04:43 PM, Gustavo A. R. Silva wrote:
> Fix inconsistent IS_ERR and PTR_ERR in vdic_get_ipu_resources.
> The proper pointer to be passed as argument is ch.
>
> This issue was detected with the help of Coccinelle.
>
> Fixes: 0b2e9e7947e7 ("media: staging/imx: remove confusing IS_ERR_OR_NULL usage")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/staging/media/imx/imx-media-vdic.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
> index 433474d..ed35684 100644
> --- a/drivers/staging/media/imx/imx-media-vdic.c
> +++ b/drivers/staging/media/imx/imx-media-vdic.c
> @@ -177,7 +177,7 @@ static int vdic_get_ipu_resources(struct vdic_priv *priv)
>   		priv->vdi_in_ch = ch;
>   
>   		ch = ipu_idmac_get(priv->ipu, IPUV3_CHANNEL_MEM_VDI_NEXT);
> -		if (IS_ERR(priv->vdi_in_ch_n)) {
> +		if (IS_ERR(ch)) {
>   			err_chan = IPUV3_CHANNEL_MEM_VDI_NEXT;
>   			ret = PTR_ERR(ch);
>   			goto out_err_chan;
