Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:33985 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031852AbeBNXB4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 18:01:56 -0500
Subject: Re: [PATCH] staging: media: reformat line to 80 chars or less
To: Parthiban Nallathambi <pn@denx.de>
Cc: p.zabel@pengutronix.de, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20180212120548.7391-1-pn@denx.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <ee47261e-aa6d-150f-e7f0-b80c74fdec1d@gmail.com>
Date: Wed, 14 Feb 2018 15:01:52 -0800
MIME-Version: 1.0
In-Reply-To: <20180212120548.7391-1-pn@denx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Parthiban, please rename the commit title to

"media: imx: capture: reformat line to 80 chars or less"

Otherwise it is fine with me.

Steve


On 02/12/2018 04:05 AM, Parthiban Nallathambi wrote:
> This is a cleanup patch to fix line length issue found
> by checkpatch.pl script.
>
> In this patch, line 144 have been wrapped.
>
> Signed-off-by: Parthiban Nallathambi <pn@denx.de>
> ---
>   drivers/staging/media/imx/imx-media-capture.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index 576bdc7e9c42..0ccabe04b0e1 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -141,7 +141,8 @@ static int capture_enum_frameintervals(struct file *file, void *fh,
>   
>   	fie.code = cc->codes[0];
>   
> -	ret = v4l2_subdev_call(priv->src_sd, pad, enum_frame_interval, NULL, &fie);
> +	ret = v4l2_subdev_call(priv->src_sd, pad, enum_frame_interval,
> +			       NULL, &fie);
>   	if (ret)
>   		return ret;
>   
