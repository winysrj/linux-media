Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33019 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753253AbdGSQSM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 12:18:12 -0400
Received: by mail-pf0-f196.google.com with SMTP id e199so368084pfh.0
        for <linux-media@vger.kernel.org>; Wed, 19 Jul 2017 09:18:11 -0700 (PDT)
Subject: Re: [PATCH] [media] imx: csi: enable double write reduction
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20170719122243.22911-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <12f124d8-fec2-8b90-5bd8-c688c649ad35@gmail.com>
Date: Wed, 19 Jul 2017 09:18:08 -0700
MIME-Version: 1.0
In-Reply-To: <20170719122243.22911-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 07/19/2017 05:22 AM, Philipp Zabel wrote:
> For 4:2:0 subsampled YUV formats, avoid chroma overdraw by only writing
> chroma for even lines. Reduces necessary write memory bandwidth by 25%.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/staging/media/imx/imx-media-csi.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index a2d26693912ec..0fb70d5a9e7fe 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -388,6 +388,12 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>   			goto unsetup_vb2;
>   	}
>   
> +	switch (image.pix.pixelformat) {
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_NV12:
> +		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
> +	}
> +

Is there any reason why you can't place this call under the
already existing case statement for YUV420 and NV12 at line
352?

Steve

>   	ipu_cpmem_set_burstsize(priv->idmac_ch, burst_size);
>   
>   	/*
> 
