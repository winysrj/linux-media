Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33154 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbdIRXHb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 19:07:31 -0400
Subject: Re: [PATCH] media: imx: Fix VDIC CSI1 selection
To: Tim Harvey <tharvey@gateworks.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1505776096-15867-1-git-send-email-tharvey@gateworks.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <9971527a-cc87-9ecd-8a4c-0569fdaeb11d@gmail.com>
Date: Mon, 18 Sep 2017 16:07:28 -0700
MIME-Version: 1.0
In-Reply-To: <1505776096-15867-1-git-send-email-tharvey@gateworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Tim for catching this error.

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 09/18/2017 04:08 PM, Tim Harvey wrote:
> When using VDIC with CSI1, make sure to select the correct CSI in
> IPU_CONF.
>
> Fixes: f0d9c8924e2c3376 ("[media] media: imx: Add IC subdev drivers")
> Suggested-by: Marek Vasut <marex@denx.de>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
>   drivers/staging/media/imx/imx-ic-prp.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
> index c2bb5ef..9e41987 100644
> --- a/drivers/staging/media/imx/imx-ic-prp.c
> +++ b/drivers/staging/media/imx/imx-ic-prp.c
> @@ -320,9 +320,10 @@ static int prp_link_validate(struct v4l2_subdev *sd,
>   		 * the ->PRPENC link cannot be enabled if the source
>   		 * is the VDIC
>   		 */
> -		if (priv->sink_sd_prpenc)
> +		if (priv->sink_sd_prpenc) {
>   			ret = -EINVAL;
> -		goto out;
> +			goto out;
> +		}
>   	} else {
>   		/* the source is a CSI */
>   		if (!csi) {
