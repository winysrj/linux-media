Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40536 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab2IXL4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 07:56:13 -0400
Message-ID: <50604A48.7050900@iki.fi>
Date: Mon, 24 Sep 2012 14:55:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 3/3] fc2580: use macro for 64 bit division and reminder
References: <1348486638-31169-1-git-send-email-gennarone@gmail.com> <1348486638-31169-4-git-send-email-gennarone@gmail.com>
In-Reply-To: <1348486638-31169-4-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2012 02:37 PM, Gianluca Gennari wrote:
> Fixes the following warnings on a 32 bit system with GCC 4.4.3 and kernel Ubuntu 2.6.32-43 32 bit:
>
> WARNING: "__udivdi3" [fc2580.ko] undefined!
> WARNING: "__umoddi3" [fc2580.ko] undefined!
>
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/tuners/fc2580.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
> index 3ad68e9..2e8ebac 100644
> --- a/drivers/media/tuners/fc2580.c
> +++ b/drivers/media/tuners/fc2580.c
> @@ -168,8 +168,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
>   	}
>
>   	f_ref = 2UL * priv->cfg->clock / r_val;
> -	n_val = f_vco / f_ref;
> -	k_val = f_vco % f_ref;
> +	n_val = div_u64_rem(f_vco, f_ref, &k_val);
>   	k_val_reg = 1UL * k_val * (1 << 20) / f_ref;
>
>   	ret = fc2580_wr_reg(priv, 0x18, r18_val | ((k_val_reg >> 16) & 0xff));
>


-- 
http://palosaari.fi/
