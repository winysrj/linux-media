Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63410 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbdF2MEJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 08:04:09 -0400
Subject: Re: [PATCH v3 3/8] [media] s5p-jpeg: Handle parsing error in
 s5p_jpeg_parse_hdr()
To: Thierry Escande <thierry.escande@collabora.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <ce18b31a-fd22-ee80-f236-08ad9b3df241@samsung.com>
Date: Thu, 29 Jun 2017 14:04:04 +0200
MIME-version: 1.0
In-reply-to: <1498579734-1594-4-git-send-email-thierry.escande@collabora.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170627160930epcas2p49fe543210e188c222b6a0eb6c73f14ae@epcas2p4.samsung.com>
 <1498579734-1594-4-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 27.06.2017 o 18:08, Thierry Escande pisze:
> This patch modifies the s5p_jpeg_parse_hdr() function so it only
> modifies the passed s5p_jpeg_q_data structure if the jpeg header parsing
> is successful.
> 
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>

Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 38 ++++++++++++++++-------------
>   1 file changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 0d935f5..df3e5ee 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1206,22 +1206,9 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
>   			break;
>   		}
>   	}
> -	result->w = width;
> -	result->h = height;
> -	result->sos = sos;
> -	result->dht.n = n_dht;
> -	while (n_dht--) {
> -		result->dht.marker[n_dht] = dht[n_dht];
> -		result->dht.len[n_dht] = dht_len[n_dht];
> -	}
> -	result->dqt.n = n_dqt;
> -	while (n_dqt--) {
> -		result->dqt.marker[n_dqt] = dqt[n_dqt];
> -		result->dqt.len[n_dqt] = dqt_len[n_dqt];
> -	}
> -	result->sof = sof;
> -	result->sof_len = sof_len;
> -	result->size = result->components = components;
> +
> +	if (notfound || !sos)
> +		return false;
>   
>   	switch (subsampling) {
>   	case 0x11:
> @@ -1240,7 +1227,24 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
>   		return false;
>   	}
>   
> -	return !notfound && sos;
> +	result->w = width;
> +	result->h = height;
> +	result->sos = sos;
> +	result->dht.n = n_dht;
> +	while (n_dht--) {
> +		result->dht.marker[n_dht] = dht[n_dht];
> +		result->dht.len[n_dht] = dht_len[n_dht];
> +	}
> +	result->dqt.n = n_dqt;
> +	while (n_dqt--) {
> +		result->dqt.marker[n_dqt] = dqt[n_dqt];
> +		result->dqt.len[n_dqt] = dqt_len[n_dqt];
> +	}
> +	result->sof = sof;
> +	result->sof_len = sof_len;
> +	result->size = result->components = components;
> +
> +	return true;
>   }
>   
>   static int s5p_jpeg_querycap(struct file *file, void *priv,
> 
