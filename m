Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:39245 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753539AbeFKAId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 20:08:33 -0400
Received: by mail-pg0-f67.google.com with SMTP id w12-v6so8896554pgc.6
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2018 17:08:33 -0700 (PDT)
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced
 scanning
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        kernel@pengutronix.de
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
Date: Sun, 10 Jun 2018 17:08:30 -0700
MIME-Version: 1.0
In-Reply-To: <20180601131316.18728-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 06/01/2018 06:13 AM, Philipp Zabel wrote:
> The IPU also supports interlaced buffers that start with the bottom field.
> To achieve this, the the base address EBA has to be increased by a stride
> length and the interlace offset ILO has to be set to the negative stride.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/gpu/ipu-v3/ipu-cpmem.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
> index 9f2d9ec42add..c1028f38c553 100644
> --- a/drivers/gpu/ipu-v3/ipu-cpmem.c
> +++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
> @@ -269,8 +269,14 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
>   
>   void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
>   {
> +	u32 ilo;
> +
>   	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
> -	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, stride / 8);
> +	if (stride >= 0)
> +		ilo = stride / 8;
> +	else
> +		ilo = 0x100000 - (-stride / 8);
> +	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
>   	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, (stride * 2) - 1);

This should be "(-stride * 2) - 1" for SLY when stride is negative.

After fixing that, interweaving seq-bt -> interlaced-bt works fine for
packed pixel formats, but there is still some problem for planar.

I haven't tracked down the issue with planar yet, but the corresponding
changes to imx-media that allow interweaving with line swapping are at

e9dd81da20 ("media: imx: Allow interweave with top/bottom lines swapped")

in branch fix-csi-interlaced.3 in my media-tree fork on github. Please 
have a
look and let me know if you see anything obvious.

Steve
